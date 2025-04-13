# from django.contrib import admin
# from .models import Task

# @admin.register(Task)
# class TaskAdmin(admin.ModelAdmin):
#     list_display = ('title', 'is_completed', 'due_date', 'priority','file', 'image')
# from django.contrib import admin  # Import admin here
from django.contrib import admin  # Import admin here
from .models import Task
from django.utils.html import format_html


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = ('title', 'is_completed', 'due_date', 'priority', 'file_link', 'image_preview')
    fields = ('title', 'description', 'is_completed', 'due_date', 'priority', 'file', 'image')

    def file_link(self, obj):
        if obj.file:
            return format_html('<a href="{}" target="_blank">Download</a>', obj.file.url)
        return "No file"
    file_link.short_description = 'File'

    def image_preview(self, obj):
        if obj.image:
            return format_html('<img src="{}" width="100" />', obj.image.url)
        return "No image"
    image_preview.short_description = 'Image'
