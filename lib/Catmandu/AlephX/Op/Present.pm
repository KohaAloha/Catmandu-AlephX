package Catmandu::AlephX::Op::Present;
use Catmandu::Sane;
use Moo;
use Catmandu::AlephX::Metadata::MARC;
use Catmandu::AlephX::Record::Present;

with('Catmandu::AlephX::Response');

has records => (
  is => 'ro',
  lazy => 1,
  default => sub { [] }
);
sub op { 'present' }

sub parse {
  my($class,$str_ref) = @_;
  my $xpath = xpath($str_ref);

  my @records;
  
  for my $r($xpath->find('/present/record')->get_nodelist()){
  
    my @metadata;

    my $record_header = get_children(
      $r->find('./record_header')->get_nodelist()
    );

    push @metadata,Catmandu::AlephX::Metadata::MARC->parse(
      $r->find('./metadata/oai_marc')->get_nodelist()
    );
    
    push @records,Catmandu::AlephX::Record::Present->new(
      metadata => \@metadata,
      record_header => $record_header,
      doc_number => $r->findvalue('./doc_number')
    );   

  }

  
  __PACKAGE__->new(
    records => \@records,
    session_id => $xpath->findvalue('/find-doc/session-id')->value(),
    error => $xpath->findvalue('/find-doc/error')->value()
  );
}

1;
