final apiKey = '626qjYrqII1ZuqIMUUtIWQa19lo3g4Wo';

String getUrlSearch(String search, int limit, int offset) => 'https://api.giphy.com/v1/gifs/search?api_key=$apiKey&q=$search&limit=$limit&offset=$offset&rating=G&lang=en';
String getUrlTrending(int limit) => 'https://api.giphy.com/v1/gifs/trending?api_key=$apiKey&limit=$limit&rating=G';