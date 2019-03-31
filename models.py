from flask_sqlalchemy import SQLAlchemy
from app import app

db = SQLAlchemy(app)


class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    name = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(128), unique=True, nullable=False)
    public_key = db.Column(db.String(256), unique=True, nullable=False)
    private_key = db.Column(db.String(256), unique=True, nullable=False)

    def __repr__(self):
        return '<Email %r>' % self.email


class Review(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    project_id = db.Column(db.String(128), nullable=True)
    reviewer = db.Column(db.Integer, db.ForeignKey('user.email'),nullable=False)
    review = db.Column(db.String(256), nullable=True)

    def __repr__(self):
        return '<reviewer %r>' % self.reviewer