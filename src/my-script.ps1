Write-Host "Fetching server services information..."

# Get all services
$services = Get-Service | Sort-Object DisplayName

# Get timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outputFile = "C:\Temp\AnnasTest\Services_ToDoList_$timestamp.txt"

# Start building the To-Do list
$todoList = @()
$todoList += "### Server Services To-Do List ($timestamp)"
$todoList += "--------------------------------------------"
$todoList += ""

foreach ($service in $services) {
    $statusIcon = if ($service.Status -eq "Running") { "✅" } else { "❌" }
    $todoList += "$statusIcon $($service.DisplayName) - Status: $($service.Status)"
}

# Save the To-Do list to a file
$todoList | Out-File -FilePath $outputFile

Write-Host "To-Do list created: $outputFile"
