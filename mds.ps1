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
# Version 2.1.0.0 - Last Update 3/03/2025

param (
  [switch]$a,
  [switch]$l,
  [switch]$h
)

function PrintVer()
{
  Write-Host "mds Version 2.1 by IKOVCK" -ForegroundColor Cyan
}

function PrintSyntax()
{
  PrintVer
  Write-Host "Mark Down Search - mds is part of md-tools by CatSW" -ForegroundColor Green
  Write-Output "Sintax 1: mds tag_to_search_in_default_path"
  Write-Output "Sintax 2: mds search string with multiple words"
  Write-Output "Sintax 3: mds tag_to_search -f filter ... -f filterN" 
  Write-Output "Sintax 4: mds -a tag_to_search_in_all_the_Repos"
  Write-Output "Sintax 5: mds -l tag_to_search_from_current_path"
  Write-Output "example 1: mds md"
  Write-Output "example 2: mds just for fun"  
  Write-Output "example 3: mds md -f go -f and"  
  Write-Output "example 4: mds -a tagInSomeRepo"
  Write-Output "example 5: mds -l TagInCurrentFolder"
  Write-Output ""
  Write-Output "after found some result with mds, you can use the mdgo command to open Visual Studio Code on the line of the match."
  Write-Output "exemple: mdgo 0002"
  exit
}

Push-Location

try {
  if ($h)
  {
    PrintSyntax
  }

  #read config
  $file = Join-Path -Path $PSScriptRoot -ChildPath "md-tools.config"
  $config = Get-Content -Path $file | ConvertFrom-Json
  $exclusionPattern = $config.exclusionPattern 
  $rootMarkDownPath  = $config.rootMarkDownPath
  $defaultSearchPath = $config.defaultSearchPath

  if ($a)
  {
    # search in all the repos
    Set-Location $rootMarkDownPath
  } 
  elseif ($l)
  {
    # search from current shell path
  } 
  else
  {
    # default search from default path
    Set-Location $defaultSearchPath
  }

  $totalArgs = $args -join " "
  $tokenArgs = $totalArgs -split "-f"
  $searchPar = $tokenArgs[0].Trim()

  $file = Join-Path -Path $PSScriptRoot -ChildPath "mds-cache.txt"

  if ([string]::IsNullOrEmpty($searchPar))
  {
    if (Test-Path $file) {
      try {
          $lines = Get-Content $file

          PrintVer
          Write-Host "use: mds -h to get the command sintax" -ForegroundColor Cyan
          Write-Host "Result read from cache of the last successfull query:" -ForegroundColor Cyan

          for ($i = 0; $i -lt $lines.Count; $i++) {
            $progressivo = "{0:D4}" -f ($i + 1)
            if ($lines.Count -gt 1) {
              $line = $lines[$i]
            } else {
              $line = $lines
            }
            $pos = $line.LastIndexOf('§')
            $PathLine = $line.Substring($pos)
            $line = $line.Substring(0, $pos)
            Write-Host "$progressivo $line " -NoNewline
            Write-Host "$PathLine" -ForegroundColor Cyan
          }
      } catch {
          Write-Host "Error reading the file: $($_.Exception.Message)"
      }
    } else {
      PrintSyntax
    }
    exit
  }

  Clear-Host
  Write-Output "Mark Down Power Search ..."
  $search = Get-ChildItem -Recurse -Include *.md | Where-Object { $_.FullName -notmatch $exclusionPattern } | Select-String -Pattern "$searchPar"

  #apply -f filters 
  if ($tokenArgs.count -gt 1)
  {
    $i = 1
    do {
      $f = $tokenArgs[$i].Trim()
      $search = $search | Select-String -Pattern "$f"
      $i++
    } until ($i -gt ($tokenArgs.count - 1))
  } 

  $matchesFound = $search | ForEach-Object { 
    [PSCustomObject]@{
        Line = $_.Line
        PathLine = "$($_.Path):$($_.LineNumber)"
    }
  }

  # the next check is needed for compatibility with Power Shell 5.1
  if($matchesFound -isnot [System.Collections.IEnumerable]) {
    $matchesFound = @($matchesFound)
  }

  if (Test-Path $file) {
    try {
        Remove-Item $file -Force
    } catch {
        Write-Host "Error during the deletion of the file: $($_.Exception.Message)"
    }
  } 

  if($null -eq $search) {
    Write-Output "No match."
  }
  else 
  {
    for ($i = 0; $i -lt $matchesFound.Count; $i++) {
      $progressivo = "{0:D4}" -f ($i + 1)
      $line = $matchesFound[$i].Line
      $PathLine = $matchesFound[$i].PathLine
      Write-Host "$progressivo $line " -NoNewline
      Write-Host "§$PathLine" -ForegroundColor Cyan
    }

    try {
      $matchesFound | ForEach-Object { "$($_.Line)   §$($_.PathLine)" } | Out-File -FilePath $file -Encoding UTF8
    } catch {
        Write-Host "Error writing to file '$file': $($_.Exception.Message)"
    }
  }	
}
finally {
  Pop-Location
}