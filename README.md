# GUAva
GUAva is a YouTube speech corpus (currently under development) based on the Growing Up Asian American (GUA) video tag. It will be used to study language variation in Asian North American individuals.

The GUAva corpus is created and processed via the [LingTube](https://github.com/Narquelion/LingTube) suite of tools for linguistic analysis of YouTube data. It is being developed alongside [LingTube](https://github.com/Narquelion/LingTube) and the [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) pipeline, a branch of LingTube specifically for doing phonetic speech research on YouTube-sourced audio. This repo therefore also serves as an example of how one could use the [LingTube](https://github.com/Narquelion/LingTube) and/or [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) tools.

## Table of Contents
* [Corpus Details](#corpus-details)
* [Corpus Processing Guidelines](#corpus-processing-guidelines)

## Corpus Details

The process of the corpus creation and processing is roughly as follows:
1. Identify specific video urls, listed in the [urls](./urls) directory (currently grouped in "sets" per regional and ethnic background)
2. For each video, download the audio and English subtitles using `yt-tools/scrape-videos.py` into [raw_audio](./corpus/raw_audio) and [raw_subtitles](./corpus/raw_subtitles)
3. (optional) Correct raw subtitles files (especially auto-subs) with the help of `yt-tools/correct-captions.py`
4. Run conversion scripts to prepare audio (`youspeak/convert-audio.py`) and subtitles (`youspeak/clean-subtitles.py`) to formats amenable to processing
5. Chunk the long audio files into short (<10 sec) segments based on pauses/breath breaks using `youspeak/chunk-audio.py`—a necessary and/or useful step for transcription and forced alignment
6. Classify each clip as usable or not (i.e., clear speech without noise, music, etc.) and confirm transcriptions for each segment of speech using `youspeak/validate-chunks.py`, which opens a GUI
7. Match transcriptions to audio in TextGrid format with `youspeak/create-textgrids.py`
8. Conduct forced alignment using the Montreal Forced aligner, then do manual correction of alignment boundaries (with the help of `adjust-textgrids.py`)

## Corpus Processing Guidelines
* [Transcript Correction Guidelines](#transcript-correction-guidelines)
* [Chunk Classification Guidelines](#chunk-classification-guidelines)
* [Phonetic Coding Guidelines](#phonetic-coding-guidelines)
* [Acoustic Segmentation Guidelines](#acoustic-segmentation-guidelines)

---

### Transcript Correction Guidelines

Listen once through—don’t spend too much time on this stage.

#### Basics:
* Fix incorrectly transcribed words.
* Add or keep punctuation at the end of sentence/utterance boundaries (i.e., periods, question marks, etc.)
  * Don’t worry about commas, but don’t remove if it’s there.
* If there is a mispronunciation (with the intended meaning clear based on context), transcribe as the intended word and add an asterisk (*). If in doubt, transcribe as it sounds.
  * e.g., _when I say* this..._ where "say" is pronounced like "see"
* If false start or single incomplete word, add a hyphen (-).
  * e.g., "I- I don't even remember..."
  * e.g., "I mean li- like I don't know"
* If incomplete sentence/phrase (fragment), add hyphen-period (-.)
  * e.g., "So I mean-. I mean I was born in California, more specifically the Bay Area.""
  * e.g., "I don't even li-. I don't like these okay?"
* Remove anything not actually said (e.g., joke subs, sound effects, commentary).

#### Details:
* Add or keep filler words (e.g., like, um, uh).
* For colloquial pronunciations, replace standard/full forms with phonetically-accurate versions (i.e., represent how things are actually pronounced!).
  * e.g., _'cause_ for "_because_" or _'til_ for "_until_"
  * e.g., _just feels a little..._ for "_it just feels at little..._"
  * e.g., _wanna_ for "_want to_" or _dunno_ for "_don't know_"
* For acronyms, capitalize all letters; don’t add periods (e.g., AM, PM, LA, FIDM).
  * Otherwise, don’t worry about capitalization (i.e., don’t change whatever’s there).

#### Other:
* For unidentifiable words, replace with `<unk>` (for unknown).
* For words/utterances in another language, if you can’t identify the words, replace with `<cs>` (for code switch).
  * Can transcribe non-English words (e.g., in that language or romanization) but not necessary and don’t spend extra time on this.
* For laughs not overlapping with speech, add in `<lgh>` (for laugh).
* For any sound effects not overlapping with speech (e.g., transition ring, bell, noise, etc.), add in `<sfx>` (for sound effect).

---

### Chunk Classification Guidelines

#### Music:
1. If no music in background, *usability*=1
2. If very quiet/slight music in background, *usability*=1 and *speech + music*=1
3. If clear/moderate to loud music in background, *usability*=0 and *speech + music*=1
4. If only music, *usability*=0 and *music only*=1

#### Noise:
1. If no background noise, *usability*=1
2. If slight noisiness, *usability*=1 and *speech + noise*=1
3. If clear/moderate to loud noise in background (e.g., traffic, fan, etc.),  *usability*=0 and *speech + noise*=1
4. If only noise and no speech (incl. loud breath only), *usability*=0 and *noise only*=1

_More details coming soon!_

---

### Phonetic Coding Guidelines

#### Basics
* Keep and/or add any missing filler words.
  - e.g., _um_, _uh_, _like_
* Keep proper names and acronyms as is.
  - e.g., _FIDM_ for [fɪdm]; _LA_ for [ɜleɪ]
* Write out numerals in words, including years.
  - e.g., _twenty ten_ for __2010__
* If there is a clearly separate laugh, should be marked as `<lgh>`.
* Otherwise, can ignore loud breaths or laughs, including those overlapping with speech.

#### Code-switching
* If there is code-switching completely to a different language and words are not identifiable, should be marked as `<cs>`.
* If a word is identifiable but a code-switch (e.g., pronounced using non-English phonology), mark it with a `_cs` tag (for code-switch).
  * If you know the language/word, can transcribe non-English words (in orthography or romanization). It may also be in manual captions already.
    - e.g., _kare_cs rice_cs_ for 'kare rice' pronounced with Korean phonology
* If the word is a non-English word (e.g. loanword) but clearly pronounced with English phonology, don't tag it.
  * If unsure, be conservative and tag it as a code-switch.

#### Unclear, Unnatural or Other Speech
* If you can't make out a word, should be marked as `<unk>`.
* If, out of an otherwise good audio chunk, there is an individual word or two that cannot be used, mark it with a `_unc` tag (for unclear).
  * This could be if a word is masked by a noise, overlapping with a sound effect or has some other issue that prevents it from being clear. If unsure which word was affected, be conservative and tag more.
    - e.g., _kare_unc_ for 'kare rice' overlapped with a 'pop' sound effect
    - e.g., _and_unc it's_unc_ for 'and it's' with a pop but not sure exactly when
    - e.g., _Amy_unc and_unc_ for 'Amy and' with cheering noises
* If a phrase or word is not produced naturally, such as imitating somebody else or doing some sort of skit, mark it with a `_unn` (for unnatural).
  - e.g., _Jennifer_unn packed_unn..._ during an imitation
* If some speech is altered (e.g., pitch raising, sped up) or includes other voices (e.g., someone else speaking), also mark it with `_unn`.
* If there are multiple issues, that require tags, tag them all.
  - e.g., _kare_cs_unc_ is a code-switch overlapped with a 'pop' sound

---

### Acoustic Segmentation Guidelines
_More details coming soon!_
