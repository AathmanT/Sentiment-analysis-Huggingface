from flask import Flask, request, jsonify
from transformers import AutoTokenizer, AutoModelForSequenceClassification

app = Flask(__name__)
tokenizer = AutoTokenizer.from_pretrained("prajjwal1/bert-tiny")
model = AutoModelForSequenceClassification.from_pretrained("prajjwal1/bert-tiny")


@app.route('/', methods=['POST'])
def analyze_sentiment():
    input_text = request.json['text']
    inputs = tokenizer(input_text, return_tensors='pt')
    outputs = model(**inputs)
    logits = outputs.logits.detach().numpy()[0]
    positive_score = logits[1]
    negative_score = logits[0]
    label = "POSITIVE" if positive_score > negative_score else "NEGATIVE"
    return jsonify({'label': label})


if __name__ == '__main__':
    app.run(debug=True)
