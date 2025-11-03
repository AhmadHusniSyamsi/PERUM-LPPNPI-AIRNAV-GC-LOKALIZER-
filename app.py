import calendar
import csv
import io
import os
from collections import Counter, defaultdict
from datetime import datetime
from operator import attrgetter

import plotly.graph_objs as go
import plotly.io as pio
from flask import (Flask, abort, flash, redirect, render_template, request,
                   send_file, send_from_directory, url_for)
from flask_login import (LoginManager, current_user, login_required,
                         login_user, logout_user)
from flask_migrate import Migrate
from werkzeug.security import check_password_hash
from werkzeug.utils import secure_filename

from config import Config
from extensions import db
from models import (Station, Station_dme, Station_dvor, Transmission,
                    Transmission_dme, Transmission_dvor, User)

app = Flask(__name__)
app.secret_key = 'rahasia'
app.config.from_object(Config)

db.init_app(app)
migrate = Migrate(app, db)

login_manager = LoginManager()
login_manager.login_view = 'login'
login_manager.init_app(app)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

from auth_routes import auth_bp
from dme_routes import dme_bp
from dvor_routes import dvor_bp
from gc_routes import groundcheck_bp
from ils_route import ils_bp
from radar_routes import radar_bp

app.register_blueprint(groundcheck_bp)
app.register_blueprint(dvor_bp)
app.register_blueprint(dme_bp)
app.register_blueprint(radar_bp)
app.register_blueprint(ils_bp)
app.register_blueprint(auth_bp)



@app.route('/')
def home():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    return redirect(url_for('login'))

@app.route('/main_dashboard', methods=['GET', 'POST'])
@login_required
def main_dashboard():
    # === VHF: ambil data ringkasan Power TX1 & TX2 ===
    data_vhf = Transmission.query.join(Station).add_columns(
        Station.nama_stasiun,
        Transmission.tx1_power, Transmission.tx2_power,
        Transmission.tanggal
    ).order_by(Transmission.tanggal).all()

    vhf_dates = [row.tanggal.strftime('%Y-%m-%d') for row in data_vhf]
    vhf_tx1 = [row.tx1_power for row in data_vhf]
    vhf_tx2 = [row.tx2_power for row in data_vhf]

    fig_vhf = go.Figure()
    fig_vhf.add_trace(go.Scatter(x=vhf_dates, y=vhf_tx1, mode='lines+markers', name='TX1 Power'))
    fig_vhf.add_trace(go.Scatter(x=vhf_dates, y=vhf_tx2, mode='lines+markers', name='TX2 Power'))
    fig_vhf.update_layout(title='VHF Power Output', xaxis_title='Tanggal', yaxis_title='Watt')
    chart_vhf = pio.to_html(fig_vhf, full_html=False)

    # === ILS (contoh dummy, ganti sesuai tabel ILS kamu) ===
    ils_data = [("2025-01-01", 95), ("2025-01-15", 97), ("2025-02-01", 94)]
    fig_ils = go.Figure([go.Bar(x=[d[0] for d in ils_data], y=[d[1] for d in ils_data])])
    fig_ils.update_layout(title='ILS Modulation (%)')
    chart_ils = pio.to_html(fig_ils, full_html=False)

    # === DVOR (contoh dummy) ===
    dvor_data = [("2025-01", 90), ("2025-02", 92)]
    fig_dvor = go.Figure([go.Bar(x=[d[0] for d in dvor_data], y=[d[1] for d in dvor_data])])
    fig_dvor.update_layout(title='DVOR Performance Index')
    chart_dvor = pio.to_html(fig_dvor, full_html=False)

    # === Radar (contoh dummy) ===
    radar_data = [("2025-01", 98), ("2025-02", 97)]
    fig_radar = go.Figure([go.Scatter(x=[d[0] for d in radar_data], y=[d[1] for d in radar_data], mode='lines+markers')])
    fig_radar.update_layout(title='Radar Availability (%)')
    chart_radar = pio.to_html(fig_radar, full_html=False)

    # === DME (contoh dummy) ===
    dme_data = [("2025-01", 80), ("2025-02", 85)]
    fig_dme = go.Figure([go.Bar(x=[d[0] for d in dme_data], y=[d[1] for d in dme_data])])
    fig_dme.update_layout(title='DME Signal Strength')
    chart_dme = pio.to_html(fig_dme, full_html=False)

    return render_template(
        'main_dashboard.html',
        chart_vhf=chart_vhf,
        chart_ils=chart_ils,
        chart_dvor=chart_dvor,
        chart_radar=chart_radar,
        chart_dme=chart_dme
    )





@app.route('/llz/cek_status')
def cek_status():
    return render_template('llz/cek_status.html')

 

@app.route('/llz/lihat_data')
def lihat_data():
    return render_template('llz/lihat_data.html')

@app.route('/login', methods=['GET','POST'])
def login():
    if request.method == 'POST':
        user = User.query.filter_by(username=request.form['username']).first()
        if user and check_password_hash(user.password, request.form['password']):
            login_user(user)
            return redirect(url_for('index'))
        flash('Username atau password salah.', 'danger')
    return render_template('login.html')

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('login'))
    

@app.route('/index')
def index():
    return render_template('index.html')

@app.route("/history")
def history():
    return render_template("history.html")

# === VHF===
@app.route('/station_list')
@login_required
def station_list():
    stations = Station.query.all()
    return render_template('vhf/station_list.html', stations=stations)

@app.route('/station/add', methods=['GET', 'POST'])
@login_required
def add_station():
    if request.method == 'POST':
        nama = request.form['nama_stasiun']
        frek = request.form['frekuensi']
        new_station = Station(nama_stasiun=nama, frekuensi=frek)
        db.session.add(new_station)
        db.session.commit()
        return redirect(url_for('add_transmission', nama_stasiun=new_station.nama_stasiun))
    return render_template('vhf/station_form.html')

@app.route('/transmission/add/<path:nama_stasiun>', methods=['GET', 'POST'])
@login_required
def add_transmission(nama_stasiun):
    station = Station.query.filter_by(nama_stasiun=nama_stasiun).first_or_404()
    if request.method == 'POST':
        tx = Transmission(
            station_id=station.id,
            tx1_power=float(request.form.get('tx1_power') or 0),
            tx1_swr=request.form.get('tx1_swr'),
            tx1_mod=float(request.form.get('tx1_mod') or 0),
            tx2_power=float(request.form.get('tx2_power') or 0),
            tx2_swr=request.form.get('tx2_swr'),
            tx2_mod=float(request.form.get('tx2_mod') or 0),
            tanggal=datetime.strptime(request.form['tanggal'], '%Y-%m-%d'),
            pic=request.form['pic']
        )
        db.session.add(tx)
        db.session.commit()
        flash('Data berhasil disimpan.', 'success')

        if request.form.get('action') == 'save_and_add':
            return redirect(url_for('add_transmission', nama_stasiun=station.nama_stasiun))
        return redirect(url_for('view_data'))

    return render_template('vhf/transmission_form.html', station=station, tx=None)

# === Dashboard ===
@app.route('/dashboard', methods=['GET', 'POST'])
@login_required
def dashboard():
    stations = Station.query.all()
    selected_station_id = request.form.get('station_id')
    selected_year = request.form.get('year', type=int)
    selected_month = request.form.get('month', type=int)
    selected_day = request.form.get('day', type=int)

    query = Transmission.query.join(Station)
    if selected_station_id:
        query = query.filter(Transmission.station_id == selected_station_id)
    if selected_year:
        query = query.filter(db.extract('year', Transmission.tanggal) == selected_year)
    if selected_month:
        query = query.filter(db.extract('month', Transmission.tanggal) == selected_month)
    if selected_day:
        query = query.filter(db.extract('day', Transmission.tanggal) == selected_day)

    data = query.add_columns(
        Station.nama_stasiun, Station.frekuensi,
        Transmission.tx1_power, Transmission.tx1_swr, Transmission.tx1_mod,
        Transmission.tx2_power, Transmission.tx2_swr, Transmission.tx2_mod,
        Transmission.tanggal, Transmission.pic
    ).order_by(Transmission.tanggal).all()

    # Data transform
    dates = [row.tanggal.strftime('%Y-%m-%d') for row in data]
    tx1_power = [row.tx1_power for row in data]
    tx2_power = [row.tx2_power for row in data]
    tx1_mod = [row.tx1_mod for row in data]
    tx2_mod = [row.tx2_mod for row in data]
    tx1_swr = [str(row.tx1_swr).lower() for row in data]
    tx2_swr = [str(row.tx2_swr).lower() for row in data]

    # === Line Chart Power ===
    fig_power = go.Figure()
    fig_power.add_trace(go.Scatter(x=dates, y=tx1_power, mode='lines+markers', name='TX1 Power'))
    fig_power.add_trace(go.Scatter(x=dates, y=tx2_power, mode='lines+markers', name='TX2 Power'))
    fig_power.update_layout(title='Power Output TX1 & TX2', xaxis_title='Tanggal', yaxis_title='Watt')
    chart_power = pio.to_html(fig_power, full_html=False)

    # === Line Chart Mod% ===
    fig_mod = go.Figure()
    fig_mod.add_trace(go.Scatter(x=dates, y=tx1_mod, mode='lines+markers', name='TX1 Mod%'))
    fig_mod.add_trace(go.Scatter(x=dates, y=tx2_mod, mode='lines+markers', name='TX2 Mod%'))
    fig_mod.update_layout(title='Modulasi TX1 & TX2', xaxis_title='Tanggal', yaxis_title='Modulasi (%)')
    chart_mod = pio.to_html(fig_mod, full_html=False)

    # === Pie Chart SWR ===
    swr_all = tx1_swr + tx2_swr
    swr_normal = sum(1 for s in swr_all if '1.5' in s or 'normal' in s or 'ok' in s)
    swr_not_normal = len(swr_all) - swr_normal
    fig_swr = go.Figure(data=[go.Pie(labels=["Normal", "Tidak Normal"], values=[swr_normal, swr_not_normal], hole=0.4)])
    fig_swr.update_layout(title="SWR Normal vs Tidak Normal")
    chart_swr = pio.to_html(fig_swr, full_html=False)

    # === Grouped Bar TX1 vs TX2 ===
    fig_grouped = go.Figure()
    fig_grouped.add_trace(go.Bar(x=dates, y=tx1_power, name='TX1 Power'))
    fig_grouped.add_trace(go.Bar(x=dates, y=tx2_power, name='TX2 Power'))
    fig_grouped.update_layout(barmode='group', title="Perbandingan TX1 vs TX2 per Tanggal", xaxis_title="Tanggal", yaxis_title="Watt")
    chart_grouped = pio.to_html(fig_grouped, full_html=False)

    # === Rata-rata Power & Mod% per Stasiun ===
    avg_by_station = defaultdict(lambda: {'tx1_power': [], 'tx2_power': [], 'tx1_mod': [], 'tx2_mod': []})
    for row in data:
        key = row.nama_stasiun
        avg_by_station[key]['tx1_power'].append(row.tx1_power)
        avg_by_station[key]['tx2_power'].append(row.tx2_power)
        avg_by_station[key]['tx1_mod'].append(row.tx1_mod)
        avg_by_station[key]['tx2_mod'].append(row.tx2_mod)

    station_labels = []
    avg_tx1_power = []
    avg_tx2_power = []
    avg_tx1_mod = []
    avg_tx2_mod = []

    for station, values in avg_by_station.items():
        station_labels.append(station)
        avg_tx1_power.append(sum(values['tx1_power']) / len(values['tx1_power']))
        avg_tx2_power.append(sum(values['tx2_power']) / len(values['tx2_power']))
        avg_tx1_mod.append(sum(values['tx1_mod']) / len(values['tx1_mod']))
        avg_tx2_mod.append(sum(values['tx2_mod']) / len(values['tx2_mod']))

    fig_avg_power = go.Figure()
    fig_avg_power.add_trace(go.Bar(x=station_labels, y=avg_tx1_power, name='TX1 Power'))
    fig_avg_power.add_trace(go.Bar(x=station_labels, y=avg_tx2_power, name='TX2 Power'))
    fig_avg_power.update_layout(title='Rata-rata Power per Stasiun', barmode='group', xaxis_title='Stasiun', yaxis_title='Watt')
    chart_avg_power = pio.to_html(fig_avg_power, full_html=False)

    fig_avg_mod = go.Figure()
    fig_avg_mod.add_trace(go.Bar(x=station_labels, y=avg_tx1_mod, name='TX1 Mod%'))
    fig_avg_mod.add_trace(go.Bar(x=station_labels, y=avg_tx2_mod, name='TX2 Mod%'))
    fig_avg_mod.update_layout(title='Rata-rata Mod% per Stasiun', barmode='group', xaxis_title='Stasiun', yaxis_title='Modulasi (%)')
    chart_avg_mod = pio.to_html(fig_avg_mod, full_html=False)

    # === Bar Chart PIC Paling Aktif ===
    pic_counter = Counter(row.pic for row in data)
    pic_labels, pic_values = zip(*pic_counter.items()) if pic_counter else ([], [])

    fig_pic = go.Figure()
    fig_pic.add_trace(go.Bar(x=pic_labels, y=pic_values, marker_color='green'))
    fig_pic.update_layout(title='PIC Paling Aktif', xaxis_title='PIC', yaxis_title='Jumlah Cek')
    chart_pic = pio.to_html(fig_pic, full_html=False)

    # === Summary Teks ===
    summary = {
        'power_summary': f"TX1 rata-rata {sum(tx1_power)/len(tx1_power):.2f} W dan TX2 rata-rata {sum(tx2_power)/len(tx2_power):.2f} W" if tx1_power and tx2_power else "Tidak ada data Power",
        'mod_summary': f"TX1 Mod% rata-rata {sum(tx1_mod)/len(tx1_mod):.2f}% dan TX2 rata-rata {sum(tx2_mod)/len(tx2_mod):.2f}%" if tx1_mod and tx2_mod else "Tidak ada data Mod%",
        'swr_summary': f"{swr_normal} Normal, {swr_not_normal} Tidak Normal dari total {len(swr_all)} entri",
        'pic_summary': f"PIC paling aktif: {pic_labels[pic_values.index(max(pic_values))]} dengan {max(pic_values)} kali pengecekan" if pic_labels else "Tidak ada data PIC"
    }

    # Tahun, Bulan, Tanggal
    years = sorted(set(row.tanggal.year for row in Transmission.query.all()))

    return render_template(
        'vhf/dashboard.html',
        data=data,
        chart_power=chart_power,
        chart_mod=chart_mod,
        chart_swr=chart_swr,
        chart_grouped=chart_grouped,
        chart_avg_power=chart_avg_power,
        chart_avg_mod=chart_avg_mod,
        chart_pic=chart_pic,
        stations=stations,
        selected_station_id=selected_station_id,
        selected_year=selected_year,
        selected_month=selected_month,
        selected_day=selected_day,
        years=years,
        summary=summary
    )


# Di app.py atau extensions.py (tempat inisialisasi Flask)
import base64
from collections import defaultdict


# Custom Jinja filter
@app.template_filter('b64encode')
def b64encode_filter(data):
    if data is None:
        return ''
    return base64.b64encode(data).decode('utf-8')


@app.route('/data')
@login_required
def view_data():
    stations = Station.query.order_by(Station.nama_stasiun).all()
    grouped_data = []
    for station in stations:
        transmissions = Transmission.query.filter_by(station_id=station.id).all()
        if transmissions:
            per_year = defaultdict(list)
            for tx in transmissions:
                year = tx.tanggal.year
                per_year[year].append(tx)
            for year in per_year:
                per_year[year].sort(key=attrgetter('tanggal'))
            sorted_per_year = dict(sorted(per_year.items(), reverse=True))
            grouped_data.append({'station': station, 'per_year': sorted_per_year})
    return render_template('vhf/data_table.html', grouped_data=grouped_data)

@app.route('/transmission/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_transmission(id):
    tx = Transmission.query.get_or_404(id)
    station = Station.query.get_or_404(tx.station_id)
    if request.method == 'POST':
        tx.tx1_power = float(request.form.get('tx1_power') or 0)
        tx.tx1_swr = request.form.get('tx1_swr')
        tx.tx1_mod = float(request.form.get('tx1_mod') or 0)
        tx.tx2_power = float(request.form.get('tx2_power') or 0)
        tx.tx2_swr = request.form.get('tx2_swr')
        tx.tx2_mod = float(request.form.get('tx2_mod') or 0)
        tx.tanggal = datetime.strptime(request.form.get('tanggal'), '%Y-%m-%d')
        tx.pic = request.form.get('pic')
        db.session.commit()
        return redirect(url_for('view_data'))
    return render_template('vhf/transmission_form.html', tx=tx, station=station)

@app.route('/transmission/delete/<int:id>', methods=['GET'])
@login_required
def delete_transmission(id):
    tx = Transmission.query.get_or_404(id)
    db.session.delete(tx)
    db.session.commit()
    return redirect(url_for('view_data'))

@app.route('/station/edit/<int:id>', methods=['GET', 'POST'])
@login_required
def edit_station(id):
    station = Station.query.get_or_404(id)
    if request.method == 'POST':
        station.nama_stasiun = request.form['nama_stasiun']
        station.frekuensi = request.form['frekuensi']
        db.session.commit()
        return redirect(url_for('home'))
    return render_template('vhf/station_form.html', station=station)

@app.route('/station/delete/<int:id>', methods=['GET', 'POST'])
@login_required
def delete_station(id):
    station = Station.query.get_or_404(id)
    Transmission.query.filter_by(station_id=station.id).delete()
    db.session.delete(station)
    db.session.commit()
    return redirect(url_for('station_list'))

# === User Profile ===
UPLOAD_FOLDER = 'static/uploads/profile'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/profile')
@login_required
def profile():
    return render_template('profile.html', user=current_user)



UPLOAD_FOLDER = os.path.join(app.root_path, 'static', 'uploads', 'profile')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'png', 'jpg', 'jpeg'}

@app.route('/profile/edit', methods=['GET', 'POST'])
@login_required
def edit_profile():
    if request.method == 'POST':
        current_user.nama = request.form.get('nama', current_user.nama)
        tanggal_lahir = request.form.get('tanggal_lahir')
        if tanggal_lahir:
            current_user.tanggal_lahir = datetime.strptime(tanggal_lahir, '%Y-%m-%d')
        current_user.jabatan = request.form.get('jabatan', current_user.jabatan)
        current_user.nip = request.form.get('nip', current_user.nip)
        current_user.email = request.form.get('email', current_user.email)
        current_user.no_hp = request.form.get('no_hp', current_user.no_hp)
        current_user.jenis_kelamin = request.form.get('jenis_kelamin', current_user.jenis_kelamin)
        current_user.lokasi_penempatan = request.form.get('lokasi_penempatan', current_user.lokasi_penempatan)

        # Upload foto profil
        if 'photo' in request.files:
            file = request.files['photo']
            if file and allowed_file(file.filename):
                filename = secure_filename(file.filename)
                save_path = os.path.join(UPLOAD_FOLDER, filename)
                file.save(save_path)
                # Simpan path relatif ke DB
                current_user.photo_path = f'uploads/profile/{filename}'

        db.session.commit()
        flash('Profil berhasil diperbarui!', 'success')
        return redirect(url_for('profile'))

    return render_template('edit_profile.html', user=current_user)

@app.route('/profile_photo/<int:user_id>')
@login_required
def profile_photo(user_id):
    user = User.query.get_or_404(user_id)
    if user.photo_path:
        # Path relatif yang sudah disimpan di DB → "uploads/profile/namafile.jpg"
        return send_from_directory(
            os.path.join(app.root_path, 'static'),
            user.photo_path
        )
    else:
        # fallback ke foto default
        return send_from_directory(
            os.path.join(app.root_path, 'static', 'img'),
            'default_profile.png'
        )

@app.route('/export')
@login_required
def export_csv():
    output = io.StringIO()
    writer = csv.writer(output)
    writer.writerow(['Stasiun', 'Frekuensi', 'TX1 Power', 'TX1 SWR', 'TX1 Mod%',
                     'TX2 Power', 'TX2 SWR', 'TX2 Mod%', 'Tanggal', 'PIC'])
    txs = Transmission.query.join(Station).add_columns(
        Station.nama_stasiun, Station.frekuensi,
        Transmission.tx1_power, Transmission.tx1_swr, Transmission.tx1_mod,
        Transmission.tx2_power, Transmission.tx2_swr, Transmission.tx2_mod,
        Transmission.tanggal, Transmission.pic
    ).all()
    for row in txs:
        writer.writerow([row.nama_stasiun, row.frekuensi,
                         row.tx1_power, row.tx1_swr, row.tx1_mod,
                         row.tx2_power, row.tx2_swr, row.tx2_mod,
                         row.tanggal, row.pic])
    output.seek(0)
    return send_file(io.BytesIO(output.getvalue().encode()), mimetype='text/csv',
                     as_attachment=True, download_name='data_vhf.csv')
from flask import abort


@app.route("/force-404")
def force_404():
    abort(404)
    
if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host="0.0.0.0", port=5000, debug=True)

    