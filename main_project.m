%% Script Principale:
clear; clc; close all;

% Parametri
alpha_vero = 19;
beta_vero = 3.1;
ciclo_M = [100, 500, 1000, 5000, 10000]; %Analisi di sensibilità – 5 iterazioni

% Ciclo per l'analisi di sensibilità
for M = ciclo_M
    fprintf('Esecuzione con M = %d...\n', M);
    esame(alpha_vero, beta_vero, M);
    pause(1); % Pausa per visualizzare i grafici
end