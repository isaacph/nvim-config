require("isaacph.packer")
if !os.getenv("INITNVIM") then
    require("isaacph.remap")
    require("isaacph.set")
end
