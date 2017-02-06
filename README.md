# MovieViewer
Code Path Week 1 Assignment
FlicksApp is a movie viewing application for iOS.

Submitted by: Palak Jadav

## User Stories

The following **required** functionality is complete:

1. User can view a list of movies currently playing in theaters from The Movie Database.
2 .Poster images are loaded using the UIImageView category in the AFNetworking library.
3. The movie poster is available by appending the returned poster_path to https://image.tmdb.org/t/p/w342.
4. User sees a loading state while waiting for the movies API (you can use any 3rd party library available to do this).
5. User can pull to refresh the movie list.

The following **additional** features are implemented:

1. User sees an error message when there's a networking error. You may not use UIAlertController or a 3rd party library to display the error.
2. Movies are displayed using a CollectionView instead of a TableView.
3. All images fade in as they are loading. However, each cell is not loading one after the other, the entire movie cell is loading with animation

GIF created with [LiceCap](http://www.cockos.com/licecap/).

http://i.imgur.com/fMTFm2K.gif
