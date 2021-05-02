# GUAva
GUAva is a YouTube speech corpus (currently under development) based on the Growing Up Asian American (GUA) video tag. It will be used to study language variation in Asian North American individuals.

The GUAva corpus is created and processed via the [LingTube](https://github.com/Narquelion/LingTube) suite of tools for linguistic analysis of YouTube data. It is being developed alongside [LingTube](https://github.com/Narquelion/LingTube) and the [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) pipeline, a branch of LingTube specifically for doing phonetic speech research on YouTube-sourced audio. This repo therefore also serves as an example of how one could use the [LingTube](https://github.com/Narquelion/LingTube) and/or [YouSpeak](https://github.com/Narquelion/LingTube/tree/main/youspeak) tools.

## Table of Contents
* [Corpus Details](#corpus-details)
* [Corpus Processing Guidelines](#corpus-processing-guidelines)

## Corpus Details

The process of the corpus creation and processing is roughly as follows:

### Scrape YouTube
1. Identify specific video urls, listed in the [lists](./lists) directory (currently grouped in "sets" per ethnic background) and run `yt-tools/scrape-channels.py` to get channel info along with urls in [screened_urls](./corpus/screened_urls)
2. For each video, download the audio and English captions using `yt-tools/scrape-videos.py` into [raw_audio](./corpus/raw_audio) and [raw_subtitles](./corpus/raw_subtitles)

### Process text
3. Convert captions (`tx-tools/clean-captions.py`) to a neater format and partially clean text
4. (optional) Correct raw captions files with the help of `tx-tools/correct-captions.py`

### Process audio
5. Run conversion script to prepare audio (`youspeak/convert-audio.py`) in format amenable to processing (i.e., mono WAV files)
6. Chunk the long audio files into short (<10 sec) segments based on pauses/breath breaks using `youspeak/chunk-audio.py`—a necessary and/or useful step for transcription and forced alignment

### Process text + audio
7. Classify each clip as usable or not (i.e., clear speech without noise, music, etc.) and confirm transcriptions for each segment of speech using `youspeak/validate-chunks.py`, which opens a GUI
8. Match transcriptions to audio in TextGrid format with `youspeak/create-textgrids.py`
9. Conduct forced alignment using the Montreal Forced aligner, then do manual correction of alignment boundaries (with the help of `adjust-textgrids.py`)

## Corpus Processing Guidelines
* [Transcript Correction Guidelines](#transcript-correction-guidelines)
* [Chunk Classification Guidelines](#chunk-classification-guidelines)
* [Phonetic Coding Guidelines](#phonetic-coding-guidelines)
* [Acoustic Segmentation Guidelines](#acoustic-segmentation-guidelines)

---
### How to Use Scripts

For the purposes of the GUAva corpus, this is how the LingTube scripts will be used to do hand-correction during corpus processing. In most cases, the only parameter that must be specified is the group (i.e., ethnicity grouping code), though a specific channel can be specified for some.

#### Correcting Captions

To run the caption correction script that opens the YouTube video in a web browser and a copy of the raw transcript file in a text editor, the command is `path/to/correct-captions.py -g $GROUP [-ch $CHANNEL]`

* e.g. To go through all the captions of the Korean (kor) group in order, run `../LingTube/tx-tools/correct-captions.py -g kor`

* e.g. To go through all the files for a particular channel (e.g., AMYLEE), run `../LingTube/tx-tools/correct-captions.py -g kor -ch AMYLEE`


#### Validating Audio Chunks

To run the audio chunk validation script for (i) classifying whether a chunk is usable or not, and (ii) matching the transcription to the audio, the command is `path/to/validate-chunks.py -g $GROUP`

* e.g. To validate a file in the Korean group, run `../LingTube/youspeak/validate-chunks.py -g kor`

A pop-up file window will then ask you to select to a chunking log file (for a particular video) to begin the process.

#### Adjusting Alignment Boundaries

To run the textgrid alignment adjustment script that opens a Praat with the appropriate directories in place, the command is `path/to/adjust-textgrids.py -g $GROUP [-ch $CHANNEL]`

* e.g. To go through all the channels in Korean (kor) group in order, run `../LingTube/youspeak/adjust-textgrids.py -g kor`

* e.g. To go through all the files for a particular channel (e.g., AMYLEE), run `../LingTube/youspeak/adjust-textgrids.py -g kor -ch AMYLEE`

---

### Transcript Correction Guidelines

Listen once through—don’t spend too much time on this stage.

#### Basics:
* Remove anything not actually said (e.g., joke subs, sound effects, commentary).
* Fix incorrectly transcribed words.
* If there is a mispronunciation (with the intended meaning clear based on context), transcribe as the intended word and add an asterisk (*). If in doubt, transcribe as it sounds.
  * e.g., _when I say* this..._ where "say" is pronounced like "see"
* If false start or single incomplete word, add a hyphen (-).
  * e.g., "I- I don't even remember..."
  * e.g., "I mean li- like I don't know"

<!--
#### Optional
* If incomplete sentence/phrase (fragment), add hyphen-period (-.)
  * e.g., "So I mean-. I mean I was born in California, more specifically the Bay Area."
  * e.g., "I don't even li-. I don't like these so"
* Add or keep punctuation at the end of sentence/utterance boundaries (i.e., periods, question marks, etc.)
  * Don’t worry about commas, but don’t remove if it’s there.
-->

#### Details:
* Add or keep filler words (e.g., like, um, uh, you know).
* For colloquial pronunciations, replace standard/full forms with phonetically-accurate versions (i.e., represent how things are actually pronounced!).
  * e.g., _'cause_ for "_because_" or _'til_ for "_until_"
  * e.g., _just feels a little..._ for "_it just feels at little..._"
  * e.g., _wanna_ for "_want to_", _dunno_ for "_don't know_", _y'know_ for "_you know_"
* For acronyms, capitalize all letters; don’t add periods (e.g., AM, PM, LA, FIDM, UCLA, US).
  * Otherwise, don’t worry about capitalization (i.e., don’t change whatever’s there).
* For numerals (including times and years), write out pronunciation in words.
  * e.g., _a hundred_ or _one hundred_ for 100
  * e.g., _five AM_ for 5:00 a.m.
  * e.g., _twenty four seven_ for 24/7
  * e.g., _twenty ten_ for "2010"

#### Other:
* For unidentifiable words, replace with `<unk>` (for unknown).
* For words/utterances in another language, if you can’t identify the words, replace with `<cs>` (for code switch).
  * Can transcribe non-English words (e.g., in that language or romanization) but not necessary and don’t spend extra time on this.
    * e.g., _kare rice_ for 'kare rice' pronounced with Korean phonology
* For laughs not overlapping with speech, add in `<lgh>` (for laugh).
* For any sound effects not overlapping with speech (e.g., transition ring, bell, noise, etc.), add in `<sfx>` (for sound effect).

---

### Chunk Classification Guidelines

#### Usable?

1. Check the box for "Yes" if audio clip is usable, meaning it contains clear, "natural" speech in English, with no (or minimal) background sounds or noise.

Here are a list of potential issues that would render a section of speech unusable for the purposes this project:
* background music
* background noise (e.g., fan, traffic, city noises)
* multiple speakers (e.g., overlapping speech with other people)
* another speaker's voice (e.g., a media clip or meme, a friend in the video)
* altered voice (e.g., sped up, slowed down, higher pitch)
* non-English speech (code-switching)
* "unnatural" or "atypical" speech (e.g., performance/skit, imitation, "putting on a voice")
* environmental noises (e.g., shuffling, placing something on a table, clapping)
* sound effects (e.g., cheer, clap, pop, swish)

2. If the clip includes very quiet ambient sounds, like very low music or some small degree of noticeable noise, can still check "Yes" if it seems usable (i,e., loud and clear, natural, etc.), but additionally check off any relevant Main Issues box(es).
3. If only a portion of the clip contains any of the above issues (e.g., a specific word or the first half of the clip), check off "Yes" along with any relevant Main Issues box(es) and see Phonetic Coding Guidelines below for how to mark these issues in the transcript.
4. If the vast majority or entire clip contains any combination of above issues, only check off the relevant relevant Main Issues box(es) and do not check "Yes".

#### Main Issues: With Speech
* **Speech + music:** Speech with any form of background music
* **Speech + noise:** Speech with any form of background noise
* **Other / altered voice:** Speech with a voice or multiple voices other than the speaker, the altered voice of the speaker, or the speaker "putting on a voice"

#### Main Issues: Not Speech
* **Music only:** A period of music but no speech overlapping (often at beginning and ends of videos, as well as some transition periods)
* **Noise:** A period of non-speech ("silence") with audible noisiness (e.g., a loud breath, background traffic noise)
* **Other sounds:** Any other case of a non-speech sound, including sound effects and environmental noises

If an issue that affects the whole clip doesn't fit into any of these categories (e.g., code-switching), simply don't check any box.

---

### Phonetic Coding Guidelines

#### Basics
* Fix any of the following:
    - missing filler words should be added (_um_, _uh_, _like_)
    - numerals should be written in number words (e.g., _a hundred_ or _one hundred_ for "100")
    - acronyms or abbreviations should be all caps without periods (e.g., _LA_ not "l.a.", "la", or "L.A.")
    - colloquial pronunciations should be as pronounced (e.g., _'cause_, _'til_, _wanna_, _dunno_, _y'know_)
    - mispronounced words should have a following asterisk (e.g., _dad*_ pronounced like "daah", _place*_ pronounced like "splace")
    - hyphenated words should have NO hyphens (e.g., _twenty nine_ not "twenty-nine", _self conscious_ not "self-conscious", _cooccur_ not "co-occur")
    - cut-off words, either as produced by the speaker or artificially via the chunking process, SHOULD have a following hyphen (e.g., _li-_ for cut-off "like") even when the initial part is cut off (e.g., _tion-_ for cut-off "action"). Alternatively, can use preceding apostrophe-hyphen notation (e.g., _'-tion') but NOT only preceding hyphen.
    - sound effects (e.g., swish, ding) not overlapping with speech, should be marked with `<sfx>`
    - laughs not overlapping with speech should be marked with `<lgh>`

#### Code-switching
* If there is code-switching completely to a different language and words are not identifiable, should be marked as `<cs>`.
* If a word is identifiable but a code-switch (e.g., pronounced using non-English phonology), mark it with a `_cs` tag (e.g., _kare_cs rice_cs_)
* If the word is a non-English word (e.g. loanword) but clearly pronounced with English phonology, don't tag it. If unsure, leave as is for later decision.

#### Unclear, Unnatural or Other Speech
* If you can't make out a word, should be marked as `<unk>`.
* If, out of an otherwise good audio chunk, there is an individual word or two that cannot be used, mark it with a `_unc` tag (for unclear).
  * This could be if a word is masked by a noise, overlapping with a sound effect or has some other issue that prevents it from being clear.
    - e.g., _kare_unc_ for 'kare rice' overlapped with a 'pop' sound effect
    - e.g., _Amy_unc and_unc_ for 'Amy and' with cheering noises
* If some speech is altered (e.g., pitch raising, sped up) or includes other voices (e.g., someone else speaking), mark it with `_unn` (for unnatural).
  - e.g., _what_unn do_unn you_unn mean_unn_ with sped up speech
* If a phrase or word is otherwise not produced in the speaker's "natural" voice, such as imitating somebody else or doing some sort of skit, also mark it with a `_unn` (for unnatural).
  - e.g., _Jennifer_unn packed_unn..._ during an imitation
* If there are multiple issues, that require tags, tag them all.
  - e.g., _kare_cs_unc_ is a code-switch overlapped with a 'pop' sound
* If unsure what words are affected (e.g., if you hear clicks but don't know whether and where it overlaps with speech), leave as is for later decision.

---

### Acoustic Segmentation Guidelines
_More details coming soon!_
