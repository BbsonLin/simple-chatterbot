import speech_recognition as sr

from flask import Flask, render_template, request
from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer

app = Flask(__name__)

chinese_bot = ChatBot("Chatterbot", storage_adapter="chatterbot.storage.SQLStorageAdapter")
chinese_bot.set_trainer(ChatterBotCorpusTrainer)
chinese_bot.train("chatterbot.corpus.chinese")


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/reply', methods=['GET'])
def reply():
    userText = request.args.get('msg')
    return str(chinese_bot.get_response(userText))


@app.route("/listen", methods=['POST'])
def listen():
    for f in request.files.getlist("blob"):
        f.save('./{}'.format(f.filename))

    r = sr.Recognizer()
    with sr.AudioFile('./listen.wav') as source:
        audio = r.record(source)

    return r.recognize_google(audio, language="zh-CN")


if __name__ == '__main__':
    app.run()
