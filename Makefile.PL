#
# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/GtkSpell/Makefile.PL,v 1.11 2003/09/22 00:45:59 rwmcfa1 Exp $
#

use 5.008;
use ExtUtils::MakeMaker;
use Cwd;
use File::Spec;

# minimum required version of dependancies we need to build
our %build_reqs = (
	'perl-ExtUtils-Depends'   => '0.1',
	'perl-ExtUtils-PkgConfig' => '0.1',
	'perl-Glib'               => '1.00rc2',
	'perl-Gtk2'               => '1.00rc2',
	'GtkSpell'                => '2.0.0',
);

# minimum required version of dependancies we need to run
our %runtime_reqs = (
	'GtkSpell'	=> undef,
);

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends;"
           . "use ExtUtils::PkgConfig;"
	   . "use Gtk2::CodeGen;"
           # just seeing if Glib is available isn't enough, make sure
           # it's recent enough, too 
           . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Gtk2 '$build_reqs{'perl-Gtk2'}';"
           . "1") {
   warn "$@\n";
   WriteMakefile(
         PREREQ_FATAL => 1,
         PREREQ_PM    => {
            Glib::                => $build_reqs{'perl-Glib'},
            Gtk2::                => $build_reqs{'perl-Gtk2'},
            ExtUtils::Depends::   => $build_reqs{'perl-ExtUtils-Depends'},
            ExtUtils::PkgConfig:: => $build_reqs{'perl-ExtUtils-PkgConfig'},
         },
   );
   exit 1; # not reached
}

my %pkgcfg = ExtUtils::PkgConfig->find('gtkspell-2.0 >= '
				       .$build_reqs{GtkSpell});

$runtime_reqs{GtkSpell} = $pkgcfg{modversion};

mkdir 'build', 0777;

# now we're ready to start creating the makefile.
# we need to use ExtUtils::Depends to get relevant information out of
# the Glib extension, and to save config information for other modules which
# will chain from this one.

$gtk2spell = ExtUtils::Depends->new ('GtkSpell', 'Gtk2', 'Glib');
$gtk2spell->set_inc ($pkgcfg{cflags});
$gtk2spell->set_libs ($pkgcfg{libs});
$gtk2spell->add_pm ('Spell.pm' => '$(INST_LIBDIR)/Spell.pm');
$gtk2spell->add_xs ('GtkSpell.xs');
my $cwd = cwd();
$gtk2spell->add_typemaps (map {File::Spec->catfile($cwd,$_)} 'gtkspell.typemap' );
$gtk2spell->add_headers ('gtk2spellperl.h');

$gtk2spell->install ('gtk2spellperl.h');
$gtk2spell->save_config ('build/IFiles.pm');

WriteMakefile(
    NAME          => 'Gtk2::Spell',
    VERSION_FROM  => 'Spell.pm',
    PREREQ_PM     => {},
    ABSTRACT_FROM => 'Spell.pm',
    XSPROTOARG    => '-noprototypes',
    $gtk2spell->get_makefile_vars,
);

#
# there's a bug in the MakeMaker output which results in .xs files in a
# subdirectory being turned into .o files in this dir.  the bug is a missing
# -o on the compiler command line.  this is a hackish fix for it.
#
package MY;
use Cwd;

sub const_cccmd {
	my $inherited = shift->SUPER::const_cccmd (@_);
	$inherited .= ' -o $@';
	$inherited;
}

sub postamble
{
	my @dirs = qw{rpms rpms/BUILD rpms/RPMS rpms/SOURCES
		      rpms/SPECS rpms/SRPMS};
	my $cwd = getcwd();

	my %subs = (
		'VERSION' => '$(VERSION)',
		'SOURCE' => '$(DISTNAME)-$(VERSION).tar.gz',
		'GTKSPELL_RUN' => $runtime_reqs{'GtkSpell'},
		'GTKSPELL' => $build_reqs{'GtkSpell'},
		'PERL_EXTUTILS_DEPENDS' => 
			$build_reqs{'perl-ExtUtils-Depends'},
		'PERL_EXTUTILS_PKGCONFIG' => 
			$build_reqs{'perl-ExtUtils-PkgConfig'},
		'PERL_GLIB' => $build_reqs{'perl-Glib'},
		'PERL_GTK' => $build_reqs{'perl-Gtk2'},
	);
	
	my $substitute = '$(PERL) -npe \''.join('; ', map {
			"s/\\\@$_\\\@/$subs{$_}/g";
		} keys %subs).'\'';

	"
realclean ::
	-rm -Rf build perl-\$(DISTNAME).spec

rpms/:
	-mkdir @dirs

SUBSTITUTE=$substitute

perl-\$(DISTNAME).spec: perl-\$(DISTNAME).spec.in \$(VERSION_FROM) Makefile
	\$(SUBSTITUTE) \$< > \$@

dist-rpms: Makefile dist perl-\$(DISTNAME).spec rpms/
	cp \$(DISTNAME)-\$(VERSION).tar.gz rpms/SOURCES/
	rpmbuild -ba --define \"_topdir $cwd/rpms\" perl-\$(DISTNAME).spec
"
}
package MAIN;

1;
__END__
Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
