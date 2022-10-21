FROM ros:melodic-ros-core

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
        git \
        build-essential \
        python-rosdep \
        ros-$ROS_DISTRO-rqt-joint-trajectory-controller

WORKDIR /ros_ws

RUN git clone https://github.com/UniversalRobots/Universal_Robots_ROS_Driver.git src/Universal_Robots_ROS_Driver && \
    git clone -b melodic-devel-staging https://github.com/ros-industrial/universal_robot.git src/universal_robot

COPY ./ur5e_bringup ./src/ur5e_bringup

RUN rosdep init && \
    rosdep update --rosdistro=$ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    catkin_make -DCATKIN_ENABLE_TESTING=0 -DCMAKE_BUILD_TYPE=Release && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* 

COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
