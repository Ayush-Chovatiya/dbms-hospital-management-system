# DBMS Hospital Management System

A SQL-based Hospital Management System designed to manage hospital operations such as patients, doctors, appointments, medical records, medications, surgeries, and medical conditions.

---

## Features

- Relational database with **8 interconnected tables**
- Foreign key relationships with referential integrity
- CHECK constraints for data validation
- Sample data for testing
- Pre-written SQL queries for common operations
- Supports patient, doctor, appointment, medical history, surgery, and medication management

---

## Database Structure

The project consists of the following tables:

- Patient
- Doctor
- Schedule
- Appointment
- MedicalHistory
- MedicalCondition
- Surgery
- Medication

> ER diagrams and schema visualizations can be found in the `diagrams/` directory.

---

## Technologies Used

- SQL
- Relational Database Management System (PostgreSQL)

---

## Project Structure

```text
DBMS-Hospital-Management-System/
│
├── sqlFiles/
│   ├── ddl_script.sql      # Database schema
│   ├── data_seed.sql       # Sample data
│   └── queries.sql         # Example SQL queries
│
├── diagrams/               # ER diagrams
│
└── README.md
```

---

## Getting Started

### 1. Create the database

Run:

```sql
SOURCE sqlFiles/ddl_script.sql;
```

### 2. Load sample data

```sql
SOURCE sqlFiles/data_seed.sql;
```

### 3. Execute sample queries

```sql
SOURCE sqlFiles/queries.sql;
```

---

## Example Queries

The project includes ready-to-use queries such as:

- View scheduled appointments
- Find doctor workload
- Display completed appointments
- View patient medical conditions
- List surgeries
- View prescribed medications

---

## Entity Relationships

- One patient can have multiple appointments.
- One doctor can have multiple appointments.
- A patient can have multiple medical history records.
- Medical history can contain multiple medical conditions.
- Patients can have multiple surgeries and medications.

---

## Future Enhancements

- Web or desktop interface
- REST API integration
- Authentication and user roles
- Appointment reminders and notifications
- Reporting and analytics dashboard

---

## Contributing

Contributions are welcome. Feel free to fork the repository, make improvements, and submit a pull request.

---

## License

This project is intended for educational and learning purposes.
