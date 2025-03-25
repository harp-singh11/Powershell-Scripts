# Define the Data Collector Set Name
$DataCollectorSet = "CPU_Monitoring"
$LogPath = "C:\PerfLogs\Admin\CPU_Monitoring"

# Create the Data Collector Set
New-Item -Path $LogPath -ItemType Directory -Force
logman create counter $DataCollectorSet -o "$LogPath\CPU_Monitoring.blg" -f bincirc -v mmddhhmm -max 100 -cnf 60

# Add Performance Counters
logman update $DataCollectorSet -c "\Processor(_Total)\% Processor Time" `
                                "\System\Processor Queue Length" `
                                "\Process(*)\% Processor Time"

# Set Sample Interval (every 10 seconds)
logman update $DataCollectorSet -si 10

# Start the Data Collector Set
logman start $DataCollectorSet

Write-Host "PerfMon Data Collector Set '$DataCollectorSet' started and logging to $LogPath"
