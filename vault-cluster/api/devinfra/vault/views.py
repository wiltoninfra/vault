from django.shortcuts import render
from django.http import HttpResponse

def vault(request):
    return render(request, 'index.html', {'usuario': 'Fulano de Tal'})