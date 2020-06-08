% Table:
%   Epoch  |  Iteration  |  Time Elapsed  |  Mini-batch  |  Validation  |  Mini-batch  |  Validation  |  Base Learning  |
%|         |             |   (hh:mm:ss)   |     RMSE     |     RMSE     |     Loss     |     Loss     |      Rate       |
%150 neurons
%|     400 |         400 |       00:00:26 |         0.06 |         0.05 |       0.0016 |       0.0012 |          0.0100 |
%|     400 |         400 |       00:00:16 |         0.06 |         0.06 |       0.0016 |       0.0016 |          0.0100 |

%500 neurons
%|     400 |         400 |       00:00:45 |         0.04 |         0.05 |       0.0008 |       0.0013 |          0.0100 |

%1000 neurons
%|     400 |         400 |       00:01:03 |         0.04 |         0.04 |       0.0035 |       0.0008 |          0.0100 |

%2 layer 150,50
%|     400 |         400 |       00:00:25 |         0.04 |         0.13 |       0.0007 |       0.0078 |          0.0100 |

%2 layer 500,50
%|     400 |         400 |       00:00:45 |         0.05 |         0.07 |       0.0013 |       0.0025 |          0.0100 |

%2 layer 500,100
%|     400 |         400 |       00:00:57 |         0.06 |         0.15 |       0.0016 |       0.0111 |          0.0100 |


% 1-delay input
data = sigmoiddist_traindata;
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

tiltnet_sigmoid1 = trainNetwork(XTrain,YTrain,layers,options);