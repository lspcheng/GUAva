# GUAva
GUAva is a YouTube speech corpus (currently under development) based on the Growing Up Asian American (GUA) video tag. It will be used to study language variation in Asian North American individuals.

The GUAva corpus is created and processed via the [LingTube](https://github.com/Narquelion/LingTube) suite of tools for linguistic analysis of YouTube data. It is being developed alongside [LingTube](https://github.com/Narquelion/LingTube) and the [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) pipeline, a branch of LingTube specifically for doing phonetic speech research on YouTube-sourced audio. This repo therefore also serves as an example of how one could use the [LingTube](https://github.com/Narquelion/LingTube) and/or [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) tools.

## Table of Contents
* [Corpus Details](#corpus-details)
* [Coding Guidelines](#coding-guidelines)
* [Transcription Guidelines](#transcription-guidelines)

## Corpus Details

The process of the corpus creation and processing is roughly as follows:
1. Identify specific GUA video urls, listed in the [urls](./urls) directory (currently grouped in "sets" per regional and ethnic background)
2. For each video, download the audio and English subtitles using `yt-tools/scrape-videos.py` into [raw_audio](./corpus/raw_audio) and [raw_subtitles](./corpus/raw_subtitles)
3. (optional) Correct and/or annotate raw subtitles files (especially auto-subs) with the help of `yt-tools/correct-subtitles.py`
4. Run conversion scripts to prepare audio (`youspeak/convert-audio.py`) and subtitles (`youspeak/convert-subtitles.py`) to formats amenable to processing
5. Chunk the long audio files into short (<10 sec) segments based on pauses/breath breaks using `youspeak/chunk-audio.py`—a necessary and/or useful step for transcription and forced alignment
6. Code each clip as usable or not (i.e., clear speech without noise, music, etc.) and confirm transcriptions for each segment of speech using `youspeak/classify-chunks.py`, which opens a GUI
7. Match transcriptions to audio in TextGrid format with `youspeak/create-textgrids.py`
8. Conduct forced alignment using the Montreal Forced aligner, and do manual correction of alignment boundaries


## Coding Guidelines

For music:
1. If no music in background, *usability*=1
2. If very quiet/slight music in background, *usability*=1 and code *speech + music*
3. If clear/moderate to loud music in background, *usability*=0 and code *speech + music*
4. If only music, *usability*=0 and code *music only*

More details coming soon!

## Transcription Guidelines
* **Include filler words/syllables** to be phonetically accurate, e.g:
  - _um_
  - _uh_
  - _like_

* **Likewise, prefer to be phonetically accurate for colloquial pronunciations rather than standard/full pronunciations.** Can be added to dictionary if not already there. Or, if unstressed words are barely pronounced (or if they were cut off because they were very low amplitude/missing), they can't be analyzed anyway.
  - _'cause_ rather than __because__ for [kəz]
  - _'til_ rather than __until__
  - _just feels a little..._ rather than __it just feels...__

* **Transcribe false starts/parts of words as is phonetically**, to ensure all phonetic detail is accounted for. **Use a hyphen to mark this (will be stripped by forced aligner later).** If full/real word, will be identified correctly in forced alignment. If not full/actual word, will be identified as unknown, which is fine. Other cases should be rare.
    - _I- I_ when repeated start as in "I- I don't even remember..."
    - _lai- laid_

* **But, if suspect artificially missing onset or offset fricative due to pre-processing (i.e., chunking procedure), transcribe full word.** This ensures that we can still use the bulk of the word as well as accurately code for phonological environment (that actually existed in reality, though it didn't make it into the clip accidentally). This assumes that we don't need to look at/analyze those fricatives.
    - _this_ for something like [θɪ] at the end of a clip with very abrupt cut off
