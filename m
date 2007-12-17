From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER] xt_hashlimit : Can generate better code if only IPV4
 needed
Date: Mon, 17 Dec 2007 13:25:41 +0100
Message-ID: <47666AC5.4040207@trash.net>
References: <4762A920.8060609@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020009040706080206040907"
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <dada1@cosmosbay.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56302 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935283AbXLQM01 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:26:27 -0500
In-Reply-To: <4762A920.8060609@cosmosbay.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020009040706080206040907
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Eric Dumazet wrote:
> This patch generalizes the (CONFIG_IP6_NF_IPTABLES || 
> CONFIG_IP6_NF_IPTABLES_MODULE)
> test done in hashlimit_init_dst() to all the xt_hashlimit module.
> 
> This permits a size reduction of "struct dsthash_dst". This saves memory 
> and cpu for IPV4 only hosts.


Applied, thanks. I didn't really like the IFIPV6 macro though, so
I replaced it by open coded #ifdefs and removed the ones for
procdir selection since without ip6_tables we'll never have
family != AF_INET anyway.



--------------020009040706080206040907
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit 0a2348ed78e69fc5a45a35924337c0fca185e3f5
Author: Eric Dumazet <dada1@cosmosbay.com>
Date:   Mon Dec 17 13:24:28 2007 +0100

    [NETFILTER]: xt_hashlimit: reduce overhead without IPv6
    
    This patch generalizes the (CONFIG_IP6_NF_IPTABLES || CONFIG_IP6_NF_IPTABLES_MODULE)
    test done in hashlimit_init_dst() to all the xt_hashlimit module.
    
    This permits a size reduction of "struct dsthash_dst". This saves memory and
    cpu for IPV4 only hosts.
    
    Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 7cc04e8..c878b1c 100644
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

--------------020009040706080206040907--
