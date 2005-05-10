From: Patrick McHardy <kaber@trash.net>
Subject: [netfilter socket hooks 5/5]: Add skfilter table
Date: Tue, 10 May 2005 18:01:58 +0200
Message-ID: <4280DAF6.4050302@trash.net>
References: <Xine.LNX.4.44.0504270037490.16008-100000@thoron.boston.redhat.com>	<426F64C8.1070601@trash.net>	<426FA44A.2010008@evtek.fi>	<426FA73E.3090605@trash.net>	<20050427114926.45a91b5e.davem@davemloft.net>
	<426FE9DD.80201@trash.net> <4280DA51.8090201@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Cc: juha.heljoranta@evtek.fi, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4280DA51.8090201@trash.net>
Content-Disposition: inline;
 filename="05.diff"
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

[NETFILTER]: Add skfilter table

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 52c8e9e72ec788e5829c6e3d412ab9d1816d79a0
tree 4919a5761d3ba1c668a54d32a8f028f002c8ff24
parent 3e78de8c1e4b12407299b48cf9f024786415639f
author Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:41:31 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 09 May 2005 18:41:31 +0200

 net/ipv4/netfilter/Kconfig            |    4 
 net/ipv4/netfilter/Makefile           |    2 
 net/ipv4/netfilter/iptable_skfilter.c |  140 ++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+)

Index: net/ipv4/netfilter/Kconfig
===================================================================
--- a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/Kconfig  (mode:100644)
+++ 4919a5761d3ba1c668a54d32a8f028f002c8ff24/net/ipv4/netfilter/Kconfig  (mode:100644)
@@ -386,6 +386,10 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_SK_FILTER
+	tristate "Socket packet filtering"
+	depends on IP_NF_IPTABLES
+
 config IP_NF_TARGET_REJECT
 	tristate "REJECT target support"
 	depends on IP_NF_FILTER
Index: net/ipv4/netfilter/Makefile
===================================================================
--- a24014694fc1a7ed32010fe4524b2601c6516eaf/net/ipv4/netfilter/Makefile  (mode:100644)
+++ 4919a5761d3ba1c668a54d32a8f028f002c8ff24/net/ipv4/netfilter/Makefile  (mode:100644)
@@ -33,6 +33,8 @@
 obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
+obj-$(CONFIG_IP_NF_SK_FILTER)	+= iptable_skfilter.o
+
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HELPER) += ipt_helper.o
 obj-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit.o
Index: net/ipv4/netfilter/iptable_skfilter.c
===================================================================
--- /dev/null  (tree:a24014694fc1a7ed32010fe4524b2601c6516eaf)
+++ 4919a5761d3ba1c668a54d32a8f028f002c8ff24/net/ipv4/netfilter/iptable_skfilter.c  (mode:100644)
@@ -0,0 +1,140 @@
+/* 
+ * iptables 'skfilter' table
+ *
+ * Copyright (C) 2005 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#define SKFILTER_VALID_HOOKS ((1 << NF_IP_LOCAL_IN))
+
+static struct
+{
+	struct ipt_replace repl;
+	struct ipt_standard entries[1];
+	struct ipt_error term;
+} initial_table __initdata = {
+	.repl = {
+		.name = "skfilter", 
+		.valid_hooks = SKFILTER_VALID_HOOKS, 
+		.num_entries = 2,
+		.size = sizeof(struct ipt_standard) * 1 + sizeof(struct ipt_error),
+		.hook_entry = { 
+			[NF_IP_LOCAL_IN] = 0,
+		},
+		.underflow = { 
+			[NF_IP_LOCAL_IN] = 0,
+		},
+	},
+	.entries = {
+	     /* LOCAL_IN */
+	     { 
+		     .entry = { 
+			     .target_offset = sizeof(struct ipt_entry),
+			     .next_offset = sizeof(struct ipt_standard),
+		     },
+		     .target = { 
+			  .target = { 
+				  .u = {
+					  .target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
+				  },
+			  },
+			  .verdict = -NF_ACCEPT - 1,
+		     },
+	     },
+	},
+	/* ERROR */
+	.term = {
+		.entry = {
+			.target_offset = sizeof(struct ipt_entry),
+			.next_offset = sizeof(struct ipt_error),
+		},
+		.target = {
+			.target = {
+				.u = {
+					.user = {
+						.target_size = IPT_ALIGN(sizeof(struct ipt_error_target)), 
+						.name = IPT_ERROR_TARGET,
+					},
+				},
+			},
+			.errorname = "ERROR",
+		},
+	}
+};
+
+static struct ipt_table skfilter = { 
+	.name		= "skfilter",
+	.valid_hooks	= SKFILTER_VALID_HOOKS, 
+	.lock		= RW_LOCK_UNLOCKED, 
+	.me		= THIS_MODULE
+};
+
+/* The work comes in here from netfilter.c. */
+static unsigned int
+ipt_hook(unsigned int hook,
+         struct sock *sk,
+	 struct sk_buff **pskb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sock *, struct sk_buff *))
+{
+	unsigned int ret;
+	int pull = 0;
+
+	if ((*pskb)->data != (*pskb)->nh.raw) {
+		__skb_push(*pskb, (*pskb)->data - (*pskb)->nh.raw);
+		pull = 1;
+	}
+	ret = ipt_do_table(NULL, pskb, hook, in, out, &skfilter, NULL);
+	if (pull)
+		__skb_pull(*pskb, (*pskb)->nh.iph->ihl * 4);
+	return ret;
+}
+
+static struct nf_sk_hook_ops ipt_ops[] = {
+	{
+		.hook		= ipt_hook,
+		.owner		= THIS_MODULE,
+		.pf		= PF_INET, 
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_FILTER,
+	},
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	/* Register table */
+	ret = ipt_register_table(&skfilter, &initial_table.repl);
+	if (ret < 0)
+		return ret;
+
+	/* Register hooks */
+	ret = nf_register_sk_hook(&ipt_ops[0]);
+	if (ret < 0)
+		goto cleanup_table;
+
+	return ret;
+
+ cleanup_table:
+	ipt_unregister_table(&skfilter);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	nf_unregister_sk_hook(&ipt_ops[0]);
+	ipt_unregister_table(&skfilter);
+}
+
+module_init(init);
+module_exit(fini);
+MODULE_LICENSE("GPL");
