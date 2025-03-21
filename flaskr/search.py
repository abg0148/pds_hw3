from flask import Blueprint
from flask import flash
from flask import render_template
from flask import request
from flask import session
from flask import url_for
from flask import redirect


from .db import get_db

bp = Blueprint("search", __name__, url_prefix="/search")

@bp.route("/", methods=("GET", "POST"))
def search():
    error = None
    if request.method == 'POST':
        mid = request.form['mid']
        db = get_db()
        is_valid = db.execute(
            "SELECT count(*) as count from member where mid = ?", (mid,)
        ).fetchone()["count"]

        print(f"is valid: {is_valid}")

        if not is_valid:
            error = f"{mid} is not a valid member id"
        else:
            session.clear()
            session["mid"] = mid
            return redirect(url_for("loan.index"))

        flash(error)

    return render_template('search.html')