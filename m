From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [patch] Fix for u32 patchlet and kernel 2.6.21
Date: Thu, 26 Apr 2007 14:14:13 +0200
Message-ID: <200704261414.14643.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WeJMGk1TG7m+qVS"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

--Boundary-00=_WeJMGk1TG7m+qVS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

attached is a small patch to get the u32 patchlet
running again with kernel 2.6.21.

Cheers,
Thomas

--Boundary-00=_WeJMGk1TG7m+qVS
Content-Type: text/x-diff; charset="us-ascii"; name="pom-u32-fix-2.6.21.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="pom-u32-fix-2.6.21.patch"

Signed-Off: Thomas Jarosch <thomas.jarosch@intra2net.com>

diff -u -p u32.old/ipt_u32.c u32/ipt_u32.c
--- u32.old/ipt_u32.c	Tue Aug  8 11:58:29 2006
+++ u32/ipt_u32.c	Thu Apr 26 13:41:54 2007
@@ -214,8 +214,9 @@ checkentry(const char *tablename,
 	return 1;
 }
 
-static struct ipt_match u32_match = { 
+static struct xt_match u32_match = { 
 	.name 		= "u32",
+	.family         = AF_INET,
 	.match		= &match,
 	.matchsize	= sizeof(struct ipt_u32),
 	.checkentry	= &checkentry,
@@ -224,12 +225,12 @@ static struct ipt_match u32_match = { 
 
 static int __init init(void)
 {
-	return ipt_register_match(&u32_match);
+	return xt_register_match(&u32_match);
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_match(&u32_match);
+	xt_unregister_match(&u32_match);
 }
 
 module_init(init);

--Boundary-00=_WeJMGk1TG7m+qVS--
