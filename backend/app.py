from flask import Flask, jsonify, request
import cx_Oracle

app = Flask(__name__)

# هون عدلي لتفاصيل الاوراكل عندك
dsn_tns = cx_Oracle.makedsn('hostname', 'port', service_name='service_name')

conn = cx_Oracle.connect(user='username', password='password', dsn=dsn_tns)


@app.route('/tests', methods=['GET'])
def get_tests():
    cursor = conn.cursor()
    cursor.execute('SELECT * FROM tests')
    rows = cursor.fetchall()
    tests = [{'test_id': row[0], 'lesson_id': row[1], 'test_name': row[2]}
             for row in rows]
    return jsonify(tests)


@app.route('/questions', methods=['GET'])
def get_questions():
    test_id = request.args.get('test_id')
    cursor = conn.cursor()
    cursor.execute(
        'SELECT * FROM questions WHERE test_id = :test_id ORDER BY state ASC', [test_id])
    rows = cursor.fetchall()
    questions = [{'question_id': row[0], 'question_text': row[2], 'choices': [
        row[3], row[4], row[5], row[6]], 'correct_choice': row[7], 'state': row[8]} for row in rows]
    return jsonify(questions)


if __name__ == '__main__':
    app.run(debug=True)
