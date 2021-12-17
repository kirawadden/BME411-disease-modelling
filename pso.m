function particle_swarm = pso(~)
    %%%%%%%%%%% Variables %%%%%%%%%%%
    % Max Iterations
    MAX_ITERATIONS = 200;
    
    % Number of particles
    N_PARTICLES = 20;
    
    % Array of particles in our swarm
    % Global Best - this will be our return value. Updated through the PSO
    % algorithm iterations
    global_best.cost = inf;
    global_best.position  = [];
    % need to create different ICs for each particle. Apply small offset to
    % h_bar and c3 to accomplish this. Offset not needed for ru3 since it
    % is already randomized
    offset = 0.0001;
    for i=1:N_PARTICLES
        M = 365;
        % optimization target - ru3
        ru3 = zeros(1,M+1);
        cr=0.9;
        for j=1:M+1
            if rand > cr
                ru3 (j) = 1;
            end
        end
        h_bar =0.0002 + offset;
        c3 = 0.0001 + offset;
        offset = offset + 0.0001;

        particle_array(i).N_VAR=368;                             % Number of input variables to optimize
        particle_array(i).VAR_SIZE=[1 particle_array(i).N_VAR];  % Size of input matrix
        particle_array(i).VAR_MIN=0.0;                           % Lower bound
        particle_array(i).VAR_MAX=1.0;                           % Upper bound

        % Initial particle positions = ICs
        particle_array(i).position = [ru3, h_bar, c3];

        % Particles are initially at rest
        particle_array(i).velocity = zeros(particle_array(i).VAR_SIZE);

        % Cost is based on initial position of the particles
        particle_array(i).cost = objectiveFn(particle_array(i).position);

        % Setup current best cost and position
        particle_array(i).particle_best.position = particle_array(i).position;
        particle_array(i).particle_best.cost = particle_array(i).cost;       
    end
    %%%%%%%%%%% Initialize Global Best %%%%%%%%%%%
    for i=1:N_PARTICLES
        % Update Global Best
        if particle_array(i).particle_best.cost < global_best.cost
            % Set Global Best Cost and Postion
            global_best = particle_array(i).particle_best;
        end
    end
    %%%%%%%%%%% Main Loop %%%%%%%%%%%
    % PSO Parameters
    w=1;            % Inertia Weight
    w_damp=0.99;     % Inertia Weight Damping Ratio
    c1=1.5;         % Personal Learning Coefficient
    c2=2.0;         % Global Learning Coefficient
    % Number of iterations
    for iteration=1:MAX_ITERATIONS
        % Update every particle
        for i=1:N_PARTICLES
            % Update Velocity
            particle_array(i).velocity = w*particle_array(i).velocity ...
                + c1*rand(particle_array(i).VAR_SIZE).*(particle_array(i).particle_best.position-particle_array(i).position) ...
                + c2*rand(particle_array(i).VAR_SIZE).*(global_best.position-particle_array(i).position);
            
            % Update Position new_pos = old_pos + change in pos
            particle_array(i).position = particle_array(i).position + particle_array(i).velocity;
            
            % Ensure velocity is within our bounds
            is_outside=(particle_array(i).position<particle_array(i).VAR_MIN | particle_array(i).position>particle_array(i).VAR_MAX);
            particle_array(i).velocity(is_outside)=-particle_array(i).velocity(is_outside);
            
            % Apply Position Limits
            for j=1:366
                if particle_array(i).position(j) > 1
                    particle_array(i).position(j) = 1.0;
                else
                    particle_array(i).position(j) = 0.0;
                end
            end
            for j = 367:368
                particle_array(i).position(j) = max(particle_array(i).position(j),particle_array(i).VAR_MIN);
                particle_array(i).position(j) = min(particle_array(i).position(j),particle_array(i).VAR_MAX);
                
            end

            % Update Cost
            particle_array(i).cost = objectiveFn(particle_array(i).position);
            
            % Update Personal Best and Global Best if applicable
            if particle_array(i).cost<particle_array(i).particle_best.cost
                % Update Personal Best
                particle_array(i).particle_best.position=particle_array(i).position;
                particle_array(i).particle_best.cost=particle_array(i).cost;
                
                if particle_array(i).particle_best.cost<global_best.cost
                    % Update Global Best
                    global_best=particle_array(i).particle_best;
                end
            end
        end
        % update weight
        w=w*w_damp;
    end
    particle_swarm = global_best;
end

