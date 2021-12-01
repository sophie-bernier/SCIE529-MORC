function inputValues = Read_input_values (weatherSource, demandSource) 
   if weatherSource == 1
        %WeatherFilename="..\..\NU_CWEEDS\CAN_NU_CAMBRIDGE-BAY-A_2400600_CWEEDS2011_T_N.WY3"
        WeatherFilename="..\..\CWEEDS_2020_NT_Rev_20210324\CAN_NT_SACHS-HARBOUR-CLIMATE_2503648_CWEEDS2011_2005-2017.WY3"
        DemandFilename=".\Whati_Generation_Sample_2017-18.xlsx"
        DataStartLine =2;
        NumVariables  =47;
        % you can rename these variables no problem.
        VariableNames ={'Station','SourceCode','Year','Month','Day', ...
                        'Hour','ExtIr','GlobHorIr','GlobHorIrFlag', ...
                        'DirNormIr','DirNormIrFlag','DifHorIr', ... 
                        'DifHorIrFlag','GloHorIllum','GloHorIllumFlag', ...
                        'DirNormIllum','DirNormIllumFlag', ...
                        'DifHorIllum','DifHorIllumFlag','ZenIll', ...
                        'ZenIllFlag','MinSun','MinSunFlag', ...
                        'CeilHeight','CeilHeightFlag','SkyCondition', ...
                        'SkyConditionFlag','Visibility', ...
                        'VisibilityFlag','PresentWeather', ...
                        'PresentWeatherFlag','StationPressure', ...
                        'StationPressureFlag','DryBulbTemp', ...
                        'DryBulbTempFlag','DewPointTemp', ...
                        'DewPointTempFlag','WindDir','WindDirFlag', ...
                        'WindSpeed','WindSpeedFlag','TotSkyCov', ...
                        'TotSkyCovFlag','OpSkyCov','OpSkyCovFlag', ...
                        'SnowCov','SnowCovFlag'};
        VariableWidths=[7,1,4,2,2,2,4,4,2,4,2,4,2,4,1,4,1,4,1,4,1,2,1, ...
                        4,1,4,1,4,1,8,1,5,1,4,1,4,1,3,1,4,1,2,1,2,1,1,1];
        opts=fixedWidthImportOptions('NumVariables',NumVariables, ...
                                     'DataLines',DataStartLine, ...
                                     'VariableNames',VariableNames, ...
                                     'VariableWidths',VariableWidths);
        WeatherTable = readtable(WeatherFilename,opts);
        years = str2double(WeatherTable.Year)';
        years_logicalArr = (years == 2010); % All entries of the desired year.
        WeatherTable = WeatherTable(years_logicalArr,:); % Cut down array to only include the desired year.
        
        % T = table2struct(T,'ToScalar',true); % if we wanted to use T as 
        % the actual input struct, this is how we'd do it.
        % We change members of struct or table from string arrs to double arrs with
        % str2double(T.GlobHorIr)';
        % and select subranges with
        % T.Month(data2.Year == 2010,:);
        % HINT: THE LAST ONE WORKS EVEN FOR SEPARATE ARRAYS NOT PART OF THE
        % SAME STRUCTURE
        
        G_H_R = (str2double(WeatherTable.GlobHorIr)')./3.6;
        %figure;
        %plot(G_H_R);
        %title("GHR");
        
        D_H_R = (str2double(WeatherTable.DifHorIllum)')./3.6;
        %figure;
        %plot(D_H_R);
        %title("DHR");
        
        Ambient_temperature = (str2double(WeatherTable.DryBulbTemp)')./10;
        %figure;
        %plot(Ambient_temperature);
        %title("Ambient temperature");
        
        Wind_speed = (str2double(WeatherTable.WindSpeed)')./10;
        %figure;
        %plot(Wind_speed);
        %title("Wind speed");
        
        %Hour_day = str2double(T.Hour)';
        %Hour_day = Hour_day - (Hour_day == 1).*0.9999 - (Hour_day > 1).*1; % hour from start of day
        %c = str2double(T.Hour)'./24; % fraction of day (23:00 is 1, 00:00 is 1/24)
        %Day_year = 1:length(T.Day);
        %Hour = (Day_year-1).*24 + str2double(T.Hour)' - 1; % hour to date from start of year
    else
        %Climatic data
        G_H_R=(xlsread('Input','Climatic_data', 'A2:A8761'))';              %Global horizontal radiation
        D_H_R=(xlsread('Input','Climatic_data', 'B2:B8761'))';              %Diffuse horizontal radiation
        Ambient_temperature=(xlsread('Input','Climatic_data', 'C2:C8761'))';%Ambient temperature
        Wind_speed=(xlsread('Input','Climatic_data', 'D2:D8761'))';         %Wind speed 10 m height
    end
        %Solar radiation data
        Hour=(xlsread('Input','Solar_radiation','A2:A8761'))';              %Parameter for calculations
        Hour_day=(xlsread('Input','Solar_radiation','B2:B8761'))';          %Parameter for calculations
        c=(xlsread('Input','Solar_radiation','C2:C8761'))';                 %Parameter for calculations
        Day_year=(xlsread('Input','Solar_radiation','D2:D8761'))';          %Parameter for calculations
    %end
    % import other data
    %Import weather data from excel file
    %xlsread yields a 1xN double.
    Latitude=(xlsread('Input','Solar_radiation','G2'));                 %Latitude
    Standard_meridian=(xlsread('Input','Solar_radiation','G3'));        %Longitude
    Local_meridian=(xlsread('Input','Solar_radiation','G4'));           %Local meridian
    Ground_reflectance=(xlsread('Input','Solar_radiation','G5'));       %Ground reflectance
    
    %PV system data    
    eta_pv_stc=(xlsread('Input','PV_system','B2'));                             %Efficiency at standard test conditions 
    mu_Voc=(xlsread('Input','PV_system','B3'));                                 %Temperature coefficient of open circuit voltage
    V_mp=(xlsread('Input','PV_system','B4'));                                   %Voltage at maximum power point
    T_stc=(xlsread('Input','PV_system','B5'));                                  %Temperature at standard test conditions 
    NOCT=(xlsread('Input','PV_system','B6'));                                   %Nominal operating cell temperature
    Area_pv=(xlsread('Input','PV_system','B7'));                                %PV module area 
    Power_module_pv=(xlsread('Input','PV_system','B8'));                        %PV module power peak
    
    %Wind power system data
    Vc=(xlsread('Input','Wind_power_system','B2'));                             %Cut-in wind speed
    Vr=(xlsread('Input','Wind_power_system','B3'));                             %Rated wind speed
    Vo=(xlsread('Input','Wind_power_system','B4'));                             %Cut-out wind speed
    eta_m=(xlsread('Input','Wind_power_system','B5'));                          %Mechanical efficiency
    eta_e=(xlsread('Input','Wind_power_system','B6'));                          %Electrical efficiency
    C_p=(xlsread('Input','Wind_power_system','B7'));                            %Coefficient of performance
    rho=(xlsread('Input','Wind_power_system','B8'));                            %Air density
    
    %Inverter data
    eta_inverter=(xlsread('Input','Inverter', 'B2'));                           %Inverter Efficiency
    
    %Battery model: Simple energy balance
    Control_soc=(xlsread('Input','Battery','B2'));                             %Minimum SOC
    eta_battery=(xlsread('Input','Battery','B3'));                             %Efficiency of the battery
    sigma=(xlsread('Input','Battery','B4'));                                   %Self-discharge
    
    %Carbon emissions data
    Carbon_tax=(xlsread('Input','Carbon_emissions','B2'));                      %Carbon tax
    Specific_carbon_emissions=(xlsread('Input','Carbon_emissions','B3'));       %Specific carbon emissions 
    
    
    %Electric and thermal load data
    if (demandSource == 1)
        Electric_load = Read_electric_timeseries (DemandFilename);
    else
        Electric_load=(xlsread('Input','Load', 'A2:A8761'))';                       %Hourly electric load for the whole year
    end
    
    %System cost data
    Specific_cost_pv=(xlsread('Input','System_cost', 'B2'));                    %Specific cost PV system
    Specific_cost_wind=(xlsread('Input','System_cost', 'B3'));                  %Specific cost wind system
    Specific_cost_battery=(xlsread('Input','System_cost', 'B4'));               %Specific cost battery
    Specific_cost_inverter=(xlsread('Input','System_cost', 'B5'));              %Specific cost inverter
    Specific_cost_diesel_generator=(xlsread('Input','System_cost', 'B6'));      %Specific cost diesel generator
    Specific_cost_diesel=(xlsread('Input','System_cost', 'B7'));                %Specific cost diesel fuel
    Specific_cost_grid=(xlsread('Input','System_cost', 'B8'));                  %Specific cost electricty taken from grid
    Specific_cost_grid_surplus=(xlsread('Input','System_cost', 'B9'));          %Specific cost electricty fed into the grid
    Project_lifetime=(xlsread('Input','System_cost', 'B10'));                   %Project lifetime
    pv_lifetime=(xlsread('Input','System_cost', 'B11'));                        %PV system lifetime
    wind_lifetime=(xlsread('Input','System_cost', 'B12'));                      %Wind power system lifetime
    battery_lifetime=(xlsread('Input','System_cost', 'B13'));                   %Battery lifetime
    inverter_lifetime=(xlsread('Input','System_cost', 'B14'));                  %Inverter lifetime
    diesel_generator_lifetime=(xlsread('Input','System_cost', 'B15'));          %Diesel generator lifetime
    Tax_rate=(xlsread('Input','System_cost', 'B16'));                           %Tax rate
    Interest_rate=(xlsread('Input','System_cost', 'B17'));                      %Interest rate
    Maintenance_rate_pv=(xlsread('Input','System_cost', 'B18'));                   %Maintenance rate
    Maintenance_rate_wind=(xlsread('Input','System_cost', 'B19'));  
    Maintenance_rate_battery=(xlsread('Input','System_cost', 'B20'));
    Maintenance_rate_diesel_generator=(xlsread('Input','System_cost', 'B21'));
    
    %STORE INPUT DATA FOR OPTIMIZATION
    %Climatic data
    inputValues.G_H_R=G_H_R;
    inputValues.D_H_R=D_H_R;             
    inputValues.Ambient_temperature=Ambient_temperature;
    inputValues.Wind_speed=Wind_speed;
    %Solar radiation data
    inputValues.Hour=Hour;
    inputValues.Hour_day=Hour_day;
    inputValues.c=c;
    inputValues.Day_year=Day_year;
    inputValues.Latitude=Latitude;
    inputValues.Standard_meridian=Standard_meridian;
    inputValues.Local_meridian=Local_meridian;
    inputValues.Ground_reflectance=Ground_reflectance;
    %PV system data    
    inputValues.bifacial_eta=0; % 0.5;
    inputValues.eta_pv_stc=eta_pv_stc;
    inputValues.mu_Voc=mu_Voc;
    inputValues.V_mp=V_mp;
    inputValues.T_stc=T_stc;
    inputValues.NOCT=NOCT;
    inputValues.Area_pv=Area_pv;
    inputValues.Power_module_pv=Power_module_pv;
    %Wind power system data
    inputValues.Vc=Vc;
    inputValues.Vr=Vr;
    inputValues.Vo=Vo;
    inputValues.eta_m=eta_m;
    inputValues.eta_e=eta_e;
    inputValues.C_p=C_p;
    inputValues.rho=rho;
    %Inverter data
    inputValues.eta_inverter=eta_inverter;
    
    inputValues.Control_soc=Control_soc;
    inputValues.eta_battery=eta_battery;
    inputValues.sigma=sigma;
    %Carbon emissions data
    inputValues.Carbon_tax=Carbon_tax;
    inputValues.Specific_carbon_emissions=Specific_carbon_emissions;
    
    %Electric and thermal load data
    inputValues.Electric_load=Electric_load;
    
    %System cost data
    inputValues.Specific_cost_pv=Specific_cost_pv;
    inputValues.Specific_cost_wind=Specific_cost_wind;
    inputValues.Specific_cost_battery=Specific_cost_battery;
    inputValues.Specific_cost_inverter=Specific_cost_inverter;
    inputValues.Specific_cost_diesel_generator=Specific_cost_diesel_generator;
    inputValues.Specific_cost_diesel=Specific_cost_diesel;
    inputValues.Specific_cost_grid=Specific_cost_grid;
    inputValues.Specific_cost_grid_surplus=Specific_cost_grid_surplus;
    inputValues.Project_lifetime=Project_lifetime;
    inputValues.pv_lifetime=pv_lifetime;                      
    inputValues.wind_lifetime=wind_lifetime;                      
    inputValues.battery_lifetime=battery_lifetime;               
    inputValues.inverter_lifetime=inverter_lifetime;                  
    inputValues.diesel_generator_lifetime=diesel_generator_lifetime;          
    inputValues.Tax_rate=Tax_rate;                         
    inputValues.Interest_rate=Interest_rate;                     
    inputValues.Maintenance_rate_pv=Maintenance_rate_pv;
    inputValues.Maintenance_rate_wind=Maintenance_rate_wind;
    inputValues.Maintenance_rate_battery=Maintenance_rate_battery;
    inputValues.Maintenance_rate_diesel_generator=Maintenance_rate_diesel_generator;
    % Specific annual CO2 and subsystem lifetimes from Kemmoku et al. (2002)
    inputValues.Specific_Annual_CO2_pv=0.267;%/1000;% kgCO2/W*year
    inputValues.Specific_Annual_CO2_wind=0.215;%/1000;% kgCO2/W*year
    inputValues.Specific_Annual_CO2_battery=0.062;%/1000; % kgCO2/W*year
    inputValues.Specific_Annual_CO2_diesel=0.066;%/1000; % kgCO2/W*year
    inputValues.Specific_CO2_pv=inputValues.Specific_Annual_CO2_pv*inputValues.pv_lifetime*ceil(inputValues.Project_lifetime/inputValues.pv_lifetime) % kgCO2/W
    inputValues.Specific_CO2_wind=inputValues.Specific_Annual_CO2_wind*inputValues.wind_lifetime*ceil(inputValues.Project_lifetime/inputValues.wind_lifetime) % kgCO2/W
    inputValues.Specific_CO2_battery=inputValues.Specific_Annual_CO2_battery*inputValues.battery_lifetime*ceil(inputValues.Project_lifetime/inputValues.battery_lifetime) % kgCO2/W
    inputValues.Specific_CO2_diesel=inputValues.Specific_Annual_CO2_diesel*inputValues.diesel_generator_lifetime*ceil(inputValues.Project_lifetime/inputValues.diesel_generator_lifetime) % kgCO2/W
    inputValues.maxElectricLoad = max(inputValues.Electric_load)
end