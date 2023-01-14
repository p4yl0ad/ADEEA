# ADEEA
ADExplorerSnapshot Docker file with watchman trigger to automatically generate output on file drop

To build and start run the start command
```bash 
sudo bash start.sh
```
Or manually 
```
sudo docker build -t adexplorersnapshotwatchman .
sudo docker run -d -v /in:/in -v /out:/out -it adexplorersnapshotwatchman # daemon mode 
```
Or 
```
sudo docker run -v /in:/in -v /out:/out -it adexplorersnapshotwatchman /bin/bash # Drop into a shell 
```
