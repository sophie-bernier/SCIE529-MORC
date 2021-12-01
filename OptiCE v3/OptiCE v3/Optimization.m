function [population, scores] = Optimization (lb, ub, inputValues, populationSize, numberOfGenerations)

% LICENSE
%Copyright (c) <2016> <Pietro Elia Campana, Yang Zhang, and Jinyue Yan>
%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in OptiCE without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom OptiCE is furnished to do so, subject to the following conditions:
%The above copyright notice and this permission notice shall be included in all copies or substantial portions of OptiCE.
%OptiCE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH OptiCE OR THE USE OR OTHER DEALINGS IN OptiCE

% GENETIC ALGORITHM OPTIMIZATION
FitnessFunction = @(x)Simulation_for_optimization(x,inputValues,true);
numberOfVariables = 6;

opts = gaoptimset('PlotFcns',{@gaplotpareto,@gaplotscorediversity},'UseParallel',1,...
'Generations',numberOfGenerations,'CrossoverFcn',{@crossoverheuristic},'CrossoverFraction',0.5,'PopulationSize',populationSize); 
%default pop 50
%default 100 generations
%constrain for initial investment
%constrain it like this and it basically converges to a single point
%would probably(?) be more interesting if we constrain the whole LCC 
b = []; %5E6; % initial investment
A = []; %[0,0,inputValues.Specific_cost_pv,0,inputValues.Specific_cost_wind,inputValues.Specific_cost_battery];
[x,fval,exitflag,output,population,scores] = gamultiobj(FitnessFunction,numberOfVariables,A,b,[],[],lb,ub,[],opts);

%PRINT RESULTS
xlswrite('Output.xlsx',scores,'scores')
xlswrite('Output.xlsx',population,'population')

end