# 📝 Task Manager App

A **Task Management Application** built with **Flutter** for the frontend and **Django** for the backend. This app allows users to **perform CRUD operations** on tasks, with features like **user authentication** using **SimpleJWT**, **task filtering**, and **local notifications** if a task's due date is missed.

---

## 🚀 Features

- ✅ **User Authentication** with **SimpleJWT** (login, registration)
- ✅ **Create, Read, Update, Delete (CRUD)** tasks
- 📋 View all tasks with options to filter by status, priority, or due date
- 🔔 **Local notifications** when a task's due date has passed
- 🌐 REST API powered by **Django REST Framework**
- 💾 **MySQL** for database storage
- 🔄 **Real-time updates** with Flutter

---

## 🛠️ Tech Stack

### 📱 Frontend (Client)

- **Flutter** (Dart)
- **http** package for API requests
- **Provider** for state management
- **Local Notifications** for alerts on due date expiry
- **JWT Authentication** for secure login

### 🌐 Backend (Server)

- **Django**
- **Django REST Framework** for APIs
- **SimpleJWT** for token-based authentication
- **MySQL** database
- **CORS Headers** for cross-origin requests

---

## 📦 Setup Instructions

### 🔧 Backend (Django)

1. Clone the repository:
   ```bash
   git clone https://github.com/Vikram-353/Task-Manager.git
   cd Task-Manager/backend
   ```
