Tizen4Docker
===========
This is a docker image allowing you to run Tizen-IDE on ANY Linux distribution. \
The image is meant to provide fully featured environment for the IDE. 

NOTE: 
- the image provides support for Tizen emulator (**make sure check "Emulator Hardware Support"**)
- the image has built-in java JDK
- the image has built-in google-chrome browser (required by the IDE)

# Requirements
Docker and Docker-Compose are the base requirements. \
Make sure to have them installed on your system. \
\
Detailed dependency check can be done with `./checkDeps.sh` script.
```bash
# TEST THE REQUIREMENTS
./checkDeps.sh
```

# Configuration
## Base configuration (required)
1. Please review the settings in `.env.example` file.
2. Edit and save new settings as `.env` file. 

## Advanced configuration (optional, most users should be fine with defaults)
1. You might want to change authentication method for docker-compose command. This can be done at `runTizen.sh` file (please check `# Docker-Auth config` header). 
2. Advanced configuration can be found at `docker-compose.yml`.
3. Advanced users might be interested in debug mode `./runTizen.sh d` (which allows easy access to docker container)

# How to build?  
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
(you might want to create a custom launcher to run this script)\
\
NOTE: Tizen-Studio will be automatically fetched and installed on the first run

# Emulator Hardware Support
Once the IDE is installed and started up, please be sure to enable Hardware Support for the emulator: 
1. open the `Emulator Manager`
2. select desired emulator and click `Edit`
3. go to the `HW Support` and enable settings: 
    * `CPU VT`
    * `GPU`
