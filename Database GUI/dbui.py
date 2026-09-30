import mysql.connector
import sys
from json import dumps
from flask import Flask, render_template_string, jsonify, request, redirect, url_for
import webbrowser
from threading import Timer

app = Flask(__name__)
db = None  # To hold the database instance

class MySQLDatabase:
    def __init__(self, host, port, database, username, password):
        self.host = host
        self.port = port
        self.database = database
        self.username = username
        self.password = password
        self.connection = self.connect_to_database()

    def connect_to_database(self):
        try:
            db_connection = mysql.connector.connect(
                host=self.host,
                port=self.port,
                user=self.username,
                password=self.password,
                database=self.database
            )
            return db_connection
        except Exception as e:
            print("\n[-] Error:\n" + str(e) + "\n")

    def get_table_names(self):
        if self.connection:
            cursor = self.connection.cursor()
            cursor.execute(f"SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES "
                           f"WHERE TABLE_TYPE='BASE TABLE' AND TABLE_SCHEMA='{self.database}'")
            tables = [row[0] for row in cursor.fetchall()]
            cursor.close()
            return tables
        return []

    def get_table_data(self, table_name):
        cursor = self.connection.cursor()
        cursor.execute(f"SELECT * FROM {table_name}")
        columns = [desc[0] for desc in cursor.description]
        rows = [dict(zip(columns, row)) for row in cursor.fetchall()]
        cursor.close()
        return {"columns": columns, "rows": rows}

    def save_record(self, table, values):
        """
        Insert a new record into the specified table using a dictionary of column: value pairs.
        """
        columns_str = ', '.join(values.keys())
        placeholders = ', '.join(['%s'] * len(values))
        values_str = tuple(values.values())

        cursor = self.connection.cursor()
        try:
            cursor.execute(
                f"INSERT INTO {table} ({columns_str}) VALUES ({placeholders})",
                values_str
            )
            self.connection.commit()
            return True
        except Exception as e:
            return str(e)

    def update_record(self, table, values, key):
        """
        Update an existing record by primary key.
        """
        primary_key_column = self.get_primary_key_column(table)
        if not primary_key_column:
            return "Primary key column not found."

        set_values = ', '.join([f"{col} = %s" for col in values.keys()])
        update_query = (
            f"UPDATE {table} SET {set_values} WHERE {primary_key_column} = %s"
        )

        cursor = self.connection.cursor()
        try:
            cursor.execute(update_query, list(values.values()) + [key])
            self.connection.commit()
            return True
        except Exception as e:
            return str(e)

    def delete_record(self, table, key):
        """
        Delete a record by primary key.
        """
        primary_key_column = self.get_primary_key_column(table)
        if not primary_key_column:
            return "Primary key column not found."

        cursor = self.connection.cursor()
        try:
            cursor.execute(
                f"DELETE FROM {table} WHERE {primary_key_column}=%s",
                (key,)
            )
            self.connection.commit()
            return True
        except Exception as e:
            return str(e)

    def get_primary_key_column(self, table_name):
        """
        Retrieves the primary key column for a given table.
        """
        cursor = self.connection.cursor()
        cursor.execute(
            f"""
            SELECT k.column_name 
            FROM information_schema.table_constraints t 
            JOIN information_schema.key_column_usage k 
            USING(constraint_name,table_schema,table_name) 
            WHERE t.constraint_type='PRIMARY KEY' 
            AND t.table_schema='{self.database}' 
            AND t.table_name='{table_name}';
            """
        )
        row = cursor.fetchone()
        cursor.close()
        if row:
            return row[0]
        else:
            return None

@app.route('/')
def index():
    # Added 'Host' and 'Port' fields to the form.
    return render_template_string("""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Database Connection</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="card mx-auto" style="max-width: 600px;">
            <div class="card-header text-center">
                <h3 class="mb-0">Connect to Database</h3>
            </div>
            <div class="card-body">
                <form method="POST" action="/connect">
                    <div class="form-group">
                        <label for="host">Host</label>
                        <input type="text" class="form-control" id="host" name="host" value="127.0.0.1" required>
                    </div>
                    <div class="form-group">
                        <label for="port">Port</label>
                        <input type="number" class="form-control" id="port" name="port" value="3306" required>
                    </div>
                    <div class="form-group">
                        <label for="database">Database</label>
                        <input type="text" class="form-control" id="database" name="database" required>
                    </div>
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password">
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Connect</button>
                </form>
                {% if message %}
                    <div class="alert alert-info mt-3">{{ message }}</div>
                {% endif %}
            </div>
        </div>
    </div>
</body>
</html>
""")

@app.route('/connect', methods=['POST'])
def connect():
    global db
    # Retrieve new form fields: host and port
    host = request.form['host']
    port = request.form['port']
    database = request.form['database']
    username = request.form['username']
    password = request.form['password']

    # Initialize MySQLDatabase with the new parameters
    db = MySQLDatabase(host, port, database, username, password)
    if db.connection:
        return redirect(url_for('select_tables'))
    else:
        return render_template_string("""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Database Connection - Failed</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="card mx-auto" style="max-width: 600px;">
            <div class="card-header text-center">
                <h3>Connect to Database</h3>
            </div>
            <div class="card-body">
                <form method="POST" action="/connect">
                    <div class="form-group">
                        <label for="host">Host</label>
                        <input type="text" class="form-control" id="host" name="host" value="127.0.0.1" required>
                    </div>
                    <div class="form-group">
                        <label for="port">Port</label>
                        <input type="number" class="form-control" id="port" name="port" value="3306" required>
                    </div>
                    <div class="form-group">
                        <label for="database">Database</label>
                        <input type="text" class="form-control" id="database" name="database" required>
                    </div>
                    <div class="form-group">
                        <label for="username">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" class="form-control" id="password" name="password">
                    </div>
                    <button type="submit" class="btn btn-primary btn-block">Connect</button>
                </form>
                <div class="alert alert-danger mt-3">Failed to connect to the database. Please check your credentials.</div>
            </div>
        </div>
    </div>
</body>
</html>
""")

@app.route('/select_tables')
def select_tables():
    tables = db.get_table_names()
    return render_template_string("""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Select Tables</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="card">
            <div class="card-header text-center">
                <h4>Select Tables</h4>
            </div>
            <div class="card-body">
                <form method="POST" action="/operate">
                    <p class="text-muted">Choose one or more tables to view and edit their records:</p>
                    <div class="form-group">
                        {% for table in tables %}
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="tables" value="{{ table }}" id="table{{ loop.index }}">
                            <label class="form-check-label" for="table{{ loop.index }}">{{ table }}</label>
                        </div>
                        {% endfor %}
                    </div>
                    <button type="submit" class="btn btn-primary">Next</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
""", tables=tables)

@app.route('/operate', methods=['POST'])
def operate():
    selected_tables = request.form.getlist('tables')
    tables = {table: db.get_table_data(table) for table in selected_tables}
    return render_template_string("""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Operate on Tables</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
</head>
<body class="bg-light">
    <div class="container py-5">
        <h1 class="text-center mb-4">Database Tables</h1>
        <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-3">
            <a class="navbar-brand" href="#">Tables</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarTables" aria-controls="navbarTables" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon">Toggle</span>
            </button>
            <div class="collapse navbar-collapse" id="navbarTables">
                <ul class="navbar-nav mr-auto">
                    {% for table, data in tables.items() %}
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="loadTable('{{ table }}')">{{ table }}</a>
                    </li>
                    {% endfor %}
                </ul>
            </div>
        </nav>
        <div id="tableContainer" class="mt-3"></div>
        <div id="formContainer"></div>

        <!-- Add/Edit Modal -->
        <div class="modal fade" id="recordModal" tabindex="-1" role="dialog" aria-labelledby="recordModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="recordModalLabel">Record Form</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form id="recordForm"></form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" id="saveButton">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function loadTable(tableName) {
            fetch(`/table/${tableName}`)
            .then(response => response.json())
            .then(data => {
                const container = document.getElementById('tableContainer');
                container.innerHTML = '';

                const table = document.createElement('table');
                table.className = 'table table-bordered table-hover';

                // Create thead
                const thead = document.createElement('thead');
                const trHead = document.createElement('tr');
                data.columns.forEach(column => {
                    const th = document.createElement('th');
                    th.textContent = column;
                    trHead.appendChild(th);
                });
                const actionTh = document.createElement('th');
                actionTh.textContent = 'Actions';
                trHead.appendChild(actionTh);
                thead.appendChild(trHead);

                // Create tbody
                const tbody = document.createElement('tbody');
                data.rows.forEach(row => {
                    const trBody = document.createElement('tr');
                    data.columns.forEach(column => {
                        const td = document.createElement('td');
                        td.textContent = row[column];
                        trBody.appendChild(td);
                    });
                    const actionTd = document.createElement('td');
                    actionTd.innerHTML = `
                        <button class="btn btn-primary btn-sm mr-1" onclick="showEditForm('${tableName}', this)">Edit</button>
                        <button class="btn btn-danger btn-sm" onclick="deleteRow('${tableName}', this)">Delete</button>
                    `;
                    trBody.appendChild(actionTd);
                    tbody.appendChild(trBody);
                });

                table.appendChild(thead);
                table.appendChild(tbody);
                container.appendChild(table);

                document.getElementById('formContainer').innerHTML = `
                    <button class="btn btn-success mt-3" onclick="showAddForm('${tableName}')">Add Record</button>
                `;
            });
        }

        function showAddForm(tableName) {
            fetch(`/table_columns/${tableName}`)
            .then(response => response.json())
            .then(columns => {
                const form = document.getElementById('recordForm');
                form.innerHTML = columns.map(column => `
                    <div class="form-group">
                        <label for="${column}">${column}</label>
                        <input type="text" class="form-control" id="${column}" name="${column}">
                    </div>
                `).join('');

                document.getElementById('saveButton').onclick = function() {
                    saveRecord('add', tableName);
                };
                $('#recordModal').modal('show');
            });
        }

        function showEditForm(tableName, button) {
            const tr = button.parentElement.parentElement;
            const table = tr.parentElement.parentElement;
            const columns = Array.from(table.querySelectorAll('thead th')).map(th => th.textContent);
            const rowData = Array.from(tr.querySelectorAll('td')).map(td => td.textContent);

            // Exclude the 'Actions' column from input
            const form = document.getElementById('recordForm');
            form.innerHTML = columns.slice(0, -1).map((column, i) => `
                <div class="form-group">
                    <label for="${column}">${column}</label>
                    <input type="text" class="form-control" id="${column}" name="${column}" value="${rowData[i]}">
                </div>
            `).join('');

            document.getElementById('saveButton').onclick = function() {
                // rowData[0] is assumed to be the primary key (first column)
                saveRecord('edit', tableName, rowData[0]);
            };
            $('#recordModal').modal('show');
        }

        function saveRecord(action, tableName, key) {
            const form = document.getElementById('recordForm');
            const formData = new FormData(form);
            const values = Object.fromEntries(formData.entries());

            const url = action === 'add' ? '/add_record' : '/update_record';
            const data = action === 'add'
                ? { table: tableName, values }
                : { table: tableName, values, key };

            fetch(url, {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success === true) {
                    $('#recordModal').modal('hide');
                    loadTable(tableName);
                } else {
                    alert('Save failed: ' + data.success);
                }
            });
        }

        function deleteRow(tableName, button) {
            const tr = button.parentElement.parentElement;
            const rowData = Array.from(tr.querySelectorAll('td')).map(td => td.textContent);

            if (!confirm('Are you sure you want to delete this record?')) return;

            fetch('/delete_record', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ table: tableName, key: rowData[0] })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success === true) {
                    loadTable(tableName);
                } else {
                    alert('Delete failed: ' + data.success);
                }
            });
        }
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
""", tables=tables)

@app.route('/table_columns/<table_name>')
def get_table_columns(table_name):
    table_data = db.get_table_data(table_name)
    return dumps(table_data["columns"], default=str)

@app.route('/table/<table_name>')
def get_table(table_name):
    table_data = db.get_table_data(table_name)
    return dumps(table_data, default=str)

@app.route('/add_record', methods=['POST'])
def add_record():
    data = request.get_json()
    table = data['table']
    values = data['values']
    success = db.save_record(table, values)
    if success is True:
        return jsonify({"success": True})
    else:
        print(" -- ERROR --", str(success))
        return jsonify({"success": success})  # Return the error message

@app.route('/update_record', methods=['POST'])
def update_record():
    data = request.get_json()
    table = data['table']
    values = data['values']
    key = data['key']
    success = db.update_record(table, values, key)
    if success is True:
        return jsonify({"success": True})
    else:
        return jsonify({"success": success})  # Return the error message

@app.route('/delete_record', methods=['POST'])
def delete_record():
    data = request.get_json()
    table = data['table']
    key = data['key']
    success = db.delete_record(table, key)
    if success is True:
        return jsonify({"success": True})
    else:
        return jsonify({"success": success})  # Return the error message

def open_browser():
    # Automatically open a browser tab when the server starts
    webbrowser.open_new('http://127.0.0.1:5000/')

if __name__ == '__main__':
    Timer(1, open_browser).start()
    app.run(debug=True)
