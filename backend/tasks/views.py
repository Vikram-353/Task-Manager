from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser,JSONParser
from .models import Task
from .serializers import TaskSerializer
from rest_framework.permissions import IsAuthenticated


class TaskViewSet(viewsets.ModelViewSet):
    queryset = Task.objects.all()
    serializer_class = TaskSerializer
    parser_classes = (MultiPartParser, FormParser,JSONParser) 
    permission_classes = [IsAuthenticated] # Enables file uploads via PUT/PATCH/POST

    def update(self, request, *args, **kwargs):
        """
        Override PUT method for updates.
        """
        print("PUT Request Data:", request.data)  # Log for debugging
        return super().update(request, *args, **kwargs)

    def partial_update(self, request, *args, **kwargs):
        """
        Override PATCH method if Flutter uses PATCH for updates.
        """
        print("PATCH Request Data:", request.data)
        return super().partial_update(request, *args, **kwargs)
    
    def get_queryset(self):
        # Only return tasks for the logged-in user
        return Task.objects.filter(created_by=self.request.user)

    def perform_create(self, serializer):
        # Save task with the current user
        serializer.save(created_by=self.request.user)

    def get_object(self):
        obj = super().get_object()
        if obj.created_by != self.request.user:
            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied("You do not have permission to access this task.")
        return obj

