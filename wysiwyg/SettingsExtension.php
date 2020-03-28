
error_reporting( -1 );
ini_set( 'display_errors', 1 ); 
$wgShowExceptionDetails = true;

# Default user options:
$wgDefaultUserOptions['riched_disable']               = false;
$wgDefaultUserOptions['riched_start_disabled']        = true;
$wgDefaultUserOptions['riched_use_toggle']            = true; 
$wgDefaultUserOptions['riched_use_popup']             = false;
$wgDefaultUserOptions['riched_toggle_remember_state'] = true;
$wgDefaultUserOptions['riched_link_paste_text']       = true;

// MW>=1.26 and versions of WYSIWYG >= "1.5.6_0 [B551+02.07.2016]"
wfLoadExtension( 'WYSIWYG' );

// MW>=1.26 and versions of WYSIWYG >= "1.5.6_0 [B551+02.07.2016]" has dependency
// to module of WikiEditor so it must be enabled too (or otherwise file
// extension.json has to be edited manually to remove dependency)
wfLoadExtension( 'WikiEditor' );