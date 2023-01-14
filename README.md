# ADEEA
ADExplorerSnapshot Docker file with watchman trigger to automatically generate output on file drop

Drop a .dat file generated from an ADExplorer enum session into /in and bloodhound compatable JSON files will be generated using 
https://github.com/c3c/ADExplorerSnapshot.py

```
p4@devmachine /> tree /in
/in
├── fuck.dat
└── ukwks382457.dat
```
And ADExplorer.py will automatically run and generate output files in the /out directory 
```
0 directories, 0 files
p4@devmachine /> tree /out/
/out/
├── fuck.dat_dir
│   ├── TOWERBRIDGE.uk.gov.co.uk_1665752651_computers.json
│   ├── TOWERBRIDGE.uk.gov.co.uk_1665752651_domains.json
│   ├── TOWERBRIDGE.uk.gov.co.uk_1665752651_groups.json
│   └── TOWERBRIDGE.uk.gov.co.uk_1665752651_users.json
└── ukwks382457.dat_dir
    ├── ukpad01a.ad.ecorp.com_1664383347_computers.json
    ├── ukpad01a.ad.ecorp.com_1664383347_domains.json
    ├── ukpad01a.ad.ecorp.com_1664383347_groups.json
    └── ukpad01a.ad.ecorp.com_1664383347_users.json

3 directories, 8 files
```

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
