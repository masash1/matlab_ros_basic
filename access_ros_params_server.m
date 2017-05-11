%% Create Parameter Tree
% Start the ROS master and parameter server in MATLAB.
rosinit

% Create a parameter tree object to interact with the parameter server.The
% parameter tree allows you to interact with the parameter server and
% provides functions such as set, get, del, has, and search.
ptree = rosparam

%% Add New Parameters
% Let's set a parameter for the robot IP address.
% Check if a parameter with the same name already exists.
has(ptree,'ROBOT_IP')

% Add some parameters. Use the set function for this.
set(ptree,'ROBOT_IP','192.168.1.1');
set(ptree,'/myrobot/ROBOT_IP','192.168.1.100')

% Set more parameters with different data types.
set(ptree,'MAX_SPEED',1.5);

% Use a cell array as an input to the set function.
set(ptree,'goal',{5.0,2.0,0.0});

% Set additional parameters.
set(ptree,'/myrobot/ROBOT_NAME','TURTLE');
set(ptree,'/myrobot/MAX_SPEED',1.5);
set(ptree,'/newrobot/ROBOT_NAME','NEW_TURTLE');

%% Get Parameter Values
% Use get function.
robotIP = get(ptree,'/myrobot/ROBOT_IP')

%% Get List of All Parameters
plist = ptree.AvailableParameters

%% Modify Existing Parameters
set(ptree,'MAX_SPEED',1.0);

set(ptree,'MAX_SPEED','none');

%% Delete Parameters
del(ptree,'goal');

has(ptree,'goal')

%% Search Parameters
results = search(ptree,'myrobot')

%% Shut Down ROS Network
rosshutdown