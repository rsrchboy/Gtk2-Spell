/*
 * $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/GtkSpell/GtkSpell.xs,v 1.3 2003/05/27 01:20:31 rwmcfa1 Exp $
 */

/* TODO: error handling could stand to be improved, or at least thought about */

#include "gtk2spellperl.h"

GtkSpell * 
SvGtkSpell (SV * sv)
{
	if (!sv || !SvOK (sv) || sv == &PL_sv_undef || ! SvROK (sv))
		return NULL;
	if( !sv_derived_from (sv, "Gtk2::Spell"))
		croak("variable is not of type Gtk2::Spell");

	return (GtkSpell*)SvIV(SvRV(sv));
}

SV *
newSVGtkSpell (GtkSpell * spell)
{
	SV * sv;

	if( !spell )
		return &PL_sv_undef;

	sv = newSV(0);
	sv_setref_pv(sv, "Gtk2::Spell", spell);

	return(sv);
}

MODULE = Gtk2::Spell	PACKAGE = Gtk2::Spell	PREFIX = gtkspell_

GtkSpell *
gtkspell_news (class, view, lang=NULL)
	SV          * class
	GtkTextView * view
	const gchar * lang
    ALIAS:
	Gtk2::Spell::new = 0
	Gtk2::Spell::new_attach = 1
    PREINIT:
	GError * error = NULL;
    CODE:
	RETVAL = gtkspell_new_attach(view, lang, &error);
	if( !RETVAL )
		gperl_croak_gerror("Gtk2::Spell->new_attach", error);
    OUTPUT:
	RETVAL

GtkSpell * 
gtkspell_get_from_text_view (class, view)
	SV          * class
	GtkTextView * view
    CODE:
	RETVAL = gtkspell_get_from_text_view(view);
	if( !RETVAL )
		XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

void 
gtkspell_detach (spell)
	GtkSpell * spell

gboolean 
gtkspell_set_language (spell, lang)
	GtkSpell    * spell
	const gchar * lang
    PREINIT:
	GError * error = NULL;
    CODE:
	RETVAL = gtkspell_set_language(spell, lang, &error);
	if( !RETVAL )
		gperl_croak_gerror("Gtk2::Spell->set_language", error);
    OUTPUT:
	RETVAL
	

void 
gtkspell_recheck_all (spell)
	GtkSpell * spell

