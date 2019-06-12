from imageai.Detection import ObjectDetection
import os
import pymysql
from time import sleep

conn = pymysql.connect(
        host='localhost',
        user='root',
        password= '',
        db='mydb',
        charset='utf8'
        )
curs = conn.cursor()

execution_path = os.getcwd()
model_path = os.getcwd()

execution_path = execution_path + "/images"
num=2

detector = ObjectDetection()
detector.setModelTypeAsRetinaNet()
detector.setModelPath( os.path.join(model_path , "resnet50_coco_best_v2.0.1.h5"))
detector.loadModel()

while True:
    if os.path.exists(execution_path+'/Image'+str(num)+'.jpg') == True:
        detections = detector.detectObjectsFromImage(input_image=os.path.join(execution_path , "Image"+str(num)+".jpg"), output_image_path=os.path.join(execution_path , "Image"+str(num)+"new.jpg"), minimum_percentage_probability=30)

        person_num=0
        for eachObject in detections:
            if eachObject["name"] == "person" :
                print(eachObject["name"] , " : ", eachObject["percentage_probability"], " : ", eachObject["box_points"] )
                print("--------------------------------")
                person_num = person_num + 1 
        print(num," : ", person_num)
        
        sql="""insert into camera(person_count,total_seat) values(%s,%s)"""
        curs.execute(sql,(person_num,'30'))
        conn.commit()

        os.system("echo 3 > /proc/sys/vm/drop_caches")
        os.system("free")
        dirname = execution_path+'/'
        filename = 'Image'+str(num)+'.jpg'
        pathname = os.path.abspath(os.path.join(dirname,filename))
        if pathname.startswith(dirname):
            os.remove(pathname)
        num=num+1
        sleep(20)
