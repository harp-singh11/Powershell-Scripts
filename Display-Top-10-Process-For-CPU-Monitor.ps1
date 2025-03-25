# Load the .blg file and extract CPU usage data
$counterData = Import-Counter -Path "C:\PerfLogs\Admin\CPU_Monitoring\CPU_Monitoring_03211325.blg"

# Filter out CPU usage data for individual processes, excluding "total" and "idle"
$cpuUsageData = $counterData.CounterSamples | Where-Object { $_.Path -like "*\Process(*)\% Processor Time" -and $_.Path -notlike "*\Process(_Total)*" -and $_.Path -notlike "*\Process(idle)*" }

# Extract the process name from the counter path and display the CPU usage
$processes = $cpuUsageData | ForEach-Object {
    # Extracting process name from the path
    $processName = ($_).Path -replace '\\process\((.*?)\)\\% processor time', '$1'
    [PSCustomObject]@{
        ProcessName = $processName
        CPUUsage    = $_.CookedValue
    }
}

# Sort by CPU usage and display the top 10 processes
$topProcesses = $processes | Sort-Object -Property CPUUsage -Descending | Select-Object -First 10
$topProcesses
