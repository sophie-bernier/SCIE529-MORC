%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%B-1 Inputs%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%B-1-I)Mode
%%Mode 1 - Standard-All Years , Mode 2 - Custom Time Range(fill in B-1-II) 
Mode=1;

%B-1-II)Mode 2 Configurations --> Ignore if using Mode 1
%%Time Input for custom weather file
CustomStart_Year=1999;
CustomStart_Month=1;
CustomStart_Day=1;
CustomStart_Hour=13;

CustomEnd_Year=2008;
CustomEnd_Month=12;
CustomEnd_Day=8;
CustomEnd_Hour=24;

%%Custom file name tag
CustomTag='custom'

%B-1-III) Header Lines for
%%Taken from CWEC file 
line1='LOCATION,TORONTO INTL A,ON,CAN,CWEC2011,716240,43.68,-79.63,-5.0,173.4';
line2='DESIGN CONDITIONS,1,Climate Design Data 2013 ASHRAE Handbook,,Heating,1,-18.1,-15.6,-23.3,0.5,-17.6,-20.4,0.6,-15.2,14.2,-4.7,12.7,-4.1,4.8,0,Cooling,7,9.9,31.4,22.4,29.6,21.4,27.9,20.6,23.7,29.1,22.7,27.8,21.7,26.3,5.8,270,22.1,17.1,26.7,21,16,25.6,20.1,15.1,24.6,71.9,29.2,68,28.1,64.2,26.2,692,Extremes,12.1,10.5,9.3,28.5,-21.6,33.9,3.3,1.9,-24,35.3,-25.9,36.4,-27.7,37.5,-30.1,38.9';
line3='TYPICAL/EXTREME PERIODS,6,Summer - Week Nearest Max Temperature For Period,Extreme,7/17,7/23,Summer - Week Nearest Average Temperature For Period,Typical,7/24,7/30,Winter - Week Nearest Min Temperature For Period,Extreme,1/ 4,1/10,Winter - Week Nearest Average Temperature For Period,Typical,12/ 6,12/12,Autumn - Week Nearest Average Temperature For Period,Typical,9/19,9/25,Spring - Week Nearest Average Temperature For Period,Typical,3/22,3/28';
line4='GROUND TEMPERATURES,3,.5,,,,-2.55,-3.69,-1.66,1.51,9.82,16.22,20.55,21.86,19.62,14.65,8.00,1.83,2,,,,1.66,-0.38,0.04,1.73,7.28,12.31,16.32,18.48,18.02,15.20,10.62,5.76,4,,,,5.15,3.06,2.60,3.23,6.38,9.76,12.86,15.02,15.53,14.30,11.61,8.33';
line5='HOLIDAYS/DAYLIGHT SAVINGS,No,0,0,0';
line6='COMMENTS 1,Custom/User Format -- WMO#716240; Custom DEF format for CWEC2011 formatted files.;';
line7='COMMENTS 2, -- Ground temps produced with a standard soil diffusivity of 2.3225760E-03 {m**2/day}';
line8='DATA PERIODS,1,1,Data,Sunday,1/ 1,12/31';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Script%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Process Begins\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% B-2 Extract File Names %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Extract File Names\n')
datedir = dir('*.WY3');
filenames = {datedir.name};
filenames = filenames';

z=1;
d=1;
chr=string(filenames);

%Splitting file name so parts of it can be used in exported files
filenames=chr;
[u,y]=size(filenames);
filnamediv=split(filenames,'_');
filenamediv=string(filnamediv);
filenamediv=filenamediv';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% B-3 Extract Data from Files %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Iterates through the list of file in folder 
fprintf('Extract Data From Files\n')

for z=1:u
EPW = cell2table(cell(0,5)) ;
RelHum=zeros(1,1);

    
q=0;
filename=filenames(z,1);
%convert wy3 to txt
file1=filenames(z,1);
file2=strrep(file1,'.WY3','.txt');

file1=char(file1);
file2=char(file2);

copyfile(file1,file2);

%extract variables from fixed width txt
DataStartLine = 2;  
NumVariables = 47;
VariableNames  = {'Station','SourceCode','Year','Month','Day','Hour','ExtIr','GlobHorIr','GlobHorIrFlag','DirNormIr','DirNormIrFlag','DifHorIr','DifHorIrFlag','GloHorIllum','GloHorIllumFlag','DirNormIllum','DirNormIllumFlag','DifHorIllum','DifHorIllumFlag','ZenIll','ZenIllFlag','MinSun','MinSunFlag','CeilHeight','CeilHeightFlag','SkyCondition','SkyConditionFlag','Visibility','VisibilityFlag','PresentWeather','PresentWeatherFlag','StationPressure','StationPressureFlag','DryBulbTemp','DryBulbTempFlag','DewPointTemp','DewPointTempFlag','WindDir','WindDirFlag','WindSpeed','WindSpeedFlag','TotSkyCov','TotSkyCovFlag','OpSkyCov','OpSkyCovFlag','SnowCov','SnowCovFlag'};
VariableWidths = [7,1,4,2,2,2,4,4,2,4,2,4,2,4,1,4,1,4,1,4,1,2,1,4,1,4,1,4,1,8,1,5,1,4,1,4,1,3,1,4,1,2,1,2,1,1,1] ;                                                  

opts=fixedWidthImportOptions('NumVariables',NumVariables,'DataLines',DataStartLine,'VariableNames',VariableNames,'VariableWidths',VariableWidths);

T =zeros(1,1);
T = readtable(filename,opts);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% C-1 Assign Variables to Weather Elements + Data Processing%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Process Data\n')
%Date
YEAR=T.Year;
DAY=T.Day;
MONTH=T.Month;

%Time
minute=zeros(size(T.Hour));
MINUTE=string(minute);
HOUR=T.Hour;


%DataSource
Datasource=zeros(size(T.Hour));
Datasource=string(Datasource);
Datasource(:,1)={'?9?9?9?9E0?9?9?9?9?9?9?9*9?9?9?9?9?9*9*_?9*9'};

%DryBulb
DryBulb=string(T.DryBulbTemp);
DryBulb=str2double(DryBulb);
DryBulb=(0.1)*DryBulb;
DryBulb=round(DryBulb,1);


%DewPoint
DewPoint=string(T.DewPointTemp);
DewPoint=str2double(DewPoint);
DewPoint=(0.1)*DewPoint;
DewPoint=round(DewPoint,1);

%RelativeHumidity 
%refer to http://www.bom.gov.au/climate/averages/climatology/relhum/calc-rh.pdf
i=0;
for i=1:size(DryBulb)
v(i,1)=100*exp(1.8096+((17.2694*DewPoint(i,1)/(237.3+DewPoint(i,1)))));
r(i,1)=exp(1.8096+((17.2694*DryBulb(i,1))/(237.3+DryBulb(i,1))));
RelHum(i,1)=v(i,1)/r(i,1);
RelHum=round(RelHum);
i=i+1;
end

%AtmosPressure
AtmosPressure=string(T.StationPressure);
AtmosPressure=str2double(AtmosPressure);
AtmosPressure=(10)*AtmosPressure;


%ExtHorzRad
ExtHorzRad=string(T.ExtIr);
ExtHorzRad=str2double(ExtHorzRad);
ExtHorzRad=ExtHorzRad/(3.6);
ExtHorzRad=round(ExtHorzRad);


%ExtDirRad
ExtDirRad=zeros(size(T.Hour));
ExtDirRad=string(ExtDirRad);
ExtDirRad(:,1)={'9999'};


OpaqSkyCvr=T.OpSkyCov;
OpaqSkyCvr=str2double(OpaqSkyCvr);

%HorzIRSky
HorzIRSky=zeros(size(T.Hour));
HorzIRSky=string(HorzIRSky);
HorzIRSky(:,1)={'9999'};

%GloHorzRad
GloHorzRad=T.GlobHorIr;
GloHorzRad=str2double(GloHorzRad);
GloHorzRad=GloHorzRad/(3.6);
GloHorzRad=round(GloHorzRad);

%DirNormRad
DirNormRad=T.DirNormIr;
DirNormRad=str2double(DirNormRad);
DirNormRad=DirNormRad/(3.6);
DirNormRad=round(DirNormRad);

%DifHorzRad
DifHorzRad=T.DifHorIr;
DifHorzRad=str2double(DifHorzRad);
DifHorzRad=DifHorzRad/(3.6);
DifHorzRad=round(DifHorzRad);

%GloHorzIllum
GloHorzIllum=T.GloHorIllum;
GloHorzIllum=str2double(GloHorzIllum);
GloHorzIllum=GloHorzIllum*(100);
GloHorzIllum=round(GloHorzIllum);

%DirNormIllum
DirNormIllum=T.DirNormIllum;
DirNormIllum=str2double(DirNormIllum);
DirNormIllum=DirNormIllum*(100);
DirNormIllum=round(DirNormIllum);

%DifHorzIllum
DifHorzIllum=T.DifHorIllum;
DifHorzIllum=str2double(DifHorzIllum);
DifHorzIllum=DifHorzIllum*(100);
DifHorzIllum=round(DifHorzIllum);

%ZenLum
ZenLum=T.ZenIll;
ZenLum=str2double(ZenLum);
ZenLum=ZenLum*(100);
ZenLum=round(ZenLum);

%WindDir
WindDir=T.WindDir;

%WindSpd
WindSpd=T.WindSpeed;
WindSpd=str2double(WindSpd);
WindSpd=WindSpd/(10);
WindSpd=round(WindSpd,1);

%TotSkyCvr
TotSkyCvr=T.TotSkyCov;

%OpaqSkyCvr
OpaqSkyCvr=T.OpSkyCov;

%Visibility
Visibility=T.Visibility;
Visibility=str2double(Visibility);
Visibility=Visibility/(10);
Visibility=round(Visibility);

%CeilingHgt
CeilingHgt=T.CeilHeight;
CeilingHgt=str2double(CeilingHgt);
CeilingHgt=CeilingHgt*(10);


%PresWeathObs
PresWeathObs=zeros(size(T.Hour));
PresWeathObs=string(PresWeathObs);
PresWeathObs(:,1)={'9'};

%PresWeathCodes
PresWeathCodes=T.PresentWeather;


%PrecipWtr
PrecipWtr=zeros(size(T.Hour));
PrecipWtr=string(PrecipWtr);
PrecipWtr(:,1)={'999'};


%AerosolOptDepth
AerosolOptDepth=zeros(size(T.Hour));
AerosolOptDepth=string(AerosolOptDepth);
AerosolOptDepth(:,1)={'999'};

%SnowDepth should be in cm but kept to be consistent with CWEC
SnowDepth=T.SnowCov;

%DaysLastSnow

DaysLastSnow=zeros(size(T.Hour));
DaysLastSnow=string(DaysLastSnow);
DaysLastSnow(:,1)={'88'};

%Albedo

Albedo=zeros(size(T.Hour));
Albedo=string(Albedo);
Albedo(:,1)={'999'};

%Rain
 
Rain=zeros(size(T.Hour));
Rain=string(Rain);
Rain(:,1)={'999'};

%RainQuantity

RainQuantity=zeros(size(T.Hour));
RainQuantity=string(RainQuantity);
RainQuantity(:,1)={'99'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%C-2 Organize all data into a table%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EPW=table(YEAR,MONTH,DAY,HOUR,MINUTE,Datasource,DryBulb,DewPoint,RelHum,AtmosPressure,ExtHorzRad,ExtDirRad,HorzIRSky,GloHorzRad,DirNormRad,DifHorzRad,GloHorzIllum,DirNormIllum,DifHorzIllum,ZenLum,WindDir,WindSpd,TotSkyCvr,OpaqSkyCvr,Visibility,CeilingHgt,PresWeathObs,PresWeathCodes,PrecipWtr,AerosolOptDepth,SnowDepth,DaysLastSnow,Albedo,Rain,RainQuantity);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% D-I Mode 1 script%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Mode==1

%separate data into years
[sizeTm,sizeTn]=size(T.Year);

endyear=str2double(T{sizeTm,'Year'});
startyear=str2double(T{1,'Year'});

range=endyear-startyear+1;



v=1;
w=1;
q=1;
leapyears=[1976 1980 1984 1988 1992 1996 2000 2004 2008 2012 2016];


houradd=0;
u=1;

for v=1:range

    
year=str2double(T{q,'Year'});  
   
  if ismember(year,leapyears)==1
    
    n=366;
    
  else
    n=365;
    
  end
  
hourstart=u;

houradd=n*24;

hourend=(u+houradd)-1;

EPWYEAR=EPW(hourstart:hourend,:);

u=u+(n*24);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% E-1 export table to txt, remove headerline with variable names%%%%%%%%%%%%%%%%%%%%%%
epwyeartoyear=sprintf('%s_%s_%s_%s_%d.txt',filenamediv(z,1),filenamediv(z,2),filenamediv(z,3),filenamediv(z,4),year)
writetable(EPWYEAR,epwyeartoyear,'WriteVariableNames',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% E-2 read txt file and store as string%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile = fopen(epwyeartoyear,'r');
tabstr = textscan(tempfile,'%s','Delimiter','\n');
fclose(tempfile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% E-3 combine header lines with string%%%%%%%%%%%%%%%%%%%%%%%%%%%%
header = [line1;line2;line3;line4;line5;line6;line7;line8;tabstr{1}];
%%%%%%%%%%%%%%%%%%%%%%%%%%%% F-1 Export to txt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile2 = fopen(epwyeartoyear,'w');
fprintf(tempfile2,'%s\n', header{:});
fclose(tempfile2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%% F-2 Convert txt to epw %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1=epwyeartoyear;
file2=strrep(file1,'.txt','.epw');

file1=char(file1);
file2=char(file2);

copyfile(file1,file2);

q=q+(24*n);

end

else
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% D-II Mode 2 script%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Custom Time Range
YEARstr=str2double(string(YEAR));
MONTHstr=str2double(string(MONTH));
DAYstr=str2double(string(DAY));
HOURstr=str2double(HOUR);


%create datetime coloumn 
t1=datetime(YEARstr,MONTHstr,DAYstr,HOURstr,minute,minute);

%insert datetime coloumn and create time table
EPWs=timetable(t1,YEAR,MONTH,DAY,HOUR,MINUTE,Datasource,DryBulb,DewPoint,RelHum,AtmosPressure,ExtHorzRad,ExtDirRad,HorzIRSky,GloHorzRad,DirNormRad,DifHorzRad,GloHorzIllum,DirNormIllum,DifHorzIllum,ZenLum,WindDir,WindSpd,TotSkyCvr,OpaqSkyCvr,Visibility,CeilingHgt,PresWeathObs,PresWeathCodes,PrecipWtr,AerosolOptDepth,SnowDepth,DaysLastSnow,Albedo,Rain,RainQuantity);

%assigning start time and end time based on custom time range input
ts=datetime(CustomStart_Year,CustomStart_Month,CustomStart_Day,CustomStart_Hour,0,0);
te=datetime(CustomEnd_Year,CustomEnd_Month,CustomEnd_Day,CustomEnd_Hour,0,0);

%calcuate time range
TR = timerange(ts,te,'closed');

%extract data from custom time range
EPWEX = EPWs(TR,:);

%convert timetable back to table
EPWEX=timetable2table(EPWEX);

%remove datetime coloumn 
EPWEX.t1=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%% E-1 export table to txt, remove headerline with variable names%%%%%%%%%%%%%%%%%%%%%%
epwcustomyear=sprintf('%s_%s_%s_%s_%s.txt',filenamediv(z,1),filenamediv(z,2),filenamediv(z,3),filenamediv(z,4),CustomTag)
writetable(EPWEX,epwcustomyear,'WriteVariableNames',0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%% E-2 read txt file and store as string%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile = fopen(epwcustomyear,'r');
tabstr = textscan(tempfile,'%s','Delimiter','\n');
fclose(tempfile);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% E-3 combine header lines with string%%%%%%%%%%%%%%%%%%%%%%%%%%%%
header = [line1;line2;line3;line4;line5;line6;line7;line8;tabstr{1}];



%%%%%%%%%%%%%%%%%%%%%%%%%%%% F-1 Export to txt %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tempfile2 = fopen(epwcustomyear,'w');
fprintf(tempfile2,'%s\n', header{:});
fclose(tempfile2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%% F-2 Convert txt to epw %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
file1=epwcustomyear;
file2=strrep(file1,'.txt','.epw');

file1=char(file1);
file2=char(file2);
 
copyfile(file1,file2);


end

z=z+1;
fprintf('Next File\n')
end

fprintf('Processing Ends\n')

