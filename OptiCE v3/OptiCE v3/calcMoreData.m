function fooTable = calcMoreData(refDieselLitres, refDieselPower, ...
                                 refScore, finalScores, DieselLitres, DieselPower, lcoe)

DieselLitresOffset = zeros(1,6);
DieselDisplaced = zeros(1,6);
EmissionsOffset = zeros(1,6);
outputLcoe = zeros(1,6);
outputLcc = zeros(1,6);
minLCC = zeros(1,6);
minLCCIdx = zeros(1,6);

minLcoe = 0;
maxLcoe = 100;
minDiesel = 0;
maxDiesel = 1E20;

for i = 1:6
    indices = (DieselLitres(:,i) <= maxDiesel) ...
                & (DieselLitres(:,i) >= minDiesel) ...
                & (lcoe(:,i) <= maxLcoe) ...
                & (lcoe(:,i) >= minLcoe)
    if ~indices
        DieselLitresOffset(i) = NaN;
        DieselDisplaced(i) = NaN;
        EmissionsOffset(i) = NaN;
        outputLcoe(i) = NaN;
        outputLcc(i) = NaN;
    else
        tempFinalScores = finalScores(indices,:,i);
        tempLcoe = lcoe(indices,i);
        tempDieselPower = DieselPower(indices,i);
        tempDieselLitres = DieselLitres(indices,i);
        
        tempFinalScores(:,1)
        min(tempFinalScores(:,1))
        minLCC(i) = min(tempFinalScores(:,1));
        minLCCIdx(i) = find(tempFinalScores(:,1) == minLCC(i),1);
        
        DieselLitresOffset(i) = refDieselLitres ...
                                - tempDieselLitres(minLCCIdx(i));
        DieselDisplaced(i) = refDieselPower ...
                             - tempDieselPower(minLCCIdx(i));
        EmissionsOffset(i) = refScore(3) ...
                             - tempFinalScores(minLCCIdx(i),3);
        outputLcoe(i) = tempLcoe(minLCCIdx(i));
        outputLcc(i) = tempFinalScores(minLCCIdx(i),1);
    end
end

fooTable(:,1) = DieselDisplaced'./(1E6);
fooTable(:,2) = DieselLitresOffset';
fooTable(:,3) = EmissionsOffset'./1000;
fooTable(:,4) = outputLcoe';
fooTable(:,5) = outputLcc';

end