% Table:
%   Epoch  |  Iteration  |  Time Elapsed  |  Mini-batch  |  Validation  |  Mini-batch  |  Validation  |  Base Learning  |
%|         |             |   (hh:mm:ss)   |     RMSE     |     RMSE     |     Loss     |     Loss     |      Rate       |

%100 neurons
%|     400 |         400 |       00:00:15 |         0.04 |         0.05 |       0.0010 |       0.0011 |          0.0100 |

%150 neurons
%|     400 |         400 |       00:00:18 |         0.03 |         0.04 |       0.0005 |       0.0007 |          0.0100 |
%|     400 |         400 |       00:00:16 |         0.03 |         0.04 |       0.0005 |       0.0008 |          0.0100 |

%500 neurons
%|     400 |         400 |       00:00:39 |         0.02 |         0.03 |       0.0002 |       0.0004 |          0.0100 |

%1000 neurons
%|     400 |         400 |       00:01:11 |         0.02 |         0.02 |       0.0002 |       0.0002 |          0.0100 |

%2 layer 150,50
%|     400 |         400 |       00:00:23 |         0.03 |         0.04 |       0.0004 |       0.0008 |          0.0100 |

%2 layer 300,50
%|     400 |         400 |       00:00:31 |         0.03 |         0.04 |       0.0005 |       0.0008 |          0.0100 |

%deeper or wider does not lead to better results.

% 1-delay input
data=gedist_traindata;
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

tiltnet_ge1= trainNetwork(XTrain,YTrain,layers,options);