#
# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/GtkSpell/Makefile.PL,v 1.4 2003/05/17 21:28:08 rwmcfa1 Exp $
#

use 5.008;
use Cwd;
use ExtUtils::MakeMaker;
use ExtUtils::Depends;
use Glib::PkgConfig;
use Gtk2::CodeGen;

#my %pkgcfg = Glib::PkgConfig->find('gtkspell-2.0');

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
$gtk2spell->add_typemaps (map {cwd().'/'.$_} 'gtkspell.typemap' );
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
sub const_cccmd {
	my $inherited = shift->SUPER::const_cccmd (@_);
	$inherited .= ' -o $@';
	$inherited;
}
package MAIN;
