#!/bin/bash

# Edit this path if you have installed VueTorrent in a different directory
vuetorrentPath="./vuetorrent"

if ! command -v unzip &> /dev/null; then
    echo "unzip is not installed. Please install unzip before running this script."
    exit 1
fi
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Please install curl before running this script."
    exit 1
fi

currentVersion=$(cat "${vuetorrentPath}/version.txt")
latestVersion=$(curl -sL https://github.com/VueTorrent/VueTorrent/releases/latest -w %{url_effective} -o /dev/null | grep -oP '(?<=tag\/v).*')

echo "Local version: ${currentVersion}"
echo "Latest version: ${latestVersion}"
if [[ "${currentVersion}" < "${latestVersion}" ]]; then
    echo "Updating VueTorrent..."

    tempDir=$(mktemp -d)
    downloadUrl=https://github.com/VueTorrent/VueTorrent/releases/latest/download/vuetorrent.zip
    zipFilePath=${tempDir}/vuetorrent.zip
    curl -sL $downloadUrl -o $zipFilePath
    rm -rf ${vuetorrentPath}/*
    unzip $zipFilePath -d . > /dev/null
    if [[ "${vuetorrentPath}" != "./vuetorrent" ]]; then
        mv ./vuetorrent/* ${vuetorrentPath}
        rmdir ./vuetorrent
    fi
    rm -f $zipFilePath

    echo "VueTorrent has been updated to ${latestVersion}!"
else
    echo "VueTorrent is up to date!"
fi