# NAME

WebService::Backlog::V2 - Web API client for Backlog::V2

# SYNOPSIS

    use WebService::Backlog::V2;
    my $backlog = WebService::Backlog::V2->new( api_key => 'your api key', space_id => 'your space id' );
    my $response = $backlog->get("/issues", { 'projectId[]' => 12345 });

# DESCRIPTION

WebService::Backlog::V2 is API client for Backlog V2 API

# METHODS

## $instance = $class->new(  api\_key => 'your api key', space\_id => 'your space id'  )

create instance

## $response\_href = $self->get($end\_point, $query\_param\_href)

call API using GET request

## $response\_href = $self->post($end\_point, $query\_param\_href, $data\_href)

call API using POST request

## $response\_href = $self->put($end\_point, $query\_param\_href, $data\_href)

call API using PUT request

## $response\_href = $self->delete($end\_point, $query\_param\_href)

call API using DELETE request

# SEE ALSO

# LICENSE

Copyright (C) Takuya Tsuchida.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Takuya Tsuchida <tsucchi@cpan.org>
