from django.db import models

gender_choices = (('Male', 'Male'), ('Female', 'Female'))


class User(models.Model):
    name = models.CharField(max_length=50)
    age = models.IntegerField()
    gender = models.CharField(max_length=10, choices=gender_choices)
    state = models.CharField(max_length=50)
    phone_number = models.BigIntegerField(blank=True, null=True)
    email = models.EmailField(blank=True, null=True)
    ip_address = models.GenericIPAddressField(null=True, unique=True)


class Cluster(models.Model):
    number = models.IntegerField()
    user = models.ForeignKey(User, on_delete=models.CASCADE)

# Create your models here.
