local lapis = require("lapis")
local app = lapis.Application()
local eth0 = "eth0"
local lo = "lo"
local wlp3s0 = "wlp3s0"
local pattern = "([^%s:]+):%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function scrape()
  local nds_table = {}
  for line in io.lines("/proc/net/dev") do
    local t = {string.match(line, pattern)}
    if(t[1] ~= nil) then
      if trim(t[1]) == wlp3s0 then
        nds_table["in"] = t[2]
        nds_table["out"] = t[10]
        nds_table["total"] = t[2] + t[10]
      end
    end
  end
  return nds_table
end

function format(t)
  local result = "# HELP target_forwarded_bytes Total number of bytes forwarded (in/out/total)." .. "\n"
  result = result .. "# TYPE target_forwarded_bytes counter" .. "\n"
  result = result .. "target_forwarded_bytes{state=\"in\"}" .. t["in"] .. "\n"
  result = result .. "target_forwarded_bytes{state=\"out\"}" .. t["out"] .. "\n"
  result = result .. "target_forwarded_bytes{state=\"total\"}" .. t["total"] .. "\n"
  return result
end

app:get("/metrics", function()
  return format(scrape())
end)

return app