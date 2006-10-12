From: Alan Ezust <alan.ezust@presinet.com>
Subject: [patch] P-O-M-ng: runme shouldn't pick up backup files
Date: Thu, 12 Oct 2006 10:17:55 -0700
Message-ID: <200610121017.55565.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DjnLFH1GOzHEE9o"
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

--Boundary-00=_DjnLFH1GOzHEE9o
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch is for the patchomatic runme script. It addresses two issues:

1. When a patch fails, it shows you exactly which file caused the failure.
2. When there are backup files (ending with ~ or beginning with #) they are
ignored by POM.


--Boundary-00=_DjnLFH1GOzHEE9o
Content-Type: text/x-diff;
  charset="us-ascii";
  name="runme.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="runme.patch"

Index: Netfilter_POM.pm
===================================================================
--- Netfilter_POM.pm	(revision 6687)
+++ Netfilter_POM.pm	(working copy)
@@ -361,7 +361,7 @@
 	opendir(DIR, $dir)
 		or croak "can't open directory $dir: $!";
 	# Don't miss .foo-test files!
-	my @dents = sort grep {!/^(\.\.?|CVS|\.svn)$/} readdir(DIR);
+	my @dents = sort grep {!/^(\.\.?|CVS|\.svn|.*~)$/} readdir(DIR);
 	closedir(DIR);
 	foreach my $dent (@dents) {
 		my $fullpath = "$dir/$dent";
@@ -486,7 +486,7 @@
 	# get list of source files that we'd need to copy
 	opendir(PDIR, $patchdir)
 		or croak "unable to open patchdir $patchdir: $!";
-	my @dents = sort readdir(PDIR);
+        my @dents = sort grep {!/^(\.\.?|CVS|\.svn|.*~)$/} readdir(PDIR);
 	closedir(PDIR);
 
 	foreach my $pf (@dents) {
@@ -494,7 +494,6 @@
 		my $ver;
 		my $oldpwd;
 
-		next if $pf =~ /^(\.|CVS$)/;
 
 		if ($pf =~ /\.patch/) {
 			# Patch file of a project:
@@ -820,22 +819,22 @@
 				print "patch output was:\n$patch_output\n";
 			}
 			if ($missing_files != 0) {
-				$self->{ERRMSG} .= "cannot apply ($missing_files missing files)\n";
+				$self->{ERRMSG} .= "cannot apply $patchfile: ($missing_files missing files)\n";
 				return 0;
 			# } elsif ($rejects*2 > $hunks) {
 			} elsif ($rejects != 0) {
-				$self->{ERRMSG} .= "cannot apply ($rejects rejects out of $hunks hunks)\n";
+				$self->{ERRMSG} .= "cannot apply $patchfile: ($rejects rejects out of $hunks hunks)\n";
 				return 0;
 			} else {
 				# could be applied!
-				#printf(" ALREADY APPLIED (%d rejects out of %d hunks)\n", $rejects, $hunks;
+				#printf(" ALREADY APPLIED $patchfile: (%d rejects out of %d hunks)\n", $rejects, $hunks;
 			}
 		} else {
 			if ($missing_files != 0) {
-				$self->{ERRMSG} .= "ERROR ($missing_files missing files)\n";
+				$self->{ERRMSG} .= "$patchfile: ERROR ($missing_files missing files)\n";
 				return 0;
 			} elsif ($rejects != 0) {
-				$self->{ERRMSG} .= "ERROR ($rejects rejects out of $hunks hunks)\n";
+				$self->{ERRMSG} .= "$patchfile: ERROR ($rejects rejects out of $hunks hunks)\n";
 				return 0;
 			}
 		}
Index: runme
===================================================================
--- runme	(revision 6687)
+++ runme	(working copy)
@@ -109,7 +109,8 @@
 	open(SOURCES, "<sources.list") || die "could not open sources.list";
 	while (my $source = <SOURCES>) {
 		chomp($source);
-		if ($source =~ m/^\s*#/ || $source =~ m/^\s+$/) {
+		if ($source =~ m/^\s*#/ || $source =~ m/^\s+$/
+                    || $source =~ m/~$/ ) {
 			next;
 		}
 		if (!open(INDEX, "curl -s $source/index |")) {

--Boundary-00=_DjnLFH1GOzHEE9o--
