package pf::UnifiedApi::Controller::Configurator;

=head1 NAME

pf::UnifiedApi::Controller::Configurator -

=head1 DESCRIPTION

pf::UnifiedApi::Controller::Configurator

=cut

use strict;
use warnings;
use Mojo::Base 'pf::UnifiedApi::Controller::RestRoute';
use pf::config qw(%Config);
use pf::util;

sub allowed {
    my ($self) = @_;
    if (isenabled($Config{advanced}{configurator})) {
        return 1;
    }
    return $self->render_error(401, "The configurator is turned off");
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2020 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

1;

