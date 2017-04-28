%% Create a new ros master in MATLAB
rosinit

%% Open a MATLAB simulator
sim = RobotSimulator('emptyMap')

%% List all topics
rostopic list

%% Get more information about a topic
rostopic info /odom

% rostopic echo /odom
% shows all messages of the topic

%% Subscribe to topic
odomSub = rossubscriber('/odom')

%% Get infomation to see MATLAB as a subscriber(also a publisher) now
rostopic info /odom

%% Receive data using receive
odomData = receive(odomSub)

odomData = receive(odomSub,10) % wait max 10s

odomData = odomSub.LatestMessage % get a latest message

%% Use showdetails to show the contents of the message
showdetails(odomData)

%% Publish to topic
% create a publisher
velPub = rospublisher('/mobile_base/commands/velocity')

%% Initialize the type and the content of data to publish
velData = rosmessage(velPub);
velData.Angular.Z = 10;
velData.Linear.X = 1;

%% Send data
send(velPub,velData)

%% Receive data
odomData = odomSub.LatestMessage;

%% Use showdetails() to see the content of data
showdetails(odomData)

%% List the existing services
rosservice list

%% Calling ROS services

% reset the position of robot
client = rossvcclient('/sim/reset_poses')
call(client)

% reset world
resetWorld = rossvcclient('/gazebo/reset_world')
call(resetWorld)

%% Shut down ROS
rosshutdown

%% Clean up
clear
close
clc
