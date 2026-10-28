# SKILL SCOUT - The Worker Finder

A full-stack mobile application designed to connect workers with people seeking their services through a location-aware worker discovery platform.

## Overview

SKILL SCOUT is an information engineering project that explores how mobile technology can simplify the process of finding and connecting with workers. The application is designed around two primary user groups: 
**workers offering their skills and services, and hirers looking for suitable workers.**

The project combines a **Flutter** mobile application with a **Node.js** backend and **MongoDB** database. It brings together mobile development, backend architecture, authentication, database integration, and geolocation-related functionality in a single application.

## Features

- **Worker–hirer matching:** Supports the concept of connecting workers with people seeking services.
- **Location-based discovery:** Incorporates geolocation functionality for location-aware worker and hirer matching.
- **Authentication:** Uses JWT-related components for token-based authentication.
- **Password security:** Uses bcrypt for password hashing.
- **Image handling:** Includes image-upload functionality.
- **Mobile application:** Built with Flutter for a mobile application experience.
- **Database integration:** Uses MongoDB for persistent data storage.
- **Separated architecture:** Maintains distinct frontend and backend components.

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Frontend programming language |
| Node.js | Backend runtime |
| MongoDB | Database and data persistence |
| JWT | Token-based authentication |
| bcrypt | Password hashing |
| MVC architecture | Organization of backend responsibilities |

## Architecture

The application separates the mobile interface, server-side logic, and database into distinct components.

```text
┌──────────────────────────┐
│     Flutter Frontend     │
│     Mobile Application   │
└────────────┬─────────────┘
             │
             │ API Communication
             ▼
┌──────────────────────────┐
│      Node.js Backend     │
│                          │
│     MVC Architecture     │
│   Routes and Controllers │
│   Authentication Logic  │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│         MongoDB          │
│      Data Persistence    │
└──────────────────────────┘
```

### Frontend

The Flutter frontend provides the mobile application interface and manages the user-facing side of the application.

### Backend

The Node.js backend handles server-side application logic and organizes responsibilities using an MVC-style structure.

### Database

MongoDB provides persistent storage for application data.

### Authentication and Security

JWT and bcrypt are used for authentication-related functionality and password hashing, respectively.

## Project Structure

```text
SKILL_SCOUT-The Worker Finder /The Labor Finder
├── frontend/       # Flutter mobile application
├── backend/        # Node.js backend
├── Skill_scout/    # Additional project files
├── .gitignore
└── README.md
```

## Getting Started

### Prerequisites

Install the following tools:

- [Git](https://git-scm.com/downloads)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/)
- [MongoDB](https://www.mongodb.com/docs/manual/installation/)

### 1. Clone the Repository

```bash
git clone https://github.com/MASTERmaze1412/SKILL_SCOUT-TheWorkerFinder.git
cd SKILL_SCOUT-TheWorkerFinder
```

### 2. Set Up the Frontend

Navigate to the Flutter application directory:

```bash
cd frontend
flutter pub get
flutter run
```

Run the application on a supported emulator or physical device.

### 3. Set Up the Backend

Open a separate terminal and navigate to the backend directory:

```bash
cd backend
```

Install the backend dependencies and start the server using the scripts and instructions provided by the backend configuration.

Configure the MongoDB connection and any required environment variables before running the server. The exact commands depend on the scripts defined in `backend/package.json`.

### 4. Configure the Connection

Ensure that the Flutter application points to the correct backend address and that the backend can connect to MongoDB.

When using a physical device, configure the API address so the device can reach the development computer.

## Development

The frontend and backend can be developed independently while communicating through the application's API layer.

- **Frontend:** Work within `frontend/` for mobile interface and application changes.
- **Backend:** Work within `backend/` for server-side logic, authentication, and data operations.
- **Integration:** Verify communication between the mobile application, backend, and database after relevant changes.

## Future Enhancements

Although the project establishes a foundation for worker discovery and matching, several improvements could expand its functionality and practical value.

- **Advanced matching:** Introduce skill-based filtering, worker availability, experience, and other relevant matching criteria.
- **Worker profiles:** Expand profiles to include detailed skills, service categories, work history, and portfolio images.
- **Reviews and ratings:** Allow hirers to review completed work and help future users assess worker reliability.
- **Real-time communication:** Add in-app messaging and notifications to simplify coordination between workers and hirers.
- **Booking management:** Introduce job requests, scheduling, booking status, and cancellation workflows.
- **Security improvements:** Strengthen authorization, request validation, rate limiting, and secure configuration management.
- **Deployment and monitoring:** Establish a documented deployment process, centralized error logging, and application health monitoring.
- **Performance and scalability:** Optimize database queries, API responses, image handling, and resource usage as adoption grows.

These enhancements are potential future directions rather than claims about currently implemented features.

## Contributing

Contributions and suggestions are welcome.

1. Fork the repository.
2. Create a branch for your changes.
3. Implement and test your changes.
4. Submit a pull request describing the changes.

## License


## Author

Developed as an engineering project focused on mobile application development, backend engineering, database integration, and location-aware worker discovery.

**Repository:** [SKILL_SCOUT — The Worker Finder](https://github.com/MASTERmaze1412/SKILL_SCOUT-TheWorkerFinder)
