#!/bin/sh


# Get the GitHub Token and Giphy API Key from GitHub Action inputs
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

GHEvent = `cat $GITHUB_EVENT_PATH`
echo $GHEvent

# Get the pull request number from the GitHub event payload
pull_request_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo PR Number - $pull_request_number

# Use the Random API to fetch a random funny GIF
giphy_response=$(curl -s "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")
echo Giphy Response - $giphy_response

# Extract the GIF URL from the Giphy response
gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)
echo GIPHY_URL - $gif_url

# Create a comment with the GIF on the pull request
comment_response=$(curl -sX POST -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{\"body\": \"### PR - #$pull_request_number has been assigned. \n ![GIF]($gif_url) \n ### 🎉 Thank you for this contribution!\"}" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pull_request_number/comments")

# Extract and print the comment URL from the comment response
comment_url=$(echo "$comment_response" | jq --raw-output .html_url)
echo "Comment URL: $comment_url"
