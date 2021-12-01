function plotSunPathDay (Hour_day, Solar_altitude, Solar_azimuth, Angle_incidence)
figure;
hold on;
for day = 1:90:365
plot(Hour_day((1:24)+(24*(day-1))),Solar_altitude((1:24)+(24*(day-1))),'b-');
plot(Hour_day((1:24)+(24*(day-1))),Solar_azimuth((1:24)+(24*(day-1))),'r-');
plot(Hour_day((1:24)+(24*(day-1))),Angle_incidence((1:24)+(24*(day-1))),'g-');
end
grid on;
title("Sun path diagram");
legend("Solar altitude", "Solar azimuth", "Angle of incidence");
xlabel("Local hour");
ylabel("Angle (degrees)");


figure;
hold on;
day = 1:365;
plot(day, Solar_altitude((24*(day-1))+12));
plot(day, Solar_azimuth((24*(day-1))+12));
plot(day, Angle_incidence((24*(day-1))+12));
grid on
title("Sun angles at local noon");
legend("Solar altitude", "Solar azimuth", "Angle of incidence");
xlabel("Day of the year");
ylabel("Angle (degrees)");

end