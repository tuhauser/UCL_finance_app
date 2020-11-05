function settings = extend_grant(settings,N_months)

settings.endDate = settings.endDate + calmonths(N_months);
tmp = settings.startDate:calmonths(1):settings.endDate;
settings.periods = datetime(tmp,'Format','yyyy-MM');

disp(['grant extended by ' int2str(N_months) ' months.'])