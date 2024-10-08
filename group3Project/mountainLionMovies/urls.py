from django.urls import path
from . import views
from .views import FilmListView

urlpatterns = [
path('', views.index, name='index'),
path('films/', FilmListView.as_view(), name='films'),
path('films/<int:pk>', views.FilmDetailView.as_view(), name='film-detail'),
path('viewers/', views.ViewerListView.as_view(), name= 'viewers'),
path('viewers/<int:pk>', views.ViewerDetailView.as_view(), name='viewer-detail'),
]
