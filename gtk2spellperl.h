/*
 * $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/GtkSpell/gtk2spellperl.h,v 1.1 2003/04/26 03:03:21 rwmcfa1 Exp $
 */

#ifndef _GTK2PERL_SPELL_H_
#define _GTK2PERL_SPELL_H_

#include <gtk2perl.h>

#include <gtkspell/gtkspell.h>

SV * newSVGtkSpell (GtkSpell * spell);
GtkSpell * SvGtkSpell (SV * sv);

#endif /* _GTK2PERL_SPELL_H_ */
