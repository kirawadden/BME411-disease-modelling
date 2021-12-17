% Get objective function
% objectiveFn --> siderv0 --> to get initial shit
% objectiveFn --> costvacfn & costhospfn --> to get cost

% Run objective fn through PSO
% pso --> to get optimal solution
fprintf('Particle Swarm Optimization: ');
tic
fmin = pso();
toc

[x1, x2, x3, x4, x5, x6, x7] = simGraph(fmin.position(367), fmin.position(368), fmin.position(1:366));

figure;
plot(x1);
hold
plot(x2);
plot(x3);
plot(x4);
plot(x5);
plot(x6,'*');
plot(x7);
ylabel("Model parameters");
xlabel("Days");
title("Model parameters vs. Days - Particle Swarm");
legend('S','Iu','ID','A', 'R','D','V');

% compare second optimization method
% Matlab problem based approach
prob.Objective = 'objectiveFnSurrogate';
% setup upper and lower bounds similar to PSO
prob.ub = ones(1,368);
prob.lb = zeros(1,368);
prob.intcon = 1:366;
prob.nvars = 368;
prob.solver = 'surrogateopt';
% MaxFunctionEvaluations is the same as PSO
prob.options = optimoptions('surrogateOpt', 'MaxFunctionEvaluations', 200);

fprintf("Surrogate Optimization: ");
tic
[x, fmin_surrogate] = surrogateopt(prob);
toc
% Simulate and graph the results
[x1, x2, x3, x4, x5, x6, x7] = simGraph(x(367), x(368), x(1:366));

figure;
plot(x1);
hold
plot(x2);
plot(x3);
plot(x4);
plot(x5);
plot(x6,'*');Position
plot(x7);
ylabel("Model parameters");
xlabel("Days");
title("Model parameters vs. Days - Surrogate Optimization");
legend('S','Iu','ID','A', 'R','D','V');


