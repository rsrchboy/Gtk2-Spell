#
# $Header: /cvsroot/gtk2-perl/gtk2-perl-xs/GtkSpell/t/0.GtkSpell.t,v 1.1 2003/05/27 01:20:20 rwmcfa1 Exp $
#

#########################
# Gtk2 Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Gtk2;

use Test::More tests => 8;
BEGIN { use_ok('Gtk2::Spell') };

use constant TRUE => 1;
use constant FALSE => 0;

Gtk2->init;

my $view = Gtk2::TextView->new;
$view->set_wrap_mode('word');
ok(1);

# could be $spell = Gtk2::Spell->new;
ok( my $spell = Gtk2::Spell->new_attach($view) );

my $scroll = Gtk2::ScrolledWindow->new( );
$scroll->set_policy('automatic', 'automatic');
$scroll->set_shadow_type('in');
$scroll->add($view);
ok(1);

my $box = Gtk2::VBox->new( FALSE, 5 );
$box->pack_start(Gtk2::Label->new("Type some text into the text box.\n".
		"Try misspelling some words.  Then right-click on them."),
				FALSE, FALSE, 0);
$box->pack_start($scroll, TRUE, TRUE, 0);
$box->show_all;
ok(1);

my $win = Gtk2::Window->new;
$win->set_default_size(400, 300);
$win->set_title("Simple GtkSpell Demonstration");
$win->set_border_width(10);
$win->add($box);
$win->show;
ok(1);

Glib::Idle->add( sub {
		$buf = $view->get_buffer;
		ok(1);
		$buf->insert_at_cursor("Hello world, this is a teast, with "
			              ."various mis-speellings on puorpuse.");
		ok(1);
		Gtk2->main_quit;
		0;
	});

Gtk2->main;
