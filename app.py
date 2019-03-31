from flask import Flask, render_template, request, redirect, session, url_for
from blockchain_backend import BLOCKCHAIN as block_back, w3
from flask_migrate import Migrate

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'
app.secret_key = b'asdasdasda34a65sd46a5s4d5as'

from models import *
migrate = Migrate(app, db)

@app.route('/')
def login():
    return render_template('login.html')


@app.route('/register')
def register():
    return render_template('register.html')


@app.route('/questions')
def questions():
    projects = {}
    count = block_back.send_count().call()
    for p in range(1,count+1):
        project = block_back.view_project(str(p)).call()
        projects[p] = project[0]
    return render_template('questions.html', projects = projects)


@app.route('/question-details/<int:id>')
def detail_question(id):
    return render_template('detail_questions.html')


@app.route('/question-details-vote/<int:id>')
def detail_question_vote(id):
    reviews = Review.query.filter_by(project_id=id)
    return render_template('detail_questions_vote.html', reviews=reviews,project_id=id)


@app.route('/question-details-ended/<int:id>')
def detail_question_ended(id):
    reviews = Review.query.filter_by(project_id=id)
    return render_template('detail_questions_ended.html', reviews=reviews,project_id=id)


@app.route('/write-review/<int:id>')
def write_review(id):
    return render_template('write-review.html',project_id=id)


@app.route('/stake/<int:id>')
def stake(id):
    return render_template('stake.html',project_id=id)


'''Post URLs----------------------------------------'''


@app.route('/stake-post', methods=['POST'])
def stake_post():
    data = request.form
    transaction_details = {'value' : data['value'],'from':session['pub_key']}
    user = User.query.filter_by(email=session['email'])
    transaction = block_back.vote(data['project_id'], bool(data['type'])).buildTransaction(transaction_details)
    private_key = user.private_key
    signed = w3.eth.account.signTransaction(transaction, private_key)
    block_back.vote(data['project_id'], bool(data['type']))
    w3.eth.sendRawTransaction(signed.rawTransaction)
    return redirect('stake')


@app.route('/register-post', methods=['POST'])
def register_post():
    email = request.form['email']
    password = request.form['password']
    name = request.form['name']
    public_key = request.form['public_key']
    private_key = request.form['private_key']
    user = User(email=email, name=name, password=password, public_key=public_key, private_key=private_key)
    db.session.add(user)
    db.session.commit()
    return redirect(url_for('login'))


@app.route('/login-post', methods=['POST'])
def login_post():
    user_login = request.form
    email = user_login['email']
    passwd = user_login['password']
    user = User.query.filter_by(email=email).first()
    if user.password == passwd:
        session['email'] = email
        session['pub_key'] = user.public_key
        return redirect('questions')
    return render_template('login.html')


@app.route('/review-post',methods=['POST'])
def review_post():
    review = request.form
    message = review['review']
    project_id = review['project_id']
    r = Review(reviewer=session['pub_key'], review=message, project_id=project_id)
    db.session.add(r)
    db.session.commit()
    return render_template('write-review.html')


@app.route('/logout')
def logout():
    session.pop('email', None)
    session.pop('pub_key', None)
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run()
