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

_More details coming soon!_

## Transcription Guidelines
* **Include filler words/syllables.**
  - _um_
  - _uh_
  - _like_

* **Likewise, prefer to be phonetically accurate for colloquial pronunciations rather than standard/full pronunciations.**
  - _'cause_ rather than __because__ for [kəz]
  - _'til_ rather than __until__
  - _just feels a little..._ rather than __it just feels...__

* **Transcribe false starts/parts of words as is phonetically**, to ensure all phonetic detail is accounted for. **Use a hyphen to mark this (will be stripped by forced aligner later).**
    - _I- I_ when repeated start as in "I- I don't even remember..."
    - _lai- laid_

* **But, if suspect artificially missing onset or offset fricative due to pre-processing (i.e., chunking procedure), transcribe full word.**
    - _this_ for something like [θɪ] at the end of a clip with very abrupt cut off

* **Also, if there is what seems to be a mispronunciation of a word (with the intended meaning clear based on context), transcribe as the intended word. Use an asterisk to mark this (will be stripped by forced aligner later)**
  - _when I say* this..._ where "say" is pronounced like "see"

* **Write out numerals in words, including years.**
  - _two thousand and ten_ for __2010__

* **Keep proper names and acronyms as is.**
  - _FIDM_ for [fɪdm]
  - _LA_ for [ɜleɪ]

* **If you can make it out, include romanization of non-English words.** See next couple of points on code-switching.
  - _banchan_ for Korean side dishes

* **If there is code-switching to a different language completely, and you don't know what it is, code it as `<cs>`.**

* **If a word is a code switch but identifiable (e.g., pronounced using non-English phonology), code it with a '_cs' tag (for code-switch).** If the word is a non-English word (e.g. loanword) but clearly pronounced with English phonology, don't have to tag it as a code-switch. If unsure, tag it as a code-switch.
  - _kare_cs rice_cs_ for 'kare rice' pronounced with Korean phonology
  - _banchan_cs_

* **If you can't make out a word, code it as `<unk>`.** If you can't confirm whether the auto-transcription was correct or there wasn't anything there, this is what to do.

* **If, out of an otherwise good audio chunk, there is an individual word or two that cannot be used, mark it with a '_unc' tag (for unclear).** This could be if a word is masked by a noise, overlapping with a sound effect or has some other issue that prevents it from being clear. If unsure which word was affected, be conservative and tag more.
  - _kare_unc_ for 'kare rice' overlapped with a 'pop' sound effect
  - _and_unc it's_unc_ for 'and it's' with a pop but not sure exactly when
  - _Amy_unc and_unc_ for 'Amy and' with cheering noises

* **If a phrase or word is not produced naturally, such as imitating somebody else or doing some sort of skit, code it with a '_unn' (for unnatural).**
  - _Jennifer_unn packed_unn..._ during an imitation


* **If there are multiple issues, that require tags, code them all.**
  - _kare_cs_unc_

* **If there is a clearly separate laugh, code it as `<lgh>`.**

* **Otherwise, ignore loud breaths or laughs, including those overlapping with speech.**  These can be dealt with on a case-by-case basis during post-alignment hand-correction.
