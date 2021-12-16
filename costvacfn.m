function h = costvacfn(u1,u2,u3)
    global population;
    % control input weight
    cost_per_control_input = 1;

    % weight factors
    b1 = 3;
    b2 = 2;
    b3 = 1;
    
    % cost of control inputs
    u1_cost = sum((population* cost_per_control_input*u1*b1).^2);
    u2_cost = sum((population* cost_per_control_input*u2*b2).^2);
    u3_cost = sum((population* cost_per_control_input*u3*b3).^2);
    h = u1_cost + u2_cost + u3_cost;
end

