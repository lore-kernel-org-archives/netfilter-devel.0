From: "Jim Gifford" <maillist@jg555.com>
Subject: Re: Bug-Report 3-19-03 patch-o-matic-ng
Date: Tue, 6 Apr 2004 12:25:28 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <050501c41c0c$ebda8b10$d100a8c0@W2RZ8L4S02>
References: <Pine.LNX.4.33.0403221004140.24116-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0502_01C41BD2.3F1E77E0"
Cc: "Netfilter Developer" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0502_01C41BD2.3F1E77E0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Jozsef,
    I got most of the patch figured out and working. The only thing I
haven't been able to figure out is the following:

    Attached is my patch that adds a check_applied subroutine.

    This routine looks at @applied when a dependency is checked, if the name
of the patch is in @applied, it returns a status of 1.
    so if nf-log is in applied, when we get to TRACE, it will just skip the
applying of nf-log, but will add the other dependency.
    If nf-log is not applied, it will add nf-log, and the other dependency.
(My original bug report)

    I fixed a routine that gives an error message,  present 'ctstat'
conflicts with to-be-installed 'tcp-window-tracking'.
    If used the routine from above to check to see if the patch exists in
@applied. It worked fine in the apply mode, but
    it broke in the revert mode. So I had to add another check, that checked
the mode add used the appropriate response from
    check_applied.

    Few issues that do exist in 1.15 and my 1.16 patch-o-matic-ng, that I
have no clue on how to fix are.

    After a dependency is applied, it needs to be added to @applied.

    If you change from apply to revert, the @applied stays the same. The
revert should only be allowed as a first available patch,
    and not be allowed to change after patches have been applied.



------=_NextPart_000_0502_01C41BD2.3F1E77E0
Content-Type: application/octet-stream;
	name="patch-o-matic-ng-20040403-applied_check-1[1].patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-o-matic-ng-20040403-applied_check-1[1].patch"

Submitted By: Jim Gifford (jim at linuxfromscratch dot org)=0A=
Date: 2004-04-06=0A=
Initial Package Version: CVS Snapshot=0A=
Origin: Jim Gifford=0A=
Description: Adds applied patch check=0A=
 =0A=
--- patch-o-matic-ng-20040403/runme.orig	2004-04-05 22:01:49.994980813 =
+0000=0A=
+++ patch-o-matic-ng-20040403/runme	2004-04-06 18:06:21.159427907 +0000=0A=
@@ -16,7 +16,7 @@=0A=
 require Term::Cap;=0A=
 =0A=
 my $POMNG_ROOT_DIR =3D '.';=0A=
-my $VERSION =3D '1.15';=0A=
+my $VERSION =3D '1.16';=0A=
 =0A=
 push(@INC, $POMNG_ROOT_DIR);=0A=
 use Netfilter_POM;=0A=
@@ -85,6 +85,7 @@=0A=
 my @patchdirs;=0A=
 my @repositories;=0A=
 my @applied;=0A=
+my $applied_text;=0A=
 my $clrscr =3D "\n\n\n\n\n\n\n\n\n\n";=0A=
 =0A=
 my $opt_batch; =0A=
@@ -260,7 +261,9 @@=0A=
 =0A=
 		print($clrscr);=0A=
 		print_header();=0A=
-		print("Already applied: ", join(" ", @applied),"\n\n");=0A=
+=0A=
+		$applied_text =3D join(" ", @applied);=0A=
+		print("Already applied: $applied_text\n\n");=0A=
 =0A=
 		if (!Netfilter_POM::requirements_fulfilled($patchlet)) {=0A=
 			printf("Not all requirements fulfilled for $plname, skipping:\n =
%s\n", =0A=
@@ -291,12 +294,15 @@=0A=
 		chomp($key);=0A=
 		if ($key eq 'y') {=0A=
 			my $ret =3D Netfilter_POM::dependencies_fulfilled($plets,=0A=
-								$plname);=0A=
+								$plname, $applied_text,=0A=
+								$opt_reverse);=0A=
 			if ($ret =3D=3D 0) {=0A=
 				if (!Netfilter_POM::apply_dependencies($plets,=0A=
-								$plname, 0, 1) ||=0A=
+								$plname, 0, 1,=0A=
+								$applied_text) ||=0A=
 				    !Netfilter_POM::apply_dependencies($plets,=0A=
-				    				$plname, 0, 0)) {=0A=
+				    				$plname, 0, 0,=0A=
+								$applied_text)) {=0A=
 					Netfilter_POM::perror();=0A=
 					goto PROMPT;=0A=
 				}=0A=
@@ -321,10 +327,12 @@=0A=
 			goto PROMPT;=0A=
 		} elsif ($key eq 'f') {=0A=
 			my $ret =3D Netfilter_POM::dependencies_fulfilled($plets,=0A=
-								$plname);=0A=
+								$plname, $applied_text,=0A=
+								$opt_reverse);=0A=
 			if ($ret =3D=3D 0) {=0A=
 				if (!Netfilter_POM::apply_dependencies($plets,=0A=
-							$plname, 1, 0)) {=0A=
+							$plname, 1, 0,=0A=
+							$applied_text)) {=0A=
 					Netfilter_POM::perror();=0A=
 					next PATCHLET;=0A=
 				}=0A=
--- patch-o-matic-ng-20040403/Netfilter_POM.pm.orig	2004-04-05 =
22:02:05.603073550 +0000=0A=
+++ patch-o-matic-ng-20040403/Netfilter_POM.pm	2004-04-06 =
19:09:54.939729037 +0000=0A=
@@ -131,6 +131,19 @@=0A=
 	return ( $res ? ($min+2) : 0);=0A=
 }=0A=
 =0A=
+# Check to see if patch is already applied=0A=
+# Return values : 1 =3D applied=0A=
+#		  0 =3D not applied=0A=
+sub check_applied($$) {=0A=
+        my $patch =3D shift;=0A=
+        my $applied_patch =3D shift;=0A=
+        if($applied_patch =3D~ m/($patch)/)=0A=
+                {=0A=
+			return 1;=0A=
+                }=0A=
+	return 0;=0A=
+        }=0A=
+=0A=
 # do we have Kconfig / Config.in applicable for kernel ?=0A=
 #=0A=
 sub check_kconfig($) {=0A=
@@ -233,16 +246,19 @@=0A=
 # 	 0	dependencies not fulfilled=0A=
 # 	-1	dependencies cannot be fulfilled [conflicting patchlets]=0A=
 #=0A=
-sub dependencies_fulfilled($$) {=0A=
-	my ($plets, $plname) =3D @_;=0A=
+sub dependencies_fulfilled($$$$) {=0A=
+	my ($plets, $plname, $applied, $reverse) =3D @_;=0A=
 	my $patchlet =3D $$plets{$plname};=0A=
-=0A=
 	for my $dep (@{$$patchlet{info}{depends}}) {=0A=
 		my $inverse =3D 0;=0A=
 		if ($dep =3D~ /^!/) {=0A=
 			$inverse =3D 1;=0A=
 			$dep =3D~ s/^!//;=0A=
 		}=0A=
+		my $applied_status =3D check_applied("$dep","$applied");=0A=
+		if ($applied_status =3D=3D 1) {=0A=
+			return 1;=0A=
+		}=0A=
 		if (!defined($$plets{$dep})) {=0A=
 			$ERRMSG =3D "$plname has dependency on $dep, but $dep is not known";=0A=
 			return 0;=0A=
@@ -252,11 +268,20 @@=0A=
 				$ERRMSG =3D "$dep not applied";=0A=
 				return 0;=0A=
 			} else {=0A=
-				$ERRMSG =3D "present '$dep' conflicts with to-be-installed =
'$plname'";=0A=
-				return -1;=0A=
+				if ($reverse =3D=3D 1 ) {=0A=
+					if ($applied_status =3D=3D 1) {=0A=
+						$ERRMSG =3D "present '$dep' conflicts with to-be-installed =
'$plname'";=0A=
+						return -1;=0A=
+					}=0A=
+				} else {=0A=
+					if ($applied_status =3D=3D 0) {=0A=
+						$ERRMSG =3D "present '$dep' conflicts with to-be-installed =
'$plname'";=0A=
+						return -1;=0A=
+					}=0A=
+				}=0A=
 			}=0A=
 		}=0A=
-		my $ret =3D dependencies_fulfilled($plets, $$plets{$dep});=0A=
+		my $ret =3D dependencies_fulfilled($plets, $$plets{$dep}, $applied);=0A=
 		if ($ret <=3D 0) {=0A=
 			# don't overwrite ERRMSG=0A=
 			return $ret;=0A=
@@ -269,11 +294,17 @@=0A=
 # plets: hash of all patchlets=0A=
 # plname: name of patchlet subject to recursive dependency resolving=0A=
 # force: forcibly try to apply dependent patches (to see .rej's)=0A=
-sub apply_dependencies($$$$)=0A=
+# applied: list of already applied patches=0A=
+# applied_status: return status of check_check routine=0A=
+sub apply_dependencies($$$$$)=0A=
 {=0A=
-	my ($plets, $plname, $force, $test) =3D @_;=0A=
+	my ($plets, $plname, $force, $test, $applied) =3D @_;=0A=
 	my $patchlet =3D $$plets{$plname};=0A=
 	for my $dep (@{$$patchlet{info}{depends}}) {=0A=
+		my $applied_status =3D check_applied("$dep","$applied");=0A=
+		if ($applied_status =3D=3D 1) {=0A=
+			return 1;=0A=
+		}=0A=
 		# don't revert existing patches=0A=
 		if ($dep =3D~ /^!/) {=0A=
 			next;=0A=
@@ -282,7 +313,7 @@=0A=
 			$ERRMSG =3D "$plname has dependency on $dep, but $dep is not known";=0A=
 			return 0;=0A=
 		}=0A=
-		if (!apply_dependencies($plets, $dep, $force, $test)) {=0A=
+		if (!apply_dependencies($plets, $dep, $force, $test, $applied)) {=0A=
 			# don't overwrite $ERRMSG=0A=
 			return 0;=0A=
 		}=0A=

------=_NextPart_000_0502_01C41BD2.3F1E77E0--
