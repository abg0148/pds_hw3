from flask import Blueprint

from flask import render_template
from flask import request
from flask import url_for
from flask import redirect
from flask import g


from .db import get_db

bp = Blueprint("loan", __name__)