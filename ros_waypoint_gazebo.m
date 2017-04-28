rosshutdown
clear all
close all
clc
%% Connect to an existing ROS master (gazebo this case)
rosinit('192.168.1.6')

%% Control parameters
xGoal = 1;
yGoal = 2;
goalRadius = 0.5;
K_angle = 5;
K_pos = 0.1;

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

% Plot the initial robot and goal positions
plot(x, y, 'bo','MarkerSize',10);
hold on
plot(xGoal, yGoal, 'r*','MarkerSize',10)

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
    plot(x,y,'g*')
    axis equal
    pause(0.1);
    
end
disp('Goal reached within threshold!');
    