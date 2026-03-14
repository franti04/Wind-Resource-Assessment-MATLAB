function v_venti = weibull_estrazione(alpha, beta, n)

    %Genera campioni di velocità del vento.

    %Questa funzione utilizza il metodo della "Trasformata Inversa" per 
    % generare n valori che seguono la distribuzione di Weibull.

    %INPUT:
    %n - Numero di campioni da generare
    %alpha - Parametro di scala (dato dal problema)
    %beta - Parametro di forma (dato dal problema)
    
    %OUTPUT:
    %v_venti - Vettore colonna contenente le velocità generate [m/s]

    %Generazione delle probabilità cumulate casuali:

    %rand crea numeri tra 0 e 1 (rappresentano la F nella CDF)
    % (CDF = Cumulative Density Function)

    F = rand(n, 1);

    %Inversione della formula della CDF di Weibull
    %Dalla teoria: F = 1 - exp(-(v/alpha)^beta)

    %Invertendo per v otteniamo: v = alpha * (-ln(1-F))^(1/beta)
    % Nota: in Matlab log() è il logaritmo naturale (ln)
    
    v_venti = alpha .* (-log(1 - F)).^(1/beta);
    %resituisco in output un vettore colonna

    v_venti = v_venti(:); 

end