function f = objectiveFnSurrogate(X0)    
    M = 365;
    ru3 = zeros(1,M+1);
    cr=0.9;
    for j=1:M+1
        if rand > cr
            ru3 (j) = 1;
        end
    end
    h_bar =0.0002;
    c3 = 0.0001;
    
    [deaths, u1, u2, u3] = siderv0(h_bar, c3, ru3);
    costhosp = costhospfn(deaths, h_bar);
    costvac = costvacfn(u1, u2, u3);
    f = costhosp + costvac;
end