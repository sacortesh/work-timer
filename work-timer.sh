#!/bin/bash

center_text() {
    local text="$1"
    local term_width=$(tput cols)
    local padding=$(((term_width) / 8))
    printf "%*s%s%*s\n" $padding "" "$text" $padding ""
}

center_ascii() {
    local ascii="$1"
    while IFS= read -r line; do
        center_text "$line"
    done <<< "$ascii"
}

ascii_art="
\\8.\\888b                 ,8'     ,o888888o.     8 888888888o.   8 8888     ,88' 
 \\8.\\888b               ,8'   . 8888     \\88.   8 8888    \\88.  8 8888    ,88'  
  \\8.\\888b             ,8'   ,8 8888       \\8b  8 8888     \\88  8 8888   ,88'   
   \\8.\\888b     .b    ,8'    88 8888        \\8b 8 8888     ,88  8 8888  ,88'    
    \\8.\\888b    88b  ,8'     88 8888         88 8 8888.   ,88'  8 8888 ,88'     
     \\8.\\888b .\\888b,8'      88 8888         88 8 888888888P'   8 8888 88'      
      \\8.\\888b8.\\8888'       88 8888        ,8P 8 8888\\8b       8 888888<       
       \\8.\\888\\8.\\88'        \\8 8888       ,8P  8 8888 \\8b.     8 8888 \\Y8.     
        \\8.\\8' \\8,\\'          \\ 8888     ,88'   8 8888   \\8b.   8 8888   \\Y8.   
         \\8.\\   \\8'              \\8888888P'     8 8888     \\88. 8 8888     \\Y8. 
"

# Colors
blue=$(tput setaf 4)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
bold=$(tput bold)
reset=$(tput sgr0)

# Variables
hours=$1
minutes=$2
project="$3"
total_seconds=$(((hours * 3600) + (minutes * 60)))
elapsed_seconds=0
break_time=0
total_break_time=0
start_time=$(date +%s)
end_time=$((start_time + total_seconds))
log_file=~/work_timer.log
motivation_file=~/phrases.txt

log_event() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >>$log_file
}

format_time() {
    local total=$1
    time_str=$(date -r $total +'%H:%M:%S')

    echo $time_str
}

format_clock() {
    local total=$1 # Input: total seconds

    local hours=$((total / 3600))          # Calculate total hours
    local minutes=$(((total % 3600) / 60)) # Calculate remaining minutes
    local seconds=$((total % 60))          # Calculate remaining seconds

    # Format hours, minutes, and seconds
    time_str=""

    if ((hours > 0)); then
        time_str+="${hours}h"
    fi
    if ((minutes < 10)); then
        time_str+=$(printf "%02dm" $minutes) # Pad minutes with leading zero if less than 10
    else
        time_str+="${minutes}m"
    fi

    if ((seconds < 10)); then
        time_str+=$(printf "%02ds" $seconds) # Pad seconds with leading zero if less than 10
    else
        time_str+="${seconds}s"
    fi

    echo $time_str
}

ascii_clock() {
    local time="$1"
    echo "
   _  _     _  _  _     _  _
  | || |  _| || || |_  _| || |_
  | || |_|_  ..  _|_  ..  _|
  |_  _|   |_||_|   |_||_|
     Time: $(format_clock $time)
"
}

# Log start
log_event "Started task: $project | Total Time: $(format_clock $total_seconds) | Projected finish: $(format_time $end_time)"

# Main loop
while [ $elapsed_seconds -lt $total_seconds ]; do
    clear

    # Display remaining time in big font
    center_ascii "$ascii_art"
    center_text "${bold}Working on: ${project}${reset}"

    remaining_seconds=$((total_seconds - elapsed_seconds))
    remaining_time=$(format_clock $remaining_seconds)
    center_text "$(tput setaf 2)Time Remaining: $(tput sgr0)"
    center_text "$(tput setaf 3)$bold$remaining_time$(tput sgr0)"

    # Progress bar logic
    progress=$(((total_seconds - elapsed_seconds) * 1000 / total_seconds))
    progress_display=$(seq -s "#" $((progress / 25)) | tr -d "[:digit:]")
    empty_space=$(seq -s "." $((1000 / 25 - progress / 25)) | tr -d "[:digit:]")
    center_text ""
    center_text "$(tput setaf 1)[${progress_display}${empty_space}]$(tput sgr0)"

    # Display motivational phrase
    if [ -f $motivation_file ]; then
        phrase=$(shuf -n 1 $motivation_file)
        center_text "$phrase"
    fi

    # Show time started, total time, and projected end time
    start_str=$(date -r $start_time +'%H:%M:%S')
    projected_end_str=$(date -r $end_time +'%H:%M:%S')
    center_text "${blue}Started at $start_str${reset} | ${yellow}Working for $hours h $minutes m${reset} | ${green}Finishing at $projected_end_str${reset}"

    # Check for break input
    read -n 1 -t 1 user_input
    if [ "$user_input" == "b" ]; then
        pause_time=$(date +%s)
        log_event "Break started at $(format_time $pause_time)"
        read -n 1 -s -r -p "Break. Press any key to resume..."
        resume_time=$(date +%s)
        break_duration=$((resume_time - pause_time))
        total_break_time=$((total_break_time + break_duration))
        end_time=$((end_time + break_duration))
        log_event "Break ended at $(format_time $resume_time) | Break duration: $(format_clock $break_duration)"
    fi

    # Update elapsed time
    elapsed_seconds=$(($(date +%s) - start_time - total_break_time))

done

# Log completion
log_event "Task finished: $project at $(format_time $(date +%s))"
center_text "$(tput setaf 2)Finished!$(tput sgr0)"
