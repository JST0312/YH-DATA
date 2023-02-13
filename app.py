from matplotlib import pyplot as plt
import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
import streamlit as st

from sklearn.preprocessing import LabelEncoder, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import MinMaxScaler


def main() :
    st.title('K-Means 클러스터링 앱')

    # 1. csv 파일을 업로드 할수 있다.
    file = st.file_uploader('CSV파일 업로드', type=['csv'])

    if file is not None :
        # csv 파일은, 판다스로 읽어서 화면에 보여준다.
        df = pd.read_csv(file)
        st.dataframe( df )

        # 결측값 처리한다.
        df = df.dropna()

        column_list = df.columns
        selected_columns = st.multiselect('X로 사용할 컬럼을 선택하세요', column_list)

        if len(selected_columns) != 0 : 
            X = df[selected_columns]
            st.dataframe(X)

            # 문자열이 들어있으면 처리한 후에 화면에 보여주자.
            X_new = pd.DataFrame()

            for name in X.columns :
                print(name)    
                # 각 컬럼 데이터를 가져온다.
                data = X[name]
                data.reset_index(inplace=True, drop=True)  
                
                # 문자열인지 아닌지 나눠서 처리하면 된다. 
                if data.dtype == object :
                    
                    # 문자열이니까, 갯수가 2개인지 아닌지 파악해서
                    # 2개이면 레이블 인코딩 하고,
                    # 그렇지 않으면 원핫인코딩 하도록 코드 작성
                    
                    if data.nunique() <= 2 :
                        # 레이블 인코딩
                        label_encoder = LabelEncoder()
                        X_new[name] = label_encoder.fit_transform(data)            
                        
                    else :
                        # 원핫인코딩
                        ct = ColumnTransformer( [ ('encoder', OneHotEncoder(), [0] ) ] , 
                                remainder='passthrough' )
                        
                        col_names = sorted(data.unique())
                        
                        X_new[ col_names ] = ct.fit_transform(  data.to_frame()  )

                else :
                    # 숫자 데이터 처리
                    
                    X_new[name] = data

            scaler = MinMaxScaler()
            X_new = scaler.fit_transform(X_new)

            st.dataframe(X_new)

            st.subheader('WCSS를 위한 클러스터링 갯수를 선택')

            if X_new.shape[0] < 10 :
                default_value = X_new.shape[0]
            else :
                default_value = 10

            max_number = st.slider('최대 그룹 선택', 2, 20, value=default_value)
            wcss = []
            for k in np.arange(1, max_number+1) :
                kmeans = KMeans(n_clusters= k, random_state=5)
                kmeans.fit(X_new)
                wcss.append( kmeans.inertia_ )

            # st.write(wcss)

            fig1 = plt.figure()
            x = np.arange(1, max_number+1)
            plt.plot( x, wcss )
            plt.title('The Elbow Method')
            plt.xlabel('Number of Clusters')
            plt.ylabel('WCSS')
            st.pyplot(fig1)


            # 실제로 그룹핑할 갯수 선택!
            # k = st.slider('그룹 갯수 결정', 1, max_number)

            k = st.number_input('그룹 갯수 결정', 1, max_number)

            kmeans = KMeans(n_clusters= k, random_state=5)

            y_pred = kmeans.fit_predict(X_new)

            df['Group'] = y_pred

            st.dataframe( df.sort_values('Group')  )


            df.to_csv('result.csv')


if __name__ == '__main__' :
    main()


