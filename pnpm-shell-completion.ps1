Register-ArgumentCompleter -CommandName pnpm -Native -ScriptBlock {
    param($wordToComplete, $commandAst)

    $bin = if (Test-Path "$PSScriptRoot/pnpm-shell-completion.exe") {
        "$PSScriptRoot/pnpm-shell-completion.exe"
    }
    elseif (Test-Path "$PSScriptRoot/pnpm-shell-completion") {
        "$PSScriptRoot/pnpm-shell-completion"
    }
    elseif (Test-Path pnpm-shell-completion.exe) {
        "pnpm-shell-completion.exe"
    }
    elseif (Test-Path pnpm-shell-completion) {
        "pnpm-shell-completion"
    }
    else {
        return
    }

    if ($commandAst.CommandElements.Count -eq 1) {
        $items = @("add", "remove", "install", "update", "publish")
        if (Test-Path "./pnpm-workspace.yaml") {
            $items += @("-F", "--filter")
        }
        if (Test-Path "./package.json") {
            $env:FEATURE = "scripts"
            $items += $(& $bin $words).Split("`n")
            Remove-Item Env:\FEATURE
        }
        return $items | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }

    $words = $commandAst.CommandElements | ForEach-Object { $_.ToString() }
    $words = $words[1..$words.Count]
    $snd = $commandAst.CommandElements[1].ToString()
    $hasFilterWithoutEquals = $snd -eq "-F" -or $snd -eq "--filter"

    $result = if ($hasFilterWithoutEquals -and $commandAst.CommandElements.Count -eq 2) {
        $env:FEATURE = "filter"
        $(& $bin).Split("`n") | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
    }
    elseif ($wordToComplete.StartsWith("-F=") -or $wordToComplete.StartsWith("--filter=")) {
        $env:FEATURE = "filter"
        $param = $wordToComplete.Split("=")[0]
        $(& $bin).Split("`n") | ForEach-Object {
            $param = $wordToComplete.Split("=")[0]
            [System.Management.Automation.CompletionResult]::new($param + "=" + $_, $_, 'ParameterValue', $_)
        }
    }
    else {
        $env:FEATURE = "pnpm_cmd"
        $cmd = $(& $bin $words)

        if ($cmd -eq "add") {
            @(
                [System.Management.Automation.CompletionResult]::new("--global", "--global", 'ParameterValue', "Install as a global package"),
                [System.Management.Automation.CompletionResult]::new("--save-dev", "--save-dev", 'ParameterValue', "Save package to your ``devDependencies``"),
                [System.Management.Automation.CompletionResult]::new("--save-peer", "--save-peer", 'ParameterValue', "Save package to your ``peerDependencies`` and ``devDependencies``")
            )
        }
        elseif ($cmd -eq "install" -or $cmd -eq "i") {
            @(
                [System.Management.Automation.CompletionResult]::new("--dev", "--dev", 'ParameterValue', "Only ``devDependencies`` are installed regardless of the ``NODE_ENV``"),
                [System.Management.Automation.CompletionResult]::new("--fix-lockfile", "--fix-lockfile", 'ParameterValue', "Fix broken lockfile entries automatically"),
                [System.Management.Automation.CompletionResult]::new("--force", "--force", 'ParameterValue', "Force reinstall dependencies"),
                [System.Management.Automation.CompletionResult]::new("--ignore-scripts", "--ignore-scripts", 'ParameterValue', "Don't run lifecycle scripts"),
                [System.Management.Automation.CompletionResult]::new("--lockfile-only", "--lockfile-only", 'ParameterValue', "Dependencies are not downloaded. Only ``pnpm-lock.yaml`` is updated"),
                [System.Management.Automation.CompletionResult]::new("--no-optional", "--no-optional", 'ParameterValue', "``optionalDependencies`` are not installed"),
                [System.Management.Automation.CompletionResult]::new("--offline", "--offline", 'ParameterValue', "Trigger an error if any required dependencies are not available in local store"),
                [System.Management.Automation.CompletionResult]::new("--prefer-offline", "--prefer-offline", 'ParameterValue', "Skip staleness checks for cached data, but request missing data from the server"),
                [System.Management.Automation.CompletionResult]::new("--prod", "--prod", 'ParameterValue', "Packages in ``devDependencies`` won't be installed")
            )
        }
        elseif ($cmd -eq "remove" -or $cmd -eq "rm" -or $cmd -eq "why") {
            $env:FEATURE = "deps"
            $(& $bin $words).Split("`n") | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
        elseif ($cmd -eq "update" -or $cmd -eq "upgrade" -or $cmd -eq "up") {
            $options = @(
                [System.Management.Automation.CompletionResult]::new("--dev", "--dev", 'ParameterValue', "Update packages only in `"devDependencies`""),
                [System.Management.Automation.CompletionResult]::new("--global", "--global", 'ParameterValue', "Update globally installed packages"),
                [System.Management.Automation.CompletionResult]::new("--interactive", "--interactive", 'ParameterValue', "Show outdated dependencies and select which ones to update"),
                [System.Management.Automation.CompletionResult]::new("--latest", "--latest", 'ParameterValue', "Ignore version ranges in package.json"),
                [System.Management.Automation.CompletionResult]::new("--no-optional", "--no-optional", 'ParameterValue', "Don't update packages in ``optionalDependencies``"),
                [System.Management.Automation.CompletionResult]::new("--prod", "--prod", 'ParameterValue', "Update packages only in `"dependencies`" and `"optionalDependencies`""),
                [System.Management.Automation.CompletionResult]::new("--recursive", "--recursive", 'ParameterValue', "Update in every package found in subdirectories or every workspace package")
            )
            $env:FEATURE = "deps"
            $deps = $(& $bin $words).Split("`n") | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
            $options + $deps
        }
        elseif ($cmd -eq "publish") {
            @(
                [System.Management.Automation.CompletionResult]::new("--access", "--access", 'ParameterValue', "Tells the registry whether this package should be published as public or restricted"),
                [System.Management.Automation.CompletionResult]::new("--dry-run", "--dry-run", 'ParameterValue', "Does everything a publish would do except actually publishing to the registry"),
                [System.Management.Automation.CompletionResult]::new("--force", "--force", 'ParameterValue', "Packages are proceeded to be published even if their current version is already in the registry"),
                [System.Management.Automation.CompletionResult]::new("--ignore-scripts", "--ignore-scripts", 'ParameterValue', "Ignores any publish related lifecycle scripts (prepublishOnly, postpublish, and the like)"),
                [System.Management.Automation.CompletionResult]::new("--no-git-checks", "--no-git-checks", 'ParameterValue', "Don't check if current branch is your publish branch, clean, and up to date"),
                [System.Management.Automation.CompletionResult]::new("--otp", "--otp", 'ParameterValue', "Specify a one-time password"),
                [System.Management.Automation.CompletionResult]::new("--publish-branch", "--publish-branch", 'ParameterValue', "Sets branch name to publish"),
                [System.Management.Automation.CompletionResult]::new("--recursive", "--recursive", 'ParameterValue', "Publish all packages from the workspace"),
                [System.Management.Automation.CompletionResult]::new("--tag", "--tag", 'ParameterValue', "Registers the published package with the given tag")
            )
        }
        elseif ($cmd -eq "run") {
            $env:FEATURE = "scripts"
            $(& $bin $words).Split("`n") | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
        else {
            $env:FEATURE = "scripts"
            $baseItems = @("add", "remove", "install", "update", "publish")
            $baseItems + $(& $bin $words).Split("`n") | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
            }
        }
    }

    Remove-Item Env:\FEATURE
    return $result
}
