FROM moveit/moveit:noetic-source

ARG USERNAME=ros
ARG USER_UID=1010
ARG USER_GID=$USER_UID

# Install catkin and other ROS tools
RUN apt-get update && \
    apt-get install -y \
    sudo \
    python3-catkin-tools \
    ros-noetic-catkin \
    ros-noetic-roslaunch \
    ros-noetic-ros-core && \
    rm -rf /var/lib/apt/lists/*

# Install move it
RUN apt update && \
    apt install -y \
    git

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME
RUN useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME 

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p /home/$USERNAME && chown -R $USER_UID:$USER_GID /home/$USERNAME

RUN echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc

# Create workspace and build for tutorial
# RUN mkdir -p /home/$USERNAME/ws/src
# RUN git clone https://github.com/moveit/moveit_tutorials.git -b master
# RUN git clone https://github.com/moveit/panda_moveit_config.git -b noetic-devel
# RUN rosdep update
# RUN rosdep install -y --from-paths . --ignore-src --rosdistro noetic
# RUN catkin config --extend /opt/ros/${ROS_DISTRO} --cmake-args -DCMAKE_BUILD_TYPE=Release
# RUN catkin build
# RUN echo "source /home/ros/ws/devel/setup.bash" >> /home/$USERNAME/.bashrc