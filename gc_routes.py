from datetime import datetime

from flask import Blueprint, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required

from extensions import db
from models import GroundCheck, GroundCheckRow

groundcheck_bp = Blueprint("groundcheck", __name__)

# ============================
# Helper
# ============================
def to_float(val):
    """Convert string ke float atau None kalau kosong."""
    if not val or val.strip() == "":
        return None
    try:
        return float(val)
    except ValueError:
        return None


# ============================
# Input Ground Check
# ============================
from datetime import datetime

from flask import Blueprint, flash, redirect, render_template, request, url_for
from flask_login import current_user, login_required

from extensions import db
from models import GroundCheck, GroundCheckRow

groundcheck_bp = Blueprint("groundcheck", __name__)

# ============================
# Helper
# ============================
def to_float(val):
    """Convert string ke float atau None kalau kosong."""
    if not val or val.strip() == "":
        return None
    try:
        return float(val)
    except ValueError:
        return None

# ============================
# Input Ground Check
# ============================
@groundcheck_bp.route("/llz/ground_check", methods=["GET", "POST"])
@login_required
def ground_check():
    # Definisikan data 90Hz dan 150Hz di sini
    # Ini memastikan variabel selalu tersedia saat halaman diakses dengan metode GET.
    data_90hz = [
        ("210.1", "35°"), ("173.2", "30°"), ("139.9", "25°"),
        ("109.2", "20°"), ("80.4", "15°"), ("52.9", "10°"),
        ("26.2", "5°"), ("9.7", "1.85°")
    ]
    data_150hz = [
        ("9.7", "1.85°"), ("26.2", "5°"), ("52.9", "10°"),
        ("80.4", "15°"), ("109.2", "20°"), ("139.9", "25°"),
        ("173.2", "30°"), ("210.1", "35°")
    ]
    
    if request.method == "POST":
        lokasi = request.form.get("lokasi")
        tanggal = datetime.strptime(request.form.get("tanggal"), "%Y-%m-%d")
        teknisi = ", ".join(request.form.getlist("teknisi[]"))
        catatan = request.form.get("catatan")
        manager_tujuan = request.form.get("manager_tujuan")
        
        gc = GroundCheck(
            lokasi=lokasi, 
            tanggal=tanggal, 
            teknisi=teknisi, 
            catatan=catatan, 
            manager_tujuan=manager_tujuan
        )
        db.session.add(gc)
        db.session.commit()

        # Looping untuk data 90 Hz
        for idx, (jarak, degree) in enumerate(data_90hz):
            row = GroundCheckRow(
                groundcheck_id=gc.id,
                freq='90 Hz',
                jarak=to_float(jarak),
                degree=degree,
                tx1_ddm_persen=to_float(request.form.get(f"hz90_{idx}_0")),
                tx1_ddm_ua=to_float(request.form.get(f"hz90_{idx}_1")),
                tx1_sum=to_float(request.form.get(f"hz90_{idx}_2")),
                tx1_mod90=to_float(request.form.get(f"hz90_{idx}_3")),
                tx1_mod150=to_float(request.form.get(f"hz90_{idx}_4")),
                tx1_rf=to_float(request.form.get(f"hz90_{idx}_5")),
                tx2_ddm_persen=to_float(request.form.get(f"hz90_{idx}_6")),
                tx2_ddm_ua=to_float(request.form.get(f"hz90_{idx}_7")),
                tx2_sum=to_float(request.form.get(f"hz90_{idx}_8")),
                tx2_mod90=to_float(request.form.get(f"hz90_{idx}_9")),
                tx2_mod150=to_float(request.form.get(f"hz90_{idx}_10")),
                tx2_rf=to_float(request.form.get(f"hz90_{idx}_11")),
            )
            db.session.add(row)

        # Baris "Center"
        center_row = GroundCheckRow(
            groundcheck_id=gc.id,
            freq='Center',
            jarak=0.0,
            degree='0°',
            tx1_ddm_persen=to_float(request.form.get("center_0")),
            tx1_ddm_ua=to_float(request.form.get("center_1")),
            tx1_sum=to_float(request.form.get("center_2")),
            tx1_mod90=to_float(request.form.get("center_3")),
            tx1_mod150=to_float(request.form.get("center_4")),
            tx1_rf=to_float(request.form.get("center_5")),
            tx2_ddm_persen=to_float(request.form.get("center_6")),
            tx2_ddm_ua=to_float(request.form.get("center_7")),
            tx2_sum=to_float(request.form.get("center_8")),
            tx2_mod90=to_float(request.form.get("center_9")),
            tx2_mod150=to_float(request.form.get("center_10")),
            tx2_rf=to_float(request.form.get("center_11")),
        )
        db.session.add(center_row)

        # Looping untuk data 150 Hz
        for idx, (jarak, degree) in enumerate(data_150hz):
            row = GroundCheckRow(
                groundcheck_id=gc.id,
                freq='150 Hz',
                jarak=to_float(jarak),
                degree=degree,
                tx1_ddm_persen=to_float(request.form.get(f"hz150_{idx}_0")),
                tx1_ddm_ua=to_float(request.form.get(f"hz150_{idx}_1")),
                tx1_sum=to_float(request.form.get(f"hz150_{idx}_2")),
                tx1_mod90=to_float(request.form.get(f"hz150_{idx}_3")),
                tx1_mod150=to_float(request.form.get(f"hz150_{idx}_4")),
                tx1_rf=to_float(request.form.get(f"hz150_{idx}_5")),
                tx2_ddm_persen=to_float(request.form.get(f"hz150_{idx}_6")),
                tx2_ddm_ua=to_float(request.form.get(f"hz150_{idx}_7")),
                tx2_sum=to_float(request.form.get(f"hz150_{idx}_8")),
                tx2_mod90=to_float(request.form.get(f"hz150_{idx}_9")),
                tx2_mod150=to_float(request.form.get(f"hz150_{idx}_10")),
                tx2_rf=to_float(request.form.get(f"hz150_{idx}_11")),
            )
            db.session.add(row)

        db.session.commit()
        flash("Data Ground Check berhasil disimpan!", "success")
        return redirect(url_for("groundcheck.detail_data", id=gc.id))

    # Jika method adalah GET, render template dengan data
    return render_template(
        "llz/ground_check.html",
        data_90hz=data_90hz,
        data_150hz=data_150hz,
    )
# ============================
# Lihat Semua Data
# ============================
@groundcheck_bp.route("/lihat_data")
@login_required
def lihat_data():
    # Manager Teknik X → hanya lihat data sesuai tujuan
    if current_user.role.lower().startswith("manager teknik"):
        ground_check = (
            GroundCheck.query
            .filter(GroundCheck.manager_tujuan.ilike(current_user.role))
            .order_by(GroundCheck.tanggal.desc())
            .all()
        )
    # Admin → lihat semua
    elif current_user.role.lower() == "admin":
        ground_check = (
            GroundCheck.query
            .order_by(GroundCheck.tanggal.desc())
            .all()
        )
    # Teknisi → lihat semua (tapi tidak bisa ACC)
    else:
        ground_check = (
            GroundCheck.query
            .order_by(GroundCheck.tanggal.desc())
            .all()
        )

    return render_template("llz/lihat_data.html", ground_check=ground_check)



def get_barcode_path(manager_tujuan):
    mapping = {
        "Manager Teknik 1": "static/barcode/m1.png",
        "Manager Teknik 2": "static/barcode/m2.png",
        "Manager Teknik 3": "static/barcode/m3.png",
        "Manager Teknik 4": "static/barcode/m4.png",
        "Manager Teknik 5": "static/barcode/m5.png",
    }
    return mapping.get(manager_tujuan.lower(), None)

# ACC Data 
@groundcheck_bp.route("/acc/<int:id>", methods=["POST"])
@login_required
def acc(id):
    record = GroundCheck.query.get_or_404(id)

    # Admin bisa ACC semua
    if current_user.role.lower() == "admin":
        allowed = True
    # Manager hanya bisa ACC jika sesuai tujuan
    elif current_user.role.lower() == record.manager_tujuan.lower():
        allowed = True
    else:
        allowed = False

    if not allowed:
        flash("Anda tidak punya izin untuk ACC data ini!", "danger")
        return redirect(url_for("groundcheck.cek_status"))

    # Update data
    record.status = "Selesai"
    record.manager = current_user.role

    # Tentukan path barcode
    barcode_path = get_barcode_path(record.manager_tujuan)
    if barcode_path:
        record.barcode_path = barcode_path
    else:
        record.barcode_path = None  # fallback

    # Simpan ke database
    db.session.add(record)
    db.session.commit()


    flash(f"Ground Check berhasil di-ACC oleh {current_user.role}", "success")
    return redirect(url_for("groundcheck.cek_status"))

# ============================
# Cek Status
# ============================
@groundcheck_bp.route("/llz/cek_status")
@login_required
def cek_status():
    records = (
        GroundCheck.query
        .order_by(GroundCheck.id.desc())  
        .all()
    )
    return render_template("llz/cek_status.html", ground_check=records)


# ============================
# update Ground Check
# ============================
# Fungsi helper untuk konversi angka
def to_float(value):
    try:
        return float(value) if value not in (None, "", "-") else None
    except ValueError:
        return None

@groundcheck_bp.route("/llz/update/<int:id>", methods=["GET", "POST"], endpoint="update")
@login_required
def update_ground_check(id):
    gc = GroundCheck.query.get_or_404(id)

    if request.method == "GET":
        rows = GroundCheckRow.query.filter_by(groundcheck_id=id).all()
        return render_template("llz/edit_ground_check.html", gc=gc, rows=rows)

    if request.method == "POST":
        try:
            # Update data utama
            gc.lokasi = request.form.get("lokasi")
            gc.tanggal = datetime.strptime(request.form.get("tanggal"), "%Y-%m-%d")

            # Ambil list teknisi dan gabung menjadi string
            teknisi_list = request.form.getlist("teknisi[]")
            gc.teknisi = ", ".join([t.strip() for t in teknisi_list if t.strip() != ""])

            gc.catatan = request.form.get("catatan")

            # Update data detail
            rows = GroundCheckRow.query.filter_by(groundcheck_id=gc.id).all()
            for row in rows:
                row.tx1_ddm_persen = to_float(request.form.get(f"tx1_ddm_persen_{row.id}"))
                row.tx1_ddm_ua = to_float(request.form.get(f"tx1_ddm_ua_{row.id}"))
                row.tx1_sum = to_float(request.form.get(f"tx1_sum_{row.id}"))
                row.tx1_mod90 = to_float(request.form.get(f"tx1_mod90_{row.id}"))
                row.tx1_mod150 = to_float(request.form.get(f"tx1_mod150_{row.id}"))
                row.tx1_rf = to_float(request.form.get(f"tx1_rf_{row.id}"))

                row.tx2_ddm_persen = to_float(request.form.get(f"tx2_ddm_persen_{row.id}"))
                row.tx2_ddm_ua = to_float(request.form.get(f"tx2_ddm_ua_{row.id}"))
                row.tx2_sum = to_float(request.form.get(f"tx2_sum_{row.id}"))
                row.tx2_mod90 = to_float(request.form.get(f"tx2_mod90_{row.id}"))
                row.tx2_mod150 = to_float(request.form.get(f"tx2_mod150_{row.id}"))
                row.tx2_rf = to_float(request.form.get(f"tx2_rf_{row.id}"))

            db.session.commit()
            flash("Data Ground Check berhasil diperbarui!", "success")
            return redirect(url_for("groundcheck.detail_data", id=gc.id))

        except Exception as e:
            db.session.rollback()
            flash(f"Terjadi kesalahan saat memperbarui data: {str(e)}", "danger")
            return redirect(url_for("groundcheck.update", id=id))

# ============================
# Delete Ground Check
# ============================
@groundcheck_bp.route("/llz/delete/<int:id>")
@login_required
def delete_ground_check(id):
    gc = GroundCheck.query.get_or_404(id)
    db.session.delete(gc)
    db.session.commit()
    flash("Data Ground Check dan semua detailnya berhasil dihapus!", "success")
    return redirect(url_for("groundcheck.lihat_data"))
 


# ============================
# Detail Ground Check
# ============================
@groundcheck_bp.route("/llz/detail/<int:id>")
@login_required
def detail_data(id):
    record = GroundCheck.query.get_or_404(id)
    rows = GroundCheckRow.query.filter_by(groundcheck_id=id).all()
    return render_template("llz/detail_data.html", record=record, rows=rows)


# ============================
# Cetak Ground Check
# ============================
@groundcheck_bp.route("/cetak/<int:id>")
@login_required
def cetak_gc(id):
    record = GroundCheck.query.get_or_404(id)
    rows = GroundCheckRow.query.filter_by(groundcheck_id=id).all()

    # Mapping manager -> file barcode PNG
    manager_barcode_map = {
        "Manager Teknik 1": "barcode/m1.png",
        "Manager Teknik 2": "barcode/m2.png",
        "Manager Teknik 3": "barcode/m3.png",
        "Manager Teknik 4": "barcode/m4.png",
        "Manager Teknik 5": "barcode/m5.png",
    }

    # Tentukan barcode_path sesuai manager_tujuan
    barcode_file = manager_barcode_map.get(record.manager_tujuan)

    # Jika ada barcode sesuai manager, simpan ke record
    if barcode_file:
        record.barcode_path = barcode_file
        db.session.commit()

    # Kirim data ke template
    return render_template("llz/cetak_gc.html", record=record, rows=rows)

