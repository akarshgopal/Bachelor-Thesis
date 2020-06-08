% Table:
%100 neurons
%|     400 |         400 |       00:00:15 |         0.04 |         0.04 |       0.0008 |       0.0009 |          0.0100 |

%150 neurons
%|     400 |         400 |       00:00:18 |         0.04 |         0.04 |       0.0007 |       0.0008 |          0.0100 |


%500 neurons
%|     400 |         400 |       00:00:37 |         0.02 |         0.06 |       0.0002 |       0.0019 |          0.0100 |

%1000 neurons
%|     400 |         400 |       00:01:10 |         0.02 |         0.06 |       0.0001 |       0.0019 |          0.0100 |

%2 layer 100,50
%|     400 |         400 |       00:00:19 |         0.04 |         0.03 |       0.0007 |       0.0005 |          0.0100 |


% 1-delay input
data = constdist_traindata;
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

tiltnet_const1= trainNetwork(XTrain,YTrain,layers,options);