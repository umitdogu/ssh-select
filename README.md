# SSH Select
A tool for selecting and connecting to a host via SSH using a real-time search and selection menu.

## Features
- Real-time search and selection menu for finding and connecting to a host via SSH
- Arrow key support for navigating the list of hosts
- Ability to filter the list in real-time as the user types
- Configuration files support

## Requirements

- Bash shell
- stty command
- awk command
- grep command
- ssh command

## Configuration
The script reads the SSH connections from configuration files located in the conf.d directory. To add a new connection, create a new file in this directory and add a Host entry in the following format:

```
Host <hostname>
  HostName <hostname or IP address>
  User <username>
  Port <port number>
  IdentityFile <path to private key file>
  
```
 
## Usage
To use the tool, simply run the script in a terminal:

  `./ssh-select.sh`

The script will display a list of all available SSH connections, and you can start typing to filter the list in real-time. Use the up and down arrow keys to navigate the list, and press Enter to select the currently highlighted host. The script will then connect to the selected host via ssh.

