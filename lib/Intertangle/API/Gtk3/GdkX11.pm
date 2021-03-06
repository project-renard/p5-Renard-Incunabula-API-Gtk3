use Renard::Incunabula::Common::Setup;
package Intertangle::API::Gtk3::GdkX11;
# ABSTRACT: Load the GdkX11 library

use Glib::Object::Introspection;
use FFI::CheckLib 0.06;
use FFI::Platypus;

my $_GDKX11_BASENAME = 'GdkX11';
my $_GDKX11_VERSION = '3.0';
my $_GDKX11_PACKAGE = __PACKAGE__;

my @_FLATTEN_ARRAY_REF_RETURN_FOR = qw/
/;

sub import {
	Glib::Object::Introspection->setup(
		basename => $_GDKX11_BASENAME,
		version  => $_GDKX11_VERSION,
		package  => $_GDKX11_PACKAGE,
		flatten_array_ref_return_for => \@_FLATTEN_ARRAY_REF_RETURN_FOR,
	);

	my $ffi_gdk = FFI::Platypus->new;
	$ffi_gdk->lib(find_lib_or_die lib => 'gdk-3');
	# Visual * gdk_x11_visual_get_xvisual (GdkVisual *visual)
	$ffi_gdk->attach( [ gdk_x11_visual_get_xvisual => __PACKAGE__ . '::X11Visual::get_xvisual' ] => [ 'opaque' ], 'opaque', sub {
		my ($xs, $gdk_visual) = @_;
		Gtk3::Gdk::threads_enter();
		my $visual = $xs->( Glib::Object::get_pointer($gdk_visual) );
		Gtk3::Gdk::threads_leave();
		return bless \$visual, __PACKAGE__ . '::Xlib::Visual';
	});
	# Screen * gdk_x11_screen_get_xscreen (GdkScreen *screen);
	$ffi_gdk->attach( [ gdk_x11_screen_get_xscreen => __PACKAGE__ . '::X11Screen::get_xscreen' ] => [ 'opaque' ], 'opaque', sub {
		my ($xs, $gdk_visual) = @_;
		Gtk3::Gdk::threads_enter();
		my $visual = $xs->( Glib::Object::get_pointer($gdk_visual) );
		Gtk3::Gdk::threads_leave();
		return bless \$visual, __PACKAGE__ . '::Xlib::Screen';
	});



	my $ffi_x11 = FFI::Platypus->new;
	$ffi_x11->lib(find_lib_or_die lib => 'X11');
	# VisualID XVisualIDFromVisual(Visual *visual)
	$ffi_x11->attach( [ XVisualIDFromVisual => __PACKAGE__ . '::Xlib::Visual::xvisualid' ], [ 'opaque' ], 'uint32_t', sub {
		my ($xs, $visual) = @_;
		my $id = $xs->( $$visual );
		return $id;
	});
	# Visual *XDefaultVisualOfScreen( Screen* screen );
	$ffi_x11->attach( [ XDefaultVisualOfScreen => __PACKAGE__ . '::Xlib::Screen::DefaultVisual' ], [ 'opaque' ], 'opaque', sub {
		my ($xs, $screen) = @_;
		my $visual = $xs->( $$screen );
		return bless \$visual, __PACKAGE__ . '::Xlib::Visual';
	});
}

1;
