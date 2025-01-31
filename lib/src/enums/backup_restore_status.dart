/// Enum representing different statuses during a backup process.
enum BackupStatus {
  creatingBackupDirectory,
  writingBackupFile,
  creatingArchive,
  completed,
  failed
}

/// Enum representing different statuses during a restore process.
enum RestoreStatus {
  readingBackupFile,
  decodingArchive,
  restoringDatabase,
  completed,
  failed
}
