enum BackupStatus {
  initializing,
  creatingBackupDirectory,
  creatingArchive,
  writingBackupFile,
  completed,
  failed,
}

enum RestoreStatus {
  initializing,
  readingBackupFile,
  decodingArchive,
  completed,
  failed,
}
