# from django.urls import path, include
# from rest_framework.routers import DefaultRouter
# from .views import TaskViewSet

# router = DefaultRouter()
# router.register(r'tasks', TaskViewSet)

# urlpatterns = [
#     path('', include(router.urls)),
# ]


# from django.urls import path, include
# from rest_framework.routers import DefaultRouter
# from .views import TaskViewSet

# router = DefaultRouter()
# router.register(r'tasks', TaskViewSet, basename='task')

# urlpatterns = [
#     path('', include(router.urls)),
# ]

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import TaskViewSet
from .views_auth import RegisterView, LoginView, LogoutView

router = DefaultRouter()
router.register(r'tasks', TaskViewSet,basename='task')

urlpatterns = [
    path('', include(router.urls)),

    # Auth endpoints
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('logout/', LogoutView.as_view(), name='logout'),
]
