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
sys.path.append('../')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'nithackathon.settings')
django.setup()
from users.models import User, Cluster


def sample():
    users = pd.read_csv("../assets/users.csv")
    age_rows = users.iloc[:, 2:3]

    # wcss = []
    # for i in range(1, 11):
    #     km = KMeans(n_clusters=i, init='k-means++',
    #                 max_iter=300, n_init=10, random_state=0)
    #     km.fit(age_rows)
    #     wcss.append(km.inertia_)
    # plt.plot(range(1, 11), wcss, c="#c51b7d")
    # plt.gca().spines["top"].set_visible(False)
    # plt.gca().spines["right"].set_visible(False)
    # plt.title('Elbow Method', size=14)
    # plt.xlabel('Number of clusters', size=12)
    # plt.ylabel('wcss', size=14)
    # plt.savefig("plot.png")
    # plt.show()

    kmeans = KMeans(n_clusters=2, init='k-means++',
                    max_iter=10, n_init=10, random_state=0)

    # Fit and predict
    y_means = kmeans.fit_predict(age_rows)

    fig, ax = plt.subplots(figsize=(8, 6))

    arr = []
    for x in range(0, 200):
        arr.append(x)

    plt.scatter(age_rows, arr,
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

    plt.xlabel("Age", size=14, labelpad=10)
    plt.ylabel("User number", size=14, labelpad=10)

    plt.title('Dominios agrupados en 5 clusters', size=16)

    plt.colorbar(ticks=[0, 1, 2, 3, 4])

    plt.savefig("kmeans.png")

    print(y_means)


def compute_kmeans(parameters):
    param_list = []
    for param in parameters.split(','):
        param_list.append(param.strip())

    qs = User.objects.all().values(*param_list)
    qs = list(qs)
    if len(qs):
        df = pd.DataFrame(qs)
        # tf_idf_array = []
        name_feature_list = []

        if 'gender' in param_list:
            df['gender'] = df.gender.apply(
                lambda x: 0 if x == "Male" else 1)

        if 'name' in param_list:
            names_rows = df['name']

            for name in names_rows:
                for n in name.split(" "):
                    freq_arr = []
                    for i in range(26):
                        freq_arr.append(0)
                    for c in n:
                        freq_arr[c.lower() - 'a'] += 1
                name_feature_list.append(freq_arr)

            name_array = np.array(name_feature_list)

            df['name']
            print(freq_arr)
            # tf_idf_vectorizor = TfidfVectorizer(max_features=5)
            # tf_idf = tf_idf_vectorizor.fit_transform(names_rows)
            # print(tf_idf)
            # print("lskdfj;sldkjf;lskadjf;lskdjf;sldakfj")
            # tf_idf_norm = normalize(tf_idf)
            # print(tf_idf_norm)
            # tf_idf_array = tf_idf_norm.toarray()
            # print(tf_idf_array)
            # sklearn_pca = PCA(n_components=1)
            # Y_sklearn = sklearn_pca.fit_transform(tf_idf_array)

        # print(Y_sklearn)
        # predict the right 'k'
        wcss = []
        max_iters = min(len(qs), 11)
        rows = df.iloc[:, :]
        print(rows)

        n_components = min(len(param_list), 2)

        sklearn_pca = PCA(n_components=n_components)
        pca_2d = sklearn_pca.fit_transform(rows)

        for i in range(1, max_iters):
            km = KMeans(n_clusters=i, init='k-means++',
                        max_iter=300, n_init=10, random_state=0)
            km.fit(pca_2d)
            wcss.append(km.inertia_)
        # plt.plot(range(1, max_iters), wcss, c="#c51b7d")
        # plt.gca().spines["top"].set_visible(False)
        # plt.gca().spines["right"].set_visible(False)
        # plt.title('Elbow Method', size=14)
        # plt.xlabel('Number of clusters', size=12)
        # plt.ylabel('wcss', size=14)
        # plt.savefig("plot.png")

        slopes = []
        for i in range(len(wcss) - 1):
            slopes.append(wcss[i] - wcss[i+1])

        max_diff = 0
        cluster_count = min(len(qs), 5)  # pre define n_clusters
        for idx, i in enumerate(range(len(slopes) - 1)):
            diff = slopes[i] - slopes[i+1]
            if diff > max_diff:
                max_diff = diff
                cluster_count = idx + 2

        kmeans = KMeans(n_clusters=cluster_count, init='k-means++',
                        max_iter=10, n_init=10, random_state=0)
        y_means = kmeans.fit_predict(pca_2d)

        if len(param_list) == 1:
            user_ids = np.array((User.objects.all().values_list('id', flat=True)))
            pca_2d = np.c_[ pca_2d, user_ids ]

        plt.scatter(pca_2d[:, 0], pca_2d[:, 1],
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

        # print(kmeans.get_feature_names_out())
        # print(kmeans.get_params())
        # print(kmeans.feature_names_in_)
        Cluster.objects.all().delete() # delete previous cluster objects
        # for idx, c in enumerate(y_means):

        return {'cluster': y_means, 'coordinates': pca_2d}
    return {'cluster': [], 'coordinates': [[]]}
