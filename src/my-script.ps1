Write-Host "Fetching server services information..."
Write-Host "Chosen color: $env:RunningServiceColor"

# Get all services
$services = Get-Service | Sort-Object DisplayName

# Get timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$outputFile = "C:\Temp\AnnasTest\Services_ToDoList_$timestamp.html"

# Read the color from the environment variable (default to green if not set)
$runningColor = $env:RunningServiceColor
if (-not $runningColor) { $runningColor = "#28a745" }  # Default green color

# Start building the HTML
$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Services To-Do List</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f8f9fa; }
        h2 { text-align: center; color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #007bff; color: white; }
        .running { background-color: $runningColor; color: #155724; }
        .stopped { background-color: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <h2>Server Services To-Do List ($timestamp)</h2>
    <table>
        <tr>
            <th>Service Name</th>
            <th>Status</th>
        </tr>
"@

# Loop through services and add rows to the table
foreach ($service in $services) {
    $statusClass = if ($service.Status -eq "Running") { "running" } else { "stopped" }
    $statusIcon = if ($service.Status -eq "Running") { "✅ Running" } else { "❌ Stopped" }

    $html += @"
        <tr class="$statusClass">
            <td>$($service.DisplayName)</td>
            <td>$statusIcon</td>
        </tr>
"@
}

# Close HTML tags
$html += @"
    </table>
</body>
</html>
"@

# Save the HTML file
$html | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "HTML To-Do list created: $outputFile"
