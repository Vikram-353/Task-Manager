# # from rest_framework import viewsets
# # from .models import Task
# # from .serializers import TaskSerializer

# # class TaskViewSet(viewsets.ModelViewSet):
# #     queryset = Task.objects.all()
# #     serializer_class = TaskSerializer
# # from rest_framework.parsers import MultiPartParser, FormParser
# # from rest_framework import viewsets
# # from .models import Task
# # from .serializers import TaskSerializer

# # class TaskViewSet(viewsets.ModelViewSet):
# #     queryset = Task.objects.all()
# #     serializer_class = TaskSerializer
# #     parser_classes = (MultiPartParser, FormParser)  # This allows file uploads

# #     def create(self, request, *args, **kwargs):
# #         print("Request Data:", request.data)  # Log the request data to check if files are being sent
# #         return super().create(request, *args, **kwargs)

# from rest_framework import viewsets
# from rest_framework.parsers import MultiPartParser, FormParser
# from .models import Task
# from .serializers import TaskSerializer

# class TaskViewSet(viewsets.ModelViewSet):
#     queryset = Task.objects.all()
#     serializer_class = TaskSerializer
#     parser_classes = (MultiPartParser, FormParser)  # For handling file uploads

#     def update(self, request, *args, **kwargs):
#         """
#         Override the update method to customize PUT request behavior if needed.
#         """
#         # You can log request data for debugging:
#         print("Request data:", request.data)

#         # Call the default update method to handle the actual update logic
#         return super().update(request, *args, **kwargs)
from rest_framework import viewsets
from rest_framework.parsers import MultiPartParser, FormParser,JSONParser
from .models import Task
from .serializers import TaskSerializer

class TaskViewSet(viewsets.ModelViewSet):
    queryset = Task.objects.all()
    serializer_class = TaskSerializer
    parser_classes = (MultiPartParser, FormParser,JSONParser)  # Enables file uploads via PUT/PATCH/POST

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
