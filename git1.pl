#!/usr/bin/perl

use strict;
use File::Spec::Functions qw(catfile);
use Carp;

$ENV{PATH} = '/bin:/usr/bin';  ## safe path

my $proj;
if (not defined($proj = shift)) {
    my $lt = readlink('.git');
    if (defined $lt) {
        $lt =~ s/^\.git_//;
        printf "Current project is $lt\n";
    }
    else {
        printf "There is no current project\n";
    }
    exit 0;
}

unless (-f catfile('.', $proj)) {
    croak "Project $proj must be a plain file in the current working directory";
}

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
        system('git', 'init') and die "Init git repository: $!";
        open(EXCLFILE, '>>', catfile('.git', 'info', 'exclude')) or die "File open for append: $!";
        print EXCLFILE "#\n*\n!$proj\n";
        close(EXCLFILE) or die "Close file: $!";
        system('git', 'add', $proj) and die "Add file to project $proj: $!";
        rename('.git', ".git_$proj") or die "Rename .git: $!";
    };
    if ($@) {
        croak "Failure: $@";
    }
}
symlink(".git_$proj", '.git') or croak "Create symlink: $!";
print "Current project is now $proj\n";

__END__
Project name:
    - should be able to handle spaces and special characters; what limitations appropriate?
    - make sure git exclude can handle whatever special chars are allowed, as well

Add pod, help flag?
