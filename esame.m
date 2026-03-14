function [n_ottimale] = esame(alpha, beta, M)
% ESAME - Funzione principale per la simulazione Montecarlo della
% distribuzione di Weibull

% INPUT:
% alpha : Parametro di forma reale
% beta  : Parametro di scala reale
% M     : Numero di iterazioni Montecarlo
%
% OUTPUT:
% n_minimo: dopo una verifica sui valori estratti dal montecarlo 
% (devono avere uno scarto percentuale minore o uguale al 15% rispetto 
% ai valori reali) si seleziona il valore con il minor numero di 
% estrazioni che passa le suddette verifiche.

    % Definisco le estrazioni che devo confrontare
    n_estrazioni = [3, 5, 10, 20, 40]; 
    %n_estrazioni = input(['inserire ''n'' array del numero ' ...
     %   'di estrazione variabile da 3 a 40: ']);
    num_casistiche = length(n_estrazioni);

    % Pre-allocazione delle matrici per velocità e gestione memoria
    % È buona norma pre-allocare quando si lavora con M elevato 
    alpha_matrice = zeros(num_casistiche, M);
    beta_matrice = zeros(num_casistiche, M);
    
    % Vettori per le statistiche
    atteso_Alpha = zeros(1, num_casistiche);
    mediano_Alpha = zeros(1, num_casistiche);
    dev_Alpha = zeros(1, num_casistiche);
    
    atteso_Beta = zeros(1, num_casistiche);
    mediano_Beta = zeros(1, num_casistiche);
    dev_Beta = zeros(1, num_casistiche);
    
    % --- FASE 1: Generazione e Stima (Montecarlo) ---
    % Imposto un ciclo for per i diversi valori di n
    for j = 1:num_casistiche
        n = n_estrazioni(j);
        
        % Pre-alloco la matrice dei venti per il lotto corrente
        v_venti = zeros(n, M); 
        
        for i = 1:M
            %Creo una matrice dove ogni colonna è un'estrazione di n valori
            %Nota: 
            %Assumiamo che weibull_estrazione restituisca 
            %un vettore colonna nx1

            v_venti(:, i) = weibull_estrazione(alpha, beta, n);
        end
        
        % Stima dei parametri alpha e beta per ogni colonna
        for y = 1:M
            
            % Studio la Carta di Weibull per ogni estrazione del Ciclo
            % Montecarlo
            [x_lin, y_lin] = weibull_carta(v_venti(:, y));
   
            % Ottengo alpha e beta stimati tramite regressione
            [alpha_stima, beta_stima] = weibull_stima(x_lin, y_lin);
            
            % Immagazzino i valori nelle matrici
            alpha_matrice(j, y) = alpha_stima;
            beta_matrice(j, y) = beta_stima;
        end
    end
    
    % --- FASE 2: Analisi Statistica e Grafica ---

    figure('Name', ['Distribuzioni Campionarie Alpha e Beta per ' ...
        'M=' num2str(M)]);
    
    for j = 1:num_casistiche
        % Istogramma per i valori stimati di alpha
        subplot(2, 5, j); 
        histogram(alpha_matrice(j, :), 'Normalization', 'pdf');
        title(['Alpha (n = ' num2str(n_estrazioni(j)) ')']);
        xlabel('Valore \alpha(m/s)'); ylabel('PDF');
        grid on;
        
        % Istogramma per i valori stimati di beta
        subplot(2, 5, j + 5); 
        histogram(beta_matrice(j, :), 'Normalization', 'pdf');
        title(['Beta (n = ' num2str(n_estrazioni(j)) ')']);
        xlabel('Valore \beta'); ylabel('PDF');
        grid on;
        
        % Calcolo valore atteso, mediano e deviazione standard 
        atteso_Alpha(j) = mean(alpha_matrice(j, :));
        mediano_Alpha(j) = median(alpha_matrice(j, :));
        dev_Alpha(j) = std(alpha_matrice(j, :));
        
        atteso_Beta(j) = mean(beta_matrice(j, :));
        mediano_Beta(j) = median(beta_matrice(j, :));
        dev_Beta(j) = std(beta_matrice(j, :));
        
        fprintf('\n--- Statistiche per n=%d ---\n', n_estrazioni(j));
        fprintf('Alpha: Atteso=%.4f, Mediano=%.4f, Std=%.4f\n', ...
            atteso_Alpha(j), mediano_Alpha(j), dev_Alpha(j));
        fprintf('Beta : Atteso=%.4f, Mediano=%.4f, Std=%.4f\n', ...
            atteso_Beta(j), mediano_Beta(j), dev_Beta(j));
            
        % --- CALCOLO INTERVALLI DI CONFIDENZA 95% ---
        % Come richiesto dalla traccia, calcoliamo l'intervallo 
        % basandoci sui percentili della distribuzione campionaria 
        % (2.5% e 97.5%)

        CI_alpha = prctile(alpha_matrice(j, :), [2.5 97.5]);
        fprintf('Intervallo Confidenza 95%% Alpha: [%.4f, %.4f]\n', ...
            CI_alpha(1), CI_alpha(2));
    end
    
    % --- FASE 3: Calcolo Potenza Elettrica ---
    rho = 1.225; % densità dell'aria in kg/m^3
    A = 40;      % area massa eolica [m^2]
    
    % Pre-allocazione vettore potenza
    potenzaElettrica = zeros(1, num_casistiche);
    
    fprintf('\n--- Analisi Potenza Elettrica ---\n');
    for j = 1:num_casistiche
        % La traccia richiede di usare "valore alfa mediano"come velocità v 
        % P = 0.5 * rho * A * v^3
        potenzaElettrica(j) = 0.5 * rho * A * (mediano_Alpha(j).^3); 
        
        fprintf('Potenza per n=%d: %.2f W\n', n_estrazioni(j), ...
            potenzaElettrica(j));
    end
    
    % --- FASE 4: Verifica Scarto Percentuale ---
    % Si valuta il numero ottimale per scarto < 15%
    limite = 15; 
    
    fprintf('\n--- Analisi Scarto Percentuale (Limite %d%%) ---\n',limite);

    n_minimo = [];
    idx_minimo = 1; % Indice per riempire il vettore n_minimo
    
    for j = 1:num_casistiche
        % Calcolo scarto percentuale assoluto rispetto ai valori veri 
        % (input alpha, beta)
        scartoAlpha = (abs(atteso_Alpha(j) - alpha) / alpha) * 100;
        scartoBeta  = (abs(atteso_Beta(j) - beta) / beta) * 100;
        
        fprintf('n=%d -> Scarto Alpha: %.2f%%, Scarto Beta: %.2f%%\n', ...
            n_estrazioni(j), scartoAlpha, scartoBeta);
            
        if scartoAlpha <= limite && scartoBeta <= limite

            n_minimo(idx_minimo) = n_estrazioni(j);
            idx_minimo = idx_minimo + 1;

        end   
    end

    % --- CONCLUSIONI FINALI ---
    fprintf('\n--------------------------------------------------\n');
    if isempty(n_minimo)
        fprintf(['NESSUN campione soddisfa il requisito del 15%% su ' ...
            'entrambi i parametri.\n']);
        n_ottimale = NaN; % Nessun valore trovato
    else
        % Poiché n_estrazioni è ordinato (3, 5, 10...), il primo valore 
        % trovato è automaticamente il minimo. 
        % Ma per sicurezza usiamo min().
        n_ottimale = min(n_minimo);
        
        fprintf('Campioni che soddisfano il requisito (<15%%): %s\n', ...
            num2str(n_minimo));
        fprintf(['>>> IL NUMERO MINIMO DI CAMPIONI CONSIGLIATO È:' ...
            'n = %d <<<\n'], n_ottimale);
    end
    fprintf('--------------------------------------------------\n');

end