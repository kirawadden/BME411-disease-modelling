function particle_swarm = pso(~)
    
    %%%%%%%%%%% Variables %%%%%%%%%%%
       
    % Max Iterations
    Max_It = 100; % TODO fine tune
    
    % Number of particles
    N_Particles = 20; % TODO fine tune
    
    % Array of particles in our swarm
    % Creates and Initializes Particle Data via particle class
    Global_Best.Cost = inf;
    Global_Best.Postition  = [];
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
        %PARTICLE Construct an instance of this class
        %   Detailed explanation goes here

        % TODO: Modify to suit our obj fn and variables for optimization
        particle_array(i).nVar=368;            % Number of Decision Variables
        particle_array(i).VarSize=[1 particle_array(i).nVar];   % Size of Decision Variables Matrix
        particle_array(i).VarMin=0;         % Lower Bound of Variables
        particle_array(i).VarMax=1;         % Upper Bound of Variables

        particle_array(i).Position = [ru3, h_bar, c3];

        % set initial velocity
        particle_array(i).Velocity = zeros(particle_array(i).VarSize);

        % calculate initial cost based on initial position
        particle_array(i).Cost = objectiveFn(particle_array(i).Position);

        % set current best
        particle_array(i).Best.Position = particle_array(i).Position;
        particle_array(i).Best.Cost = particle_array(i).Cost;
        % Global Best
       
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
            % check if velocity is within our bounds
            
 
            % Update Position
            particle_array(i).Position = particle_array(i).Position + particle_array(i).Velocity;
            
            % TODO may or may not need to check if velocity is within our
            % bounds... whatever those may be
            
            % Velocity Mirror Effect
            IsOutside=(particle_array(i).Position<particle_array(i).VarMin | particle_array(i).Position>particle_array(i).VarMax);
            particle_array(i).Velocity(IsOutside)=-particle_array(i).Velocity(IsOutside);
            
            % Apply Position Limits
            for j=1:366
                if particle_array(i).Position(j) > 1
                    particle_array(i).Position(j) = 1;
                else
                    particle_array(i).Position(j) = 0;
                end
            end
            for j = 367:368
                particle_array(i).Position(j) = max(particle_array(i).Position(j),particle_array(i).VarMin);
                particle_array(i).Position(j) = min(particle_array(i).Position(j),particle_array(i).VarMax);
                
            end
            
%             
            
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
        % update weight
        w=w*wdamp;
    end
    
    particle_swarm = Global_Best;
end

