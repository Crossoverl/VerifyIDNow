"""  f1f2.py 
#############################################################
#title - compare face 1 photo to face 2 photo     
#version 1 02/20/2021 start from recognize_face.py              
#        2 uses 128 measurements OpenFace pre-trained neural net
#          based on Google FaceNet research
#Github reference - https://github.com/ageitgey/face_recognition
#/blob/master/examples/facerec_from_webcam_faster.py
#https://pypi.org/project/face-recognition/
#windows command line execution--  
#  cd C:\FR
#  python f1f2.py
#
#  ctl c to end
# 
#construction-- Tom Hill
#  
#objective -- compare self jpg to DL jpg, print true false result
#             face photo to drivers license face photo
#
#output-- match= [True] or match= [False]
#
#############################################################              
"""
#############################################################
# imports 
#############################################################
import face_recognition
from flask.wrappers import Response
import numpy as np
from flask import Flask, app, jsonify, request
import json
import base64
import os

response = ''

app = Flask(__name__)

@app.route('/', methods = ['GET', 'POST'])
def nameRoute():

    global response

    if (request.method == 'POST'):
        request_data = request.data
        request_data = json.loads(request_data.decode('utf-8'))
        selfie = request_data['selfie']
        dlPhoto = request_data['dl']
        response = verify(selfie, dlPhoto)
        os.remove('selfie.jpg')
        os.remove('dl.jpg')
        return jsonify({'result' : response})
    else:
        return jsonify({'result' : "test"})

# #############################################################
# # Takes two photos and returns whether they are a match
# #############################################################
def verify(selfieBase64, dlBase64):

    # Load self photo
    selfie_64_decode = base64.b64decode(selfieBase64) 
    selfie_result = open('selfie.jpg', 'wb') # create a writable image and write the decoding result
    selfie_result.write(selfie_64_decode)
    self_image = face_recognition.load_image_file("selfie.jpg")

    #print how many faces were recognized
    print("selfie: " + str(len(face_recognition.face_encodings(self_image))))

    if (len(face_recognition.face_encodings(self_image)) == 0):
        return "Could not detect face in selfie"

    # Load ID photo
    dl_64_decode = base64.b64decode(dlBase64) 
    dl_result = open('dl.jpg', 'wb') # create a writable image and write the decoding result
    dl_result.write(dl_64_decode)
    DL_image = face_recognition.load_image_file("dl.jpg")

    #print how many faces were recognized
    print("DL: " + str(len(face_recognition.face_encodings(DL_image))))

    if (len(face_recognition.face_encodings(DL_image)) == 0):
        return "Could not detect face in ID photo"
    
    # Get the first face recognized in selfie
    self_face_encoding = face_recognition.face_encodings(self_image)[0]
    # print("self encoding=",self_face_encoding)  #print 128 matrix

    # Get the first face recognized in ID
    DL_face_encoding = face_recognition.face_encodings(DL_image)[0]
    # print("DL encoding=",DL_face_encoding) #print 128 matrix

    DL_small_face_encoding = [DL_face_encoding]  #save in array

    tolerance = 0.6

    # compare self photo with drivers license photo
    match = face_recognition.compare_faces(DL_small_face_encoding, self_face_encoding)  
    print("match=",match) #match= [True] or match= [False] or out of range too small
    return str(match)
# ################ end of program ###########################

if __name__ == "__main__":
    app.run(debug = True)