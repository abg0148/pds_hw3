from flask import Blueprint

from flask import render_template
from flask import request
from flask import url_for
from flask import redirect
from flask import g


from .db import get_db

bp = Blueprint("search", __name__, url_prefix="/search")

@bp.route("/", methods=("GET", "POST"))
def search():
    if request.method == 'POST':
        mid = request.form['mid']
        db = get_db()
        is_valid = db.execute(
            "SELECT count(*) from member"
        ).fetchone()
        print(f"is_valid: {is_valid}")
    return render_template('search.html')