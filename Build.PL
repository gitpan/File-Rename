use strict;
use Module::Build;
use File::Spec;
my $script = File::Spec->catfile( 'script',
		Module::Build->os_type eq 'Windows'  
			? 'file-rename' : 'rename' );

Module::Build -> new (
	license		=> 'perl',	
	script_files	=> [ $script ],
	module_name	=> 'File::Rename',
	PL_files	=> { 'rename.PL' => $script },
	#   create_makefile_pl	=> 'traditional'
	
) -> create_build_script;
	 
