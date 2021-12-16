function particle_swarm = pso(~)
    
    %%%%%%%%%%% Variables %%%%%%%%%%%
       
    % Max Iterations
    Max_It = 100; % TODO fine tune
    
    % Number of particles
    N_Particles = 20; % TODO fine tune
    
    % Array of particles in our swarm
    % Creates and Initializes Particle Data via particle class
    particle_array=repmat(particle,N_Particles,1);
    
    % Global Best
    Global_Best.Cost = inf;
    Global_Best.Postition  = []; 
    
    %%%%%%%%%%% Initialize Global Best %%%%%%%%%%%
    for i=1:N_Particles
        % Update Global Best
        if particle_array(i).Best.Cost < Global_Best.Cost
            % Set Global Best Cost and Postion
            Global_Best = particle_array(i).Best;
        end
    end
    
    %%%%%%%%%%% Main Loop %%%%%%%%%%%
    
    % TODO - make our own... also, do we need to update these? some people
    % do and others do not
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
            
            particle_array(i).Velocity
            % TODO may or may not need to check if velocity is within our
            % bounds... whatever those may be
            
 
            % Update Position
            particle_array(i).Position = particle(i).Position + particle(i).Velocity;
            
            % TODO may or may not need to check if velocity is within our
            % bounds... whatever those may be
            
            % Update Cost
            particle_array(i).Cost = objectiveFn(particle_array(i).Position);
            particle_array(i).Cost
            
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
        % TODO --- How do we want to go about updating the coeffs?
        % Everyone updates w, some people update c1 and c2 as well
        w=w*wdamp;
    end
    
    particle_swarm = Global_Best;
end

