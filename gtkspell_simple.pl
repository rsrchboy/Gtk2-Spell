#!/usr/bin/perl -w
#
# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/GtkSpell/gtkspell_simple.pl,v 1.2 2003/05/17 13:31:02 rwmcfa1 Exp $
#

use strict;

use Gtk2;
use Gtk2::Spell;

use constant TRUE => 1;
use constant FALSE => 0;

Gtk2->init;

my $view = Gtk2::TextView->new;
$view->set_wrap_mode('word');

# could be $spell = Gtk2::Spell->new;
# croaks on error
my $spell = Gtk2::Spell->new_attach($view);

my $scroll = Gtk2::ScrolledWindow->new( undef, undef );
$scroll->set_policy('automatic', 'automatic');
$scroll->set_shadow_type('in');
$scroll->add($view);

my $box = Gtk2::VBox->new( FALSE, 5 );
$box->pack_start(Gtk2::Label->new("Type some text into the text box.\n".
		"Try misspelling some words.  Then right-click on them."),
				FALSE, FALSE, 0);
$box->pack_start($scroll, TRUE, TRUE, 0);
$box->show_all;

my $win = Gtk2::Window->new;
$win->set_default_size(400, 300);
$win->set_title("Simple GtkSpell Demonstration");
$win->set_border_width(10);
$win->signal_connect( 'destroy' => sub {
		Gtk2->main_quit;
	});
$win->add($box);

$win->show;

Gtk2->main;
