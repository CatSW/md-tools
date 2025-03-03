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
# Version 2.1.0.0 - Last Update 3/03/2025

param (
  [switch]$h
)

function PrintVer()
{
  Write-Host "mdgo Version 2.1 by IKOVCK" -ForegroundColor Cyan
}

function PrintSyntax()
{
  PrintVer
  Write-Host "Mark Down GO - mdgo is part of md-tools by CatSW" -ForegroundColor Green
  Write-Output "Sintax: mdgo <mds result line number>"
  Write-Output "example: mdgo 0002"
  exit
}

if ($h)
{
  PrintSyntax
}

if ($args.Count -eq 0) {
  PrintSyntax
}

Write-Output "Mark Down GO..."

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
