from flask import Flask, send_file
import os
import hashlib
import random
import string

app = Flask(__name__)
DATA_DIR = '/serverdata'

@app.route('/file', methods=['GET'])
def get_file():
    file_path = os.path.join(DATA_DIR, 'data.txt')
    checksum = hashlib.md5(open(file_path, 'rb').read()).hexdigest()
    return {
        'file': send_file(file_path),
        'checksum': checksum
    }

if __name__ == '__main__':
    # Create a 1KB file with random data
    file_path = os.path.join(DATA_DIR, 'data.txt')
    with open(file_path, 'wb') as f:
        f.write(''.join(random.choices(string.ascii_letters + string.digits, k=1024)).encode())
    
    app.run(host='0.0.0.0', port=5000)
