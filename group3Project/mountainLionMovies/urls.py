from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='index'),  # This assumes you have an index view defined
]
