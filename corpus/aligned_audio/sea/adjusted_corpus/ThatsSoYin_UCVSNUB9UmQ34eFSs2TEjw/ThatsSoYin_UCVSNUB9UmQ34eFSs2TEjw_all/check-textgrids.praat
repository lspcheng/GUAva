## text grid reviewer.praat
## Originally created by the excellent Katherine Crosswhite
## Script modified by Mark Antoniou
## MARCS Auditory Laboratories C 2010
## Script modified by Lauretta Cheng 2021

##  This script opens all the sound files in a given directory, plus
##  their associated textgrids so that you can review/change the
##  boundaries or labels.

form Enter directory and search string
# Be sure not to forget the slash (Windows: backslash, OSX: forward
# slash)  at the end of the directory name.
	sentence Directory ./audio/
	sentence Tg_directory ./queue/skipped/
	sentence Queue_directory ./queue/
#  Leaving the "Word" field blank will open all sound files in a
#  directory. By specifying a Word, you can open only those files
#  that begin with a particular sequence of characters. For example,
#  you may wish to only open tokens whose filenames begin with ba.
	sentence Vowel_number 
	sentence Filetype wav
	boolean Textgrid_reference 1
endform

if textgrid_reference = 0
	Create Strings as file list... list 'directory$'*'vowel_number$'*'filetype$'
else
	Create Strings as file list... list 'tg_directory$'*'vowel_number$'*TextGrid
endif

#pause # debugging pause

number_of_files = Get number of strings
for x from 1 to number_of_files
     select Strings list
     current_file$ = Get string... x
		printline 'current_file$'

	 #basename$ = current_file$ - ".wav"
	 #printline 'basename$'
	 
	 if textgrid_reference = 0
		Read from file... 'directory$''current_file$'
     	object_name$ = selected$ ("Sound")
    	 Read from file... 'tg_directory$''object_name$'.TextGrid
     	plus Sound 'object_name$'
	 else
		Read from file... 'tg_directory$''current_file$'
		object_name$ = selected$ ("TextGrid")
		appendInfoLine: directory$ + object_name$ + "." + filetype$
		go_to_next = 0
		printline 'go_to_next'
		if fileReadable: directory$ + object_name$ + "." + filetype$
    	 	Read from file... 'directory$''object_name$'.'filetype$'
			plus TextGrid 'object_name$'
		else
			go_to_next = 1
		endif
	 endif
	printline 'go_to_next'
	if go_to_next = 1
		Remove
		#pause
	else
     Edit
	 beginPause: "Edit Text Grid"
     clicked = endPause: "Quit", "Skip", "Done", 3, 1
	 if clicked = 1
		endeditor
		select all
		Remove
		exitScript ()
	 elsif clicked = 2
		select TextGrid 'object_name$'
		Remove
		select Sound 'object_name$'
		Write to WAV file... 'tg_directory$''object_name$'.wav
		Remove
		filedelete 'directory$''object_name$'.wav
	 elsif clicked = 3
		# Now save the result
		select TextGrid 'object_name$'
		Write to text file... 'queue_directory$''object_name$'.TextGrid
		Remove
		select Sound 'object_name$'
		Write to WAV file... 'queue_directory$''object_name$'.wav
		Remove
		# Delete file
		filedelete 'tg_directory$''object_name$'.Textgrid
		filedelete 'directory$''object_name$'.wav
	 endif

	 endeditor

	 #pause  Make any changes then click Continue. 
     #minus Sound 'object_name$'
     #Write to text file... 'tg_directory$''object_name$'.TextGrid

     #select all
     #minus Strings list
     #Remove
	endif
endfor

select Strings list
Remove
clearinfo
printline TextGrids have been reviewed.

# for 'vowel_number$' .'filetype$' files in 
#printline 'directory$'.

## written by Katherine Crosswhite
## crosswhi@ling.rochester.edu
