# Responsibility Architecture

## System presentation

#### Dashboard

- Show SIS dashboard
- Show subject list
- Display notifications
- Show subject detail to student
- Show more detailed subject info to teacher
- Show statistics

## Bussiness/Application

#### Subject Manager

- Filter subjects
- Search subject

#### Enrollment Validator

- Check subject requirements for students
- Check subject capacity
- TODO ADD MORE
  
#### Enrollment Manager

- Enroll student to subject
- Withdraw student from subject
- TODO ADD MORE

#### History Analyzer

- Analyze subject history

## Persistence/Infrastructure

#### Subject enrollment repository

- Store subject data
- Store subject history
- Store student enrollment data

#### Alert

- Email alerts

#### Logger

- Record notifications
