from django.contrib import admin
from devinfra.app.models import Author

class AuthorAdmin(admin.ModelAdmin):
    pass
admin.site.register(Author, AuthorAdmin)


@admin.register(Author)
class AuthorAdmin(admin.ModelAdmin):
    pass

@admin.register(Author, Reader, Editor, site=custom_admin_site)
class PersonAdmin(admin.ModelAdmin):
    pass
