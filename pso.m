function particle_swarm = pso(~)
    
    %%%%%%%%%%% Variables %%%%%%%%%%%
       
    % Max Iterations
    Max_It = 200;
    
    % Number of particles
    N_Particles = 20;
    
    % Array of particles in our swarm
    % Global Best - this will be our return value. Updated through the PSO
    % algorithm iterations
    Global_Best.Cost = inf;
    Global_Best.Postition  = [];
    % need to create different ICs for each particle. Apply small offset to
    % h_bar and c3 to accomplish this. Offset not needed for ru3 since it
    % is already randomized
    offset = 0.0001;
    for i=1:N_Particles
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

        particle_array(i).nVar=368;                           % Number of input variables to optimize
        particle_array(i).VarSize=[1 particle_array(i).nVar]; % Size of input matrix
        particle_array(i).VarMin=0.0;                           % Lower bound
        particle_array(i).VarMax=1.0;                           % Upper bound

        % Initial particle positions = ICs
        particle_array(i).Position = [ru3, h_bar, c3];

        % Particles are initially at rest
        particle_array(i).Velocity = zeros(particle_array(i).VarSize);

        % Cost is based on initial position of the particles
        particle_array(i).Cost = objectiveFn(particle_array(i).Position);

        % Setup current best cost and position
        particle_array(i).Best.Position = particle_array(i).Position;
        particle_array(i).Best.Cost = particle_array(i).Cost;       
    end

    
    %%%%%%%%%%% Initialize Global Best %%%%%%%%%%%
    for i=1:N_Particles
        % Update Global Best
        if particle_array(i).Best.Cost < Global_Best.Cost
            % Set Global Best Cost and Postion
            Global_Best = particle_array(i).Best;
        end
    end
    
    %%%%%%%%%%% Main Loop %%%%%%%%%%%
    % PSO Parameters
    w=1;            % Inertia Weight
    wdamp=0.99;     % Inertia Weight Damping Ratio
    c1=1.5;         % Personal Learning Coefficient
    c2=2.0;         % Global Learning Coefficient
    
    % Number of iterations
    for iteration=1:Max_It
        % Update every particle
        for i=1:N_Particles
            
            % Update Velocity
            particle_array(i).Velocity = w*particle_array(i).Velocity ...
                + c1*rand(particle_array(i).VarSize).*(particle_array(i).Best.Position-particle_array(i).Position) ...
                + c2*rand(particle_array(i).VarSize).*(Global_Best.Position-particle_array(i).Position);
            
 
            % Update Position new_pos = old_pos + change in pos
            particle_array(i).Position = particle_array(i).Position + particle_array(i).Velocity;
            
            % Ensure velocity is within our bounds
            IsOutside=(particle_array(i).Position<particle_array(i).VarMin | particle_array(i).Position>particle_array(i).VarMax);
            particle_array(i).Velocity(IsOutside)=-particle_array(i).Velocity(IsOutside);
            
            % Apply Position Limits
            for j=1:366
                if particle_array(i).Position(j) > 1
                    particle_array(i).Position(j) = 1.0;
                else
                    particle_array(i).Position(j) = 0.0;
                end
            end
            for j = 367:368
                particle_array(i).Position(j) = max(particle_array(i).Position(j),particle_array(i).VarMin);
                particle_array(i).Position(j) = min(particle_array(i).Position(j),particle_array(i).VarMax);
                
            end

            % Update Cost
            particle_array(i).Cost = objectiveFn(particle_array(i).Position);
            
            % Update Personal Best and Global Best if applicable
            if particle_array(i).Cost<particle_array(i).Best.Cost
                % Update Personal Best
                particle_array(i).Best.Position=particle_array(i).Position;
                particle_array(i).Best.Cost=particle_array(i).Cost;
                
                if particle_array(i).Best.Cost<Global_Best.Cost
                    % Update Global Best
                    Global_Best=particle_array(i).Best;
                end
            end
        end
        % update weight
        w=w*wdamp;
    end
    
    particle_swarm = Global_Best;
end

