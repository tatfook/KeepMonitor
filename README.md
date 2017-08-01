# KeepMonitor

a collection of backend ops work.

## structure

    .
    ├── backup_keepwork.sh      # backup database of keepwork regularly
    ├── LICENSE
    └── README.md

    0 directories, 3 files


## scripts

**backup_keepwork**

> ./backup_keepwork.sh -h

    usage: ./backup_keepwork.sh -b | -r backup_file | -h
      -b, run backup
      -r backup_file, recovery from file named backup_file in sync directory
      -h, show usage


## todo
- [  ] deploy ci server
- [  ] backup gitlab data
