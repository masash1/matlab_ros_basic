%% Load Sample Messages
exampleHelperROSLoadMessages

%% Laser Scan Messages
% Laser scanners are commonly used sensors in robotics. You can see the
% standard ROS format for a laser scan message by creating an empty message
% of the appropriate type.

% Use rosmessage to create the message.
emptyscan = rosmessage('sensor_msgs/LaserScan')

% The emptyscan has no contents in it. Look at the scan that is
% automatically loaded by exampleHelperROSLoadMessages
scan

%% Can get the measured points in Cartesian coordinates using the readCartesian function:
xy = readCartesian(scan)

% This returns a list of [x,y] coordinates that were calculated base on all
% valid range readngs.

%% Visualize the scan message using plot function:
figure 
plot(scan,'MaximumRange',5)

%% Image Messages
% MATLAB also provides support for image messages, which always have the
% message type sensor_msgs/Image.

% Create an empty image message using rosmessage to see the standard ROS
% format for an image message.
emptyimg = rosmessage('sensor_msgs/Image')

% The emptyimg has no contents. Look at the img which is loaded by
% exampleHelperROSLoadMessages.
img

%% The data field stores raw image data that cannot be used directly for processing and visualization in MATLAB.
% Can use the readImage function to retrieve the image in a format that is
% compatible for MATLAB.
% Convert ROS image data into MATLAB image
imageFormatted = readImage(img);

%% Visualize the image
% The original image has an 'rgb8' encoding. By default, readImage returns
% the image in a standard 480x640x3 uint8 format. Can view this image using
% the imshow function.
figure 
imshow(imageFormatted)

%% Compressed Messages
% Many ROS systems send their image data in a compressed format. MATLAB
% provides support for these compressed image messages.

% Create an empty compressed image message using rosmessage.
emptyimgcomp = rosmessage('sensor_msgs/CompressedImage')

% The emptyimgcomp has no content. Look at the imgcomp that is loaded by
% exampleHelper.
imgcomp

%% Convert ROS image data into MATLAB image
% Similar to the image message, can use readImage to obtain the image in
% standard RGB format. Even though the original encoding for this
% compressed image is bgr8, readImage will do the conversion.
compressedFormatted = readImage(imgcomp);

%% Visualize the image
figure 
imshow(compressedFormatted)

% Most image formats are supported but '16UC1' and '32FC1' encodings are
% not supported for compressed depth images.

%% Point Clouds
% Point clouds can be captured by a variety of sensors used in robotics.
% THe most common message type in ROS for transmitting point clouds is
% sensor_msgs/PointCloud2 and MATLAB provides some specialized functions to
% work with this data.

% Can see the standard ROS format for a point cloud message.
emptycloud = rosmessage('sensor_msgs/PointCloud2')

% ptcloud is given by helper
ptcloud

%% Extract xyz coordinates
% The point cloud information is encoded in the Data field of the message.
% Can extract the [x,y,z] coordinates as an N-by-3 matrix by calling the
% readXYZ function.
xyz = readXYZ(ptcloud)

%% Remove NaN
% This is an artifact of the Kinect sensor.
xyzvalid = xyz(~isnan(xyz(:,1)),:)

% If there is NaN in X, the Y and Z also have NaN. So removing NaN of X is
% enough.

%% Retrieve color values if exist
% Some point cloud sensors also assign RGB color values to each point in a
% point cloud. If these color values exist, can retrieve them with a call
% to readRGB.
rgb = readRGB(ptcloud)

%% Visualize the point cloud
% Use scatter3 function to visualize the point cloud. scatter3 will
% automatically extract the [x,y,z] coordinates and the RGB color values
% (if they exist) and show them in a 3D scatter plot. The scatter3 function
% ignores all NaN [x,y,z] coordinates, even if RGB values exist for that
% point.
figure 
scatter3(ptcloud)

%% ROS Shutdown
rosshutdown
