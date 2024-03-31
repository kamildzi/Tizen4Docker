Tizen4Docker
===========
This is a docker image allowing you to run Tizen-IDE on ANY Linux distribution. \
The image is meant to provide fully featured environment for the IDE. 

NOTE: 
- the image provides support for Tizen emulator (**make sure check "Emulator Hardware Support"**)
- the image has built-in java JDK
- the image has built-in google-chrome browser (required by the IDE)

# Requirements
Docker is the base requirement. \
Make sure to have it installed on your system. \
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
1. You might want to change authentication method for the `docker` command. This can be done at `runTizen.sh` file (please check `# Docker-Auth config` header). 
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
sudo docker compose build
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

# IDE Upgrade / Reinstall process
This paragraph describes how to deal with upgrade and reinstall process.

Please note:
- Refer to `.env.example` for details and detailed volume descriptions. 
- First step (data backup) is completely optional. You can skip this if you don't have any data to worry about. 
- Failed or incomplete installations can be fixed by following this procedure. 

Please follow below steps:

1. (Optional) Backup the data from docker volumes: 
- `LOCAL_TIZEN_STUDIO_DIRECTORY`
- `LOCAL_TIZEN_STUDIO_DATA_DIRECTORY`
- `LOCAL_WORKSPACE`

You might copy the data manually, or use a built-in backup script:

```bash
./runTizen.sh backup
``` 

2. Delete the contents of the volumes (to force a clean install):
- `LOCAL_TIZEN_STUDIO_DIRECTORY`
- `LOCAL_TIZEN_STUDIO_DATA_DIRECTORY`
- `LOCAL_WORKSPACE` (optional, don't wipe the workspace if you want your project data to stay intact)

You might wipe the directories manually or use built-in script. 
The script will ask you which volumes would you like to wipe out. 

```bash
./runTizen.sh purge
``` 

3. Edit .env file with your favourite editor (and change the `TIZEN_VERSION`)
```bash
nano .env
```

4. Rebuild the docker image

First, please remove current Tizen4Docker image. 
Please note that image name (`tizen4docker_tizen`) might differ on your machine. 
```bash
sudo docker image rm tizen4docker_tizen
```

After the image is deleted, please start the runner script. 
A new docker image will be built automatically and then the IDE will be installed.
```bash
./runTizen.sh
```