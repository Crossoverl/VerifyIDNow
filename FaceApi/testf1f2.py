import face_recognition
import numpy as np
import base64

# selfie_64_decode = base64.b64decode(selfieBase64) 
# selfie_result = open('selfie.jpg', 'wb') # create a writable image and write the decoding result
# selfie_result.write(selfie_64_decode)
self_image = face_recognition.load_image_file("selfiePhysical.jpg")
# print(self_image)
print("selfie: " + str(len(face_recognition.face_encodings(self_image))))

# DL_image = face_recognition.load_image_file("dl.jpg")
# print("DL: " + str(len(face_recognition.face_encodings(DL_image))))

# self_face_encoding = face_recognition.face_encodings(self_image)[0]
# print("self encoding=",self_face_encoding)  #print 128 matrix

# #############################################################
# # Load drivers license DL photo and learn how to recognize it.
# #############################################################
# dl_64_decode = base64.b64decode(dlBase64) 
# dl_result = open('dl.jpg', 'wb') # create a writable image and write the decoding result
# dl_result.write(dl_64_decode)
# DL_image = face_recognition.load_image_file("dl.jpg")
# DL_face_encoding = face_recognition.face_encodings(DL_image)[0]
# print("DL encoding=",DL_face_encoding) #print 128 matrix

# DL_small_face_encoding = [DL_face_encoding]  #save in array
# #############################################################
# # compare self photo with drivers license photo
# #############################################################
# match = face_recognition.compare_faces(DL_small_face_encoding, self_face_encoding)  
# print("match=",match) #match= [True] or match= [False] or out of range too small