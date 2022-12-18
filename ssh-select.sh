#!/bin/bash

# Clear the screen
clear

# Use the `stty` command to enable real-time input and display updates
stty -echo
stty -icanon

# Set the initial search string to empty
search_string=""

# Initialize the selected host index to 0 (no host selected)
selected_index=0

# Configuration files
confFiles="/home/user/.ssh/conf.d/*"

# all hosts from configuration files
allHosts=$(grep -E "Host "  $confFiles | awk '{print $2}')

# Continuously display the matching hosts in real time as the user types
while true; do
  # Clear the current line
  printf "\r"

  # set the cursor to top-left
  tput cup 0 0

  # Read a single character from the user
  read -n1 char
  
  # If the user pressed enter, select the currently selected host
  if [ "$char" = "" ]; then
    # Get the list of matching hosts
    matching_hosts=($(echo "$allHosts" | grep -i -E "$search_string"))
    # Get the selected host from the list of matching hosts
    host=${matching_hosts[$selected_index]}
    # Clear the screen
    clear
    ssh "$host"
    break
  fi

  # If the user pressed backspace, remove the last character from the search string
  if [ "$char" = $'\x7f' ]; then
    search_string="${search_string%?}"
  elif [ "$char" = $'\x1b' ]; then
    # If the user pressed the escape key, read the next two characters
    read -n2 -s next_chars
    # If the next two characters are "[A", the user pressed the up arrow key
    if [ "$next_chars" = "[A" ]; then
      # Decrement the selected host index
      selected_index=$((selected_index - 1))
      # If the selected host index is less than 0, set it to the last index in the list of matching hosts
      if [ $selected_index -lt 0 ]; then
        matching_hosts=($(echo "$allHosts" | grep -i -E "$search_string"))
        selected_index=$(( ${#matching_hosts[@]} - 1 ))
      fi
    # If the next two characters are "[B", the user pressed the down arrow key
    elif [ "$next_chars" = "[B" ]; then
      # Increment the selected host index
      selected_index=$((selected_index + 1))
      # If the selected host index is greater than or equal to the number of matching hosts, set it to 0
      matching_hosts=($(echo "$allHosts" | grep -i -E "$search_string"))
      if [ $selected_index -ge ${#matching_hosts[@]} ]; then
        selected_index=0
      fi
    fi
  else
    # Otherwise, add the character to the search string
    search_string+="$char"
  fi

  # Clear the screen
  clear
  
  # Search for the hosts that match the search string
  matching_hosts=$(echo "$allHosts" | grep -i -E "$search_string")

  # Initialize an empty array
  allHostsArray=()

  # Loop through the output line by line
  while read -r line; do
    # Add each line to the array
    allHostsArray+=("$line")
  done <<< "$matching_hosts"

  # get terminal's lines count
  terminalLines=$(tput lines)-5

  # Print the list of matching hosts
  printf "\n.............\n\e[1m\e[93m$search_string\e[0m\n.............\n"

  # Print each matching host
  for (( i=0; i<${#allHostsArray[@]}; i++ )); do
    # If the current host is the selected host, print it in cyan and bold
    if [ $i -eq $selected_index ]; then
      printf "\e[1m\e[36m${allHostsArray[$i]}\e[0m\n"
    else
      if (( terminalLines > $i )); then
        printf "${allHostsArray[$i]}\n"
      fi
    fi
  done

done

# Reset the terminal settings
stty echo
stty icanon

