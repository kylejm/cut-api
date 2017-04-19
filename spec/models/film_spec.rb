require "rails_helper"

RSpec.describe Film, :type => :model do
  it "parses a movie from Flixster" do
    title = "Interstellar"
    running_time = 97
    running_time_description = "1 hr. 37 min."
    theater_release_date = Date.new(2017, 4, 7)
    poster_url = "http://poster.com/image.jpg"
    poster_size = 'thumbnail'
    synopsis = "Best movie ever"

    flixster_num_of_scores = 1134
    flxster_user_score = 63

    rotten_tomatoes_score = 50
    critic_review_count = 1231

    json = {
      "id": 771382349,
      "title": title,
      "mpaa": "US: PG",
      "runningTime": running_time_description,
      "year": 2017,
      "boxOffice": "",
      "releaseType": "TopBoxOffice",
      "theaterReleaseDate": {
        "year": "2017",
        "month": "4",
        "day": "07"
      },
      "poster": { "#{poster_size}": poster_url },
      "trailer": {
        "low": "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
        "med": "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
        "high": "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
        "hd": "http://link.theplatform.com/s/NGweTC/media/iTHXNgNW4Lz5",
        "thumbnail": "http://resizing.flixster.com/QxyMqPE0tz_WSS8OJWwggnh_158=/171x128/v1.bjsxNDc5ODUzO2o7MTcyOTc7MjA0ODsxMDgwOzE5MjA",
        "duration": 151
      },
      "status": "Live",
      "playing": true,
      "boxOfficeCurrencySymbol": "&#163;",
      "actors": [
        {
          "id": 162656441,
          "name": "Alec Baldwin"
        },
        {
          "id": 162652875,
          "name": "Steve Buscemi"
        },
        {
          "id": 351528089,
          "name": "Jimmy Kimmel"
        }
      ],
      "synopsis": synopsis,
      "reviews": {
        "flixster": {
          "numScores": flixster_num_of_scores,
          "numWantToSee": 9818,
          "popcornScore": flxster_user_score
        },
        "rottenTomatoes": {
          "rating": rotten_tomatoes_score,
          "certifiedFresh": false
        },
        "criticsNumReviews": critic_review_count
      }
    }.symbolize_keys


    f = Film.from_flixster(json)
    f.save

    expect(f.title).to eq title
    expect(f.running_time).to eq running_time
    expect(f.theater_release_date).to eq theater_release_date
    expect(f.posters.first.url).to eq poster_url
    expect(f.posters.first.size).to eq poster_size
    expect(f.synopsis).to eq synopsis

    expect(f.ratings.count).to eq 2

    expect(f.ratings[0].rating).to eq rotten_tomatoes_score / Float(100)
    expect(f.ratings[0].rating_count).to eq critic_review_count
    expect(f.ratings[0].source).to eq :rotten_tomatoes.to_s

    expect(f.ratings[1].rating).to eq flxster_user_score / Float(100)
    expect(f.ratings[1].rating_count).to eq flixster_num_of_scores
    expect(f.ratings[1].source).to eq :flixster_users.to_s

    f.destroy

    expect(f.ratings.count).to eq 0
  end
end
