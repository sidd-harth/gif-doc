#!/bin/sh

# Get the GitHub Token and Giphy API Key from GitHub Action inputs
GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

echo GHEvent - $GITHUB_EVENT_PATH

# Get the pull request number from the GitHub event payload
pull_request_number=$(jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH")
echo PR Number - $pull_request_number

# Use the Random API to fetch a random funny GIF
giphy_response=$(curl "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")
echo Giphy Response - $giphy_response

# Extract the GIF URL from the Giphy response
gif_url=$(echo "$giphy_response" | jq --raw-output .data.images.downsized.url)
echo URL - $gif_url

# # Use the Random API to fetch a random funny GIF
# giphy_response=$(curl -s "https://api.humorapi.com/gif/search?api-key=8fbb1119c04e46c1bcfbf3fae20935e6&query=random")
# echo $giphy_response

# # Extract the Random URL from the Giphy response
# gif_url=$(echo "$giphy_response" | jq --raw-output .images[0].url)
# echo $gif_url

# Create a comment with the GIF on the pull request
comment_response=$(curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d "{\"body\": \"### PR - #$pull_request_number has been assigned. \n ![GIF]($gif_url) \n ### 🎉 Thank you for this contribution!\"}" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pull_request_number/comments")

# Extract and print the comment URL from the comment response
comment_url=$(echo "$gif_url")
echo "Comment URL: $comment_url"
