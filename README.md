# hyper-v--vm-backup-script
Basic script to backup your hyper-v vms to a destination of your choice, requires 7zip  
  
accepts the following parameters  
destination (required): folder you want the back-ups to finally reside in  
backupdepth (required): how many backups to keep, if there's more than this many 7z files in the destination it will iteratively delete the oldest file until it meets the set value  
password (optional): put a password on the 7z file  
  
designed with the expectation that it would run as a scheduled task on the hyper-v host, a bit resource intensive so best run during off-hours  
  
that's it! nothing too fancy, hopefully useful to others
