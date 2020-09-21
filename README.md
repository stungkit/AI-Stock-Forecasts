![Frame 1](https://user-images.githubusercontent.com/26531613/89218912-d9911580-d59c-11ea-8264-e44a06ca68ca.png)

## General information about this app

This iOS app predicts Fortune 100 companies stock price evolution through sentiment analysis
This app uses **SwiftUI** for the layout, **CoreML** for the models creation, **Twitter** as the source for data analysis and **the Swifter package** for fetching the 200 most recent comments about the searched company.

## Quick presentation of the app

![Untitled 001](https://user-images.githubusercontent.com/26531613/90335413-ee10dd00-dfa2-11ea-8fdc-c5b47f32738e.jpeg)

## How does it work?

For this app, I am using Twitter as the source for my sentiment analysis. I am performing the company analysis via 200 twitter comments about the company. Those comments are splitted in 2 sets. The first set gathers the 100 most recent comments about the company (Ex: @apple) and the second set gathers the 100 most recent comments about the stock (Ex: #AAPL).
As the wording between those 2 sets of comments is very different, I used 2 different models trained on different datasets: IMBD dataset of 50k movie reviews for the first model and the Kaggle Sentiment Analysis on Financial Tweets dataset for the 2nd model.
I feed the 100 twitter comments about the company to the first model and the 100 twitter comments about the stock to the second model. Then, I calculate a total score based on the sentiment analysis of those 200 twitter comments

## Animated demo of the app

![app-presentation](https://user-images.githubusercontent.com/26531613/90067490-2ff90500-dcbd-11ea-9138-92c5ff26f94c.gif)

## Third Party components usage

### On the HomeScreen:
Icons made by Icongeek26 from www.flaticon.com

### On the ResultScreen:
I used the Circle Control code from this project:
https://medium.com/swlh/replicating-the-apple-card-application-using-swiftui-f472f3947683

## Open Source & Copying

I provide the entire source code of this dema app for free. This demo app is licensed under MIT so you can use my code in your app, if you choose.

However, **please do not ship this app** under your own account. Paid or free.
