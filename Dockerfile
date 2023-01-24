FROM ros:melodic-ros-core

SHELL ["/bin/bash", "-c"]

WORKDIR /ros_ws

COPY ./ur ./src/ur
COPY ./ur_bringup ./src/ur_bringup
COPY ./ur_components_description ./src/ur_components_description
COPY ./ur3_moveit_config ./src/ur3_moveit_config
COPY ./ur5e_moveit_config ./src/ur5e_moveit_config

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        python3-pip \
        ros-$ROS_DISTRO-rqt-joint-trajectory-controller && \
    pip3 install \
        rosdep \
        vcstool && \
    vcs import src < src/ur/ur.repos && \
    vcs import src < src/ur5e_moveit_config/assets.repos && \
    # Use only the necessary packages
    mv src/panther_ros/panther_description src/panther_description && \
    rm -rf src/panther_ros && \
    mv src/universal_robot/ur_description src/ur_description && \
    mv src/universal_robot/ur_gazebo src/ur_gazebo && \
    rm -rf src/universal_robot && \
    mv src/realsense-ros/realsense2_description src/realsense2_description && \
    rm -rf src/realsense-ros && \
    # Build ROS pkgs
    rosdep init && \
    rosdep update --rosdistro=$ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
