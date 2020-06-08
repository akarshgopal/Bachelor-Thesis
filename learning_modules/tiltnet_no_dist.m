% Table:
%   Epoch  |  Iteration  |  Time Elapsed  |  Mini-batch  |  Validation  |  Mini-batch  |  Validation  |  Base Learning  |
%|         |             |   (hh:mm:ss)   |     RMSE     |     RMSE     |     Loss     |     Loss     |      Rate       |

%Hyperparameters:
%150 neurons, zscore normalization, 2000 point val set
%Shuffling on
%|     400 |         400 |       00:00:25 |         0.02 |         0.02 |       0.0002 |       0.0002 |          0.0100 |

%8000 point val set
%|     400 |         400 |       00:00:18 |         0.02 |         0.03 |       0.0003 |       0.0004 |          0.0100 |
%Shuffling off
%|     400 |         400 |       00:00:18 |         0.02 |         0.03 |       0.0002 |       0.0004 |          0.0100 |

%500 neurons
%Shuffling off
%|     400 |         400 |       00:00:39 |         0.01 |         0.03 |   8.5896e-05 |       0.0003 |          0.0100 |
%Shuffling on
%|     400 |         400 |       00:00:38 |         0.01 |         0.02 |       0.0001 |       0.0003 |          0.0100 |

%1000 neurons
%Shuffling on
%|     400 |         400 |       00:01:10 |         0.01 |         0.02 |   7.4084e-05 |       0.0003 |          0.0100 |

% 2layer 100,50
%|     400 |         400 |       00:00:18 |         0.02 |         0.03 |       0.0003 |       0.0006 |          0.0100 |

%2layer 500,50
%|     400 |         400 |       00:00:45 |         0.03 |         0.03 |       0.0004 |       0.0005 |          0.0100 |

%2layer 500,50
%|    1000 |        1000 |       00:01:45 |         0.06 |         0.06 |       0.0016 |       0.0016 |          0.0100 |

%100 neurons
%|     400 |         400 |       00:00:15 |         0.03 |         0.04 |       0.0003 |       0.0006 |          0.0100 |

% 1-delay input
data = nodist_traindata;
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

idx = randperm(size(XTrain,2), 8000);
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

tiltnet_no_dist1 = trainNetwork(XTrain,YTrain,layers,options);