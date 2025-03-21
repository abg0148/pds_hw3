from flask import Blueprint
from flask import render_template
from flask import request
from flask import url_for
from flask import redirect
from flask import g


from .db import get_db

bp = Blueprint("copies", __name__, url_prefix="/copies")

@bp.route("/<int:bid>/available", methods=("GET", "POST"))
def available(bid):
    db = get_db()

    available_copies = db.execute("SELECT * FROM available_book_copies WHERE bid = ?",(bid,)).fetchall()

    data_rows = []
    for row in available_copies:
        data_rows.append(dict(row))

    return render_template('copies.html', bid=bid, rows=data_rows)
