Tizen4Docker
===========
This is a docker image allowing you to run Tizen-IDE on ANY Linux distribution. \
The image is meant to provide fully featured environment for the IDE. 

NOTE: 
- the image provides support for Tizen emulator
- the image has built-in java JDK
- the image has built-in google-chrome browser (required by the IDE)

# Requirements
Docker and Docker-Compose are required. \
You should use you package manager to install them. 
```bash
# TEST THE REQUIREMENTS
which docker
which docker-compose
```

# Configuration
1. Please review the settings in `.env.example` file.
2. Edit and save new settings as `.env` file. 

NOTE: Advanced configuration can be found at `docker-compose.yml`.

# 3. How to build?  
Simply start a run script: 
```bash
./runTizen.sh
```
This will automatically build docker-image if it is needed. \
\
Alternatively you might start build command manually:
```bash
sudo docker-compose build
```

# How to run the IDE?
Just start the run script:
```bash
./runTizen.sh
```
