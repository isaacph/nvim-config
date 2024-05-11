-- print('test')
vim.lsp.set_log_level("TRACE")

local jdtls_path = "/home/isaac/projects/jdtls-setup/jdtls"
local java_path = "java"
-- local jdtls_jar_path = "C:\\workplace\\jdt-language-server\\plugins\\org.eclipse.eL:quinox.launcher.win32.win32.x86_64_1.2.900.v20240213-1244.jar"
-- local jdtls_jar_path = "C:\\workplace\\jdt-language-server\\plugins\\org.eclipse.equinox.launcher_1.6.800.v20240327-1824.jar"
local jdtls_jar_path = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_1.6.800.v20240330-1250.jar"
-- jdtls /usr/share/java/jdtls/config_linux/
local jdtls_config_path = jdtls_path .. "/config_linux/"
-- local lombok_path = "C:\\workplace\\install\\lib\\lombok.jar"
local lombok_path = "/usr/share/java/lombok/lombok.jar"

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- local workspace_dir = 'C:\\workplace\\jdtls-workspace-data\\' .. project_name
local workspace_dir = '/home/isaac/projects/jdtls-setup/workspace/' .. project_name

local config = {
    cmd = {
        java_path,
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. lombok_path,
        '-jar', jdtls_jar_path,
        '-configuration', jdtls_config_path,
        '-data', workspace_dir,
    },
    root_dir = require('jdtls.setup')
        .find_root({'.git', 'mvnw', 'gradlew', 'build.gradle'}),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a lsit of options
    settings = {
        java = {
        },
    },

    -- Language server 'initializationOptions',
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't play on using the debugger or other eclipse.jdt.ls plugins
    -- you can remove this
    init_options = {
        bundles = {}
    },
}
require('jdtls').start_or_attach(config)

-- set_bindings(0)

ColorMyPencils()

