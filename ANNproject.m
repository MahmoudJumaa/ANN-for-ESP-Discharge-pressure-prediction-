clc; clear all; close all; % clearvars;

%% This code was prepared by: Amjed Hassan Email:(amjed.mohammed@kfupm.edu.sa)  

%% 

%% 
%% 

tic

%% Uploading Data Sets

Data_all      = xlsread('case3.xlsx','oil'); % to input the data from Xl file
Data    = Data_all(1:12885,1:17); %   check the number of rows


Choice  = 0.7;%0.70
Np      = 16; % Total Number of Inputs is 16

 
%% Data Randomization (New rand from FL)

Length_Data          =      length(Data);
Random_Nums          =      randperm(Length_Data,Length_Data);
Random_Nums          =      Random_Nums'; 

Data_random         =       Data  (Random_Nums, :);
Data_Tr             =       Data_random(1 : ceil(length(Data_all) * Choice), :);
Data_Tst            =       Data_random(length(Data_Tr)+1 : end, :);

Data_Tr             =       sortrows(Data_Tr,1);
Data_Tst            =       sortrows(Data_Tst,1);

Training_Depth      =       Data_Tr(:,1); % Depth represents the Temperature
Testing_Depth       =       Data_Tst(:,1);

Input_Training      =       Data_Tr(:, 1 :Np);     % Don't take depths as an input .
Output_Training     =       Data_Tr(:,Np + 1);  %% ??? why + 1 
Input_test          =       Data_Tst(:, 1 :Np) ;
Output_test         =       Data_Tst(:,Np + 1) ;


%% 


rand('seed',200) % To get same results every time, Change numeric value to get different results 

%% Creating a Neural Network

L1_Neurons  = 5;  % Refers to number of Neurons in Layer 1
L2_Neurons  = 3;  % Refers to number of Neurons in Layer 2
L3_Neurons  = 2;  % Refers to number of Neurons in Layer 3


net    = fitnet(L1_Neurons);  % Single Layered Neural Network

%net = fitnet([L1_Neurons L2_Neurons ]); % Multiple Layered Neural Network
%net = fitnet([L1_Neurons L2_Neurons L3_Neurons]); % Multiple Layered Neural Network

net.trainFcn                = 'trainlm';    % Training Algorithm
net.trainParam.showWindow   = 1;            % '0' to hide and '1' to show neural network popup window and    
net.layers{1}.transferFcn   = 'tansig';     % Layer 1 Transfer function
net.trainParam.epochs       = 1000;         % Stopping criteria Number of itteration
net.trainParam.lr           = 0.12;         % Learning Rate
net.trainParam.mc           = 0.6;          % Learning algorithm parameter
net.trainParam.min_grad     = 0; 
net.trainParam.mu_max       = 1E100;
net.divideParam.trainRatio  = 0.85;         % training set [%]
net.divideParam.valRatio    = 0.15;         % validation set [%]   
net.divideParam.testRatio   = 0;            % test set [%]
 

% net = newrb(Input_data',Target_data',0.0,360,12,4);  % Radial Basis Function Neural Network
% net = newrb(Input_data',Target_data',goal,spread,MN,DF) % Radial Basis Function Neural Network

[net,tr]                = train(net,Input_Training',Output_Training'); 
save net;
Results_Training        = sim(net,Input_Training');
Results_Testing         = sim(net,Input_test');

CorrCoef_Train          = corrcoef(Results_Training,Output_Training); 
CorrCoef_Test           = corrcoef(Results_Testing,Output_test);


% MAE

MAE_Train          = mae(Results_Training,Output_Training); 
MAE_Test           = mae(Results_Testing,Output_test);
 
AAPE_Train              =       mean ( abs ( ( Output_Training - Results_Training')./Output_Training))*100;
AAPE_Test               =       mean ( abs ( ( Output_test - Results_Testing')./Output_test))*100;

AAD_Train              =       mean ( abs ( ( Output_Training - Results_Training')));
AAD_Test               =       mean ( abs ( ( Output_test - Results_Testing')));

%% Outputs

figure (1)
plotperform(tr)
% xlabel('Iteration "59 Epochs')
grid on

figure (2)
plottrainstate(tr)
% xlabel('Iteration "59 Epochs')
grid on

figure (3)
plotfit(net,Input_Training(:,1)',Output_Training(:,1)')

figure (4)
plotregression(Output_Training, Results_Training)
xlabel('Actual','FontSize',12,'FontWeight','bold','Color','k');
ylabel('Predicted','FontSize',12,'FontWeight','bold','Color','k');
title(' Actual vs Predicted, for Training Data using ANN');

figure (5)
plotregression(Output_test, Results_Testing)
xlabel('Actual','FontSize',12,'FontWeight','bold','Color','k');
ylabel('Predicted','FontSize',12,'FontWeight','bold','Color','k');
title(' Actual vs Predicted , for Testing Data using ANN');

% figure (6)
% plot(Results_Training,Training_Depth,'--')
% hold on;
% plot(Output_Training,Training_Depth,'r*');
% legend('Predicted','Real');
% set (gca,'Ydir','reverse')
% xlabel('relative viscosity ','FontSize',12,'FontWeight','bold','Color','k');
% ylabel('Temperature(C)','FontSize',12,'FontWeight','bold','Color','k');
% grid on
% title('relative viscosity vs Temperature(C), for Training Data using ANN','FontSize',12,'FontWeight','bold','Color','k');
% 
% figure (7)
% plot(Results_Testing,Testing_Depth,'--')
% hold on;
% plot(Output_test,Testing_Depth,'ro');
% legend('Predicted','Real');
% set (gca,'Ydir','reverse')
% xlabel('relative viscosity ');
% ylabel('Temperature(C)');
% title(' relative viscosity vs Temperature(C), for Testing Data using ANN','FontSize',12,'FontWeight','bold','Color','k');



disp ('CorrCoef_Train = '), disp (CorrCoef_Train(2,1))
disp('CorrCoef_Test'),  disp (CorrCoef_Test(2,1))

% Mean Aboslue Error or average absolute percentage error
disp ('MAE_Train = '), disp (MAE_Train)
disp('MAE_Test = '),  disp (MAE_Test)

disp ('AAPE_Train = '), disp (AAPE_Train)
disp('AAPE_Test'),  disp (AAPE_Test)

disp ('AAD_Train = '), disp (AAD_Train)
disp('AAD_Test = '),  disp (AAD_Test)
toc

 
 