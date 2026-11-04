from flask import Flask, request
from rag import RetrievalAugmentedGeneration
from update import update
import threading

app = Flask(__name__)
threading.Thread(target=update).start()
labour_law = RetrievalAugmentedGeneration("labour_law")

@app.route("/labour_law", methods=["POST"])
def index():
    data = request.json
    return labour_law.run(data['message'])

app.run(host='0.0.0.0', port=5000, debug=False)