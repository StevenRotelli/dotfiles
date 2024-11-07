-- import lspsaga safely
local navigator_status, navigator = pcall(require, "navigator")
if not navigator_status then
  print("test")
  return
end
navigator.setup()
