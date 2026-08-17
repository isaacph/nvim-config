### Isaac Neovim Config for Windows

Symlink this folder to: C:\Users\isaac\AppData\Local\nvim

```
cmd
cd C:\Users\isaac\AppData\Local\nvim
mklink /J nvim C:\workplace\nvim-config
```

### Setup

From `VsDevCmd.bat -arch=x64` (or like 'C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat'):

```
git clone https://github.com/neovim/neovim.git
cd neovim
cmake -S cmake.deps -B .deps -G Ninja -D CMAKE_BUILD_TYPE=Release
cmake --build .deps --config Release
cmake -B build -G Ninja -D CMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

winget install tree-sitter-cli

Also do wezterm README
