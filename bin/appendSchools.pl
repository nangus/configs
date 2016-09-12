#!/usr/bin/perl
%schools=(
  "Bellevue Middle School"=>"bellevue",
  "Blue Oaks Elementary PTC"=>"blueoaks",
  "Del Campo Athletics"=>"delcampo",
  "Diamond Creek"=>"diamondcreek",
  "Drew Charter School"=>"drewcharter",
  "East Nashville Magnet Middle School"=>"eastnashville",
  "Eich Middle School PTC"=>"eich",
  "H.G. Hill"=>"headmagnet",
  "Head Magnet"=>"hghill",
  "Inman Middle School PTA"=>"inman",
  "KIPP WAYS Academy"=>"kipp",
  "LL ESAT High School"=>"llesat",
  "Mary Lin Elementary PTA"=>"marylin",
  "Mary McLeod Bethune Middle School"=>"marymcleod",
  "Morningside Elementary School"=>"morningside",
  "Oakmont High School"=>"oakmont",
  "Overton High School"=>"overton",
  "Roseville High School"=>"roseville",
  "Sargeant Elementary"=>"sargeant",
  "Stoneridge Elementary PTC"=>"stoneridge"
);

for $s( keys(%schools)){
  print $s."\n";
}
open IN,'PTAWeekly0714.csv';
@in=<IN>;
close IN;
$title=shift @in;
$title=~s/[\r\n]//g;
$title.=",pta_weekly_tracking\n";
open OUT, ">PTAWeekly-40.csv";
print OUT $title;

foreach $in(@in){
  $in=~s/[\r\n]//g; #windows lawl...
  $append='';
  foreach $k (keys %schools){
    if($in=~m/$k/){
      $append=$schools{$k};
      print $append."\n";
    }
  }
  if(!$append){
    print 'hmm this should not happen';
    print $in."\n";
    exit;
  }
  print OUT $in.",pta-weekly-40-".$append."\n";
}
close OUT;
