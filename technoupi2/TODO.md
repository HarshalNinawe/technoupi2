# TODO: Resolve Flutter Run Errors

## Step 1: Explain Errors
- [x] Explain "Flutter failed to delete a directory" errors (file locks by processes like previous Flutter run, Chrome, VSCode).
- [x] Explain "Failed to remove build/.dart_tool/ephemeral" (same file lock issue).
- [x] Explain typos in commands ("futter" -> "flutter", "tecnhnoupi2" -> "technoupi2").

## Step 2: Provide Solutions
- [x] Kill running processes (flutter, dart, chrome, etc.).
- [x] Close VSCode and any editors.
- [x] Manually delete locked directories if needed.
- [x] Run flutter clean.
- [x] Run flutter run again.

## Step 3: Execute Resolution Commands
- [ ] Kill processes using taskkill.
- [ ] Attempt flutter clean.
- [ ] If clean fails, manually delete directories.
- [ ] Run flutter run.

## Step 4: Test Resolution
- [ ] Verify flutter run works without errors.
