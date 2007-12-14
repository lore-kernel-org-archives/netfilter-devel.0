From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [NETFILTER] xt_hashlimit : Can generate better code if only IPV4
 needed
Date: Fri, 14 Dec 2007 17:02:40 +0100
Message-ID: <4762A920.8060609@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040309090108050702080108"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp28.orange.fr ([80.12.242.100]:28731 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbXLNQCo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:02:44 -0500
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2812.orange.fr (SMTP Server) with ESMTP id 4EED670000A4
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Dec 2007 17:02:42 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040309090108050702080108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch generalizes the (CONFIG_IP6_NF_IPTABLES || 
CONFIG_IP6_NF_IPTABLES_MODULE)
test done in hashlimit_init_dst() to all the xt_hashlimit module.

This permits a size reduction of "struct dsthash_dst". This saves memory 
and cpu for IPV4 only hosts.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

 net/netfilter/xt_hashlimit.c |   45 ++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 14 deletions(-)



--------------040309090108050702080108
Content-Type: text/plain;
 name="xt_hashlimit_ipv6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_hashlimit_ipv6.patch"

--- net-2.6.25/net/netfilter/xt_hashlimit.c.prev
+++ net-2.6.25/net/netfilter/xt_hashlimit.c
@@ -20,8 +20,14 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/ipv6.h>
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+# include <linux/ipv6.h>
+# include <net/ipv6.h>
+# define IFIPV6(...) __VA_ARGS__
+#else
+# define IFIPV6(...)
+#endif
+
 #include <net/net_namespace.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -34,11 +40,11 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("iptables match for limiting per hash-bucket");
 MODULE_ALIAS("ipt_hashlimit");
-MODULE_ALIAS("ip6t_hashlimit");
+IFIPV6(MODULE_ALIAS("ip6t_hashlimit");)
 
 /* need to declare this at the top */
 static struct proc_dir_entry *hashlimit_procdir4;
-static struct proc_dir_entry *hashlimit_procdir6;
+IFIPV6(static struct proc_dir_entry *hashlimit_procdir6;)
 static const struct file_operations dl_file_ops;
 
 /* hash table crap */
@@ -48,10 +54,12 @@ struct dsthash_dst {
 			__be32 src;
 			__be32 dst;
 		} ip;
+	    IFIPV6(
 		struct {
 			__be32 src[4];
 			__be32 dst[4];
 		} ip6;
+	    )
 	} addr;
 	__be16 src_port;
 	__be16 dst_port;
@@ -221,8 +229,9 @@ static int htable_create(struct xt_hashl
 	hinfo->rnd_initialized = 0;
 	spin_lock_init(&hinfo->lock);
 	hinfo->pde = create_proc_entry(minfo->name, 0,
-				       family == AF_INET ? hashlimit_procdir4 :
-							   hashlimit_procdir6);
+				       IFIPV6(family == AF_INET6 ?
+							hashlimit_procdir6 :)
+							hashlimit_procdir4);
 	if (!hinfo->pde) {
 		vfree(hinfo);
 		return -1;
@@ -292,8 +301,9 @@ static void htable_destroy(struct xt_has
 
 	/* remove proc entry */
 	remove_proc_entry(hinfo->pde->name,
-			  hinfo->family == AF_INET ? hashlimit_procdir4 :
-						     hashlimit_procdir6);
+			  IFIPV6(hinfo->family == AF_INET6 ?
+					hashlimit_procdir6 :)
+					hashlimit_procdir4);
 	htable_selective_cleanup(hinfo, select_all);
 	vfree(hinfo);
 }
@@ -405,7 +415,7 @@ hashlimit_init_dst(const struct xt_hashl
 			return 0;
 		nexthdr = ip_hdr(skb)->protocol;
 		break;
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+IFIPV6(
 	case AF_INET6:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
 			memcpy(&dst->addr.ip6.dst, &ipv6_hdr(skb)->daddr,
@@ -422,7 +432,7 @@ hashlimit_init_dst(const struct xt_hashl
 		if ((int)protoff < 0)
 			return -1;
 		break;
-#endif
+)
 	default:
 		BUG();
 		return 0;
@@ -599,6 +609,7 @@ static struct xt_match hashlimit_mt_reg[
 		.destroy	= hashlimit_mt_destroy,
 		.me		= THIS_MODULE
 	},
+IFIPV6(
 	{
 		.name		= "hashlimit",
 		.family		= AF_INET6,
@@ -613,6 +624,7 @@ static struct xt_match hashlimit_mt_reg[
 		.destroy	= hashlimit_mt_destroy,
 		.me		= THIS_MODULE
 	},
+    )
 };
 
 /* PROC stuff */
@@ -675,6 +687,7 @@ static int dl_seq_real_show(struct dstha
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
+    IFIPV6(
 	case AF_INET6:
 		return seq_printf(s, "%ld " NIP6_FMT ":%u->"
 				     NIP6_FMT ":%u %u %u %u\n",
@@ -685,6 +698,7 @@ static int dl_seq_real_show(struct dstha
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
+    )
 	default:
 		BUG();
 		return 0;
@@ -756,14 +770,17 @@ static int __init hashlimit_mt_init(void
 				"entry\n");
 		goto err3;
 	}
+	err = 0;
+IFIPV6(
 	hashlimit_procdir6 = proc_mkdir("ip6t_hashlimit", init_net.proc_net);
 	if (!hashlimit_procdir6) {
 		printk(KERN_ERR "xt_hashlimit: unable to create proc dir "
 				"entry\n");
-		goto err4;
+		err = -ENOMEM;
 	}
-	return 0;
-err4:
+    )
+	if (!err)
+		return 0;
 	remove_proc_entry("ipt_hashlimit", init_net.proc_net);
 err3:
 	kmem_cache_destroy(hashlimit_cachep);
@@ -777,7 +794,7 @@ err1:
 static void __exit hashlimit_mt_exit(void)
 {
 	remove_proc_entry("ipt_hashlimit", init_net.proc_net);
-	remove_proc_entry("ip6t_hashlimit", init_net.proc_net);
+IFIPV6(	remove_proc_entry("ip6t_hashlimit", init_net.proc_net);)
 	kmem_cache_destroy(hashlimit_cachep);
 	xt_unregister_matches(hashlimit_mt_reg, ARRAY_SIZE(hashlimit_mt_reg));
 }

--------------040309090108050702080108--


