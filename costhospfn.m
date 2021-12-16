function g = costhospfn(deaths, h_bar)
    global population;

    cost_per_death = 9300000;
    % convert death to $
    death_cost = population*cost_per_death*sum(deaths);

    cost_per_hospitalization = 20000;
    % convert hospitalization to $
    hosp_cost = population*cost_per_hospitalization*h_bar;

    g = death_cost + hosp_cost; 
end