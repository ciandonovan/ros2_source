# Setup

Initial setup
```
vcs import --input ros2.repos rolling/src
```

Update repositories
```
vcs pull rolling/src/
```

Volume-mount `rolling/` into container at `/opt/ros/rolling/`
