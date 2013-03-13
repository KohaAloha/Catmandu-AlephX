package Catmandu::AlephX::Metadata::MARC::Aleph;
use Catmandu::Sane;
use Moo;
extends qw(Catmandu::AlephX::Metadata);

sub parse {
  my($class,$xpath)=@_;
 
  my @marc = ();

  for my $fix_field($xpath->find('./fixfield')->get_nodelist()){
    my $tag = $fix_field->findvalue('@id')->value();
    my $value = $fix_field->findvalue('.')->value();
    push @marc,[$tag,'','','_',$value];
  }

  for my $var_field($xpath->find('./varfield')->get_nodelist()){

    my $tag = $var_field->findvalue('@id')->value();
    my $ind1 = $var_field->findvalue('@i1')->value();
    my $ind2 = $var_field->findvalue('@i2')->value();

    my @subf = ();

    foreach my $sub_field($var_field->find('.//subfield')->get_nodelist()) {
      my $code  = $sub_field->findvalue('@label')->value();
      my $value = $sub_field->findvalue('.')->value();
      push @subf,$code,$value;
    }

    push @marc,[$tag,$ind1,$ind2,@subf];

  }

  __PACKAGE__->new(type => 'oai_marc',data => \@marc); 
}

1;
