From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH] PoM-NG Subversion compatibility fix
Date: Wed, 20 Oct 2004 10:09:40 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098259780.2477.3.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XUoxKJM1/OsotVMemwS6"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-XUoxKJM1/OsotVMemwS6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

  PoM-NG fails to apply any patches from a checked Subversion working
area, because it fails to skip .svn directories when parsing directory
entries... The attached patch fixes this, please apply.

-- 
 Regards,
   Krisztian KOVACS

--=-XUoxKJM1/OsotVMemwS6
Content-Disposition: attachment; filename=pom-ng-svn-fix.patch
Content-Type: text/x-patch; name=pom-ng-svn-fix.patch; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: Netfilter_POM.pm
===================================================================
--- Netfilter_POM.pm	(revision 3229)
+++ Netfilter_POM.pm	(working copy)
@@ -379,7 +379,7 @@
 	opendir(DIR, $dir)
 		or croak "can't open directory $dir: $!";
 	# Don't miss .foo-test files!
-	my @dents = sort grep {!/^(\.\.?|CVS)$/} readdir(DIR);
+	my @dents = sort grep {!/^(\.\.?|CVS|\.svn)$/} readdir(DIR);
 	closedir(DIR);
 	foreach my $dent (@dents) {
 		my $fullpath = "$dir/$dent";

--=-XUoxKJM1/OsotVMemwS6--
