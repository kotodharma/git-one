I have been frustrated by the fact that git, in spite of its tremendous power and
flexibility, is simply not designed to deal with projects that are comprised of
only a single file, often in a directory along with a bunch of other individual text
files that I might also like to revision independently.

"Just use RCS," you might say. Yeah, well, but... I like git, want to keep using it,
to learn it better, and, well, RCS is just too ancient. Let's be serious.

So here's a little Perl script to facilitate that M.O.  What it basically does
is to manage a separate .git for each "project" file, naming them .git_<filename>,
and repointing a symbolic link called .git to whichever one is currently being
worked on. Each .git/info/exclude is automatically created to specify that everything
except the file in question is to be ignored. Thankfully git works even when .git
is a symlink.

This is written to run on UNIX and UNIX-like OSes. If you want to port it to
Windows or whatever, be my guest (it's already partially portable, in its handling
of filesystem paths). I've put it in the public domain, so you can do with it as
you please. I would appreciate receiving improvements.

** At present I don't consider this to be ready to call "done" yet.  It needs some
   more improvement and testing.

