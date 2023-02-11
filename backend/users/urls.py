from .views import UserViewSet, ClusterViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'users', UserViewSet, basename='')
router.register(r'clusters', ClusterViewSet, basename='')
urlpatterns = router.urls
