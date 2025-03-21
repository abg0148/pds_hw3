from flask import Blueprint
from flask import session
from flask import render_template


from .db import get_db

bp = Blueprint("loan", __name__, url_prefix="/loan")

@bp.route("/", methods=("GET", "POST"))
def index():
    db = get_db()

    all_loan_records = db.execute(
        "SELECT * from everything where mid = ?", (session["mid"],)
    ).fetchall()

    data_rows = []
    for row in all_loan_records:
        data_rows.append(dict(row))

    return render_template('loan.html', rows=data_rows)
