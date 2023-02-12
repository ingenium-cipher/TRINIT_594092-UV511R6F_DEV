#autopep8: off
import os
import django
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import sys
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import normalize
from sklearn.decomposition import PCA
from sklearn.metrics import silhouette_score
sys.path.append('../')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'nithackathon.settings')
django.setup()
from users.models import User, Cluster

name_feature_list = []
states_list = ["Andhra Pradesh","Arunachal Pradesh ","Assam","Bihar","Chhattisgarh","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu and Kashmir","Jharkhand","Karnataka","Kerala","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Odisha","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand","West Bengal","Andaman and Nicobar Islands","Chandigarh","Dadra and Nagar Haveli","Daman and Diu","Lakshadweep","National Capital Territory of Delhi","Puducherry"]

def compute_freq(x, idx):
    freq_arr = []
    for i in range(26):
        freq_arr.append(0)
    for n in x[idx].split(" "):
        for c in n:
            freq_arr[ord(c.lower()) - ord('a')] += 1
    return pd.Series(freq_arr, index = list(map(chr, range(97, 123))))

def predict_k(pca_2d, qs, param_list):
    if len(param_list) == 1:
        return min(len(qs), 3)
    wcss = []
    max_iters = min(len(qs), 11)

    for i in range(2, max_iters):
        km = KMeans(n_clusters=i, init='k-means++',
                    max_iter=300, n_init=10, random_state=0)
        km.fit_predict(pca_2d)
        wcss.append(silhouette_score(pca_2d, km.labels_))

    plt.clf()
    plt.plot(range(2, max_iters), wcss, c="#c51b7d")
    plt.gca().spines["top"].set_visible(False)
    plt.gca().spines["right"].set_visible(False)
    plt.title('Elbow Method', size=14)
    plt.xlabel('Number of clusters', size=12)
    plt.ylabel('wcss', size=14)
    plt.savefig("plot.png")

    # slopes = []
    cluster_count = min(len(qs), 3)  # pre define n_clusters
    max_score = 0
    for idx, s in enumerate(wcss):
        if s > max_score:
            max_score = s
            cluster_count = idx + 2

    return cluster_count

def compute_kmeans(parameters):
    param_list = []
    for param in parameters.split(','):
        param_list.append(param.strip())

    user_queryset = User.objects.all()

    qs = user_queryset.values(*param_list)
    qs = list(qs)
    if len(qs):
        df = pd.DataFrame(qs)

        if 'gender' in param_list:
            df['gender'] = df.gender.apply(
                lambda x: 0 if x == "Male" else 1)

        if 'state' in param_list:
            df['state'] = df.state.apply(
                lambda x: states_list.index(x)
            )

        if 'name' in param_list:
            df2 = df.apply(compute_freq, args = (param_list.index('name'), ), axis=1, result_type='expand')
            df = pd.concat([df, df2], axis = 1)
            df = df.drop('name', axis='columns')

        rows = np.array(df.iloc[:, :])
        pca_2d = rows
        if len(param_list) >= 2:
            sklearn_pca = PCA(n_components=2)
            pca_2d = sklearn_pca.fit_transform(rows)

        # predict the right 'k'
        cluster_count = predict_k(pca_2d, qs, param_list)
        # for idx, i in enumerate(range(len(slopes) - 1)):
        #     diff = slopes[i] - slopes[i+1]
        #     if diff > max_diff:
        #         max_diff = diff
        #         cluster_count = idx + 2

        kmeans = KMeans(n_clusters=cluster_count, init='k-means++',
                        max_iter=10, n_init=10, random_state=0)
        y_means = kmeans.fit_predict(pca_2d)

        coordinates = pca_2d

        if len(param_list) == 1:
            x_axis = rows[:, 0]
            y_axis = np.array(user_queryset.values_list('id', flat=True))
            coordinates = np.vstack((x_axis, y_axis)).T
        else:
            x_axis = pca_2d[:, 0]
            y_axis = pca_2d[:, 1]

        plt.clf()

        plt.scatter(x_axis, y_axis,
                c=y_means,
                edgecolor="none",
                cmap=plt.cm.get_cmap("Spectral_r", 5),
                alpha=0.5)

        plt.gca().spines["top"].set_visible(False)
        plt.gca().spines["right"].set_visible(False)
        plt.gca().spines["bottom"].set_visible(False)
        plt.gca().spines["left"].set_visible(False)

        plt.xticks(size=12)
        plt.yticks(size=12)

        plt.xlabel("Component 1", size=14, labelpad=10)
        plt.ylabel("Component 2", size=14, labelpad=10)

        plt.title('Dominios agrupados en 5 clusters', size=16)

        plt.colorbar(ticks=[0, 1, 2, 3, 4])

        plt.savefig("kmeans.png")
        Cluster.objects.all().delete() # delete previous cluster objects
        for idx, user in enumerate(list(user_queryset)):
            Cluster.objects.create(number=y_means[idx], user=user)

        return {'cluster': y_means, 'coordinates': coordinates}
    return {'cluster': [], 'coordinates': [[]]}
