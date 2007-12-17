From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 62/64]: xt_hashlimit: reduce overhead without IPv6
Date: Tue, 18 Dec 2007 00:47:37 +0100 (MET)
Message-ID: <20071217234737.23601.23404.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39072 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933548AbXLQXrj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:39 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_hashlimit: reduce overhead without IPv6

This patch generalizes the (CONFIG_IP6_NF_IPTABLES || CONFIG_IP6_NF_IPTABLES_MODULE)
test done in hashlimit_init_dst() to all the xt_hashlimit module.

This permits a size reduction of "struct dsthash_dst". This saves memory and
cpu for IPV4 only hosts.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0a5d984db399c3f71a657b3bbe13904a359bf614
tree e5504b8c345752d394a11a716f0698c0da22b1d6
parent 990af8a278165f0bf91b6d13d9caa61260633868
author Eric Dumazet <dada1@cosmosbay.com> Mon, 17 Dec 2007 14:58:58 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 net/netfilter/xt_hashlimit.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 651c1d2..c35d220 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -20,8 +20,11 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/ip.h>
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 #include <linux/ipv6.h>
 #include <net/ipv6.h>
+#endif
+
 #include <net/net_namespace.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -48,10 +51,12 @@ struct dsthash_dst {
 			__be32 src;
 			__be32 dst;
 		} ip;
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 		struct {
 			__be32 src[4];
 			__be32 dst[4];
 		} ip6;
+#endif
 	} addr;
 	__be16 src_port;
 	__be16 dst_port;
@@ -599,6 +604,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 		.destroy	= hashlimit_mt_destroy,
 		.me		= THIS_MODULE
 	},
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	{
 		.name		= "hashlimit",
 		.family		= AF_INET6,
@@ -613,6 +619,7 @@ static struct xt_match hashlimit_mt_reg[] __read_mostly = {
 		.destroy	= hashlimit_mt_destroy,
 		.me		= THIS_MODULE
 	},
+#endif
 };
 
 /* PROC stuff */
@@ -675,6 +682,7 @@ static int dl_seq_real_show(struct dsthash_ent *ent, int family,
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	case AF_INET6:
 		return seq_printf(s, "%ld " NIP6_FMT ":%u->"
 				     NIP6_FMT ":%u %u %u %u\n",
@@ -685,6 +693,7 @@ static int dl_seq_real_show(struct dsthash_ent *ent, int family,
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
+#endif
 	default:
 		BUG();
 		return 0;
@@ -756,14 +765,17 @@ static int __init hashlimit_mt_init(void)
 				"entry\n");
 		goto err3;
 	}
+	err = 0;
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	hashlimit_procdir6 = proc_mkdir("ip6t_hashlimit", init_net.proc_net);
 	if (!hashlimit_procdir6) {
 		printk(KERN_ERR "xt_hashlimit: unable to create proc dir "
 				"entry\n");
-		goto err4;
+		err = -ENOMEM;
 	}
-	return 0;
-err4:
+#endif
+	if (!err)
+		return 0;
 	remove_proc_entry("ipt_hashlimit", init_net.proc_net);
 err3:
 	kmem_cache_destroy(hashlimit_cachep);
@@ -777,7 +789,9 @@ err1:
 static void __exit hashlimit_mt_exit(void)
 {
 	remove_proc_entry("ipt_hashlimit", init_net.proc_net);
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 	remove_proc_entry("ip6t_hashlimit", init_net.proc_net);
+#endif
 	kmem_cache_destroy(hashlimit_cachep);
 	xt_unregister_matches(hashlimit_mt_reg, ARRAY_SIZE(hashlimit_mt_reg));
 }
