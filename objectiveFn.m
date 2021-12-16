function f = objectiveFn(X0)

M = 365;
% optimization target - ru3
ru3 = zeros(1,M+1);
cr=0.9;
for i=1:M+1
    if rand > cr
        ru3 (i) = 1;
    end
end
h_bar =0.00222;
c3 = 0.03;
% X0 = [ru3, c3, h_bar];     
%     ru3 = X0(1:366);
%     h_bar = X0(367);
%     c3 = X0(368);

    
    [deaths, u1, u2, u3] = siderv0(h_bar, c3, ru3);
    f = costhospfn(deaths, h_bar) + costvacfn(u1, u2, u3);
end