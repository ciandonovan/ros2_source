# This is an auto generated Dockerfile for ros2:source
# generated from docker_images_ros2/source/create_ros_image.Dockerfile.em

ARG FROM_IMAGE=osrf/ros2:devel
FROM $FROM_IMAGE

# set environment
ARG ROS_DISTRO=rolling
ENV ROS_DISTRO=$ROS_DISTRO
ENV ROS2_WS=/opt/ros/$ROS_DISTRO
ENV ROS_VERSION=2 \
    ROS_PYTHON_VERSION=3

# clone source
#ARG ROS2_BRANCH=$ROS_DISTRO
#ARG ROS2_REPO=https://github.com/ros2/ros2.git
#RUN git clone $ROS2_REPO -b $ROS2_BRANCH \
#    && vcs import src < ros2/ros2.repos

WORKDIR $ROS2_WS
COPY $ROS_DISTRO/src/ $ROS2_WS/src/

# install dependencies
RUN apt-get update && rosdep install -y \
    --from-paths src \
    --ignore-src \
    --skip-keys " \
        fastcdr \
        rti-connext-dds-6.0.1 \
        urdfdom_headers" \
    && rm -rf /var/lib/apt/lists/*

# build source
#RUN colcon \
#    build \
#    --symlink-install \
#    --mixin build-testing-on release \
#    --cmake-args --no-warn-unused-cli

# test build
#ARG RUN_TESTS
#ARG FAIL_ON_TEST_FAILURE
#RUN if [ ! -z "$RUN_TESTS" ]; then \
#        colcon test; \
#        if [ ! -z "$FAIL_ON_TEST_FAILURE" ]; then \
#            colcon test-result; \
#        else \
#            colcon test-result || true; \
#        fi \
#    fi

# disable /ros_entrypoint.sh fail
RUN sed --in-place \
        's|^set -e|set +e|' \
        /ros_entrypoint.sh

# install base packages
RUN apt-get update && apt-get install --no-install-recommends -y \
        tini \
        && rm -rf /var/lib/apt/lists/*

RUN echo "source $ROS2_WS/install/setup.bash" >> /root/.bash_history
RUN echo "colcon build --event-handlers console_direct+" >> /root/.bash_history
RUN echo "colcon build --event-handlers console_direct+ --symlink-install --packages-select launch" >> /root/.bash_history
