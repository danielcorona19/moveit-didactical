FROM ros:noetic-ros-base

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
    ros-noetic-moveit

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME
RUN useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME 

RUN echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
&& chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p /home/$USERNAME && chown -R $USER_UID:$USER_GID /home/$USERNAME

RUN echo "source /opt/ros/noetic/setup.bash" >> /home/$USERNAME/.bashrc
