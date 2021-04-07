clear all; clc
% DAVI ROCHA CARVALHO; ENG. ACUSTICA - UFSM; Fevereiro/2020
addpath(genpath([pwd, '\..\EAC-Toolbox']));

%% GENERAL INFO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ~ ASSEMBLE ANTHROPOMETRY FROM CIPC, ARI AND ITS DATABASES
addpath([pwd, '\..\DADOS_TREINAMENTO']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options 
% Defina quais datasets usar: {'cipic', 'ari', '3d3a', 'ita', 'riec', 'tub_sim'}
Datasets = {'cipic', 'ari', '3d3a', 'ita'};
% Defina quais parametros de saida (Tabela CIPIC e valida para todos*)
head_torso = [1,3]; % aplicado a cipic e ari

left_ear = 1:8;      
right_ear = 9:16;    % aplicado a cipic e ari
% 
left_theta = [];       % aplicado a cipic e ari
right_theta = [];      % aplicado a cipic e ari

anthro = []; % inicializar save
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CIPIC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmp('cipic', Datasets))   
    anthro_CIPIC = load('anthro_CIPIC.mat');
    % Orelhas
    d1_C = anthro_CIPIC.D(:, left_ear);
    d2_C = anthro_CIPIC.D(:, right_ear);
    t1_C = anthro_CIPIC.theta(:, left_theta);
    t2_C = anthro_CIPIC.theta(:, right_theta);

    % Cabeca e torso
    x_C = anthro_CIPIC.X(:,head_torso);

    % Concatena
    data_CIPIC(:,:,1) = [x_C, d1_C, t1_C].'; 
    data_CIPIC(:,:,2) = [x_C, d2_C, t2_C].'; 

    %%% Remorção de indivíduos sem antropometria   
    remove_CIPIC = any(any(isnan(data_CIPIC),1),3); % identifica quais colunas não possuem pelo menos uma das medidas necessárias        
    remove_CIPIC(1) = true; % remover individuo pra posterior teste
    data_CIPIC(:,remove_CIPIC,:) = [];
    
    anthro = cat(2, [anthro, data_CIPIC]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ARI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmp('ari', Datasets))
    anthro_ARI = load('anthro_ARI.mat');
    % Orelhas
    d1_A = anthro_ARI.D(:, left_ear);
    d2_A = anthro_ARI.D(:, right_ear);
    t1_A = anthro_ARI.theta(:, left_theta);
    t2_A = anthro_ARI.theta(:, right_theta);
    % Cabeca e torso
    x_A = anthro_ARI.X(:,head_torso);

    % Concatena
    data_ARI(:,:,1) = [x_A, d1_A, t1_A].'; 
    data_ARI(:,:,2) = [x_A, d2_A, t2_A].'; 

    %%% Remorção de indivíduos sem dados anthropométricos %%%   
    remove_ARI = any(any(isnan(data_ARI),1),3); % identifica quais colunas não possuem pelo menos uma das medidas necessárias        
    remove_ARI([41,43,45]) = true; % remover outliers
    data_ARI(:,remove_ARI,:) = [];
    
    anthro = cat(2, [anthro, data_ARI]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ITA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmp('ita', Datasets))
    anthro_ITA = load('anthro_ITA.mat');
    d_I = anthro_ITA.D(left_ear,:); %ITA apresenta medições apenas para orelha esquerda
    x_I = anthro_ITA.X; % x1, x3: head width, head depth 
    ITA_anthro = [x_I; d_I];
    ITA_anthro(:,:,2) = ITA_anthro;
    % caso queira adcionar algum parametro, go to: Anthropometry_ITA.m
    
    anthro = cat(2, [anthro, ITA_anthro]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3D3A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmp('3d3a', Datasets))
    anthro_D3A = load('anthro_3D3A.mat');
    d_3 = anthro_D3A.D(left_ear,:); %ITA apresenta medições apenas para orelha esquerda
    x_3 = anthro_D3A.X(1:2, :); % x1, x3, x12: head width, head depth, torso width
    D3A_anthro = [x_3; d_3];
    D3A_anthro(:,:,2) = D3A_anthro;
    remove_D3A=false(length(D3A_anthro), 1);
    remove_D3A(7) = 1; 
    D3A_anthro(:,remove_D3A,:) = [];
    
    anthro = cat(2, [anthro, D3A_anthro]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RIEC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmp('riec', Datasets))
    anthro_RIEC = load('anthro_RIEC.mat');
    d_3 = anthro_RIEC.D(left_ear,:); %ITA apresenta medições apenas para orelha esquerda
    x_3 = anthro_RIEC.X(1:2, :); % x1, x3, x12: head width, head depth, torso width
    RIEC_anthro = [x_3; d_3];
    RIEC_anthro(:,:,2) = RIEC_anthro;
    
    anthro = cat(2, [anthro, RIEC_anthro]);   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TU Berlim %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if any(strcmp('tub_meas', Datasets)) || any(strcmp('tub_sim', Datasets))
    anthro_TUB = load('anthro_TUB.mat');
    % Orelhas
    d1_T = anthro_TUB.D(:, left_ear);
    d2_T = anthro_TUB.D(:, right_ear);
    t1_T = anthro_TUB.theta(:, left_theta);
    t2_T = anthro_TUB.theta(:, right_theta);
    % Cabeca e torso
    x_T = anthro_TUB.X(:,head_torso);
%     x_T(:,3) = x_T(:,3)-10;
    % Concatena
    data_TUB(:,:,1) = [x_T, d1_T, t1_T].'; 
    data_TUB(:,:,2) = [x_T, d2_T, t2_T].'; 
    
    %%% Remorção de indivíduos sem dados anthropométricos %%%
    remove_TUB = any(any(isnan(data_TUB),1),3); % identifica quais colunas não possuem pelo menos uma das medidas necessárias        
    remove_TUB([1,96]) = true; % remover Fabian (verifique pela geometria 3d)
    data_TUB(:,remove_TUB,:) = [];
    
    % assembly
    anthro = cat(2, [anthro, data_TUB]);
end



%% Feature selection
ch = 1;
cor = corr(anthro(3:end,:,ch)', anthro(3:end,:,ch)');
 
clc
figure()
heat = heatmap(cor(:,:,1), 'Colormap', parula(5));
% figure()
% heatmap(cor(:,:,2), 'Colormap', jet);

% labels = {'x1', 'x3', 'x12'};
labels  = {'d1', 'd2', 'd3','d4', 'd5', 'd6', 'd7', 'd8'};
% labels  = {'d1','d2', 'd3', 'd5', 'd7', 'd8'};

% heatmap(heat,'ver','metric', 'ColorVariable','val','CellLabelFormat', '%,g')
ax = gca;
ax.XData = labels;
ax.YData = labels;
set(gca, 'fontsize', 13)
title('Correlação antropométrica')
caxis([0 0.8]); 
colorbar off

%%
% figure()
% plot(anthro(:,:,1)')
% legend('x1', 'x3', 'd1', 'd2', 'd3', 'd4', 'd5', 'd6', 'd7', 'd8')
% % desvio padrão interno de parametros:
% std_dev = std(anthro(3:end,:,1)');
% 
% bar(std_dev)
% title('Desvio padrão')
% 
% xticklabels({'d1', 'd2', 'd3', 'd4', 'd5', 'd6', 'd7', 'd8'})

