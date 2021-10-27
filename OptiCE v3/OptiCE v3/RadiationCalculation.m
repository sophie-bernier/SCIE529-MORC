function  G_T_R= RadiationCalculation (inputValues,Tilt_angle,Azimuth_angle)
% The function calculation the radiation. 

G_H_R=inputValues.G_H_R;
D_H_R=inputValues.D_H_R;             
Ambient_temperature=inputValues.Ambient_temperature;
Wind_speed=inputValues.Wind_speed;
Latitude=inputValues.Latitude;
Standard_meridian=inputValues.Standard_meridian;
Local_meridian=inputValues.Local_meridian;
Ground_reflectance=inputValues.Ground_reflectance;
Hour_day=inputValues.Hour_day;
c=inputValues.c;
Day_year=inputValues.Day_year;
Hour=inputValues.Hour;


Day_year_1=Day_year + c;
B_H_R= G_H_R-D_H_R;
declination=23.45*sin(pi*2*(284+Day_year_1)/365);
Time_correction_B=360.*(Day_year_1-1)/365;
Time_correction_E=229.2*(0.000075+0.001868.*cos(Time_correction_B*pi/180)-0.032077.*sin(Time_correction_B*pi/180)-0.014615.*cos(2*Time_correction_B*pi/180)-0.04089.*sin(2*Time_correction_B*pi/180));
Time_correction=4.*(Standard_meridian-Local_meridian)+Time_correction_E;
Local_solar_time=Hour_day+Time_correction./60;
Hour_angle=((Hour_day-12)+(Time_correction./60))*15;
Solar_altitude=asin(cos(declination.*pi/180).*cos(Hour_angle.*pi/180).*cos(Latitude.*pi/180)+sin(declination.*pi/180).*sin(Latitude.*pi/180)).*180/pi;







Solar_azimuth=zeros(size(Hour_angle));
ind=find(Hour_angle==0);
Solar_azimuth(ind)=0;
ind=find(Hour_angle<0);
Solar_azimuth(ind)=acos((cos(declination(ind).*pi/180).*cos(Hour_angle(ind).*pi/180).*sin(Latitude*pi/180)-sin(declination(ind).*pi/180).*cos(Latitude*pi/180))./cos(Solar_altitude(ind).*pi/180)).*Hour_angle(ind)./abs(Hour_angle(ind)).*180/pi;;
ind=find(Hour_angle>0);
Solar_azimuth(ind)=acos((cos(declination(ind).*pi/180).*cos(Hour_angle(ind).*pi/180).*sin(Latitude*pi/180)-sin(declination(ind).*pi/180).*cos(Latitude*pi/180))./cos(Solar_altitude(ind).*pi/180)).*Hour_angle(ind)./abs(Hour_angle(ind)).*180/pi;;

Angle_incidence=acos(cos(Solar_altitude.*pi/180).*sin(Tilt_angle.*pi/180).*cos((Solar_azimuth-Azimuth_angle).*pi/180)+sin(Solar_altitude.*pi/180).*cos(Tilt_angle.*pi/180)).*180./pi;

B_N_R=zeros(size(Solar_altitude));
ind=find(Solar_altitude<5);
B_N_R(ind)=0;
ind=find(Solar_altitude>5);
B_N_R(ind)=B_H_R(ind)./(cos((90-Solar_altitude(ind)).*pi/180));

B_T_R=zeros(size(Angle_incidence));
ind=find(Angle_incidence>90);
B_T_R(ind)=0;
ind=find(Angle_incidence<90);
B_T_R(ind)=B_N_R(ind).*cos(Angle_incidence(ind).*pi./180);

D_T_R=D_H_R*(1+cos(Tilt_angle*pi/180))/2;
G_R_R=Ground_reflectance*G_H_R*(1-cos(Tilt_angle*pi/180))/2;
G_T_R=B_T_R+D_T_R+G_R_R;