class Song
    attr_accessor :name
    attr_reader :artist, :genre
    @@all = []
    def initialize(name, artist = nil, genre = nil)
        @name = name
        self.artist = artist if artist
        self.genre = genre if genre
        
    end
    def artist=(artist)
        @artist = artist
        artist.add_song(self)
    end
    def genre=(genre)
        @genre = genre
        genre.songs << self unless genre.songs.include?(self)
    end
    def self.all
        @@all
    end
    def self.destroy_all
        all.clear
    end
    def save
        self.class.all << self
    end
    def self.create(name)
        artist = new(name)
        artist.save
        artist
    end
    def self.find_by_name(name)
        all.detect{|i| i.name == name}
    end
    def self.find_or_create_by_name(name)
        find_by_name(name) || create(name)
    end
    def self.new_from_filename(filename)
        items = filename.split(" - ")
        artist_name, song_name, genre_name = items[0], items[1], items[2].gsub(".mp3", "")
        artist = Artist.find_or_create_by_name(artist_name)
        genre = Genre.find_or_create_by_name(genre_name)
        new(song_name, artist, genre)
    end
    def self.create_from_filename(filename)
        new_from_filename(filename).tap{|i| i.save}
    end
end