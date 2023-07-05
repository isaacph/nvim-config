require("isaacph.packer")
print("OS ENV INITNVIM:", os.getenv("INITNVIM"))
if not os.getenv("INITNVIM") then
    print("calling other scripts")
    require("isaacph.remap")
    require("isaacph.set")
end
