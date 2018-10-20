#!/usr/bin/env python

import rospy
import math
import tf
from tf.transformations import euler_from_quaternion
import message_filters

# The laser scan message
from sensor_msgs.msg import LaserScan

# The odometry message
from nav_msgs.msg import Odometry

# the velocity command message
from geometry_msgs.msg import Twist

# instantiate global variables "globalOdom"
globalOdom = Odometry()

# global pi - this may come in handy
pi = math.pi

# method to control the robot
def callback(scan,odom):
    # the odometry parameter should be global
    global globalOdom
    globalOdom = odom

    # make a new twist message
    command = Twist()

    # Fill in the fields.  Field values are unspecified 
    # until they are actually assigned. The Twist message 
    # holds linear and angular velocities.
    command.linear.x = 0.0
    command.linear.y = 0.0
    command.linear.z = 0.0
    command.angular.x = 0.0
    command.angular.y = 0.0
    command.angular.z = 0.0

    # get goal x and y locations from the launch file
    goalX = rospy.get_param('hw2/goalX',0.0)
    goalY = rospy.get_param('hw2/goalY',0.0)
    
    # find current (x,y) position of robot based on odometry
    currentX = globalOdom.pose.pose.position.x
    currentY = globalOdom.pose.pose.position.y

    # find current orientation of robot based on odometry (quaternion coordinates)
    xOr = globalOdom.pose.pose.orientation.x
    yOr = globalOdom.pose.pose.orientation.y
    zOr = globalOdom.pose.pose.orientation.z
    wOr = globalOdom.pose.pose.orientation.w

    # find orientation of robot (Euler coordinates)
    (roll, pitch, yaw) = euler_from_quaternion([xOr, yOr, zOr, wOr])

    # find currentAngle of robot (equivalent to yaw)
    # now that you have yaw, the robot's pose is completely defined by (currentX, currentY, currentAngle)
    currentAngle = yaw

    # find laser scanner properties (min scan angle, max scan angle, scan angle increment)
    maxAngle = scan.angle_max
    minAngle = scan.angle_min
    angleIncrement = scan.angle_increment

    # find current laser angle, max scan length, distance array for all scans, and number of laser scans
    currentLaserTheta = minAngle
    maxScanLength = scan.range_max 
    distanceArray = scan.ranges
    numScans = len(distanceArray)
   
    # the code below (currently commented) shows how 
    # you can print variables to the terminal (may 
    # be useful for debugging)
    #print 'x: {0}'.format(currentX)
    #print 'y: {0}'.format(currentY)
    #print 'theta: {0}'.format(currentAngle)

    # for each laser scan
    distThreshold = 2.0   # obstacle avoidance threshold
    turnLeft = False      # boolean check for left turn manoeuvre
    turnRight = False     # boolean check for right turn manoeuvre
    obsAvoidBearing = 0.0 # heading change to avoid obstacles
    obsAvoidVel = 0.0     # velocity change to avoid obstacles
    scaleVel = 1.0        # magnitude of obstacle avoidance and goal seeking velocities
    for curScan in range(0, numScans):
      if distanceArray[curScan] < distThreshold:
        if currentLaserTheta >= -pi/2.0 and currentLaserTheta <= 0.0:
          # obstacle detected on the right quadrant
          if not turnLeft: # has not applied left turn yet
            obsAvoidBearing = 1.0 # turn left
            print 'Left turn manoeuvre applied'
            turnLeft = True
        elif currentLaserTheta >= 0.0 and currentLaserTheta <= pi/2.0:
          # obstacle detected on the left quadrant
          if not turnRight: # has not applied right turn yet
            obsAvoidBearing += -1.0 # turn right
            print 'Right turn manoeuvre applied'
            turnRight = True
        if currentLaserTheta >= -pi*1.0/6.0 and currentLaserTheta < pi*1.0/6.0:
          # obstacle detected in front 60 degree cone
          if distanceArray[curScan]/distThreshold < 1.0 - obsAvoidVel:
            obsAvoidVel = scaleVel*(1.0 - (distanceArray[curScan])/distThreshold)
            print 'Slowing down'
      currentLaserTheta = currentLaserTheta + angleIncrement
    
    # based on the motion you want (found using goal location,
    # current location, and obstacle info), set the robot
    # motion
    
    # compute bearing to goal position
    headingToGoal = math.atan2(goalY-currentY,goalX-currentX)
    bearing = headingToGoal - currentAngle
    
    # compute distance to goal position
    distToGoal = math.sqrt(math.pow(goalY-currentY,2)+math.pow(goalX-currentX,2))
    vel = scaleVel
    if distToGoal < 5.0:
      # slow down if you are approaching the goal
      vel = vel*distToGoal/5.0
      if distToGoal < 1.0:
        # stop if you are within 1 unit of goal
        vel = 0.0
        print 'Arrived at goal!'
    
    # commanded velocities
    command.linear.x = 2.5 * (vel - obsAvoidVel)
    command.angular.z = 1.0 * (bearing + obsAvoidBearing)
    pub.publish(command)

# main function call
if __name__ == "__main__":
    # Initialize the node
    rospy.init_node('lab2', log_level=rospy.DEBUG)

    # subscribe to laser scan message
    sub = message_filters.Subscriber('base_scan', LaserScan)

    # subscribe to odometry message    
    sub2 = message_filters.Subscriber('odom', Odometry)

    # synchronize laser scan and odometry data
    ts = message_filters.TimeSynchronizer([sub, sub2], 10)
    ts.registerCallback(callback)

    # publish twist message
    pub = rospy.Publisher('cmd_vel', Twist, queue_size=10)

    # Turn control over to ROS
    rospy.spin()

