# README - md-tools by [IK0VCK](https://www.qrz.com/db/IK0VCK) @ ![CatSW](./Img/CatSW.png)

- Last Update: 06/03/2025

[git clone](https://github.com/CatSW/md-tools.git)

In this project, I created the following **PowerShell** scripts: 

- **mds** Mark Down Search
- **mdgo** Mark Down GO
- **mdToolsBuild** optional - Build a Repo demo structure and git clone the md-tools in it

## Description

These commands are intended to search a folder hierarchy of markdown files that form a hypertext. The search will also include any loose, non-hyperlinked files and will encompass all files within a designated root folder and its subfolders.  

## Prerequisites

- Install Microsoft Visual Studio Code
- enable Power Shell scripts on your system
- optional: git (available on shell) if you want to use `mdToolsBuild`

PowerShell has an execution policy that determines which scripts can be run. By default, it's often set to "Restricted," meaning no scripts can be run. To enable scripts, you need to change this policy.

If, when trying to run mds, you receive an error that scripts are not enabled, then  
Run PowerShell as Administrator:

```powershell
Set-ExecutionPolicy RemoteSigned
```

## Installation

- clone md-tools in a temporary location
- execute mdToolsBuild 
  - it will create C:\Repo
  - it will create C:\Repo\CatSW
  - it will clone md-tools in it
- add `C:\Repo\CatSW\md-tools\` in your $Env:Path
- try to execute `mds md`
- if is all ok the previous command will found something like this:

```
Mark Down Power Search ...
{mds md} Starting Search from: C:\Repo\CatSW\
0001 markdown containing md word @C:\Repo\CatSW\md-tools\demo\demo.md:3
0002 and mds and mdgo togheter @C:\Repo\CatSW\md-tools\demo\demo.md:7
0003 - mds= Mark Down Search - A Power Shell tool by IK0VCK @ CatSW @C:\Repo\CatSW\md-tools\demo\glossario.md:5
0004 - mdgo= Mark Down GO - A Power Shell tool by IK0VCK @ CatSW @C:\Repo\CatSW\md-tools\demo\glossario.md:6
```

In the case the installation is ok and you can try to execute `mdgo 4`
Visual Studio Code should open the file `glossario.md` at the line corresponding to the match indicated by the parameter.

## Configuration

Clone the project in your machine and then put the cloned folder in the system path.
<br>
In the `md-tools.config` file, you need to customize these two paths:
- rootMarkDownPath the root of your Mark Down folder hierarchy
- defaultSearchPath the preferred "project" folder to use (for faster search for default mds search only from this path)

```json
{
  "rootMarkDownPath" : "C:\\Repo\\",
  "defaultSearchPath" : "C:\\Repo\\CatSW\\",
  "exclusionPattern": "\\packages\\|\\bin\\|\\obj\\|\\md-tools\\README.md"
}
```

Set `defaultSearchPath` to something like `C:\Repo\YourPersonalProjectsRoot\YourMdDefaultInfoFolder\`

## mds - Mark Down Search

open a Power Shell console and try `mds -h`

if you have installed the scripts correctly, you should see something like this:

```
mds Version 2.2 by IKOVCK
Mark Down Search - mds is part of md-tools by CatSW
Sintax 1: mds tag_to_search_in_default_path
Sintax 2: mds search string with multiple words
Sintax 3: mds tag_to_search -f filter ... -f filterN
Sintax 4: mds -a tag_to_search_in_all_the_Repos
Sintax 5: mds -l tag_to_search_from_current_path
example 1: mds md
example 2: mds just for fun
example 3: mds md -f go -f and
example 4: mds -a tagInSomeRepo
example 5: mds -l TagInCurrentFolder

If you want to filter something in the part after the @, use | sls filter in cascade.
exemple: mds md | sls demo

after found some result with mds, you can use the mdgo command to open Visual Studio Code on the line of the match.
exemple: mdgo 2
```

For default, the search start form `defaultSearchPath`  
-l switch is intended to limit the search in a local subfolder path (the current path of the shell) for a faster response  
-a switch is intended to extend the search to the entire hierarchy from `rootMarkDownPath` (slower)

Subdirectories will be included in all searches.

## mdgo - Mark Down GO

open a Power Shell console and try `mdgo`

```
mdgo Version 2.1.1 by IKOVCK
Mark Down GO - mdgo is part of md-tools by CatSW
Sintax: mdgo <mds result line number>
example: mdgo 0002
```

If you have found some result with `mds` and then use `mdgo` with a right parameter, will be opened the mark down file in Visual studio Code at the line number of the match.

## Test

Only if you have installed the script using `mdToolsBuild`, that come with a couple of md example files, used in the following command.
(Note: the output in the following exemples, are in the case you have not added new files) 
then try:

```
mds mds
```

```
Mark Down Power Search ...
{mds mds} Starting Search from: C:\Repo\CatSW\
0001 and mds and mdgo togheter @C:\Repo\CatSW\md-tools\demo\demo.md:7
0002 - mds= Mark Down Search - A Power Shell tool by IK0VCK @ CatSW @C:\Repo\CatSW\md-tools\demo\glossario.md:5
```

You should get 2 matches.  
then try (smart use of tag):

```
mds mdgo=
```

```
Mark Down Power Search ...
{mds mdgo=} Starting Search from: C:\Repo\CatSW\
0001 - mdgo= Mark Down GO - A Power Shell tool by IK0VCK @ CatSW @C:\Repo\CatSW\md-tools\demo\glossario.md:6
```

You should get 1 match.  
then try with 2 optional filters in place:

```
mds md -f go -f and
```

```
Mark Down Power Search ...
{mds md -f go -f and} Starting Search from: C:\Repo\CatSW\
0001 and mds and mdgo togheter @C:\Repo\CatSW\md-tools\demo\demo.md:7
```
You should get 1 match.  