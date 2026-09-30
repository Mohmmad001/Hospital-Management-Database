# Hospital Management Database (MySQL + Flask)

A relational database for a medical clinic, with a lightweight web UI for
browsing its tables.

## What it covers

- Patient records and their phone numbers
- Doctors and specialties
- Appointment scheduling (check-up, emergency, surgery, follow-up)
- Appointment-to-doctor assignment (many-to-many)
- Billing and payments
- Constraints (primary/foreign keys, `CHECK`, cascades), views, stored
  procedures, and role-based privileges (doctor, receptionist, accountant,
  admin)

## Project structure

```
database/HospitalDB.sql      # Schema + sample data (MySQL dump)
app/dbui.py                  # Flask web UI
requirements.txt
```

## Setup

**Requirements:** Python 3.8+, MySQL 8.0+

1. Install dependencies:
```bash
   pip install -r requirements.txt
```
2. Import the database:
```bash
   mysql -u root -p < database/HospitalDB.sql
```
   The dump creates a database named `hostpital` (sic). Use that name in the UI,
   or rename it.
3. Start the UI:
```bash
   python app/dbui.py
```
4. In the connection form, enter host (`127.0.0.1`), port, database name,
   username and password. Credentials are entered at runtime and never
   stored in the code.

## Notes

- Don't commit real passwords or credentials.
- The sample data is fictional.
