vuetorrentPath = "./vuetorrent"

import requests
import shutil
import os
import zipfile

print("Starting local and remote version check...")

# Get the current version from the version.txt file
with open(f"{vuetorrentPath}/version.txt", "r") as file:
    currentVersion = file.read().strip()

# Send a GET request to the latest release
response = requests.get('https://github.com/VueTorrent/VueTorrent/releases/latest', allow_redirects=True)

# Get the URL after redirection
redirected_url = response.url

# Split the URL by '/' and get the last part and remove v
latestVersion = redirected_url.split('/')[-1].replace('v', '')

print(f"Local version: {currentVersion}")
print(f"Latest version: {latestVersion}")
if currentVersion < latestVersion:
    print("Updating VueTorrent...")

    # Create a temporary folder to store the downloaded release

    # Download the latest release zip file
    downloadUrl = "https://github.com/VueTorrent/VueTorrent/releases/latest/download/vuetorrent.zip"
    zipFilePath = f"VueTorrent-{latestVersion}.zip"
    response = requests.get(downloadUrl)
    with open(zipFilePath, "wb") as file:
        file.write(response.content)

    # Extract the contents of the zip file to the VueTorrent folder
    with zipfile.ZipFile(zipFilePath, "r") as zip_ref:
        shutil.rmtree(vuetorrentPath)
        zip_ref.extractall(path=".")
        os.rename("./vuetorrent", vuetorrentPath)
    
    os.remove(zipFilePath)

    print(f"VueTorrent has been updated to {latestVersion}!")
else:
    print("VueTorrent is up to date!")