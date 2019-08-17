
## 1- Assign old and new folders
old <- "/Library/Frameworks/R.framework/Versions/3.5/Resources/library"
new <- "/Library/Frameworks/R.framework/Versions/3.6/Resources/library"

## 2- Create empty folders in new library
# all old dirs
old.files <- list.dirs (old, full.names = FALSE, recursive = TRUE)
# all new dirs
new.files <- list.dirs (new, full.names = FALSE, recursive = TRUE)
# folders lacked in new version
mv.files <- setdiff (old.files, new.files)
# define dir names to be created
dirs <- paste0 (new, mv.files)
# create folders one by one
for (i in 1:length (dirs)) {
  ifelse (!dir.exists (dirs[i]), dir.create(dirs[i], recursive = TRUE), print(i))
}
# check new dirs
length (list.dirs (new, full.names = TRUE, recursive = TRUE))

## 3- Move files from old to new directories
before <- list.files (mv.files, full.names = TRUE, recursive = TRUE)
after <- gsub ("3.5", "3.6", before)
file.rename (before, after)

## 4- Delete the old version
unlink ("/Library/Frameworks/R.framework/Versions/3.5/", recursive = TRUE)
