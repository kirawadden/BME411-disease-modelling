function h = costvacfn(u1,u2,u3)
    global population;
    % control input weight
    cost_per_vaccine = 20;
    cost_per_test = 139;
    cost_govt_control = 1;

    % weight factors
    b1 = 3;
    b2 = 2;
    b3 = 1;
    
    % cost of control inputs
    u1_cost = sum((population*cost_govt_control*u1*b1).^1.5);
    u2_cost = sum((population*cost_per_test*u2*b2).^1.5);
    u3_cost = sum((population*cost_per_vaccine*u3*b3).^1.5);
    h = u1_cost + u2_cost + u3_cost;
end

