from flask import (Blueprint, flash, redirect, render_template, request,
                   session, url_for)
from werkzeug.security import generate_password_hash

from models import User, db

auth_bp = Blueprint('auth', __name__)


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            flash('Username sudah terdaftar. Gunakan username lain.')
            return redirect(url_for('auth.register'))

        hashed_password = generate_password_hash(password)
        new_user = User(username=username, password=hashed_password)
        db.session.add(new_user)
        db.session.commit()

        flash('Registrasi berhasil! Silakan login.')
        return redirect(url_for('login'))

    return render_template('register.html')


# ==================== FORGOT PASSWORD ====================
@auth_bp.route('/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        username = request.form['username']
        user = User.query.filter_by(username=username).first()
        if user:
            session['reset_user_id'] = user.id  # simpan sesi
            return redirect(url_for('auth.reset_password'))
        else:
            flash("Username tidak ditemukan", "danger")
    return render_template('forgot_password.html')


# ==================== RESET PASSWORD ====================
@auth_bp.route('/reset_password', methods=['GET', 'POST'])
def reset_password():
    user_id = session.get('reset_user_id')
    if not user_id:
        flash("Sesi reset password tidak valid", "danger")
        return redirect(url_for('auth.forgot_password'))

    user = User.query.get(user_id)
    if not user:
        flash("User tidak ditemukan", "danger")
        return redirect(url_for('auth.forgot_password'))

    if request.method == 'POST':
        new_password = request.form['password']
        user.set_password(new_password)  # hashing di model User
        db.session.commit()
        session.pop('reset_user_id', None)  # hapus sesi
        flash("Password berhasil direset, silakan login", "success")
        return redirect(url_for('login'))

    return render_template('reset_password.html')
