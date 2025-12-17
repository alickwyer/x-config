# 设置pwsh环境，只需运行一次
if (Test-Path function:Load-MSVCDevEnv) {
    return;
}

# 快速使用命令，同Alias但是支持参数
function ls { if ($args.Count -eq 0) { lsd -hFA } else { lsd @args } }
function ll { if ($args.Count -eq 0) { lsd -lhFA } else { lsd -l @args } }
function usr { cd $env:USER_DIR_ }
function wd { cd $env:WORK_DIR_ }
function rf { rm -Recurse -Force @args }
function gitr { git clone --recursive @args }
function which { where.exe @args }

# 加载MSVC编译环境
function Load-MSVCDevEnv {
    if (-not $env:CXX_COMPILER_) {
        $vsPath = &(Join-Path ${env:ProgramFiles(x86)} "\Microsoft Visual Studio\Installer\vswhere.exe") -property installationpath
        Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
        Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -Arch amd64
        $env:CXX_COMPILER_ = "MSVC";
        Write-Host -ForegroundColor Green "Current CXX_COMPILER_: $env:CXX_COMPILER_";
    } else {
        Write-Warning "Current CXX_COMPILER_: $env:CXX_COMPILER_";
    }
}

# 加载LLVM编译环境
function Load-LLVMDevEnv {
    if (-not $env:CXX_COMPILER_) {
        $env:Path = "$env:LLVM_BIN_;$env:Path";
        $env:CXX_COMPILER_ = "LLVM";
        Write-Host -ForegroundColor Green "Current CXX_COMPILER_: $env:CXX_COMPILER_";
    } else {
        Write-Warning "Current CXX_COMPILER_: $env:CXX_COMPILER_";
    }
}

try { Remove-Alias ls } catch {}

# 适应白色主题，调整命令输入的高亮色
Set-PSReadLineOption -Colors @{
    Command                   = "`e[94m"
    Comment                   = "`e[32m"
    ContinuationPrompt        = "`e[37m"
    Default                   = "`e[97m"
    Emphasis                  = "`e[96m"
    Error                     = "`e[91m"
    InlinePrediction          = "`e[37;2;3m"
    Keyword                   = "`e[92m"
    ListPrediction            = "`e[34m"
    ListPredictionSelected    = "`e[48;5;238m"
    ListPredictionTooltip     = "`e[37;2;3m"
    Member                    = "`e[97m"
    Number                    = "`e[97m"
    Operator                  = "`e[97m"
    Parameter                 = "`e[97m"
    Selection                 = "`e[30;47m"
    String                    = "`e[36m"
    Type                      = "`e[97m"
    Variable                  = "`e[92m"
}

# 环境变量设置，只需要进行一次
if (-not $env:INIT_PS1_LOADED) {
    $env:INIT_PS1_LOADED = "YES"
    $env:VCPKG_ROOT = "$env:USER_DIR_/vcpkg"
    $env:PATH = "$env:VCPKG_ROOT;$env:PATH"
    $env:Path = "$env:Path;$env:USERPROFILE\scoop\shims;$env:ProgramFiles\dotnet;$env:ProgramFiles\Git\cmd;$env:ProgramFiles\7-Zip"

    Set-ExecutionPolicy Bypass -Scope Process -Force
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
    Write-Host "👋 Welcome to WezTerm + PowerShell! Have a great day!" -ForegroundColor Cyan
}
