rosshutdown
clear all
close all
clc
%% Create a ROS master in MATLAB
rosinit

%% Start the simulator
sim = RobotSimulator('emptyMap');

%% Control parameters
xGoal = 1;
yGoal = 2;
goalRadius = 0.5;
K_angle = 1;
K_pos = 1;

%% Create subscribers
odomSub = rossubscriber('/odom');

%% Create publishers
velPub = rospublisher('/mobile_base/commands/velocity');

%% Receive the latest odometry message
odomData = odomSub.LatestMessage;

%% Initial calculation

% Unwrap initial position X Y of robot
position = odomData.Pose.Pose.Position;
x = position.X;
y = position.Y;

% Plot the initial goal position
hold(sim.Axes,'on');
goalLines = plot(sim.Axes, xGoal, yGoal, 'r*','MarkerSize',10);

% Find the initial distance to the goal
goalDist = sqrt((yGoal-y)^2 + (xGoal-x)^2);

%% Control loop
velData = rosmessage(velPub);

while (goalDist >= goalRadius)
    
    % Receive latest odometry message
    odomData = odomSub.LatestMessage;
    
    % Unwrap position
    position = odomData.Pose.Pose.Position;
    x = position.X;
    y = position.Y;
    
    % Unwrap orientation
    orientation = odomData.Pose.Pose.Orientation;
    q = [orientation.W, orientation.X, orientation.Y, orientation.Z];
    r = quat2eul(q);
    theta = r(1);
    
    % Distance control
    goalDist = sqrt((yGoal-y)^2 + (xGoal-x)^2);
    velData.Linear.X = K_pos*goalDist;
    
    % Angle control
    thetaRef = atan2(yGoal-y, xGoal-x);
    thetaError = angdiff(theta,thetaRef);
    velData.Angular.Z = K_angle*thetaError;
    
    % Send control commands
    send(velPub, velData);
    
    % Plot results
    plot(sim.Axes,x,y,'g*','MarkerSize',1);
    axis equal
    pause(0.1);
    
end
disp('Goal reached within threshold!');
    
    
