From: Sven Anders <anders@anduras.de>
Subject: [PATCH] -verbose for 'runme'
Date: Thu, 23 Jun 2005 10:09:47 +0200
Message-ID: <42BA6E4B.6060203@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030000070905060203070000"
Cc: laforge@netfilter.org
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

This is a multi-part message in MIME format.
--------------030000070905060203070000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

I added a verbose option to the 'runme' script.
It simply shows the output of the called 'patch' command, so you could
see *why* a try to patch failed.

Maybe any of the maintainers will find it useful too, and will add it...

Regards
~ Sven
- --
~ Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
~                                                 /\ Support plain text e-mail
~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Thomas Träger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFCum5K5lKZ7Feg4EcRApWwAJ9+gqg9Pj9kQGI5lPQgzFDNODGslQCeN3og
Tzw29jF2hE68CROaPiOMtS0=
=XEoI
-----END PGP SIGNATURE-----

--------------030000070905060203070000
Content-Type: text/x-diff;
 name="Nefilter_POM.pm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Nefilter_POM.pm.patch"

--- Netfilter_POM.pm.orig	2005-02-16 14:25:55.000000000 +0100
+++ Netfilter_POM.pm	2005-02-16 22:20:28.000000000 +0100
@@ -767,7 +767,7 @@
 
 sub apply_patches {
 	my $self = shift;
-	my($patchlet, $proj, $revert, $test, $copy) = @_;
+	my($patchlet, $proj, $revert, $test, $copy, $verbose) = @_;
 
 	return 1 unless safe_exists($patchlet, ('patch', $proj, 'best'));
 
@@ -798,9 +798,11 @@
 		my $rejects;
 		my $notempty;
 		my $hunks = count_hunks($patchfile);
+		my $patch_output = "";
 		open(PATCH, "$cmd|") || die("can't start patch '$cmd': $!\n");
 		while (my $line = <PATCH>) {
 			# FIXME: parse patch output
+			$patch_output .= ">> $line";
 			chomp($line);
 			if ($line =~ /No file to patch/) {
 				$missing_files++;
@@ -813,6 +815,10 @@
 		close(PATCH);
 
 		if ($test) {
+			if ($verbose && (($missing_files != 0) || ($rejects != 0)))
+			{
+				print "patch output was:\n$patch_output\n";
+			}
 			if ($missing_files != 0) {
 				$self->{ERRMSG} .= "cannot apply ($missing_files missing files)\n";
 				return 0;
@@ -843,10 +849,11 @@
 # 	normal (non-test) mode: 1 on success, 0 on failure
 # 	test mode: 1 if test was successful (patch could be applied/reverted)
 #	copy: directory with the shadow tree, if any
+#	verbose mode: output verbose messages
 #
 sub apply_patchlet {
 	my $self = shift;
-	my($patchlet, $revert, $test, $copy) = @_;
+	my($patchlet, $revert, $test, $copy, $verbose) = @_;
 	my(@projects);
 
 	# print Dumper($patchlet);
@@ -869,7 +876,7 @@
 
 		if (!(($self->apply_newfiles($patchlet, $proj, $revert, $test, $copy)
 				 && $self->apply_lineadds($patchlet, $proj, $revert, $test, $copy)
-				 && $self->apply_patches($patchlet, $proj, $revert, $test, $copy))
+				 && $self->apply_patches($patchlet, $proj, $revert, $test, $copy, $verbose))
 			     || ($test
 				 && defined $patchlet->{info}->{successor}
 				 && defined $self->{patchlets}->{$patchlet->{info}->{successor}}

--------------030000070905060203070000
Content-Type: text/x-diff;
 name="runme.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="runme.patch"

--- runme.orig	2005-02-16 22:16:07.000000000 +0100
+++ runme	2005-02-16 22:21:09.000000000 +0100
@@ -78,6 +78,7 @@
 my $clrscr = "\n\n\n\n\n\n\n\n\n\n";
 
 my $opt_batch; 
+my $opt_verbose; 
 my $opt_test;
 my $opt_check;
 my $opt_reverse;
@@ -89,6 +90,7 @@
 my $opt_iptpath;
 
 my $result = GetOptions("batch" => \$opt_batch,
+			"verbose" => \$opt_verbose,
 			"test" => \$opt_test,
 			"check" => \$opt_check,
 			"reverse" => \$opt_reverse,
@@ -234,7 +236,7 @@
 		if (grep($_ eq $plname, @{$session->{applied}})) {
 			print("applied\n");
 			next PATCHLET;
-		} elsif ($session->apply_patchlet($patchlet, !$opt_reverse, 1, "/tmp/pom-$$")) {
+		} elsif ($session->apply_patchlet($patchlet, !$opt_reverse, 1, "/tmp/pom-$$", $opt_verbose)) {
 			print("applied\n");
 			push(@{$session->{applied}}, $plname);
 			next PATCHLET;
@@ -368,6 +370,10 @@
 
 specify the iptables source path
 
+=item B<--verbose>
+
+verbose output (shows output of patch command)
+
 =back
 
 =head1 DESCRIPTION

--------------030000070905060203070000--
