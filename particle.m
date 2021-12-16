classdef particle
    %PARTICLE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Position
        Cost
        Velocity
        Best
        
        nVar
        VarSize
        VarMin % $0 ??????
        VarMax % Cost of death * total population????? 
    end
    
    methods
        function obj = particle(~)
            %PARTICLE Construct an instance of this class
            %   Detailed explanation goes here
            
            % TODO: Modify to suit our obj fn and variables for optimization
            obj.nVar=10;            % Number of Decision Variables
            obj.VarSize=[1 obj.nVar];   % Size of Decision Variables Matrix
            obj.VarMin=-10;         % Lower Bound of Variables
            obj.VarMax= 10;         % Upper Bound of Variables
            
            % set initial position
            obj.Position = unifrnd(obj.VarMin,obj.VarMax,obj.VarSize);
            
            % set initial velocity
            obj.Velocity = zeros(obj.VarSize);
            
            % calculate initial cost based on initial position
            obj.Cost = objectiveFn(obj.Position);
            
            % set current best
            obj.Best.Position = obj.Position;
            obj.Best.Cost = obj.Cost;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
    
    %%%% Failed attempt at methods
%     methods(Static)
%         function obj = UpdateVelocity()
%             newVelocity = [8,8,8,8];
%             obj.Velocity = newVelocity;
%             
%         end
%     end
end

