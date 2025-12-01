unit scConsts;

interface

const
  isComponentName = 'Professional Screen Camera Component';
  isVersion = '0.0.0.0';
  isHistory = 'Release 01/07/2020';
  DeletingMsg = 'Deleting Temp File';
  PreviewMsg = 'Preview... (Cancel=Esc)';
  RecordingMsg = 'Recording... (Cancel=Esc)--(Stop=Shift+Esc)--(Pause=Pause Key)';
  PauseMsg = 'Paused... (Press pause key to resume)';
  SavingMsg = 'Saving Video...';
  SavingSuccessMsg = 'Saving Success...';
  //error massages
  ErrorMsg1 = 'Unable to allocate memory for image';
  ErrorMsg2 = 'Unable to lock image handle at memory';
  ErrorMsg3 = 'Error retrieving image bits';
  ErrorMsg4 = 'Failure: Video for windows version too old!';
  ErrorMsg5 = 'Error capturing a frame from screen.';
  ErrorMsg7 = 'Error: This compressor cann`t work if the dimensions is adjusted slightly'
               + #13#10 + 'Use default compressor?';
  ErrorMsg8 = 'User aborted!';
  ErrorMsg9 = 'Error: Not recording AVI file using current compressor.'
               + #13#10 + 'Use default compressor?';
  ErrorMsg10 = 'You no selected compressor, use default compressor?';
  ErrorMsg11 = 'Can not delete video temp file.';
  ErrorMsg12 = 'Error on create AVI file.';
  ErrorMsg13 = 'Error on create AVI stream.';
  ErrorMsg14 = 'Error on compress AVI stream.';
  ErrorMsg16 = 'Error on set AVI stream format.';
  ErrorMsg17 = 'Can not delete audio temp file.';
  ErrorMsg19 = 'Error on write data to AVI stream.';
  ErrorMsg20 = 'Error creating AVI file with "MS Video Codec".';
  ErrorMsg21 = 'Can not delete existing video file.';
  ErrorMsg22 = 'Error: unsupported format!';
  ErrorMsg23 = 'Error: bad format!';
  ErrorMsg24 = 'Error: reading files!';
  ErrorMsg25 = 'Error: writing files!';
  ErrorMsg26 = 'Error: out of memory!';
  ErrorMsg27 = 'Error: internal error!';
  ErrorMsg28 = 'Error: bad flags!';
  ErrorMsg29 = 'Error: bad params!';
  ErrorMsg30 = 'Error: bad size!';
  ErrorMsg31 = 'Error: bad handle!';
  ErrorMsg32 = 'Error: opening files!';
  ErrorMsg33 = 'Error: in compressor!';
  ErrorMsg34 = 'Error: no compressor!';
  ErrorMsg35 = 'Error: read-only files!';
  ErrorMsg36 = 'Error: no data!';
  ErrorMsg37 = 'Error: buffer too small!';
  ErrorMsg38 = 'Error: cannot compress!';
  ErrorMsg39 = 'Error: user abort!';
  ErrorMsg40 = 'Error: generic!';
  ErrorMsg41 = 'Avi error number: ';
  ErrorMsg42 = 'The file could not be read, indicating a corrupt file or an unrecognized format.';
  ErrorMsg43 = 'The file could not be opened because of insufficient memory.';
  ErrorMsg44 = 'A disk error occurred while reading the stream file.';
  ErrorMsg45 = 'A disk error occurred while opening the stream file.';
  ErrorMsg46 = 'According to the registry, the type of stream file specified in AVIFileOpen does not have a handler to process it.';
  ErrorMsg47 = 'Unknown error opening stream file';
  ErrorMsg48 = 'Unable to get stream';
  ErrorMsg49 = 'Not exist file path.';
  ErrorMsg50 = 'In mode 8-bit or 16-bit with width image 1280 effect setting is not possible.';

implementation

end.


