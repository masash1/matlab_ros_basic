%% Create Service Server
% Start the ROS master and example
rosinit
exampleHelperROSCreateSampleNetwork

% See what service types are available
rostype.getServiceList

% Make a simple servier that displays "A service client is calling". Create
% the service using the rossvcserver command. Specify the service name and
% the service message type.
testserver = rossvcserver('/test','std_srvs/Empty',@exampleHelperROSEmptyCallback)

% List all services
rosservice list

% More info about the services
rosservice info /test

%% Create Service Client
% Create a service client for the /test
testclient = rossvcclient('/test')

% Create an empty request message for the service.
testreq = rosmessage(testclient)

% When want to get a response from the server, use the call function, which
% calls the service server and returns a response.
testresp = call(testclient,testreq,'Timeout',3)

%% Create a Service for Adding Two Numbers
% Inspect the sturucture of the request and response messages by calling
% rosmsg show.
rosmsg show roscpp_tutorials/TwoIntsRequest

rosmsg show roscpp_tutorials/TwoIntsResponse

% Create the service server with this message type and a callback function
% that calculates the addition.
sumserver = rossvcserver('/sum','roscpp_tutorials/TwoInts',@exampleHelperROSSumCallback)

% Create a service client to call the service server. This client can be
% created anywhere in the ROS network. For this example, create a client
% for the /sum service in MATLAB.
sumclient = rossvcclient('/sum')

% Create the request message.
sumreq = rosmessage(sumclient);
sumreq.A = 2;
sumreq.B = 1

% Call the server.
sumresp = call(sumclient,sumreq,'Timeout',3)

%% Shut Down ROS Network
exampleHelperROSShutDownSampleNetwork
rosshutdown