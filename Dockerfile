FROM ros:foxy-ros-base

# https://askubuntu.com/a/1013396
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /home/

# Follows instructions for installing ROS 2 Humble Hawksbill here:
# https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debians.html

# SET LOCALE
# check for UTF-8
# RUN locale  

# RUN apt update && apt install locales
# RUN locale-gen en_US en_US.UTF-8
# RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
# RUN export LANG=en_US.UTF-8

# # verify settings
# RUN locale  

# # SETUP SOURCES
# RUN apt install software-properties-common -y
# RUN add-apt-repository universe

# RUN apt update && apt install curl -y
# RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# # INSTALL ROS 2 PACKAGES
# RUN apt update
# RUN apt upgrade

# RUN apt install ros-humble-desktop -y
# RUN apt install ros-humble-ros-base -y
# RUN apt install ros-dev-tools -y

# # ENVIRONMENT SETUP
# # Replace ".bash" with your shell if you're not using bash
# # Possible values are: setup.bash, setup.sh, setup.zsh
# RUN chmod +x /opt/ros/humble/setup.sh
# RUN /opt/ros/humble/setup.sh

# # The above does not seem to work in setting ros2 to PATH variable.
# # RUN export PATH="/opt/ros/humble/bin"

# CMD ["ros2", "run", "demo_nodes_cpp", "talker"]


RUN apt update
RUN apt upgrade -y

# Install Dependencies
RUN apt install libboost-program-options-dev libusb-1.0-0-dev python3-pip -y
RUN pip3 install rowan

RUN pip3 install cflib transforms3d
RUN apt-get install ros-foxy-tf-transformations -y

# Set up ROS 2 Workspace
RUN mkdir -p ros2_ws/src

WORKDIR /home/ros2_ws/src

RUN git clone https://github.com/IMRCLab/crazyswarm2 --recursive
RUN git clone --branch ros2 --recursive https://github.com/IMRCLab/motion_capture_tracking.git

COPY ./scripts/source_ros.sh /home/ros2_ws/source_ros.sh

# RUN chmod +x /opt/ros/foxy/setup.sh
# RUN /opt/ros/foxy/setup.sh

WORKDIR /home/ros2_ws
RUN . /opt/ros/foxy/setup.sh
RUN colcon build --symlink-install
