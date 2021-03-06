%% Initialize the ROS master and global node.
rosinit

% Create the sample ROS network
exampleHelperROSCreateSampleNetwork

%% Use rostopic list to check topics.
rostopic list

%% Use rostopic info to view more info about the topic.
rostopic info /scan

%% To find out more about the topic's message type, create an empty message of the same type.
scandata = rosmessage('sensor_msgs/LaserScan')

%% Use rosmsg to see a complete list of all message types.
rosmsg list

%% ROS messages are objects and the message data is stored in properties.
% Subscribe to the /pose topic to receive and examine the messages.
posesub = rossubscriber('/pose')

%% Use receive to acquire data from the subscriber.
posedata = receive(posesub,10)

%% The message has a type of geometry_msgs/Twist. See the values.
posedata.Linear
posedata.Angular

%% Data access for these nested messages works exactly the same as accessing the data in other messages.
xpos = posedata.Linear.x

%% Use showdetails function to see all the data in a message.
showdetails(posedata)

%% Set message property values. Create a message with type geometry_msgs/Twist.
twist = rosmessage('geometry_msgs/Twist')

% View the message data to make sure that the change took effect.
twist.Linear
twist.Angular 
showdetails(twist)

%% Copy messages
% There are 2 ways to copy the contents of a message:
% A reference copy in which the copy and the original messages share the
% same data.
% A deep copy in which the copy and the original messages each have their
% own data.

% A reference copy
twistCopyRef = twist

% Modify the Linear.Z field of twistCopyRef and see that it changes the
% contents of twist as well
twistCopyRef.Linear.Z = 7;
twist.Linear

% A deep copy
twistCopyDeep = copy(twist)

% Modify the Linear.X property of twistCopyDeep and notice that the
% contents of twist remain unchanged.
twistCopyDeep.Linear.X = 100;
twistCopyDeep.Linear

%% Save and Load Messages
% Get a new message from the subscriber:
posedata = receive(posesub,10)

%% Save the pose data to a .mat file using save function.
save('posedata.mat','posedata')

% Before loading the file back into the workspace, clear the posedata
% variable.
clear posedata

%% Load the message data by calling the load functino.
messageData = load('posedata.mat')

% Examine messageData.posedata to see the message contents.
messageData.posedata

% Delete the .mat file with
delete('posedata.mat')

%% Object Arrays in Messages
% Some messages from ROS are stored in Object Arrays. These should be
% handled differently from typical data arrays.

% The variable tf contains a sample message.
tf

% tf has 2 fields: MessageType contains a standard data array and
% Transforms contains an object array.
tf.Transforms

% Notice that the ouput returns 53 individual answers, since each object is
% evaluated and returns the value of its Transform field. This format is
% not always useful, so convert to a cell array.
cellTransforms = {tf.Transforms.Transform}

% Can access object array elements the same way access standard MATLAB
% vectors:
tf.Transforms(5)

% Can access the properties of individual array elements:
tf.Transforms(5).Transform.Translation

%% Show Down ROS Network
exampleHelperROSShutDownSampleNetwork
rosshutdown
