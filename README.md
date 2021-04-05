# GUAva
GUAva is a YouTube speech corpus (currently under development) based on the Growing Up Asian American (GUA) video tag. It will be used to study language variation in Asian North American individuals.

The GUAva corpus is created and processed via the [LingTube](https://github.com/Narquelion/LingTube) suite of tools for linguistic analysis of YouTube data. It is being developed alongside LingTube and the [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) pipeline, a branch of LingTube specifically for doing phonetic speech research on YouTube-sourced audio. This repo therefore also serves as an example of how one could use the LingTube/YouSpeak tools.

## Table of Contents
* [Corpus Details](##-corpus-details)
* [Coding Guidelines](##-coding-guidelines)
* [Transcription Guidelines](##-transcription-guidelines)

## Corpus Details

The process of the corpus creation and processing is roughly as follows:
1. Identify specific GUA video urls, listed in the [urls](./urls) directory (currently grouped in "sets" per regional and ethnic background)
2. For each video, download the audio and English subtitles using `yt-tools/scrape-videos.py` into raw_audio and [raw_subtitles](./corpus/raw_subtitles)
3. (optional) Correct and/or annotate raw subtitles files (especially auto-subs) with the help of `yt-tools/correct-subtitles.py`
4. Run conversion scripts to prepare audio (`youspeak/convert-audio.py`) and subtitles (`youspeak/convert-subtitles.py`) to formats amenable to processing
5. Chunk the long audio files into short (<10 sec) segments based on pauses/break breaks (`youspeak/chunk-audio.py`)—necessary and/or useful for transcription and forced alignment
6. Code each clip as usable or not (i.e., clear speech without noise, music, etc.) and confirm transcriptions for each segment of speech using a GUI (`youspeak/classify-chunks.py`)
7. Match transcriptions to audio in TextGrid format (`youspeak/create-textgrids.py`)
8. Conduct forced alignment using the Montreal Forced aligner, and do manual correction of alignment boundaries


## Coding Guidelines

More details coming soon!

## Transcription Guidelines
