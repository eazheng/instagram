# Project 4 - *Instagram*

**Instagram** is a photo sharing app using Parse as its backend.

Time spent: **22** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [x] User can use a tab bar to switch between all "Instagram" posts and posts published only by the user. AKA, tabs for Home Feed and Profile
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [ ] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post in home timeline and see number of likes for each post in the post details screen.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I would be interested in adding a feature such that a double tap on the image would be the same as tapping the like button to like a post.
2. It would be interesting to see the different ways in which everyone kept track of which user liked each photo and how many likes each photo had, as well as if anyone was able to create a comment feature that displayed a section for comments only if there were some which already existed.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

Creating a new account and adding a profile picture:
<img src='http://g.recordit.co/OBQ2vRiprK.gif' title='Video Walkthrough1' width='' alt='Video Walkthrough1' />


Posting a new pic and liking photos on timeline:

<img src='http://g.recordit.co/rLDakSB2qZ.gif' title='Video Walkthrough2' width='' alt='Video Walkthrough2' />

GIF created with [Recordit](http://www.recordit.co).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library


## Notes

Describe any challenges encountered while building the app.

One aspect of the app I found challenging was to figure out how to communicate with the Parse server, for example, finding the appropriate methods to set and save the data as well as query for the Post objects and extracting the needed information from there. Especially being unfamiliar with Heroku and the Parse package, it took a while to figure out how to make sure all the data from the app was being synced up with the server data.

## License

    Copyright [2019] [eazheng]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
