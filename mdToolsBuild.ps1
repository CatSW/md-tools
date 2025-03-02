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
# Version 2.0.0.0 - Last Update 2/03/2025

Push-Location

Write-Host "Build Repo demo folder hierarchy"

function BuildFolder()
{
  param (
    [string]$path
  )

  if (!(Test-Path -Path $path)) {
    try {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
        Write-Host "Folder '$path' created successfully."
    } catch {
        Write-Error "Failed to create folder '$path': $($_.Exception.Message)"
    }
  } else {
    Write-Host "Folder '$path' already exists."
  }
  Set-Location $path
}

BuildFolder("C:\Repo")
BuildFolder("C:\Repo\CatSW")

$path = "C:\Repo\CatSW\md-tools"
if (!(Test-Path -Path $path)) {
	git clone https://github.com/CatSW/md-tools.git
	Set-Location $path
	explorer .
}

Write-Host "md Tools Build terminated."

Pop-Location
Pause
