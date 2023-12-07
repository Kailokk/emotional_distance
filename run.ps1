# Set the path to the Cargo project directory
$cargoProjectDirectory = ".\builder"

# Set the path to the subdirectory containing the executable
$executableSubdirectory = "..\output"

# Step 1: Run 'cargo run --release' in the specified directory
Write-Host "Building and running the Cargo project..."
Set-Location -Path $cargoProjectDirectory
$cargoProcess = Start-Process -FilePath "cargo" -ArgumentList "run --release" -PassThru -Wait
Write-Host "Cargo process exited with code $($cargoProcess.ExitCode)"

# Step 2: Run the executable in a different subdirectory
Write-Host "Running the executable in a different subdirectory..."
Set-Location -Path $executableSubdirectory
$executableProcess = Start-Process -FilePath ".\processing_sketch.exe" -PassThru -Wait
Write-Host "Executable process exited with code $($executableProcess.ExitCode)"

Read-Host