/// SQLite initialization for platforms that don't support `dart:io`.
///
/// On web, sqflite is not supported, so this remains a no-op.
void initSqliteForPlatform() {}
