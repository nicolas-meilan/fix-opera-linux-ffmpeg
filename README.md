# Fix Opera Linux ffmpeg

* Fix Opera html5 media content.
* It script must be execute all times opera will fails on showing html5 media content.
* Now it also fixes WidevineCdm support for DRM video. You can try it on Vevo youtube channel for example. (Requires Chrome installation in /opt/google/chrome)

## Index

* [Requirements](#Requirements)
* [How use](#How-use)
* [Create an alias](#Create-an-alias)

### Requirements

1. **curl** (Is needed for downloading the ffmpeg lib)
    ```sudo apt install curl```

2. **unzip** (Is needed for unzipping the downloaded file)
    ```sudo apt install unzip```

### How use

1. Clone this repo

    ```git clone https://github.com/nicolas-meilan/fix-opera-linux-ffmpeg```

2. Go to the repo root folder

    ```cd ./fix-opera-linux-ffmpeg-widevine```

3. Give execute permissions to the script file

    ```chmod +x ./fix-opera.sh```

4. Execute the script using sudo (Is needed for put the ffmpeg lib into the opera instalation folder)
    
    ```sudo ./fix-opera.sh```

### Create an alias

1. Clone this repo
    
    ```git clone https://github.com/nicolas-meilan/fix-opera-linux-ffmpeg```

2. Create a **script** folder on your **home**
    
    ```mkdir ~/.scripts```

3. Copy the script into the **script** folder
    
    ```cp ./fix-opera-linux-ffmpeg-widevine/fix-opera.sh ~/.scripts```

4. Give execute permissions to the script file
    
    ```chmod +x ~/.scripts/fix-opera.sh```

5. Create an **alias** on the **.bashrc** file (Remember replace **<YOUR_USER>** for your linux user)
    
    ```echo "alias fix-opera='sudo /home/<YOUR_USER>/.scripts/fix-opera.sh' # Opera fix HTML5 media" >> ~/.bashrc```

6. Update **.bashrc** file
    
    ```source ~/.bashrc```

7. Delete the repo
    
    ```rm -rf ./fix-opera-linux-ffmpeg-widevine```
