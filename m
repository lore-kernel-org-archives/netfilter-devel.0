From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: PoM-NG question
Date: Thu, 08 Apr 2004 14:24:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1081427043.1201.22.camel@nienna.balabit>
References: <1081343893.1191.58.camel@nienna.balabit>
	 <4074146B.9080004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-7FqtojpuBnCWV2hi5IUj"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <4074146B.9080004@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-7FqtojpuBnCWV2hi5IUj
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

On Wed, 2004-04-07 at 16:47, Patrick McHardy wrote:
> >   Is it possible to use more than one .patch file in a patchlet? I mean,
> > I'd like to incorporate a complete, broken-out patchtree into a
> > patchlet. Is this possible ATM?
> > 
> 
> AFAIK it's not possible. Such a feature would be great, though.

  I've created a patch which adds support for broken out patches in
pom-ng. Please review, I'm not much of a Perl user... The patch supports
broken-out patch names like 01-foo-linux-2.4.patch, however, retains
compatibility with previous versions, so that names like linux-2.4.patch
can be used as well.

  Another fix is attached, this is for the runme script to do not omit
warnings that OSPEED is not set.

-- 
 Regards,
   Krisztian KOVACS

--=-7FqtojpuBnCWV2hi5IUj
Content-Disposition: attachment; filename=netfilter_patchsets.patch
Content-Type: text/x-patch; name=netfilter_patchsets.patch; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: Netfilter_POM.pm
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/Netfilter_POM.pm,v
retrieving revision 1.19
diff -u -r1.19 Netfilter_POM.pm
--- Netfilter_POM.pm	3 Mar 2004 12:30:46 -0000	1.19
+++ Netfilter_POM.pm	8 Apr 2004 12:12:59 -0000
@@ -407,8 +407,11 @@
 
 	# save the filename of the patch itself
 	foreach my $pf (@dents) {
-		if ($pf =~ /(([^-]+)(-([\d\.]*))?\.patch)$/) {
-			$patchlet{patch}{$2}{$4} = $1;
+		if ($pf =~ /(((\d+-[^-]+)-)?(([^-]+)(-([\d\.]*)))?\.patch)$/) {
+			if (!defined($patchlet{patch}{$5}{$7})) {
+				$patchlet{patch}{$5}{$7} = [];
+			}
+			push @{$patchlet{patch}{$5}{$7}}, $1;
 		}
 	}
 
@@ -733,16 +736,19 @@
 			if ($test) {
 				$options .= "--dry-run ";
 			}
-			my $patchfile = ($$patchlet{basedir}.'/'.$$patchlet{patch}{$proj}{best});
-			my $cmd = sprintf("%s -f -p1 -d %s %s < %s", 
-					  $BIN_PATCH, $projpath, 
-					  $options,
-					  $patchfile);
+
+			my @patchfiles = sort map { $$patchlet{basedir}.'/'.$_ } @{$$patchlet{patch}{$proj}{best}};
+			my $patchfiles = join ' ', @patchfiles;
+			my $cmd = sprintf("cat %s | %s -f -p1 -d %s %s",
+					  $patchfiles,
+					  $BIN_PATCH, $projpath,
+					  $options);
 
 			my $missing_files;
 			my $rejects;
 			my $notempty;
-			my $hunks = count_hunks($patchfile);
+			my $hunks = 0;
+			map { $hunks += count_hunks($_) } @patchfiles;
 			open(PATCH, "$cmd|") || die("can't start patch '$cmd': $!\n");
 			while (my $line = <PATCH>) {
 				# FIXME: parse patch output

--=-7FqtojpuBnCWV2hi5IUj
Content-Disposition: attachment; filename=runme_fix_ospeed.patch
Content-Type: text/x-patch; name=runme_fix_ospeed.patch; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: runme
===================================================================
RCS file: /cvspublic/patch-o-matic-ng/runme,v
retrieving revision 1.15
diff -u -r1.15 runme
--- runme	4 Mar 2004 07:54:24 -0000	1.15
+++ runme	8 Apr 2004 12:10:22 -0000
@@ -234,7 +234,7 @@
 }
 
 if (defined($ENV{TERM}) && !$opt_batch) {
-	my $terminal = Tgetent Term::Cap {};
+	my $terminal = Tgetent Term::Cap { OSPEED => 9600 };
 	$clrscr = $terminal->Tputs('cl', 1);
 }
 

--=-7FqtojpuBnCWV2hi5IUj--
