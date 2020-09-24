![Frame 1](https://user-images.githubusercontent.com/26531613/89218912-d9911580-d59c-11ea-8264-e44a06ca68ca.png)

<a href="https://apps.apple.com/us/app/ai-stock-forecasts/id1527494965?ign-mpt=uo%3D2"><img src="https://user-images.githubusercontent.com/26531613/94089836-1d0c4100-fde2-11ea-9893-3b6b7b3f0b22.png"></a>

## General information about this app

This iOS app predicts Fortune 100 companies stock price evolution through sentiment analysis
This app uses **SwiftUI** for the layout, **CoreML** for the models creation, **Twitter** and **News-api** as the sources for data analysis.

## Quick presentation of the app

![Untitled 001](https://user-images.githubusercontent.com/26531613/90335413-ee10dd00-dfa2-11ea-8fdc-c5b47f32738e.jpeg)

## How does it work?

For this app, I am using **Twitter** and **News-api** as the sources for my sentiment analysis.

I am performing the company analysis via 100 twitter comments about the company. Those comments are splitted in 2 sets. The first set gathers the 50 most recent tweets about the company (Ex: @apple) and the second set gathers the 50 most recent tweets about the stock (Ex: #AAPL).
As the wording between those 2 sets of comments is very different, I used 2 different models trained on different datasets: IMBD dataset of 50k movie reviews for the first model and the Kaggle Sentiment Analysis on Financial Tweets dataset for the 2nd model.

Then, I fetch the 20 most recent news articles about the company and use the first model to perform the sentiment analysis on those news articles

Finally, I calculate a total score based on the sentiment analysis of those 120 comments

## Animated demo of the app

![app-presentation](https://user-images.githubusercontent.com/26531613/90067490-2ff90500-dcbd-11ea-9138-92c5ff26f94c.gif)

## Third Party components usage

### Fetching Twitter data
Swifter package from https://github.com/mattdonnelly/Swifter

### On the HomeScreen:
Icons made by Icongeek26 from www.flaticon.com

### On the ResultScreen:
I used the Circle Control code from this project:
https://medium.com/swlh/replicating-the-apple-card-application-using-swiftui-f472f3947683

## Open Source & Copying

I provide the entire source code of this dema app for free. This demo app is licensed under MIT so you can use my code in your app, if you choose.

However, **please do not ship this app** under your own account. Paid or free.
