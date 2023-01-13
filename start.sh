sudo echo "[i] Starting docker build && docker run "
sudo docker build -t adexplorersnapshotdockerwatchman .
sudo docker run -d -v /in:/in -v /out:/out -it adexplorersnapshotdockerwatchman






# misc useful
# sudo docker stop $(sudo docker ps -a -q)
# sudo docker rm $(sudo docker ps -a -q)
# sudo docker rmi $(sudo docker images -a -q) 
