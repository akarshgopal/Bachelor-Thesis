% Table:
%   Epoch  |  Iteration  |  Time Elapsed  |  Mini-batch  |  Validation  |  Mini-batch  |  Validation  |  Base Learning  |
%|         |             |   (hh:mm:ss)   |     RMSE     |     RMSE     |     Loss     |     Loss     |      Rate       |
%150 neurons
%|     400 |         400 |       00:00:23 |         0.02 |         0.02 |       0.0002 |       0.0003 |          0.0100 |

%500 neurons
%|     400 |         400 |       00:00:43 |         0.01 |         0.02 |   5.7758e-05 |       0.0002 |          0.0100 |

%1000 neurons
%|     400 |         400 |       00:01:10 |         0.01 |         0.02 |   6.8850e-05 |       0.0002 |          0.0100 |

% 1-delay input
data = modeldist_traindata;
inputdata =[data(:,1:12) data(:,49:56)];
YTrain = (data(:,31:33)-data(:,43:45))';

XTrain = inputdata';

numFeatures = length(XTrain(:,1));
numResponses = length(YTrain(:,1));

layers = [ ...
    sequenceInputLayer(numFeatures,'Normalization','zscore')
    fullyConnectedLayer(150)
    reluLayer
    fullyConnectedLayer(numResponses)
    regressionLayer];

maxEpochs = 400;
miniBatchSize = 32;

idx = randperm(size(XTrain,2),8000);
XValidation = XTrain(:,idx);
XTrain(:,idx) = [];
YValidation = YTrain(:,idx);
YTrain(:,idx) = [];

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'ValidationData',{XValidation,YValidation}, ...
    'ValidationFrequency',30, ...
    'InitialLearnRate',0.01, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress',...
    'Verbose',1);

tiltnet_modeldist1 = trainNetwork(XTrain,YTrain,layers,options);