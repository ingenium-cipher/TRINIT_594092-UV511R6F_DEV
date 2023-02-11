#autopep8: off
import sys
import os, django
import pandas as pd
sys.path.append('../')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'nithackathon.settings')
django.setup()
from users.models import User

def populate():
    users = pd.read_csv("../assets/users.csv")
    age_rows = users['Age']
    gender_rows = users['Gender']

    for i in range(len(age_rows)):
        if i % 5 == 0:
            User.objects.create(
                name="Ayush", age=age_rows[i], gender=gender_rows[i], state="Bihar")
        elif i % 5 == 1:
            User.objects.create(
                name="Ashu", age=age_rows[i], gender=gender_rows[i], state="Bihar")
        elif i % 5 == 2:
            User.objects.create(
                name="Chintu", age=age_rows[i], gender=gender_rows[i], state="Bihar")
        elif i % 5 == 3:
            User.objects.create(
                name="Kshitij", age=age_rows[i], gender=gender_rows[i], state="Bihar")
        else:
            User.objects.create(
                name="Anshul", age=age_rows[i], gender=gender_rows[i], state="Bihar")

populate()
