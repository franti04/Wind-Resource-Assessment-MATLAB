function [alpha_stima,beta_stima] = weibull_stima(x,y)

    % Calcolo i coefficienti della retta di regressione lineare che possiede 
    % il seguente andamento:

    %                      y = beta * x + intercetta

    % dove 
    %                      intercetta = - beta * ln(alpha)

    % Adopero il metodo ai minimi quadrati

    % vettore dei coefficienti del polinomio di grado 1:
    p = polyfit(x,y,1); 
     
    % valore della pendenza della retta di regressione:
    beta_stima = p(1); 
    
    % valore di passaggio della retta di regressione per l'asse delle ordinate
    intercetta = p(2); 

    % valore stimato del parametro alpha:
    alpha_stima = exp(-intercetta./beta_stima); 
    

end