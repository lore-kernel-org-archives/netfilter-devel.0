From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng] ipt_TARPIT for Linux 2.6.19
Date: Thu, 11 Jan 2007 10:28:37 +0100
Message-ID: <20070111092837.GA32096@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Kj7319i9nmIyA2yE"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this patch makes ipt_TARPIT.c conform to the Linux 2.6.19 API.

Max


--Kj7319i9nmIyA2yE
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ipt_tarpit-linux_2.6.19.patch"

Index: patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c
===================================================================
--- patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	(revision 6730)
+++ patchlets/TARPIT/linux-2.6/net/ipv4/netfilter/ipt_TARPIT.c	(working copy)
@@ -35,7 +35,6 @@
  * - Reply to TCP !SYN,!RST,!FIN with ACK, window 0 bytes, rate-limited
  */
 
-#include <linux/config.h>
 #include <linux/version.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -214,8 +213,8 @@
 			   const struct net_device *in,
 			   const struct net_device *out,
 			   unsigned int hooknum,
-			   const void *targinfo,
-			   void *userinfo)
+			   const struct xt_target *target,
+			   const void *targinfo)
 {
 	struct sk_buff *skb = *pskb;
 	struct rtable *rt = (struct rtable*)skb->dst;
@@ -249,8 +248,8 @@
 
 static int check(const char *tablename,
 		 const void *e_void,
+		 const struct xt_target *target,
 		 void *targinfo,
-		 unsigned int targinfosize,
 		 unsigned int hook_mask)
 {
 	const struct ipt_entry *e = e_void;

--Kj7319i9nmIyA2yE--
