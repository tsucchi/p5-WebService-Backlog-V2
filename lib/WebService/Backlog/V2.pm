package WebService::Backlog::V2;
use 5.008005;
use Mouse;

our $VERSION = "0.01";

use Furl;
use URI;
use Carp ();
use JSON qw(decode_json encode_json);

has 'api_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'space_id' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'timeout' => (
    is      => 'ro',
    isa     => 'Int',
    default => 10,
);

has 'ua' => (
    is       => 'ro',
    isa      => 'Furl',
    lazy     => 1,
    required => 1,
    default  => sub {
        my ($self) = @_;
        Furl->new( timeout => $self->timeout );
    },
);

no Mouse;

sub api_base_uri {
    my ($self) = @_;
    my $space_id = $self->space_id;
    return "https://${space_id}.backlog.jp/api/v2";
}

sub _request {
    my ($self, $method, $end_point, $query_param_href, $data_json, @additional_header) = @_;

    my %query_param = ( %{ $query_param_href || {} }, apiKey => $self->api_key );

    my $uri_for_query_param = URI->new();
    $uri_for_query_param->query_form(%query_param);
    $end_point .= $uri_for_query_param->as_string;

    my $ua = $self->ua;
    my $uri = $self->api_base_uri . $end_point;
    my $req = Furl::Request->new($method, $uri, [@additional_header], $data_json);
    my $res = $ua->request($req);
    unless ( $res->is_success ) {
        Carp::croak $res->status_line . $res->content;
    }
    return if ( $res->code eq '204' );# No Content
    return decode_json($res->content);
}

sub get {
    my ($self, $end_point, $query_param_href) = @_;
    return $self->_request('GET', $end_point, $query_param_href);
}

sub post {
    my ($self, $end_point, $query_param_href, $data_href) = @_;
    my $data_json = encode_json($data_href);
    my @additional_header = ( 'Content-Type' => 'application/x-www-form-urlencoded' );
    return $self->_request('POST', $end_point, $query_param_href, $data_json, @additional_header);
}

sub put {
    my ($self, $end_point, $query_param_href, $data_href) = @_;
    my $data_json = encode_json($data_href);
    my @additional_header = ( 'Content-Type' => 'application/x-www-form-urlencoded' );
    return $self->_request('PUT', $end_point, $query_param_href, $data_json, @additional_header);
}

sub delete {
    my ($self, $end_point, $query_param_href) = @_;
    return $self->_request('DELETE', $end_point, $query_param_href);
}


1;
__END__

=encoding utf-8

=head1 NAME

WebService::Backlog::V2 - Web API client for Backlog::V2

=head1 SYNOPSIS

    use WebService::Backlog::V2;
    my $backlog = WebService::Backlog::V2->new( api_key => 'your api key', space_id => 'your space id' );
    my $response = $backlog->get("/issues", { 'projectId[]' => 12345 });


=head1 DESCRIPTION

WebService::Backlog::V2 is API client for Backlog V2 API

=head1 METHODS

=head2 $instance = $class->new(  api_key => 'your api key', space_id => 'your space id'  )

create instance

=head2 $response_href = $self->get($end_point, $query_param_href)

call API using GET request

=head2 $response_href = $self->post($end_point, $query_param_href, $data_href)

call API using POST request

=head2 $response_href = $self->put($end_point, $query_param_href, $data_href)

call API using PUT request

=head2 $response_href = $self->delete($end_point, $query_param_href)

call API using DELETE request


=head1 SEE ALSO



=head1 LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Takuya Tsuchida E<lt>tsucchi@cpan.orgE<gt>

=cut

