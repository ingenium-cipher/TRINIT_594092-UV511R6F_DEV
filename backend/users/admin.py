from django.contrib import admin

from .models import User, Cluster

admin.site.register(User)
admin.site.register(Cluster)

# Register your models here.
