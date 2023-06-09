import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:project_one_tuneup/NowPlaying/now_playing.dart';
import 'package:project_one_tuneup/controller/getallsongs_controller.dart';
import 'package:project_one_tuneup/model/model.dart';
import 'package:project_one_tuneup/playlist/playlist_song.dart';

class PlaylistToAddsong extends StatefulWidget {
  const PlaylistToAddsong(
      {super.key, required this.sindex, required this.playlist});
  final int sindex;
  final PlayModel playlist;

  @override
  State<PlaylistToAddsong> createState() => _PlaylistToAddsongState();
}

class _PlaylistToAddsongState extends State<PlaylistToAddsong> {
  @override
  Widget build(BuildContext context) {
    late List<SongModel> songplaylist;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 12, 25),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 5, 12, 25),
        elevation: 15,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white60,
            )),
        title: Text(
          widget.playlist.name,
          style: GoogleFonts.orbitron(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Column(children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(12),
            child: ValueListenableBuilder(
              valueListenable: Hive.box<PlayModel>('playlistDB').listenable(),
              builder:
                  (BuildContext context, Box<PlayModel> song, Widget? child) {
                songplaylist =
                    listplaylist(song.values.toList()[widget.sindex].songid);
                return songplaylist.isEmpty
                    ? Center(
                        child: Text(
                        'Add Songs',
                        style: GoogleFonts.orbitron(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white60),
                      ))
                    : ListView.builder(
                        itemCount: songplaylist.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: QueryArtworkWidget(
                              type: ArtworkType.AUDIO,
                              id: songplaylist[index].id,
                              artworkHeight: 60,
                              artworkWidth: 60,
                              nullArtworkWidget: Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: const Icon(
                                    Icons.music_note,
                                    color: Colors.white60,
                                  )),
                              artworkBorder: BorderRadius.circular(10),
                              artworkFit: BoxFit.cover,
                            ),
                            title: Text(songplaylist[index].title,
                                maxLines: 1,
                                style: const TextStyle(color: Colors.white70)),
                            subtitle: Text(
                              songplaylist[index].artist!,
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 1,
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  widget.playlist
                                      .deletedata(songplaylist[index].id);
                                },
                                icon: const Icon(Icons.delete_outline,
                                    color: Color.fromARGB(255, 224, 86, 76))),
                            onTap: () {
                              Getallsongs.audioPlayer.setAudioSource(
                                  Getallsongs.createsongslist(songplaylist),
                                  initialIndex: index);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NowPlayingScreen(
                                      songmodel: songplaylist,
                                      count: songplaylist.length,
                                    ),
                                  ));
                            },
                          ),
                        ),
                      );
              },
            ),
          ))
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Playlistsongdisplayscreen(
                        playlist: widget.playlist,
                      )));
        },
        label: Text(
          'Add Songs',
          style: GoogleFonts.orbitron(),
        ),
      ),
    );
  }

  List<SongModel> listplaylist(List<int> data) {
    List<SongModel> playsong = [];
    for (int i = 0; i < Getallsongs.copysong.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (Getallsongs.copysong[i].id == data[j]) {
          playsong.add(Getallsongs.copysong[i]);
        }
      }
    }

    return playsong;
  }
}
