function f = objectiveFn(X0)    
    ru3 = X0(1:366);
    h_bar = X0(367);
    c3 = X0(368);
    
    [deaths, u1, u2, u3] = siderv0(h_bar, c3, ru3);
    costhosp = costhospfn(deaths, h_bar);
    costvac = costvacfn(u1, u2, u3);
    f = costhosp + costvac;
end