from dbConfig import *
from datetime import date
import sys
import os
import uuid

@app.route('/show_data_log_login/<username>', methods=['GET'])
@connect_sql()
def show_data_log_login(cursor,username):
    try:
        sql= "SELECT * from login,user where login.username like %s and login.username = user.username "
        cursor.execute(sql,username)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result)
    except Exception as e:
            return (str(e)),400

@app.route('/show_report_member', methods=['GET'])
@connect_sql()
def show_report_member(cursor):
    try:
        sql= "SELECT * from user"
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result)
    except Exception as e:
            return (str(e)),400

@app.route('/group_by_buys', methods=['GET'])
@connect_sql()
def group_by_buys(cursor):
    try:
        sql= "SELECT COUNT(sell_id), sell_id FROM buys GROUP BY sell_id"
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result)
    except Exception as e:
            return (str(e)),400

@app.route('/Cut_stock_buys', methods=['POST'])
@connect_sql()
def Cut_stock_buys(cursor):
    try:
        data = request.json
        sql =""" SELECT DATE_FORMAT(buys_expired_date,"%Y") as Y , buys_id as buys_id , sell_id as sell_id , number_buy as number_buy FROM buys where buys_status = 'R'"""
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result_year_buys_end = toJson(cursor.fetchall(), columns)

        sql_mouth_buys ="""SELECT DATE_FORMAT(buys_expired_date,"%m") as M FROM buys where buys_status = 'R'"""
        cursor.execute(sql_mouth_buys)
        columns = [column[0] for column in cursor.description]
        result_mouth_buys_end = toJson(cursor.fetchall(), columns)

        sql_day_buys ="""SELECT DATE_FORMAT(buys_expired_date,"%d") as D FROM buys where buys_status = 'R'"""
        cursor.execute(sql_day_buys)
        columns = [column[0] for column in cursor.description]
        result_day_buys_end = toJson(cursor.fetchall(), columns)
        status = "555"
        ytext = data["year"]#จากหน้าบ้าน ตึ๋งเองจ้า
        mtext = data["mouth"]#จากหน้าบ้าน ตึ๋งเองจ้า
        dtext = data["day"]#จากหน้าบ้าน ตึ๋งเองจ้า
        year = str(ytext)
        mouth = str(mtext)
        day = str(dtext)
        for index,val in enumerate(result_year_buys_end):
            data_year_buys_end = str(result_year_buys_end[index]["Y"])
            data_mouth_buys_end = str(result_mouth_buys_end[index]["M"])
            data_day_buys_end = str(result_day_buys_end[index]["D"])
            b_id = str(result_year_buys_end[index]["buys_id"])
            s_id = str(result_year_buys_end[index]["sell_id"])
            nb_b = str(result_year_buys_end[index]["number_buy"])
            if year >= data_year_buys_end:
                if year > data_year_buys_end:
                    status= " year DEL "
                    cut_stock(b_id,s_id,nb_b)
                elif mouth >= data_mouth_buys_end:
                    if mouth > data_mouth_buys_end:
                        status= " mouth DEL "
                        cut_stock(b_id,s_id,nb_b)
                    elif day > data_day_buys_end:
                        status= " day DEL "
                        cut_stock(b_id,s_id,nb_b)
                elif mouth < data_mouth_buys_end:
                        status = " NO DEL"
                elif day > data_day_buys_end :
                    if mouth > data_mouth_buys_end:
                        status= " day DEL "
                        cut_stock(b_id,s_id,nb_b)
                elif day < data_day_buys_end :
                        status = " NO DEL"
            else:
                status = " NO DEL"
            print(status)
        return jsonify(result_year_buys_end)
    except Exception as e:
        return (str(e)),400

@app.route('/sql_cut_stock/<buys_id>/<sell_id>/<number_buy>', methods=['GET'])
@connect_sql()
def cut_stock(cursor,buys_id,sell_id,number_buy):
    try:
        sql=""" select sell_number from sell where sell_id = %s"""
        cursor.execute(sql,sell_id)
        result = cursor.fetchone()
        number_new_sell = int(result[0])  + int(number_buy)
        sql_up_sell="""update sell set sell_number = %s where sell_id = %s """
        cursor.execute(sql_up_sell,(number_new_sell,sell_id))
        sql_delete_buy = """ delete from buys where buys_id =%s"""
        cursor.execute(sql_delete_buy,buys_id)
        return jsonify(result[0])
    except Exception as e:
        return jsonify(str(e))
@app.route('/store/<path:filename>', methods=['GET', 'POST'])
def download(filename):
    return send_from_directory(directory='../src/user_image/', filename=filename)

@app.route('/api/uploadimage', methods=['POST'])
@connect_sql()
def upload_file(cursor):
    # check if the post request has the file part
    if 'file' not in request.files:
        # flash('No file part')
        print('No file part')
        return 'No file part'
    file = request.files['file']
    username = request.form['username']
    location_parameters = request.form['location_parameters']
    print(username)
    # if user does not select file, browser also
    # submit an empty part without filename
    if file.filename == '':
        # flash('No selected file')
        print('No selected file')
        return 'No selected file'
    if file and allowed_file(file.filename):
        path = " "
        if location_parameters=='Insert_user':
            path = "../src/user_image/"
        elif location_parameters=='Edit_user':
            path = "../src/user_image/"
        elif location_parameters=='Insert_cat':
            path = "../src/img_icon/"
        elif location_parameters=='Edit_cat':
            path = "../src/img_icon/"
        elif location_parameters=='Insert_sell':
            path = "../src/img_sell/"
        elif location_parameters=='Edit_sell':
            path = "../src/img_sell/"
        filename = secure_filename(file.filename)
        print(filename)
        fileExt = filename.split('.')[1]
        autoGenFileName = uuid.uuid4()
        newFileName = str(autoGenFileName) + '.' + fileExt

        if not os.path.isdir(path):
            os.mkdir(path)
        file.save(os.path.join(path, newFileName))
        created = datetime.utcnow()
        sql = ""
        if  location_parameters=='Insert_user':
            sql = """
            update user set user_image = %s where username = %s """
            cursor.execute(sql, (newFileName, username))
        elif location_parameters=='Edit_user':
            sql = """
            update user set user_image = %s where username = %s """
            cursor.execute(sql, (newFileName, username))
        elif location_parameters =='Insert_cat':
            sql = """
            update category set cat_icon = %s where cat_name = %s """
            cursor.execute(sql, (newFileName, username)) #username ก็ คือ cat_name ที่  Manage_cat สร้างไว้ function onUpload
        elif location_parameters =='Edit_cat':
            cat_id = request.form['cat_id']
            sql = """
            update category set cat_name = %s , cat_icon = %s where cat_id = %s """
            cursor.execute(sql, (username,newFileName,cat_id)) #username ก็ คือ cat_name ที่  Manage_cat สร้างไว้ function onUpload
            # print(username)
            # print(newFileName)
            # print(cat_id)
        elif location_parameters =='Insert_sell':
            sql_count_bill = "SELECT MAX(sell_id)  FROM sell"
            cursor.execute(sql_count_bill)
            pk = cursor.fetchone()
            sql = """
            update sell set sell_image = %s where sell_id = %s """
            cursor.execute(sql, (newFileName,pk))
        elif location_parameters =='Edit_sell':
            sell_id = request.form['sell_id']
            sql = """
            update sell set sell_image = %s where sell_id = %s """
            cursor.execute(sql, (newFileName,sell_id))
        print("Success")
        return jsonify("Success"),200

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
@app.route('/show_user_buys_status', methods=['POST'])
@connect_sql()
def show_user_buys_status(cursor):
    try:
        data = request.json
        sql_count_bill = "SELECT MAX(bill_id)  FROM buys where username = %s"
        cursor.execute(sql_count_bill,(data['user']))
        re = cursor.fetchone()
        sql="select * from buys,sell,user where buys.bill_id = %s and buys.buys_status = %s and buys.sell_id = sell.sell_id and sell.username = user.username"
        cursor.execute(sql,(re[0],'B'))
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/Alert_sell_user', methods=['POST'])
@connect_sql()
def Alert_sell_user(cursor):
    try:
        data = request.json
        sql="""select * from buys,sell,user where (buys.buys_status = %s and
         buys.sell_id = sell.sell_id and
         buys.username = user.username) and sell.username = %s"""
        cursor.execute(sql,('B',data['username']))
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/show_user_buys/<username>', methods=['GET'])
@connect_sql()
def show_user_buys(cursor,username):
    try:
        sql="select * from buys,sell where buys.username = %s and buys.buys_status = %s and buys.sell_id = sell.sell_id"
        cursor.execute(sql,(username,'R'))
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/cart', methods=['POST'])
@connect_sql()
def cart(cursor):
    try:
        data = request.json
        # sql_count = "SELECT COUNT(bill_id)  FROM `buys` WHERE `buys_status` = 'B'"
        # cursor.execute(sql_count)
        # result_count = cursor.fetchone()

        sql_get_number="select * from sell where sell_id = %s"
        cursor.execute(sql_get_number,data['sell_id'])
        re = cursor.fetchone()
        total_number = int(re[9])  - int(data['number_buy'])
        sql_update_sell_number="""update sell set  sell_number = %s where sell_id = %s"""
        cursor.execute(sql_update_sell_number,(total_number,data['sell_id']))
        check_user_up_in = """ select count(buys_id)  from buys where sell_id = %s and username = %s and buys_status = %s """
        cursor.execute(check_user_up_in,(data['sell_id'],data['username'],'R'))
        res = cursor.fetchone()
        if res[0]==0:
            sql_in_buy="""insert into buys (sell_id , username , number_buy , buys_expired_date) VALUES (%s,%s,%s,%s)"""
            cursor.execute(sql_in_buy,(data['sell_id'],data['username'],data['number_buy'],data['buys_expired_date']))
            get_date  = "SELECT DATE_ADD(buys_expired_date, INTERVAL +7 HOUR) FROM buys  where sell_id = %s and username=%s and buys_status = %s "
            cursor.execute(get_date,(data['sell_id'],data['username'],'R'))
            result = cursor.fetchone()
            update_sql_buys = """ update buys set buys_expired_date = %s where sell_id = %s and username = %s and buys_status = %s """
            cursor.execute(update_sql_buys,(result,data['sell_id'],data['username'],'R'))
            return jsonify('insert'),200
        else:
            sql_query_buys = """ select * from buys where buys.sell_id = %s and buys.username = %s and buys.buys_status = %s """
            cursor.execute(sql_query_buys,(data['sell_id'],data['username'],'R'))
            re_query_buys = cursor.fetchone()
            nb = int(re_query_buys[5]) + int(data['number_buy'])
            sql_up_buy="""update buys set number_buy = %s , buys_expired_date = %s where sell_id = %s and username = %s and buys_status = %s """
            cursor.execute(sql_up_buy,(nb,data['buys_expired_date'],data['sell_id'],data['username'],'R'))
            get_date  = "SELECT DATE_ADD(buys_expired_date, INTERVAL +7 HOUR) FROM buys  where sell_id = %s and username=%s and buys_status = %s "
            cursor.execute(get_date,(data['sell_id'],data['username'],'R'))
            result = cursor.fetchone()
            update_sql_buys = """ update buys set buys_expired_date = %s where sell_id = %s and username = %s and buys_status = %s """
            cursor.execute(update_sql_buys,(result,data['sell_id'],data['username'],'R'))
            return jsonify('update',data['buys_expired_date']),200
            print(type(data))
        return jsonify('จองสำเร็จ'),200
    except Exception as e:
        return jsonify(str(e)),400

@app.route('/count_buy/<username>', methods=['GET'])
@connect_sql()
def count_buy(cursor,username):
    try:
        sql="select count(buys_id) as count_buy_id from buys where username = %s and buys_status = %s"
        cursor.execute(sql,(username,'R'))
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/update_sell_and_buys_plus', methods=['POST'])
@connect_sql()
def update_sell_and_buys_plus(cursor):
    try:
        data = request.json
        sql_get_number="select * from sell where sell_id = %s"
        cursor.execute(sql_get_number,data['sell_id'])
        re = cursor.fetchone()
        number_new_sell=0
        number_new_buys_user=0
        sql_get_number_buys="select * from buys where sell_id = %s and username = %s and buys_status = %s"
        cursor.execute(sql_get_number_buys,(data['sell_id'],data['username'],'R'))
        re_buys = cursor.fetchone()
        if data['event_status']=='plus':
            number_new_sell = int(re[9])-1
            number_new_buys_user = re_buys[5]+1
        elif data['event_status']=='del':
            number_new_sell = int(re[9])+1
            number_new_buys_user = re_buys[5]-1
        update_sql_buys_date = """ update buys set buys_expired_date = %s where sell_id = %s and username = %s and buys_status = %s """
        cursor.execute(update_sql_buys_date,(data['buys_expired_date'],data['sell_id'],data['username'],'R'))
        get_date  = "SELECT DATE_ADD(buys_expired_date, INTERVAL +7 HOUR) FROM buys  where sell_id = %s and username=%s and buys_status = %s "
        cursor.execute(get_date,(data['sell_id'],data['username'],'R'))
        result_buys_expired_date = cursor.fetchone()
        sql_up_buy="""update buys set number_buy = %s , buys_expired_date = %s where sell_id = %s and username = %s and buys_status = %s """
        cursor.execute(sql_up_buy,(number_new_buys_user,result_buys_expired_date,data['sell_id'],data['username'],'R'))
        sql_up_sell="""update sell set sell_number = %s where sell_id = %s """
        cursor.execute(sql_up_sell,(number_new_sell,data['sell_id']))
        sql_select = """ select sell_number from sell where sell_id = %s """
        cursor.execute(sql_select,data['sell_id'])
        result = cursor.fetchone()
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/get_data_sell_of_groups/<id>', methods=['GET'])
@connect_sql()
def get_data_sell_of_groups(cursor,id):
    try:
        sql="select * from sell,user where (sell.sell_number > 0) and groups_id = %s and user.username = sell.username"
        cursor.execute(sql,id)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/get_max_sell_of_buys/<id>', methods=['GET'])
@connect_sql()
def get_max_sell_of_buys(cursor,id):
    try:
        sql_select = "select sell_id from buys where sell_id = %s"
        cursor.execute(sql_select,id)
        result = cursor.fetchone()
        if result is not None:
            sql="select sell_id as sell_id ,sum(number_buy) as s_b from buys  where buys_status = %s and  buys.sell_id =%s GROUP BY buys.sell_id"
            cursor.execute(sql,('B',id))
            columns = [column[0] for column in cursor.description]
            result_sql = toJson(cursor.fetchall(), columns)
            print(result_sql[0]["s_b"])
            max = int(result_sql[0]["s_b"])
            return jsonify(max),200
        else:
            return jsonify("0"),200
    except Exception as e:
        return ("0"),200

@app.route('/get_name_groups/<id>', methods=['GET'])
@connect_sql()
def get_name_groups(cursor,id):
    try:
        sql="select * from groups where cat_id = %s "
        cursor.execute(sql,id)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/get_sell_and_groups', methods=['GET'])
@connect_sql()
def get_sell_and_groups(cursor):
    try:
        sql="select * from groups,sell,user where (sell_number >=1 ) and sell.groups_id =groups.groups_id and user.username = sell.username "
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/Search_sell/<search_name>', methods=['GET'])
@connect_sql()
def Search_sell(cursor,search_name):
    try:
        sql="select * from category,groups,sell,user where (sell_number >=1 )and sell.sell_name LIKE %s and groups.cat_id = category.cat_id and sell.groups_id =groups.groups_id and user.username = sell.username "
        cursor.execute(sql,search_name)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/getdata_sell/<id>', methods=['GET'])
@connect_sql()
def getdata_sell(cursor,id):
    try:
        sql="select * from category,groups,sell,user where (sell_number >=1 )and category.cat_id = %s and groups.cat_id = category.cat_id and sell.groups_id =groups.groups_id and user.username = sell.username "
        cursor.execute(sql,id)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/get_image_database', methods=['GET'])
@connect_sql()
def getdata_image(cursor):
    try:
        sql="select * from image"
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/get_category', methods=['GET'])
@connect_sql()
def get_category(cursor):
    try:
        sql="select * from category"
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result),200
    except Exception as e:
        return (str(e)),400

@app.route('/Buys', methods=['POST'])
@connect_sql()
def update_Buys(cursor):
    try:
        data = request.json
        sql_count_bill = "SELECT MAX(bill_id)  FROM buys"
        cursor.execute(sql_count_bill)
        re = cursor.fetchone()
        bill_id= int(re[0])+1
        sql="""update buys set  bill_id = %s , buys_status = %s , buys_address = %s where username = %s and buys_status = %s """
        cursor.execute(sql,(bill_id,'B',data['address'],data['username'],'R'))
        return jsonify("success"),200
    except Exception as e:
        return jsonify(str(e)),400

@app.route('/update_data', methods=['POST'])
@connect_sql()
def update_data(cursor):
    try:
        data = request.json
        sql="""update user set  username = %s , password = %s , fname = %s, lname=%s,status=%s, phone=%s , user_image=%s , user_address = %s where user_id = %s"""
        cursor.execute(sql,(data['username'],data['password'],data['fname'],data['lname'],data['status'],data['phone'],data['image'],data['user_address'],data['user_id']))
        print(type(data))
        return jsonify("แก้ไขสำเร็จ")
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/update_data_buys', methods=['POST'])
@connect_sql()
def update_data_buys(cursor):
    try:
        data = request.json
        sql="""update buys set number_buy = %s , buys_status = %s , buys_expired_date = %s where buys_id = %s"""
        cursor.execute(sql,(data['number_buy'],data['buys_status'],data['date'],data['buys_id']))
        get_date  = "SELECT DATE_ADD(buys_expired_date, INTERVAL +7 HOUR) FROM buys  where  buys_id = %s "
        cursor.execute(get_date,data['buys_id'])
        result_buys_expired_date = cursor.fetchone()
        sql="""update buys set buys_expired_date = %s where buys_id = %s"""
        cursor.execute(sql,(result_buys_expired_date,data['buys_id']))
        print(type(data))
        return jsonify("แก้ไขสำเร็จ")
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/update_data_sell', methods=['POST'])
@connect_sql()
def update_data_sell(cursor):
    try:
        data = request.json
        sql="""update sell set  username = %s , groups_id = %s , sell_name = %s, sell_image=%s,sell_address=%s, sell_price=%s , date_start = %s , description=%s , sell_number=%s  where sell_id = %s"""
        cursor.execute(sql,(data['username'],data['groups_id'],data['sell_name'],data['sell_image'],data['sell_address'],data['sell_price'],data['date'],data['description'],data['sell_number'],data['sell_id']))
        print(type(data))
        return jsonify("แก้ไขสำเร็จ")
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/update_data_cat', methods=['POST'])
@connect_sql()
def update_data_cat(cursor):
    try:
        data = request.json
        sql="""update  category set  cat_name = %s , cat_icon = %s where cat_id = %s"""
        cursor.execute(sql,(data['cat_name'],data['cat_icon'],data['cat_id']))
        print(type(data))
        return jsonify("แก้ไขสำเร็จ"),200
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/update_data_groups', methods=['POST'])
@connect_sql()
def update_data_groups(cursor):
    try:
        data = request.json
        sql="""update  groups set  groups_name = %s , cat_id = %s where groups_id = %s"""
        cursor.execute(sql,(data['groups_name'],data['cat_id'],data['groups_id']))
        print(type(data))
        return jsonify("แก้ไขสำเร็จ")
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/add_data', methods=['POST'])
@connect_sql()
def insert_data(cursor):
    try:
        data = request.json
        sql = "SELECT COUNT(username)  FROM `user` WHERE `username` LIKE %s"
        cursor.execute(sql, data['username'])
        re = cursor.fetchone()
        status=0
        if re[0]==0:
            sql="""INSERT INTO user (username, password, fname, lname, status, phone, user_image,user_address) VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"""
            cursor.execute(sql,(data['username'],data['password'],data['fname'],data['lname'],data['status'],data['phone'],data['image'],data['user_address']))
            status=200
            return jsonify(status)
        else:
            status=150
            return jsonify(status)
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/add_data_sell', methods=['POST'])
@connect_sql()
def add_data_sell(cursor):
    try:
        data = request.json
        sql="""INSERT INTO sell (username, groups_id, sell_name, sell_image, sell_address, sell_price, description, sell_number)  VALUES (%s,%s,%s,%s,%s,%s,%s,%s)"""
        cursor.execute(sql,(data['username'],data['groups_id'],data['sell_name'],data['sell_image'],data['sell_address'],data['sell_price'],data['description'],data['sell_number']))
        status=200
        return jsonify(status)
    except Exception as e:
        return jsonify(str(e)),400

@app.route('/add_data_cat', methods=['POST'])
@connect_sql()
def insert_cat(cursor):
    try:
        data = request.json
        sql = "SELECT COUNT(cat_name)  FROM category  WHERE cat_name = %s"
        cursor.execute(sql, data['cat_name'])
        re = cursor.fetchone()
        status=0
        if re[0]==0:
            sql="""INSERT INTO category (cat_name, cat_icon ) VALUES (%s,%s)"""
            cursor.execute(sql,(data['cat_name'],data['cat_icon']))
            status=200
            return jsonify(status)
        else:
            status=150
            return jsonify(status)
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/add_data_groups', methods=['POST'])
@connect_sql()
def insert_groups(cursor):
    try:
        data = request.json
        sql = "SELECT COUNT(groups_name)  FROM groups  WHERE groups_name = %s and cat_id = %s"
        cursor.execute(sql,(data['groups_name'],data['cat_id']))
        re = cursor.fetchone()
        status=0
        if re[0]==0:
            sql="""INSERT INTO  groups (groups_name,cat_id) VALUES (%s,%s)"""
            cursor.execute(sql,(data['groups_name'],data['cat_id']))
            status=200
            return jsonify(status)
        else:
            status=150
            return jsonify(status)
    except Exception as e:
        return jsonify("ERROR"),400

@app.route('/test', methods=['GET'])
@connect_sql()
def test_sql(cursor):
    sql = """SELECT * FROM user"""
    cursor.execute(sql)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify(result)

@app.route('/show_data_cat', methods=['GET'])
@connect_sql()
def show_data_cat(cursor):
    sql = """SELECT * FROM category"""
    cursor.execute(sql)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify(result)

@app.route('/show_data_buys', methods=['GET'])
@connect_sql()
def show_data_buys(cursor):
    sql = """SELECT * FROM buys,sell,user,groups,category where buys.sell_id = sell.sell_id and buys.username = user.username and sell.groups_id = groups.groups_id and groups.cat_id = category.cat_id"""
    cursor.execute(sql)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify(result)

@app.route('/show_data_buys_from_status/<id>', methods=['GET'])
@connect_sql()
def show_data_buys_from_status(cursor,id):
    sql = """SELECT * FROM buys,sell,user where (buys.sell_id = sell.sell_id and buys.username = user.username) and buys.buys_status Like %s """
    cursor.execute(sql,id)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify(result)

@app.route('/show_data_sell', methods=['POST'])
@connect_sql()
def show_data_sell(cursor):
    data = request.json
    if data['status']=='A':
        if data['patch']=='Report_sell':
            sql = """SELECT * FROM sell,user,groups,category where sell.username = user.username and sell.groups_id = groups.groups_id and groups.cat_id = category.cat_id and category.cat_id like %s """
            cursor.execute(sql,data['para'])
            columns = [column[0] for column in cursor.description]
            result = toJson(cursor.fetchall(), columns)
            return jsonify(result)
        else:
            sql = """SELECT * FROM sell,user,groups,category where sell.username = user.username and sell.groups_id = groups.groups_id and groups.cat_id = category.cat_id"""
            cursor.execute(sql)
            columns = [column[0] for column in cursor.description]
            result = toJson(cursor.fetchall(), columns)
            return jsonify(result)
    else:
        sql = """SELECT * FROM sell,user,groups where user.username = %s and sell.username = user.username and sell.groups_id = groups.groups_id"""
        cursor.execute(sql,data['username'])
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify(result)

@app.route('/show_data_groups', methods=['GET'])
@connect_sql()
def show_data_groups(cursor):
    sql = """SELECT * FROM groups,category where   groups.cat_id = category.cat_id"""
    cursor.execute(sql)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify(result)

@app.route('/show_data_groups_cat/<cat_id>', methods=['GET'])
@connect_sql()
def show_data_groups_cat(cursor,cat_id):
    sql = """SELECT * FROM groups,category where category.cat_id = %s and groups.cat_id = category.cat_id"""
    cursor.execute(sql,cat_id)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify(result)

@app.route('/login/<user>/<passwd>', methods=['GET'])
@connect_sql()
def check_login(cursor,user,passwd):
    try:
        sql = """SELECT * FROM user where username = %s and password = %s """
        cursor.execute(sql,(user,passwd))
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        if result is not None:#ถ้าไม่ใช่ NONE ให้ทำ if
            sql_insrt_login = """ insert into login (username, status_login) VALUES(%s,%s)"""
            cursor.execute(sql_insrt_login,(user,'Y'))
            return jsonify(result),200

    except Exception as e:
        return jsonify("NO_DATA"),200

@app.route('/logout/<user>', methods=['GET'])
@connect_sql()
def logout(cursor,user):
    try:
        sql_insrt_logout = """ insert into login (username, status_login) VALUES(%s,%s)"""
        cursor.execute(sql_insrt_logout,(user,'N'))
        return jsonify("success"),200
    except Exception as e:
        return (str(e)),400

# @app.route('/test/<id>', methods=['GET'])
# @connect_sql()
# def t_s(cursor,id):
#     sql = """SELECT * FROM user where user_id = '%s'"""
#     cursor.execute(sql,id)
#     columns = [column[0] for column in cursor.description]
#     result = toJson(cursor.fetchall(), columns)
#     return jsonify(result)

@app.route('/delete_user/<id>', methods=['GET'])
@connect_sql()
def delete_sql(cursor,id):
    try:
        sql = """delete from user where user_id = %s """
        cursor.execute(sql,id)
        return jsonify('ลบสำเร็จ')
    except Exception as e:
        return jsonify(str(e))

@app.route('/delete_buys/<id>/<number>/<sell_id>', methods=['GET'])
@connect_sql()
def delete_buys(cursor,id,number,sell_id):
    try:
        sql_select = "select sell_number from  sell where sell_id = %s"
        cursor.execute(sql_select,sell_id)
        result_select = cursor.fetchone()
        number_sell = result_select[0]+int(number)
        sql = """delete from buys where buys_id = %s """
        cursor.execute(sql,id)
        sql_return_number = "update sell set sell_number = %s where sell_id = %s"
        cursor.execute(sql_return_number,(number_sell,sell_id))
        return jsonify("ลบสำเร็จ")
    except Exception as e:
        return jsonify(str(e))

@app.route('/delete_groups/<id>', methods=['GET'])
@connect_sql()
def delete_groups_sql(cursor,id):
    try:
        sql = """delete from groups where groups_id = %s """
        cursor.execute(sql,id)
        return jsonify('ลบสำเร็จ')
    except Exception as e:
        return jsonify(str(e))

@app.route('/delete_sell/<id>', methods=['GET'])
@connect_sql()
def delete_sell_sql(cursor,id):
    try:
        sql = """delete from sell where sell_id = %s """
        cursor.execute(sql,id)
        return jsonify('ลบสำเร็จ')
    except Exception as e:
        return jsonify(str(e))

@app.route('/delete_cat/<id>', methods=['GET'])
@connect_sql()
def delete_category(cursor,id):
    try:
        sql = """delete from category where cat_id = %s """
        cursor.execute(sql,id)
        return jsonify('ลบสำเร็จ')
    except Exception as e:
        return jsonify(str(e))

@app.route('/getproductimage/<product_id>', methods=['GET'])
@connect_sql()
def getproductimagebyid(cursor, product_id):
    data = request.json
    sql = "SELECT * FROM `products` WHERE `product_id` = %s"
    cursor.execute(sql,product_id)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    return jsonify({"product": result})

@app.route('/getproduct/<product_id>', methods=['GET'])
@connect_sql()
def getproductbyid(cursor,product_id):
    sql = "SELECT * FROM `products` WHERE `product_id` = %s"
    cursor.execute(sql,product_id)
    columns = [column[0] for column in cursor.description]
    result = toJson(cursor.fetchall(), columns)
    # print(result)
    for i in result:
        categoryList = []
        sql1 = "SELECT * FROM `category` WHERE category_id=%s"
        cursor.execute(sql1, (i["category_id"]))
        columns = [column[0] for column in cursor.description]
        resulProduct = toJson(cursor.fetchall(), columns)
        for i1 in resulProduct:
            categoryList.append(i1)
            i["category"] = categoryList
            i.pop('category_id', None)

    for i in result:
        image_productsList = []
        sql1 = "SELECT image_url FROM `image_products` WHERE `product_id` = %s"
        cursor.execute(sql1, (i["product_id"]))
        columns = [column[0] for column in cursor.description]
        resulProduct = toJson(cursor.fetchall(), columns)
        for i1 in resulProduct:
            image_productsList.append(i1)
            i["image_products"] = image_productsList

    return jsonify({"product": result})

@app.route('/category', methods=['GET', 'POST', 'DELETE', 'PATCH'])
@connect_sql()
def category(cursor):
    if request.method == 'GET':
        sql = "SELECT * FROM category"
        cursor.execute(sql)
        columns = [column[0] for column in cursor.description]
        result = toJson(cursor.fetchall(), columns)
        return jsonify({'category': result})


@app.route('/register', methods=['POST'])
@connect_sql()
def register(cursor):

    try:
        data = request.json
        ret = {}
        sql = "SELECT COUNT(email)  FROM `user` WHERE `email` LIKE %s"
        cursor.execute(sql, data['email'])
        regis_email = cursor.fetchone()
        status = 0
        msg = ''
        if(regis_email[0] == 0):
            created = datetime.utcnow()
            position = 'member'
            sql = """INSERT INTO `user` (`fname`, `lname`, `email`, `password`, `created_date`, `position`) VALUES (%s, %s, %s, %s, %s,%s)"""
            cursor.execute(
                sql, (data['fname'], data['lname'], data['email'], data['password'], created, position))
            ret = {"msg": {"title": 'สมัครสามาชิกสำเร็จ',"status": 'success', 'show': True}}
            status = 200
        else:
            ret = {"msg": {"title": 'email นี้มีผู้ใช้งานแล้ว',
                            "status": 'error', 'show': True}}
            status = 401
        return jsonify(ret), status
    except:
        return jsonify({'register': 'fail'})

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', threaded=True, port=5000)
