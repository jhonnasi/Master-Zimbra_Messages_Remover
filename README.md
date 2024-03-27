# Master - Zimbra Messages Remover

## Overview
The "Master - Messages Remover" is a Bash script designed to aid Zimbra server administrators in managing their email environments. It offers a simple and efficient way to delete messages based on specific criteria such as subject, sender, or combination. This script generates a log file containing the IDs of deleted messages, providing a clear record of actions taken.

## Features
- **Selective Deletion**: Allows administrators to target messages for deletion by subject, sender, or both.
- **User-Friendly Prompts**: Guides the user through the deletion process with straightforward prompts to ensure precise targeting of messages.
- **Logging**: This script creates a file listing the deleted message IDs, aiding in record-keeping and accountability.

## Requirements
- The script must be run on a Zimbra server using the Zimbra user account.
- The Zimbra user must have appropriate permissions to read and execute the script.

## Installation
No formal installation is necessary. Simply download the `master.sh` script and ensure it is executable:
```bash
chmod +x master.sh

## Usage
To use the script, navigate to the directory containing master.sh and execute it:
./master.sh

Follow the on-screen prompts to select and delete messages. Before proceeding with deletion operations, ensure you have a backup of important data.

## Troubleshooting
The script includes validations to prevent common errors, but issues may arise if a non-existent Zimbra account is specified. Zimbra will report such Errors, providing insights into the issue.

## Contributing
Contributions are welcome! If you're interested in contributing, please directly message me on GitHub to discuss your ideas.

## License
This project is available for personal use. Commercial use is prohibited without prior authorization. Please see the LICENSE file for more details.

## Contact
If you have questions, suggestions, or contributions, feel free to contact me on my GitHub profile: jhonnasi.

Thank you for using or contributing to the Master - Zimbra Messages Remover project!
