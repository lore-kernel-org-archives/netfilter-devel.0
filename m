From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] set match
Date: Sun, 28 May 2006 19:42:03 +0200
Message-ID: <1148838123.2516.1.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Hvr0IGn9GMQ7ROZjMMAD"
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


--=-Hvr0IGn9GMQ7ROZjMMAD
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

here's a simple patch for the set match in pom. It adds the
new protoff parameter in the match function of ipt_set.c and
changes struct ipt_ip * to void * in the checkentry function
of ipt_set.c and ipt_SET.c, so they compile without warnings.

Regards,
Torsten

--=-Hvr0IGn9GMQ7ROZjMMAD
Content-Disposition: attachment; filename=set.patch
Content-Type: text/x-patch; name=set.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: set/linux-2.6/net/ipv4/netfilter/ipt_SET.c
===================================================================
--- set/linux-2.6/net/ipv4/netfilter/ipt_SET.c	(revision 6622)
+++ set/linux-2.6/net/ipv4/netfilter/ipt_SET.c	(working copy)
@@ -48,7 +48,7 @@
 
 static int
 checkentry(const char *tablename,
-	   const struct ipt_entry *e,
+	   const void *e,
 	   void *targinfo,
 	   unsigned int targinfosize, unsigned int hook_mask)
 {
Index: set/linux-2.6/net/ipv4/netfilter/ipt_set.c
===================================================================
--- set/linux-2.6/net/ipv4/netfilter/ipt_set.c	(revision 6622)
+++ set/linux-2.6/net/ipv4/netfilter/ipt_set.c	(working copy)
@@ -34,6 +34,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ipt_set_info_match *info = matchinfo;
@@ -45,7 +46,7 @@
 
 static int
 checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *ip,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)

--=-Hvr0IGn9GMQ7ROZjMMAD--
