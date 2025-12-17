# 设置pwsh环境，只需运行一次
if (Test-Path function:Load-MSVCDevEnv) {
    return;
}

if (Test-Path $env:x_dir_) {
	$user_dir = "$env:x_dir_/User"
	$prog_dir = "$env:x_dir_/Programs"
	$work_dir = "$env:x_dir_/Workspace"
	$init_ps1 = "$user_dir/config/pwsh/x_boot.ps1"
	$env:USER_DIR_ = $user_dir
	$env:PROG_DIR_ = $prog_dir
	$env:WORK_DIR_ = $work_dir
	$env:LLVM_BIN_ = "$prog_dir/llvm-21.1.6/bin"
	$env:INIT_PS1_ = $init_ps1
	$env:XDG_CACHE_HOME = "$user_dir/cache"
	$env:XDG_CONFIG_HOME = "$user_dir/config"
	$env:XDG_DATA_HOME = "$user_dir/share"
	$env:XDG_RUNTIME_HOME = "$user_dir/rt"
	$env:XDG_STATE_HOME = "$user_dir/state"
	$env:RUSTUP_HOME = "$user_dir/rustup"
	$env:CARGO_HOME = "$user_dir/cargo"
	$env:DOTNET_CLI_UI_LANGUAGE = "en"
	$env:LANG = "en_US.UTF-8"
	$env:GOENV = "$user_dir/gopher/env"
	$env:GOPATH = "$user_dir/gopher/home"
	$env:GOCACHE = "$user_dir/gopher/go-build"
	$env:GOMODCACHE = "$user_dir/gopher/pkg/mod"
	$env:GOTELEMETRYDIR = "$user_dir/gopher/telemetry"
	$env:PNPM_HOME = "$user_dir/pnpm"
	$env:UV_CACHE_DIR = "$user_dir/uv/cache"
	$env:UV_PYTHON_CACHE_DIR = "$user_dir/uv/python/cache"
	$env:UV_PYTHON_INSTALL_DIR = "$user_dir/uv/python/install"
	$env:UV_PYTHON_BIN_DIR = "$user_dir/uv/python/bin"
	$env:UV_TOOL_BIN_DIR = "$user_dir/uv/tool/bin"
	$env:UV_TOOL_DIR = "$user_dir/uv/tool"
	$env:Path = "$env:windir;$env:windir/System32"
  $env:Path = "$prog_dir/ImageGlass;$env:Path"
	$env:Path = "$user_dir/pnpm;$env:Path"
	$env:Path = "$user_dir/uv/self;$env:Path"
	$env:Path = "$user_dir/uv/tool/bin;$env:Path"
	$env:Path = "$user_dir/uv/python/bin;$env:Path"
  $env:Path = "$user_dir/cargo/bin;$env:Path"
	$env:Path = "$prog_dir/nvim-win64/bin;$env:Path"
	$env:Path = "$prog_dir/cmake/bin;$env:Path"
	$env:Path = "$prog_dir/VSCode/bin;$env:Path"
	$env:Path = "$prog_dir/PowerShell;$env:Path"
}

# 快速使用命令，同Alias但是支持参数
function ls { if ($args.Count -eq 0) { lsd -hFA } else { lsd @args } }
function ll { if ($args.Count -eq 0) { lsd -lhFA } else { lsd -l @args } }
function ud { cd $env:USER_DIR_ }
function wd { cd $env:WORK_DIR_ }
function rf { rm -Recurse -Force @args }
function gitr { git clone --recursive @args }
function which { where.exe @args }

# 加载MSVC编译环境
function Load-MSVCDevEnv {
    $vcpkg_root = $env:VCPKG_ROOT
    if (-not $env:CXX_COMPILER_) {
        $vsPath = &(Join-Path ${env:ProgramFiles(x86)} "\Microsoft Visual Studio\Installer\vswhere.exe") -property installationpath
        Import-Module (Join-Path $vsPath "Common7\Tools\Microsoft.VisualStudio.DevShell.dll")
        Enter-VsDevShell -VsInstallPath $vsPath -SkipAutomaticLocation -Arch amd64
        $env:CXX_COMPILER_ = "MSVC";
        Write-Host -ForegroundColor Green "Current CXX_COMPILER_: $env:CXX_COMPILER_";
    } else {
        Write-Warning "Current CXX_COMPILER_: $env:CXX_COMPILER_";
    }
    $env:VCPKG_ROOT=$vcpkg_root
    $env:PATH = "$env:VCPKG_ROOT;$env:PATH"
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
    $env:VCPKG_ROOT=$vcpkg_root
    $env:PATH = "$env:VCPKG_ROOT;$env:PATH"
}

try { Remove-Alias ls } catch {}

if (-not $env:x_light_) {
    Set-PSReadLineOption -Colors @{
        # Command                   = "`e[94m"
        # Comment                   = "`e[32m"
        # ContinuationPrompt        = "`e[37m"
        # Default                   = "`e[97m"
        # Emphasis                  = "`e[96m"
        # Error                     = "`e[91m"
        InlinePrediction          = "`e[90;2;3m"
        # Keyword                   = "`e[92m"
        # ListPrediction            = "`e[34m"
        # ListPredictionSelected    = "`e[48;5;238m"
        # ListPredictionTooltip     = "`e[37;2;3m"
        # Member                    = "`e[97m"
        # Number                    = "`e[97m"
        Operator                  = "`e[97m"
        Parameter                 = "`e[97m"
        # Selection                 = "`e[30;47m"
        # String                    = "`e[36m"
        # Type                      = "`e[97m"
        # Variable                  = "`e[92m"
    }
} else {

}
# 适应白色主题，调整命令输入的高亮色
# Set-PSReadLineOption -Colors @{
#     Command                   = "`e[94m"
#     Comment                   = "`e[32m"
#     ContinuationPrompt        = "`e[37m"
#     Default                   = "`e[97m"
#     Emphasis                  = "`e[96m"
#     Error                     = "`e[91m"
#     InlinePrediction          = "`e[37;2;3m"
#     Keyword                   = "`e[92m"
#     ListPrediction            = "`e[34m"
#     ListPredictionSelected    = "`e[48;5;238m"
#     ListPredictionTooltip     = "`e[37;2;3m"
#     Member                    = "`e[97m"
#     Number                    = "`e[97m"
#     Operator                  = "`e[97m"
#     Parameter                 = "`e[97m"
#     Selection                 = "`e[30;47m"
#     String                    = "`e[36m"
#     Type                      = "`e[97m"
#     Variable                  = "`e[92m"
# }

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
