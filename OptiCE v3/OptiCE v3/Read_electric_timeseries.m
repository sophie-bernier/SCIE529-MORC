function Electric_load = Read_electric_timeseries (DemandFilename)
        demandTable = readtable(DemandFilename);
        % every 15 minutes starting at 00:00 in kilowatts
        % calculate in watt-hours
        startRow = 2;
        startCol = 2;
        numRow = 365;
        numCol = 96;
        idx = 1;
        i = 1;
        countInHour = 0;
        tempDemand = 0;
        demand = 0;
        Electric_load = zeros(1,numRow*24);
        debugDemand = zeros(6,numCol*numRow,1);
        for row = startRow:(startRow+numRow-1)
            hourlyDemand = 0;
            for col = startCol:(startCol+numCol-1)
                tempDemand = demandTable{row,col};
                if ~isnan(tempDemand)
                    demand = tempDemand;
                end
                hourlyDemand = hourlyDemand + 0.25*demand;

                debugDemand(1,i) = demand;
                debugDemand(2,i) = row;
                debugDemand(3,i) = col;
                debugDemand(4,i) = hourlyDemand;
                debugDemand(6,i) = tempDemand;
                
                
                countInHour = countInHour + 1;
                if (countInHour >= 4)
                    Electric_load(idx) = hourlyDemand;
                    hourlyDemand = 0;
                    idx = idx + 1;
                    debugDemand(5,i) = 1;
                    countInHour = 0;
                end
                
                i = i+1;
            end
        end
        % normalize for Cambridge Bay, using data from QEC Power Plant Data
        % (as of 2017)
        % annualEnergy = 12902E6%Wh
        % Sachs Harbour, from Karanasios and Parker paper
        annualEnergy = 929E6%Wh
        sum(Electric_load)
        Electric_load = Electric_load.*annualEnergy./sum(Electric_load);
end