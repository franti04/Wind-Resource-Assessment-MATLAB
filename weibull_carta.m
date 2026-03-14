function [Xcarta, Ycarta] = weibull_carta(X)
    % Calcola i punti per la carta di Weibull

    % Input: 
    %   X -> vettore colonna del campione
    % Output:
    %   Xcarta -> log(X ordinato)
    %   Ycarta -> log(-log(1-F(X))) per carta di Weibull

    %Ordina il campione (da esperimenti più piccoli a più grandi)
    Xs = sort(X);

    %Dimensione del campione
    n = length(Xs);

    %Calcola F(X) con formula stimatore di Bloom della funzione di
    % distribuzione per ogni esperimento i_esimo del campione Xs
    i=(1:n)';
    F_Blom = (i - 0.5) ./ (n + 0.25);  % vettore colonna

    %linearizzazione per la carta di Weibull e per poter 
    %applicare regressione lineare e trovare stimatori alfa e beta 
    Ycarta = log(-log(1 - F_Blom));

    % Asse X della carta: log(X)
    Xcarta = log(Xs);

end