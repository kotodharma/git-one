#!/usr/bin/perl
use File::Spec::Functions qw(catfile);
use Carp;

## How to make this cross platform?
$ENV{PATH} = '/bin:/usr/bin';  ## safe path

my $proj = shift || croak 'No filename given.';
## what if proj has a space in it? take care of that.

if (-e '.git') {
    if (-l '.git') {
        unlink '.git' || croak 'Cannot remove .git';
    }
    else {
        croak 'Cannot use this script where there is a normal git repo';
    }
}

unless (-d ".git_$proj") {
    eval {
        system('git init') and die "git init: $!";
        open(EXCLFILE, '>>', catfile('.git', 'info', 'exclude')) or die "File open for append: $!";
        ## seek(EXCLFILE, 0, SEEK_END) or die "Seek failed.";
        print EXCLFILE "#\n*\n!$proj\n";
        close(EXCLFILE) or die "Close file: $!";
        system("git add $proj") and die "git add $proj: $!";
        rename('.git', ".git_$proj") or die "rename .git: $!";
    };
    if ($@) {
        croak "Failure: $@";
    }
}
system("ln -s .git_$proj .git") and croak 'system ln -s';
print "Git1 project is $proj\n";

__END__
