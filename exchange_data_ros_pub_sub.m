%% Start the ROS master and a sample
rosinit
exampleHelperROSCreateSampleNetwork

%% Use rostopic to see which topics are available
rostopic list

%% Use rostopic info to check if any nodes are publishing to the /scan topic
rostopic info /scan

%% Use rossubscriber to subscribe to the /scan topic.
laser = rossubscriber('/scan')

%% Use receive to wait for a new message (the second argument is a time-out in seconds).
scandata = receive(laser,10)

%% Plot the scan data
figure
plot(scandata,'MaximumRange',7)

%% Subscribe using callback functions
robotpose = rossubscriber('/pose',@exampleHelperROSPoseCallback)
global pos
global orient

% the most current position and orientation data will always be stored in
% the pos and orient. The exampleHelperROSPoseCallback function contains
% pos and orient.

pause(2)
pos
orient

% Stop the pose subscriber by cleaning the subscriber variable
clear robotpose

%% Publish Messages
% Create a publisher that sends ROS string messages to the /chatter topic.
chatterpub = rospublisher('/chatter','std_msgs/String')
pause(2) % Wait to ensure publisher is registered

%% Create and populate a ROS message to send to the /chatter topic.
chattermsg = rosmessage(chatterpub);
chattermsg.Data = 'hello world'

%% Use rostopic list to verify that the /chatter topic is available in the ROS network.
rostopic list

%% Define a subscriber for the /chatter topic.
chattersub = rossubscriber('/chatter',@exampleHelperROSChatterCallback)

%% Publish a message to the /chatter topic.
send(chatterpub,chattermsg)
pause(2)

%% Remove the sample nodes, publishers, and subscribers.
exampleHelperROSShutDownSampleNetwork
clear global pos orient

rosshutdown

