# AlarmKitDemo

An AlarmKit demo app for iOS 26.4.

<br>

## Screenshots

#### Main Screen

| <small>Alarms</small> | <small>Remove</small> |
| --- | --- |
| <img src="Documents/Alarms.png" width="160" /> | <img src="Documents/Alarms.remove.png" width="160" /> |

#### Alarm Registration

| <small>Register</small> | <small>Title</small> |
| --- | --- |
| <img src="Documents/Register.png" width="160" /> | <img src="Documents/Register.Title.png" width="160" /> |

| <small>Repeat Option</small> | <small>Sound</small> |
| --- | --- |
| <img src="Documents/Register.RepeatOption.png" width="160" /> | <img src="Documents/Register.Sound.png" width="160" /> |

| <small>Snooze</small> | <small>Snooze Duration</small> |
| --- | --- |
| <img src="Documents/Register.Snooze.png" width="160" /> | <img src="Documents/Register.Snooze.Duration.png" width="160" /> |

| <small>Type</small> |
| --- |
| <img src="Documents/Register.Type.png" width="160" /> |

#### Alarm States

| <small>Foreground</small> | <small>Background</small> | <small>Lock Screen</small> |
| --- | --- | --- |
| <img src="Documents/Alarm.Foreground.png" width="160" /> | <img src="Documents/Alarm.Background.png" width="160" /> | <img src="Documents/Alarm.LockScreen.png" width="160" /> |

#### Logs

| <small>Log Alert</small> | <small>Log Calendar</small> |
| --- | --- |
| <img src="Documents/Log.Alert.png" width="160" /> | <img src="Documents/Log.Calendar.png" width="160" /> |

#### Accessibility and UI

| <small>Color Scheme</small> | <small>Dynamic Type</small> | <small>Orientation</small> |
| --- | --- | --- |
| <img src="Documents/ColorScheme.png" width="160" /> | <img src="Documents/DynamicType.png" width="160" /> | <img src="Documents/Orientation.png" width="160" /> |

<br>

## Features

- Create, edit, and delete alarms
- Support separate alarm types (`Sleep | Wake Up`, `Other`)
- Configure repeat schedules with `AlarmRepeatOptions`
- Choose from multiple alarm sounds (`Beep`, `Cuckoo Bird`, `Forest Birds`, `Morning Birds`, `Wind Chime`, `Cheerful`)
- Enable or disable snooze and configure snooze duration
- Handle Live Activity actions for alarm dismissal and countdown transitions
- Show a log alert after alarm completion and save log entries by date
- Persist logs with `SwiftData` (`LogEntity`)

<br>

## Tech Stack

- Swift
- SwiftUI
- AlarmKit
- AppIntents / ActivityKit
- SwiftData
- UserDefaults

<br>

## Run

1. Open `AlarmKitDemo.xcodeproj` in Xcode.
2. Select the `AlarmKitDemo` scheme.
3. Build and run the app on a real device.
4. Grant alarm permissions on first launch.
5. Create an alarm with the `+` button and test the flow.

<br>

## Project Structure

```text
AlamkitDemo/
├─ Documents/
├─ AlarmKitDemo/
│  ├─ Alarm/
│  ├─ Register/
│  ├─ LiveActivity/
│  ├─ Log/
│  └─ Resources/
│     └─ Sounds/
├─ AlarmKitDemo.xcodeproj
```

<br>

## Flow

1. `AlarmRegisterData.schedule()` schedules alarms through `AlarmManager`.
2. `AlarmsData.updateAlarms()` listens to `alarmUpdates` and keeps UI state in sync.
3. When an alarm finishes, the app presents a log alert.
4. Choosing `OK` stores a log entry and removes one-time alarms.
5. Choosing `Cancel` dismisses the alert and removes the alarm without saving a log.

<br>

## Persistence

- Alarm list: `UserDefaults` (`AlarmSections`)
- Logs: `SwiftData` (`LogEntity`)

<br>

## Notes

- Deployment target: `iOS 26.4`
- AlarmKit and Live Activity behavior should be tested on a real device
- Localization resources are included for English and Korean
