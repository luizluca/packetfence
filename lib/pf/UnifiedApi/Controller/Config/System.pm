package pf::UnifiedApi::Controller::Config::System;

=head1 NAME

pf::UnifiedApi::Controller::Config::System -

=cut

=head1 DESCRIPTION

pf::UnifiedApi::Controller::Config::System

=cut

use strict;
use warnings;
use Mojo::Base 'pf::UnifiedApi::Controller::RestRoute';
use pfappserver::Model::Enforcement;
use pfappserver::Form::Interface::Create;
use pf::UnifiedApi::Controller::Config;
use pf::error qw(is_success);

sub model {
    require pfappserver::Model::Config::System;
    return pfappserver::Model::Config::System->new();
}

sub get_gateway {
    my ($self) = @_;
    $self->render(json => {item => $self->model->getDefaultGateway()}, status => 200);
}

sub put_gateway {
    my ($self) = @_;
    require pfappserver::Model::Interface;
    my $interfaces = pfappserver::Model::Interface->new->get('all');

    my $gateway = $self->get_json ? $self->get_json->{gateway} : undef;
    if($gateway) {
        my ($status, $status_msg) = $self->model->write_network_persistent($interfaces, $gateway);
        $self->render(json => {message => $status_msg}, status => $status);
    }
    else {
        $self->render(json => {message => "Missing the gateway in the request payload"}, status => 422)
    }
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2019 Inverse inc.

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
