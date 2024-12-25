import streamlit as st
import joblib

MODEL = joblib.load("./models/titanic_model.pkl")


def main():
    st.title("タイタニック号の生存者を予測する")

    pclass = st.selectbox("チケットのクラス", [1, 2, 3])
    age = st.slider("年齢", 0, 100, 29)
    sibsp = st.slider("兄弟・配偶者の数", 0, 10, 0)
    parch = st.slider("両親・子どもの数", 0, 10, 0)
    fare = st.slider("運賃", 0, 1000, 1)

    if st.button("生存確率を予測"):
        features = [pclass, age, sibsp, parch, fare]
        proba = MODEL.predict_proba([features])[0][1]
        st.write(f"### 生存確率: {proba:.2%}%")


if __name__ == "__main__":
    main()
