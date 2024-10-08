from django.shortcuts import render
from django.core.paginator import Paginator
from django.views import generic
from django.views.generic import ListView
from .models import Collection, Company, Country, Film, Genre, Keyword, Language, Person, Viewer, LT_Films_Cast, LT_Films_Companies, LT_Films_Countries, LT_Films_Crew, LT_Films_Genres, LT_Films_Keywords, LT_Films_Languages, LT_Seen_Film_Ratings, LT_Viewer_Seen_Films


def index(request):
    return render(request, 'index.html')

class FilmListView(ListView):
    model = Film
    template_name = 'film_list.html'
    context_object_name = 'film_list'
    paginate_by = 40

class ViewerListView(generic.ListView):
    model = Viewer

class ViewerDetailView(generic.DetailView):
    model = Viewer

class FilmDetailView(generic.DetailView):
    model = Film