#!/usr/bin/env python
import rospy
from std_msgs.msg import String

def talker():
    pub = rospy.Publisher('/ur_hardware_interface/script_command', String, queue_size=10)

    rospy.init_node('talker', anonymous=True)
    
    rate = rospy.Rate(0.25) # 10hz
    
    while not rospy.is_shutdown():
        # hello_str = "sec myProgram():\nrg_grip(100.0, 40.0, tool_index = 0, blocking = True, depth_comp = False, popupmsg = True)\nend\n"
        hello_str = "sec myProgram():\nset_digital_out(1, True)\nend\n"

        rospy.loginfo(hello_str)
        pub.publish(hello_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass