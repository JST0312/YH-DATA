import streamlit as st
from app_home import run_home_app
from app_eda import run_eda_app

def main():
    
    st.title('자동차 가격 예측 앱')

    menu = ['Home', 'EDA', 'ML']
    choice = st.sidebar.selectbox('메뉴', menu)

    if choice == 'Home':
        run_home_app()
    elif choice == 'EDA' :
        run_eda_app()
    elif choice == 'ML' :
        pass

if __name__=='__main__' :
    main()



