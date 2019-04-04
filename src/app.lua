local lapis = require("lapis")
local app = lapis.Application()
local eth0 = "eth0"
local wlp3s0 = "wlp3s0"
local ens18 = "ens18"
local docker0 = "docker0"
local enp1s0 = "enp1s0"
local bearer = "Bearer /RqFf-iW{<iaQ&5uAZmV~(QhZ§@5#gtitEyJq|5SN${2et|R&>d.VelFa}q,MxCz"
local pattern = "([^%s:]+):%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)"
total_fwd = 0

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function scrape()
  local nds_table = {}
  for line in io.lines("/proc/net/dev") do
    local t = {string.match(line, pattern)}
    if(t[1] ~= nil) then
      if trim(t[1]) == enp1s0 then
        nds_table["in"] = t[2]
        nds_table["out"] = t[10]
        nds_table["total"] = t[2] + t[10]
      end
    end
  end
  return nds_table
end

function format(total)
  local result = "# HELP target_forwarded_bytes Total number of bytes forwarded (in/out/total)." .. "\n"
  result = result .. "# TYPE target_forwarded_bytes counter" .. "\n"
  result = result .. "target_forwarded_bytes{state=\"total\"} " .. total .. "\n"
  return result
end

app:get("/metrics", function(self)
  local auth = self.req.headers["authorization"]
  total_fwd = total_fwd + 150 
  if(auth ~= bearer) then
    return "Unauthorized"
  else
    return {layout = false, content_type = "text/plain", format(total_fwd)}
  end
  
end)

app:get("/owner", function(self)
  local f = io.open("static/owner","r")
  local owner = f:read("*a")
  f:close()
  return {layout = false, content_type = "text/plain", owner}		 
end)

return app
