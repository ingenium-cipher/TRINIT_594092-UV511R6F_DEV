from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import viewsets
from .serializers import UserSerializer
from scripts.cluster import compute_kmeans
from .models import User, Cluster
from rest_framework import status


def get_cluster_data(parameters):
    kmeans_dict = compute_kmeans(parameters)
    print(kmeans_dict['coordinates'])
    queryset = User.objects.all()
    data = [dict(UserSerializer(item).data, cluster=kmeans_dict['cluster'][idx], coordinates={'x': kmeans_dict['coordinates'][idx][0], 'y': kmeans_dict['coordinates'][idx][1]})
            for idx, item in enumerate(queryset)]
    return data


class UserViewSet(viewsets.ViewSet):
    def create(self, request):
        serializer_class = UserSerializer(data=request.data)
        if serializer_class.is_valid():
            serializer_class.save()
            return Response({'data': serializer_class.data})
        return Response(serializer_class.errors, status=status.HTTP_400_BAD_REQUEST)


class ClusterViewSet(viewsets.ViewSet):
    def list(self, request):
        parameters = request.GET.get("parameters", '__all__')
        return Response(get_cluster_data(parameters))

    def retreive(self, request, pk=None):
        user_ids = Cluster.objects.filter(
            number=pk).values_list("id", flat=True)
        queryset = User.objects.filter(id__in=user_ids)
        return Response(UserSerializer(queryset, many=True).data)
