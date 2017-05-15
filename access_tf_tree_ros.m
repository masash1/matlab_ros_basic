%% Initialize the ROS system
rosinit

exampleHelperROSStartTfPublisher

% Create a new transformation tree object with the rostf function.
tftree = rostf
pause(1);

tftree.AvailableFrames

%% Receive Transformations
% Retrieve the transformation that describes the relationship between the
% mounting point and the camera center.
mountToCamera = getTransform(tftree,'mounting_point','camera_center');
mountToCameraTranslation = mountToCamera.Transform.Translation
quat = mountToCamera.Transform.Rotation
mountToCameraRotationAngles = rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]))

% To inspect the relationship between the robot base and the camera's
% mounting point, call getTransform again.
baseToMount = getTransform(tftree,'robot_base','mounting_point');
baseToMountTranslation = baseToMount.Transform.Translation
baseToMountRotation = baseToMount.Transform.Rotation

%% Apply Transformations
% Wait until the transformation between the camera_center and robot_base
% coordinate frames becomes available.
waitForTransform(tftree,'robot_base','camera_center');

pt = rosmessage('geometry_msgs/PointStamped');
pt.Header.FrameId = 'camera_center';
pt.Point.X = 3;
pt.Point.Y = 1.5;
pt.Point.Z = 0.2;

tfpt = transform(tftree,'robot_base',pt)

tfpt.Point

robotToCamera = getTransform(tftree,'robot_base','camera_center')

robotToCamera.Transform.Translation
robotToCamera.Transform.Rotation

%% Send Transformations
tfStampedMsg = rosmessage('geometry_msgs/TransformStamped');
tfStampedMsg.ChildFrameId = 'wheel';
tfStampedMsg.Header.FrameId = 'robot_base';

tfStampedMsg.Transform.Translation.X = 0;
tfStampedMsg.Transform.Translation.Y = -0.2;
tfStampedMsg.Transform.Translation.Z = -0.3;

quatrot = axang2quat([0 1 0 deg2rad(30)])
tfStampedMsg.Transform.Rotation.W = quatrot(1);
tfStampedMsg.Transform.Rotation.X = quatrot(2);
tfStampedMsg.Transform.Rotation.Y = quatrot(3);
tfStampedMsg.Transform.Rotation.Z = quatrot(4);

tfStampedMsg.Header.Stamp = rostime('now');

sendTransform(tftree,tfStampedMsg)

tftree.AvailableFrames

%% Stop Example Publisher and ROS network
exampleHelperROSStopTfPublisher

rosshutdown