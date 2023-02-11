from django.shortcuts import render
from rest_framework.response import Response
from rest_framework import viewsets
from .serializers import UserSerializer
from scripts.cluster import compute_kmeans
from .models import User, Cluster
from rest_framework import status
from rest_framework.decorators import action
from django.db.models import Count
import pandas as pd
from django.http import HttpResponse

states_list = ["Andhra Pradesh", "Arunachal Pradesh ", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha",
               "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal", "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli", "Daman and Diu", "Lakshadweep", "National Capital Territory of Delhi", "Puducherry"]


def get_cluster_data(parameters):
    kmeans_dict = compute_kmeans(parameters)
    queryset = User.objects.all()
    data = [dict(UserSerializer(item).data, cluster=kmeans_dict['cluster'][idx], coordinates={'x': kmeans_dict['coordinates'][idx][0], 'y': kmeans_dict['coordinates'][idx][1]})
            for idx, item in enumerate(queryset)]
    return data


def get_client_ip(request):
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip


class UserViewSet(viewsets.ViewSet):
    def create(self, request):
        data = request.data
        data['ip_address'] = get_client_ip(request)
        serializer_class = UserSerializer(data=data)
        if serializer_class.is_valid():
            serializer_class.save()
            return Response({'data': serializer_class.data})
        return Response(serializer_class.errors, status=status.HTTP_400_BAD_REQUEST)

    @action(detail=False, methods=['get'])
    def search(self, request):
        name = request.GET.get("name")
        age = request.GET.get("age")
        user_qs = User.objects.filter(name__icontains=name, age=age)
        return Response(UserSerializer(user_qs, many=True).data)


class ClusterViewSet(viewsets.ViewSet):
    def list(self, request):
        parameters = request.GET.get("parameters", '__all__')
        return Response(get_cluster_data(parameters))

    @action(detail=False, methods=['get'])
    def state(self, request):
        result = []
        for idx, state in enumerate(states_list):
            count = User.objects.filter(state=state).count()
            temp = {}
            temp['x'] = idx
            temp['y'] = count
            result.append(temp)
        return Response(result)

    def retrieve(self, request, pk=None):
        user_ids = Cluster.objects.filter(
            number=pk).values_list("user_id", flat=True)
        queryset = User.objects.filter(id__in=user_ids)
        return Response(UserSerializer(queryset, many=True).data)

    @action(detail=True, methods=['get'])
    def csv(self, request, pk=None):
        user_ids = Cluster.objects.filter(
            number=pk).values_list("user_id", flat=True)
        queryset = User.objects.filter(id__in=user_ids)
        data = UserSerializer(queryset, many=True).data
        df = pd.DataFrame(data)
        df.to_csv("cluster.csv")
        return HttpResponse(
            content_type='text/csv',
            headers={
                'Content-Disposition': 'attachment; filename="cluster.csv"'},
        )
