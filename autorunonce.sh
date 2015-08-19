#!/bin/bash

set_config_var() {
  lua - "$1" "$2" "$3" <<EOF > "$3.bak"
local key=assert(arg[1])
local value=assert(arg[2])
local fn=assert(arg[3])
local file=assert(io.open(fn))
local made_change=false
for line in file:lines() do
  if line:match("^#?%s*"..key.."=.*$") then
    line=key.."="..value
    made_change=true
  end
  print(line)
end
if not made_change then
  print(key.."="..value)
end
EOF
mv "$3.bak" "$3"
}

get_config_var() {
  lua - "$1" "$2" <<EOF
local key=assert(arg[1])
local fn=assert(arg[2])
local file=assert(io.open(fn))
for line in file:lines() do
  local val = line:match("^#?%s*"..key.."=(.*)$")
  if (val ~= nil) then
    print(val)
    break
  end
end
EOF
}

#enable raspi-cam
set_config_var start_x 1 /boot/config.txt
CUR_GPU_MEM=$(get_config_var gpu_mem /boot/config.txt)
if [ -z "$CUR_GPU_MEM" ] || [ "$CUR_GPU_MEM" -lt 128 ]; then
  set_config_var gpu_mem 128 /boot/config.txt
fi
sed /boot/config.txt -i -e "s/^startx/#startx/"
sed /boot/config.txt -i -e "s/^fixup_file/#fixup_file/"

# create camera.sh
echo "#!/bin/bash" > camera.sh
echo "" >> camera.sh
echo "DATE=\$(date +'%Y-%m-%d_%H%M%S')" >> camera.sh
echo "raspistill -vf -hf -o /data/timelaps/\$DATE.jpg" >> camera.sh

# create autrun.sh
echo "#!/bin/bash" > autorun.sh
echo "" >> autorun.sh
echo "#move exsisting timelaps folder to ??? -> FIXME" >> autorun.sh
echo "" >> autorun.sh
echo "# create timelaps folder" >> autorun.sh
echo "mkdir -p /data/timelaps/" >> autorun.sh
echo "" >> autorun.sh
echo "watch -n15 "/data/camera.sh"" >> autorun.sh

reboot
