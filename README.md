# Work Timer Script
![image](https://github.com/user-attachments/assets/500e6e9e-eb33-49b5-8609-54119c71735f)

This script helps you time your work sessions, take breaks, log your activities, and provides motivational phrases to keep you focused.

## Setup and Permissions

Before using the script, make sure it has execution permissions. You can grant permissions by running the following command:

```bash
chmod +x work-timer.sh
```

## Usage
To use the script, run it with the following format:

```bash
./work-timer.sh [hours] [minutes] [project]
```

### Example
To start a timer for 15 minutes while working on a project called "trabajando", use:

```bash
./work-timer.sh 0 15 trabajando
```

### Breaks
While the timer is running, you can take a break by pressing b. This will log the break and allow you to resume work when ready.

## Viewing Logs
Logs for the timer and breaks are saved in the file:

```bash
~/work_timer.log
```

This file contains a record of your work sessions, breaks, project name, start time, and end time.

## Adding Motivational Phrases
If you want to add new motivational phrases to be displayed during your work sessions, simply add them to the file:

```bash
~/phrases.txt
```
Each phrase should be on a new line, and the script will randomly pick from the list during each session.

## Support
Did you like the script? Consider supporting by donating to my PayPal:

[Donate Here](https://www.paypal.com/donate/?hosted_button_id=5ETRMJCAXCHEN)

