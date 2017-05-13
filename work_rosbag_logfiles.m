%% Load a rosbag
filepath = fullfile(fileparts(which('ROSWorkingWithRosbagsExample')),'data','ex_multiple_topics.bag');
bag = rosbag(filepath)

% See more information about the topics and messages that are recorded in
% the bag.
bag.AvailableTopics

%% Select Messages
% Before retrieve any message data, you must select a set of messages based
% on criteria such as time stamp, topic name, and message type.
bag.MessageList

% Since the list is very large, can also display a selection of rows with
% the familiar row and column selection syntax.
bag.MessageList(500:505,:)

% To select all messages that were published on the /odom topic, use the
% following select command.
bagselect1 = select(bag,'Topic','/odom')

% To get the list of messages that were recorded within the first 30s of
% the rosbag and published on the /odom topic, enter the following command.
start = bag.StartTime
bagselect2 = select(bag,'Time',[start start+30],'Topic','/odom')

% Use the last selection to narrow down the time window even further.
bagselect3 = select(bagselect2,'Time',[205 206])

% If want to save a set of selection options, store the selection elements
% in a cell array and then re-use it later as an input to the select
% function.
selectOptions = {'Time',[start,start+1; start+5,start+6],'MessageType',{'sensor_msgs/LaserScan','nav_msgs/Odometry'}};
bagselect4 = select(bag,selectOptions{:})

%% Read Selected Message Data
% To retrieve the messages in selection as a cell array, use the
% readMessages function.
msgs = readMessages(bagselect3);
size(msgs)

% The resulting cell array contains as many elements as indicated in the
% NumMessages property of the selection object. In reading message data,
% can also be more selective and only retrieve messages at specific
% indices.
msgs = readMessages(bagselect3,[1 2 3 7])
msgs{2}

%% Extract Message Data as Time Series
% Use the same selection, but use the timeseries function to only extract
% the properties for x-position and z-axis angular velocity.
ts = timeseries(bagselect3,'Pose.Pose.Position.X','Twist.Twist.Angular.Z')

% To see the data contained within the time series, access the Data
% property.
ts.Data

% Calculate the mean of the data colums.
mean(ts)

% Plot the data of the time series.
figure
plot(ts,'LineWidth',3)