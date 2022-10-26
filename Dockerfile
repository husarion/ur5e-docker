FROM ros:melodic-ros-core

SHELL ["/bin/bash", "-c"]

WORKDIR /ros_ws

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        python3-pip \
        ros-$ROS_DISTRO-rqt-joint-trajectory-controller && \
    pip3 install \
        rosdep \
        vcstool 

COPY ./ur5e_moveit_config ./src/ur5e_moveit_config
COPY ./ur5e_bringup ./src/ur5e_bringup
COPY ./ur5e.repos /

RUN vcs import src < /ur5e.repos && \
    mv src/universal_robot/ur_description src/ur_description && \
    rm -rf src/universal_robot && \
    rosdep init && \
    rosdep update --rosdistro=$ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* 

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]