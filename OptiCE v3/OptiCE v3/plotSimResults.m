figure;
hold on;
plot(Power_pv);
plot(Power_wind);
plot(Diesel_Production);
plot(Battery_charged);
plot(inputValues.Electric_load)
legend("Power pv", "Power wind", "Power diesel", "Battery charge", "Electric load");