From: Alan Ezust <alan.ezust@presinet.com>
Subject: [patch] POM-NG: runme message clarification and filename regex
	fixes (v3)
Date: Thu, 11 Jan 2007 10:21:52 -0800
Message-ID: <200701111021.55817.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4221583.0tO1V8MFyU";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

--nextPart4221583.0tO1V8MFyU
Content-Type: multipart/mixed;
  boundary="Boundary-01=_ABopFpKFmBwpRTo"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_ABopFpKFmBwpRTo
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch (3rd attempt to submit), includes fixes to the messages, to clar=
ify=20
where things went wrong (when they do go wrong), and also avoids picking up=
=20
backup files in the patchlets directory.

Cheers --alan


=2D-=20
Alan Ezust            www.presinet.com
Presinet, inc         alan.ezust@presinet.com
           Victoria, BC, Canada

--Boundary-01=_ABopFpKFmBwpRTo
Content-Type: text/x-diff;
  charset="us-ascii";
  name="runme.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="runme.patch"

Index: Netfilter_POM.pm
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- Netfilter_POM.pm	(revision 6735)
+++ Netfilter_POM.pm	(working copy)
@@ -361,12 +361,13 @@
 	opendir(DIR, $dir)
 		or croak "can't open directory $dir: $!";
 	# Don't miss .foo-test files!
=2D	my @dents =3D sort grep {!/^(\.\.?|CVS|\.svn)$/} readdir(DIR);
+	my @dents =3D sort grep {!/^(\.\.?|CVS|\.svn|.*~)$/} readdir(DIR);
 	closedir(DIR);
 	foreach my $dent (@dents) {
 		my $fullpath =3D "$dir/$dent";
 		if (-f $fullpath) {
=2D			push(@{$patchlet->{$dent =3D~ /\.ladd/ ? 'ladds' : 'files'}->{$proj}-=
>{$ver}}, "$pdir/$fullpath");
+                        my $key =3D ($dent =3D~ /\.ladd/ ? 'ladds' : 'file=
s');
+			push(@{$patchlet->{$key}->{$proj}->{$ver}}, "$pdir/$fullpath");
 		} elsif (-d _) {
 			$self->recurse($pdir, $fullpath, $patchlet, $proj, $ver);
 		}
@@ -486,7 +487,7 @@
 	# get list of source files that we'd need to copy
 	opendir(PDIR, $patchdir)
 		or croak "unable to open patchdir $patchdir: $!";
=2D	my @dents =3D sort readdir(PDIR);
+        my @dents =3D sort grep {!/^(\.\.?|CVS|\.svn|.*~)$/} readdir(PDIR);
 	closedir(PDIR);
=20
 	foreach my $pf (@dents) {
@@ -494,7 +495,6 @@
 		my $ver;
 		my $oldpwd;
=20
=2D		next if $pf =3D~ /^(\.|CVS$)/;
=20
 		if ($pf =3D~ /\.patch/) {
 			# Patch file of a project:
@@ -820,22 +820,22 @@
 				print "patch output was:\n$patch_output\n";
 			}
 			if ($missing_files !=3D 0) {
=2D				$self->{ERRMSG} .=3D "cannot apply ($missing_files missing files)\n";
+				$self->{ERRMSG} .=3D "cannot apply $patchfile: ($missing_files missing=
 files)\n";
 				return 0;
 			# } elsif ($rejects*2 > $hunks) {
 			} elsif ($rejects !=3D 0) {
=2D				$self->{ERRMSG} .=3D "cannot apply ($rejects rejects out of $hunks h=
unks)\n";
+				$self->{ERRMSG} .=3D "cannot apply $patchfile: ($rejects rejects out o=
f $hunks hunks)\n";
 				return 0;
 			} else {
 				# could be applied!
=2D				#printf(" ALREADY APPLIED (%d rejects out of %d hunks)\n", $rejects,=
 $hunks;
+				#printf(" ALREADY APPLIED $patchfile: (%d rejects out of %d hunks)\n",=
 $rejects, $hunks;
 			}
 		} else {
 			if ($missing_files !=3D 0) {
=2D				$self->{ERRMSG} .=3D "ERROR ($missing_files missing files)\n";
+				$self->{ERRMSG} .=3D "$patchfile: ERROR ($missing_files missing files)=
\n";
 				return 0;
 			} elsif ($rejects !=3D 0) {
=2D				$self->{ERRMSG} .=3D "ERROR ($rejects rejects out of $hunks hunks)\n=
";
+				$self->{ERRMSG} .=3D "$patchfile: ERROR ($rejects rejects out of $hunk=
s hunks)\n";
 				return 0;
 			}
 		}
Index: runme
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- runme	(revision 6735)
+++ runme	(working copy)
@@ -3,7 +3,7 @@
 # runme.pl, part of the patch-o-matig 'next generation' package.
 # (C) 2003-2004 by Harald Welte <laforge@netfilter.org>
 #     2004	by Jozsef Kadlecsik <kadlec@blackhole.kfki.ho>
=2D#
+#     2006      small fixes by Alan Ezust <alan.ezust@presinet.com>
 # This script is subject to the GNU GPLv2
 #
 # $Id$
@@ -75,7 +75,7 @@
=20
 my @patchlets;
 my @repositories;
=2Dmy $clrscr =3D "\n\n\n\n\n\n\n\n\n\n";
+my $clrscr =3D "\n\n\n\n\n";
=20
 my $opt_batch;=20
 my $opt_verbose;=20
@@ -346,15 +346,16 @@
=20
 		print($clrscr);
 		print_header($session);
=2D		print("Already applied: ", join(" ", @{$session->{applied}}),"\n\n");
+		print("Already applied: ", join(" ", @{$session->{applied}}),"\n");
=20
 		next PATCHLET unless $session->requirements_fulfilled($patchlet);
 		print("Testing ${plname}... ");
 		if (grep($_ eq $plname, @{$session->{applied}})) {
=2D			print("applied\n");
+			print("already applied.\n");
 			next PATCHLET;
=2D		} elsif ($session->apply_patchlet($patchlet, !$opt_reverse, 1, "/tmp/p=
om-$$", $opt_verbose)) {
=2D			print("applied\n");
+		}=20
+		elsif ($session->apply_patchlet($patchlet, !$opt_reverse, 1, "/tmp/pom-$=
$", $opt_verbose)) {
+			print("Reverse Test passed - assuming already applied.\n");
 			push(@{$session->{applied}}, $plname);
 			next PATCHLET;
 		}

--Boundary-01=_ABopFpKFmBwpRTo--

--nextPart4221583.0tO1V8MFyU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBFpoBDsJbtw6GURksRAkwcAJ9OZEEyA8AC2inNTeyXq+d9dVhIRwCgmIyr
Of+PbvJ8WXZHrLwh2rLT/XY=
=cs9T
-----END PGP SIGNATURE-----

--nextPart4221583.0tO1V8MFyU--
