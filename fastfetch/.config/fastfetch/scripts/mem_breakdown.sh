#!/usr/bin/env bash
# Shows wired, active, inactive(+speculative), and compressed (GiB)
ps=4096  # page size on macOS is 4096 bytes for Apple Silicon
vm_stat | awk -v ps="$ps" '
  function GiB(x){return x*ps/1024/1024/1024}
  /Pages wired down/        {gsub("\\.","",$NF); w=$NF}
  /Pages active/            {gsub("\\.","",$NF); a=$NF}
  /Pages inactive/          {gsub("\\.","",$NF); i=$NF}
  /Pages speculative/       {gsub("\\.","",$NF); s=$NF}
  /Pages occupied by compressor/ {gsub("\\.","",$NF); c=$NF}
  END {
    printf "wired: %.1fG  active: %.1fG  inactive: %.1fG  compressed: %.1fG\n",
           GiB(w), GiB(a), GiB(i+s), GiB(c)
  }'
