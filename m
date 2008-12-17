From: Piotr Duszynski <regis44@gmail.com>
Subject: [PATCH 1/1 ] Conntrack extensions : Interrupt timeout
Date: Wed, 17 Dec 2008 21:22:32 +0100
Message-ID: <49495F88.2010103@gmail.com>
References: <49467ACC.8080107@trash.net> <20081216.012018.196068498.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYLQU1r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:27:47 -0500
Received: by fg-out-1718.google.com with SMTP id 19so40042fgg.17
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2008 12:27:45 -0800 (PST)
In-Reply-To: <20081216.012018.196068498.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi everyone,

This is my first patch for the netfilter, so please don't flame me from
the beginning :) I am not a kernel hacker .

I wanted to write a module that would track all the MAC information for
all established connections. Unfortunately, after the module is loaded
and all the information is being properly recorded to the conntrack
computer hangs . I can read that it is related with interrupt timeout,
but after several hours of trying to fix this I am still in the same
spot . I would really appreciate any guidance in this matter .

Best regards
Piotr Duszynski

Example usage :

iptables -A INPUT -j L2INFO

Patch:

diff -uNr
linux-2.6.27.i686.orig/include/linux/netfilter/nf_conntrack_common.h
linux-2.6.27.i686.new/include/linux/netfilter/nf_conntrack_common.h
- ---
linux-2.6.27.i686.orig/include/linux/netfilter/nf_conntrack_common.h
2008-11-28 07:31:14.000000000 +0100
+++ linux-2.6.27.i686.new/include/linux/netfilter/nf_conntrack_common.h
2008-12-09 17:42:47.000000000 +0100
@@ -73,6 +73,10 @@
 	/* Connection has fixed timeout. */
 	IPS_FIXED_TIMEOUT_BIT = 10,
 	IPS_FIXED_TIMEOUT = (1 << IPS_FIXED_TIMEOUT_BIT),
+
+	/* Connection has src L2 info */
+	IPS_L2_INFO_BIT = 11,
+	IPS_L2_INFO = (1 << IPS_L2_INFO_BIT),
 };

 /* Connection tracking event bits */
diff -uNr linux-2.6.27.i686.orig/include/linux/netfilter/xt_L2INFO.h
linux-2.6.27.i686.new/include/linux/netfilter/xt_L2INFO.h
- --- linux-2.6.27.i686.orig/include/linux/netfilter/xt_L2INFO.h
1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.27.i686.new/include/linux/netfilter/xt_L2INFO.h	2008-12-14
06:10:29.000000000 +0100
@@ -0,0 +1,29 @@
+#ifndef _XT_L2INFO_H
+#define _XT_L2INFO_H
+
+#include <linux/if_ether.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conn_l2info {
+	// MAC only at the moment
+	unsigned char src_addr[ETH_ALEN];
+	unsigned char dst_addr[ETH_ALEN];
+};
+
+
+
+static inline struct nf_conn_l2info  *nfct_l2info(const struct nf_conn *ct)
+{
+        return nf_ct_ext_find(ct,NF_CT_EXT_L2INFO);
+}
+
+#endif
+
diff -uNr
linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_extend.h
linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_extend.h
- --- linux-2.6.27.i686.orig/include/net/netfilter/nf_conntrack_extend.h
2008-11-28 07:31:53.000000000 +0100
+++ linux-2.6.27.i686.new/include/net/netfilter/nf_conntrack_extend.h
2008-12-14 04:16:44.000000000 +0100
@@ -8,12 +8,14 @@
 	NF_CT_EXT_HELPER,
 	NF_CT_EXT_NAT,
 	NF_CT_EXT_ACCT,
+	NF_CT_EXT_L2INFO,
 	NF_CT_EXT_NUM,
 };

 #define NF_CT_EXT_HELPER_TYPE struct nf_conn_help
 #define NF_CT_EXT_NAT_TYPE struct nf_conn_nat
 #define NF_CT_EXT_ACCT_TYPE struct nf_conn_counter
+#define NF_CT_EXT_L2INFO_TYPE struct nf_conn_l2info

 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff -uNr linux-2.6.27.i686.orig/net/netfilter/Kconfig
linux-2.6.27.i686.new/net/netfilter/Kconfig
- --- linux-2.6.27.i686.orig/net/netfilter/Kconfig	2008-11-28
07:29:39.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/Kconfig	2008-12-09
18:52:13.000000000 +0100
@@ -380,6 +380,16 @@

 	  To compile it as a module, choose M here.  If unsure, say N.

+
+config NETFILTER_XT_TARGET_L2INFO
+	tristate  '"L2INFO" target support'
+	depends on NETFILTER_XTABLES
+	depends on NF_CONNTRACK
+	help
+	  Adds L2 info to the connection
+	  If unsure, say `N'.
+
+
 config NETFILTER_XT_TARGET_NOTRACK
 	tristate  '"NOTRACK" target support'
 	depends on NETFILTER_XTABLES
diff -uNr linux-2.6.27.i686.orig/net/netfilter/Makefile
linux-2.6.27.i686.new/net/netfilter/Makefile
- --- linux-2.6.27.i686.orig/net/netfilter/Makefile	2008-11-28
07:29:33.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/Makefile	2008-12-09
18:52:18.000000000 +0100
@@ -49,6 +49,7 @@
 obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_L2INFO) += xt_L2INFO.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
 obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o

diff -uNr linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_standalone.c
linux-2.6.27.i686.new/net/netfilter/nf_conntrack_standalone.c
- --- linux-2.6.27.i686.orig/net/netfilter/nf_conntrack_standalone.c
2008-11-28 07:29:39.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/nf_conntrack_standalone.c
2008-12-14 06:28:19.000000000 +0100
@@ -26,6 +26,8 @@
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_acct.h>
+#include <linux/netfilter/xt_L2INFO.h>
+

 MODULE_LICENSE("GPL");

@@ -151,6 +153,32 @@
 	if (test_bit(IPS_ASSURED_BIT, &ct->status))
 		if (seq_printf(s, "[ASSURED] "))
 			return -ENOSPC;
+	if (test_bit(IPS_L2_INFO, &ct->status))
+	    {
+		if (seq_printf(s, "[L2INFO] "))
+			return -ENOSPC;
+	        struct nf_conn_l2info* l2info = nfct_l2info(ct);	
+	
+		if (!l2info)
+			return -ENOSPC;
+
+		int
ret=seq_printf(s,"[%.2x:%.2x:%.2x:%.2x:%.2x:%.2x]<->[%.2x:%.2x:%.2x:%.2x:%.2x:%.2x]
",
+                l2info->src_addr[0],
+                l2info->src_addr[1],
+                l2info->src_addr[2],
+                l2info->src_addr[3],
+                l2info->src_addr[4],
+                l2info->dst_addr[5],
+                l2info->dst_addr[0],
+                l2info->dst_addr[1],
+                l2info->dst_addr[2],
+                l2info->dst_addr[3],
+                l2info->dst_addr[4],
+                l2info->dst_addr[5]);
+	
+		if (ret)
+		return -ENOSPC;
+	    }

 #if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (seq_printf(s, "mark=%u ", ct->mark))
diff -uNr linux-2.6.27.i686.orig/net/netfilter/xt_L2INFO.c
linux-2.6.27.i686.new/net/netfilter/xt_L2INFO.c
- --- linux-2.6.27.i686.orig/net/netfilter/xt_L2INFO.c	1970-01-01
01:00:00.000000000 +0100
+++ linux-2.6.27.i686.new/net/netfilter/xt_L2INFO.c	2008-12-17
07:25:09.000000000 +0100
@@ -0,0 +1,140 @@
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+#include <linux/netfilter/xt_L2INFO.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/inet.h>
+#include <linux/version.h>
+
+
+MODULE_AUTHOR("Piotr Duszynski L2 info target");
+MODULE_DESCRIPTION("x_tables per-conntrack L2info target");
+MODULE_LICENSE("GPL");
+
+
+static unsigned int target(struct sk_buff *skb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const struct xt_target *target,
+       const void *targinfo)
+{
+	struct nf_conn_l2info *l2info ;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	struct ethhdr *eth;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	
+	if (ct && (! test_bit(IPS_L2_INFO,&ct->status)))
+	{
+
+  	if(IP_CT_ESTABLISHED!=ctinfo
+	&& ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
+	return XT_CONTINUE;
+	
+	if (  IP_CT_ESTABLISHED==ctinfo)
+	printk(KERN_INFO "L2INFO ESTABLISHED\n");
+	if ( ctinfo == IP_CT_ESTABLISHED+IP_CT_IS_REPLY)
+	printk(KERN_INFO "L2INFO REPLY ESTABLISHED\n");
+	
+		l2info = nfct_l2info(ct);
+		if (!l2info) {
+			printk(KERN_INFO "Adding L2INFO extension\n");
+			l2info = nf_ct_ext_add(ct, NF_CT_EXT_L2INFO,GFP_ATOMIC);
+			if (l2info == NULL) {
+				printk(KERN_INFO "failed to add L2INFO extension\n");
+				return XT_CONTINUE;
+			}
+		}
+		
+		set_bit(IPS_L2_INFO,&ct->status);
+	}
+		return XT_CONTINUE;
+}
+
+
+static void
+destroy(const struct xt_target *target, void *targinfo)
+{
+	nf_ct_l3proto_module_put(target->family);
+}
+
+
+static struct xt_target xt_l2info __read_mostly = {
+		.name		= "L2INFO",
+		.family		= AF_INET,
+		.destroy 	= destroy,
+		.target		= target,
+		.me		= THIS_MODULE,
+};
+
+static struct nf_ct_ext_type l2info_extend __read_mostly = {
+	.len		= sizeof(struct nf_conn_l2info),
+	.align		= __alignof__(struct nf_conn_l2info),
+	.id		= NF_CT_EXT_L2INFO,
+};
+
+static int __init xt_l2info_init(void)
+{
+	int ret;
+
+	ret = nf_ct_extend_register(&l2info_extend);
+	if (ret < 0) {
+		printk(KERN_ERR "xt_L2INFO: Unable to register extension\n");
+		return ret;
+	}
+
+	ret = xt_register_target(&xt_l2info);
+	if (ret < 0)
+		nf_ct_extend_unregister(&l2info_extend);
+	else
+	printk(KERN_ERR "xt_L2INFO: Target registered \n");
+	
+	return ret;
+}
+
+static void __exit xt_l2info_fin(void)
+{
+	nf_ct_extend_unregister(&l2info_extend);
+	xt_unregister_target(&xt_l2info);
+}
+
+module_init(xt_l2info_init);
+module_exit(xt_l2info_fin);
+

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklJX4gACgkQd6OfpFr9kt8cowCfec1CCI67wJ6gSJXSznrxo1Ho
N/8AniB2w5Wf5S4ZMBlMyaBbgEpkqTzM
=ks30
-----END PGP SIGNATURE-----
