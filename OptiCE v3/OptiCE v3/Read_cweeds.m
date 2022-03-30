function T = Read_cweeds
    filename="..\..\NU_CWEEDS\CAN_NU_CAMBRIDGE-BAY-A_2400600_CWEEDS2011_T_N.WY3"
    DataStartLine =2;
    NumVariables  =47;
    % you can rename these variables no problem.
    VariableNames ={'Station','SourceCode','Year','Month','Day','Hour','ExtIr','GlobHorIr','GlobHorIrFlag','DirNormIr','DirNormIrFlag','DifHorIr','DifHorIrFlag','GloHorIllum','GloHorIllumFlag','DirNormIllum','DirNormIllumFlag','DifHorIllum','DifHorIllumFlag','ZenIll','ZenIllFlag','MinSun','MinSunFlag','CeilHeight','CeilHeightFlag','SkyCondition','SkyConditionFlag','Visibility','VisibilityFlag','PresentWeather','PresentWeatherFlag','StationPressure','StationPressureFlag','DryBulbTemp','DryBulbTempFlag','DewPointTemp','DewPointTempFlag','WindDir','WindDirFlag','WindSpeed','WindSpeedFlag','TotSkyCov','TotSkyCovFlag','OpSkyCov','OpSkyCovFlag','SnowCov','SnowCovFlag'};
    VariableWidths=[7,1,4,2,2,2,4,4,2,4,2,4,2,4,1,4,1,4,1,4,1,2,1,4,1,4,1,4,1,8,1,5,1,4,1,4,1,3,1,4,1,2,1,2,1,1,1];
    opts=fixedWidthImportOptions('NumVariables',NumVariables,'DataLines',DataStartLine,'VariableNames',VariableNames,'VariableWidths',VariableWidths);
    T = zeros(1,1);
    T = readtable(filename,opts);
end