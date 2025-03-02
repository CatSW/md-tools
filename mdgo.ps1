# Copyright 2025 Stefano Vesco - IK0VCK
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Version 2.0.0.0 - Last Update 1/03/2025

Write-Output "Mark Down GO..."
if ($args.Count -eq 0) {
  Write-Host "Sintax: mdgo <mds result line number>"
  Write-Output "example: mdgo 0002"
  return
}

$number = 0
if (-not [int]::TryParse($args[0], [ref]$number)) {
  Write-Host "Error: the parameter must be a number."
  exit
}

$file = Join-Path -Path $PSScriptRoot -ChildPath "mds-cache.txt"

if (Test-Path $file) {
    try {
        $lines = Get-Content $file
        if ($number -ge 1 -and $number -le $lines.Count) {
          if ($lines.Count -eq 1) {
            $selection = $lines
          }
          else {
            $selection = $lines[$number - 1] 
          }
        } else {
            Write-Host "Error: the specified line number is invalid."
        }
    } catch {
        Write-Host "Error reading the file: $($_.Exception.Message)"
    }
} else {
    Write-Host "Error: the file '$file' does not exist."
    Write-Host "You must first execute mds command, with some output matches, and then execute mdgo with a reference match number as parameter."
    exit
}

$tokens = ($selection -split '§')
if($tokens.count -gt 0)
{
  $searchString = $tokens[$tokens.count - 1]
}
else 
{
  Write-Output "??? Error: mds-cache.txt contain invalid text - missing § at the line specified"
  exit
}

Invoke-Expression "code -g ""$searchString"""
