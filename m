From: Art Haas <ahaas@airmail.net>
Subject: [PATCH] C99 patches for net/bridge/netfilter
Date: Thu, 27 Feb 2003 11:25:25 -0600
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030227172525.GA21084@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org,
	linux-net@vger.kernel.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi.

Here are three patches for converting files in net/bridget/netfilter to
use C99 initializers. The patches at first were just going to be adding
an '=' to array initializers, but then I decided to add named
initializers to the structures as I thought it would make them easier to
read.

Art Haas

===== net/bridge/netfilter/ebtable_filter.c 1.1 vs edited =====
--- 1.1/net/bridge/netfilter/ebtable_filter.c	Mon Sep 16 18:11:27 2002
+++ edited/net/bridge/netfilter/ebtable_filter.c	Thu Feb 27 11:14:10 2003
@@ -16,16 +16,31 @@
 
 static struct ebt_entries initial_chains[] =
 {
-  {0, "INPUT", 0, EBT_ACCEPT, 0},
-  {0, "FORWARD", 0, EBT_ACCEPT, 0},
-  {0, "OUTPUT", 0, EBT_ACCEPT, 0}
+	{
+		.name	= "INPUT",
+		.policy	= EBT_ACCEPT,
+	},
+	{
+		.name	= "FORWARD",
+		.policy	= EBT_ACCEPT,
+	},
+	{
+		.name	= "OUTPUT",
+		.policy	= EBT_ACCEPT,
+	}
 };
 
 static struct ebt_replace initial_table =
 {
-  "filter", FILTER_VALID_HOOKS, 0, 3 * sizeof(struct ebt_entries),
-  { [NF_BR_LOCAL_IN]&initial_chains[0], [NF_BR_FORWARD]&initial_chains[1],
-    [NF_BR_LOCAL_OUT]&initial_chains[2] }, 0, NULL, (char *)initial_chains
+	.name		= "filter",
+	.valid_hooks	= FILTER_VALID_HOOKS,
+	.entries_size	= 3 * sizeof(struct ebt_entries),
+  	.hook_entry	= {
+		[NF_BR_LOCAL_IN]	= &initial_chains[0],
+		[NF_BR_FORWARD]		= &initial_chains[1],
+    		[NF_BR_LOCAL_OUT]	= &initial_chains[2],
+	},
+	.entries	= (char *)initial_chains
 };
 
 static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
@@ -37,8 +52,11 @@
 
 static struct ebt_table frame_filter =
 { 
-  {NULL, NULL}, "filter", &initial_table, FILTER_VALID_HOOKS, 
-  RW_LOCK_UNLOCKED, check, NULL
+	.name		= "filter",
+	.table		= &initial_table,
+	.valid_hooks	= FILTER_VALID_HOOKS, 
+	.lock		= RW_LOCK_UNLOCKED,
+	.check		= check,
 };
 
 static unsigned int
@@ -49,12 +67,24 @@
 }
 
 static struct nf_hook_ops ebt_ops_filter[] = {
-	{ { NULL, NULL }, ebt_hook, PF_BRIDGE, NF_BR_LOCAL_IN,
-	   NF_BR_PRI_FILTER_BRIDGED},
-	{ { NULL, NULL }, ebt_hook, PF_BRIDGE, NF_BR_FORWARD,
-	   NF_BR_PRI_FILTER_BRIDGED},
-	{ { NULL, NULL }, ebt_hook, PF_BRIDGE, NF_BR_LOCAL_OUT,
-	   NF_BR_PRI_FILTER_OTHER}
+	{
+		.hook		= ebt_hook,
+		.pf		= PF_BRIDGE,
+		.hooknum	= NF_BR_LOCAL_IN,
+		.priority	= NF_BR_PRI_FILTER_BRIDGED,
+	},
+	{
+		.hook		= ebt_hook,
+		.pf		= PF_BRIDGE,
+		.hooknum	= NF_BR_FORWARD,
+		.priority	= NF_BR_PRI_FILTER_BRIDGED
+	},
+	{
+		.hook		= ebt_hook,
+		.pf		= PF_BRIDGE,
+		.hooknum	= NF_BR_LOCAL_OUT,
+		.priority	= NF_BR_PRI_FILTER_OTHER
+	}
 };
 
 static int __init init(void)
===== net/bridge/netfilter/ebtable_nat.c 1.1 vs edited =====
--- 1.1/net/bridge/netfilter/ebtable_nat.c	Mon Sep 16 18:11:27 2002
+++ edited/net/bridge/netfilter/ebtable_nat.c	Thu Feb 27 11:13:56 2003
@@ -15,16 +15,31 @@
 
 static struct ebt_entries initial_chains[] =
 {
-  {0, "PREROUTING", 0, EBT_ACCEPT, 0},
-  {0, "OUTPUT", 0, EBT_ACCEPT, 0},
-  {0, "POSTROUTING", 0, EBT_ACCEPT, 0}
+	{
+		.name	= "PREROUTING",
+		.policy	= EBT_ACCEPT,
+	},
+	{
+		.name	= "OUTPUT",
+		.policy	= EBT_ACCEPT,
+	},
+	{
+		.name	= "POSTROUTING",
+		.policy	= EBT_ACCEPT,
+	}
 };
 
 static struct ebt_replace initial_table =
 {
-  "nat", NAT_VALID_HOOKS, 0, 3 * sizeof(struct ebt_entries),
-  { [NF_BR_PRE_ROUTING]&initial_chains[0], [NF_BR_LOCAL_OUT]&initial_chains[1],
-    [NF_BR_POST_ROUTING]&initial_chains[2] }, 0, NULL, (char *)initial_chains
+	.name		= "nat",
+	.valid_hooks	= NAT_VALID_HOOKS,
+	.entries_size	= 3 * sizeof(struct ebt_entries),
+	.hook_entry	= {
+		[NF_BR_PRE_ROUTING]	= &initial_chains[0],
+		[NF_BR_LOCAL_OUT]	= &initial_chains[1],
+		[NF_BR_POST_ROUTING]	= &initial_chains[2],
+	},
+	.entries	= (char *)initial_chains
 };
 
 static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
@@ -36,8 +51,11 @@
 
 static struct ebt_table frame_nat =
 {
-  {NULL, NULL}, "nat", &initial_table, NAT_VALID_HOOKS,
-  RW_LOCK_UNLOCKED, check, NULL
+	.name		= "nat",
+	.table		= &initial_table,
+	.valid_hooks	= NAT_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.check		= check,
 };
 
 static unsigned int
@@ -55,12 +73,24 @@
 }
 
 static struct nf_hook_ops ebt_ops_nat[] = {
-	{ { NULL, NULL }, ebt_nat_dst, PF_BRIDGE, NF_BR_LOCAL_OUT,
-	   NF_BR_PRI_NAT_DST_OTHER},
-	{ { NULL, NULL }, ebt_nat_src, PF_BRIDGE, NF_BR_POST_ROUTING,
-	   NF_BR_PRI_NAT_SRC},
-	{ { NULL, NULL }, ebt_nat_dst, PF_BRIDGE, NF_BR_PRE_ROUTING,
-	   NF_BR_PRI_NAT_DST_BRIDGED},
+	{
+		.hook		= ebt_nat_dst,
+		.pf		= PF_BRIDGE,
+		.hooknum	= NF_BR_LOCAL_OUT,
+		.priority	= NF_BR_PRI_NAT_DST_OTHER
+	},
+	{
+		.hook		= ebt_nat_src,
+		.pf		= PF_BRIDGE,
+		.hooknum	= NF_BR_POST_ROUTING,
+		.priority	= NF_BR_PRI_NAT_SRC
+	},
+	{
+		.hook		= ebt_nat_dst,
+		.pf		= PF_BRIDGE,
+		.hooknum	= NF_BR_PRE_ROUTING,
+		.priority	= NF_BR_PRI_NAT_DST_BRIDGED
+	},
 };
 
 static int __init init(void)
===== net/bridge/netfilter/ebtable_broute.c 1.1 vs edited =====
--- 1.1/net/bridge/netfilter/ebtable_broute.c	Mon Sep 16 18:11:27 2002
+++ edited/net/bridge/netfilter/ebtable_broute.c	Thu Feb 27 11:18:05 2003
@@ -18,13 +18,20 @@
 
 // EBT_ACCEPT means the frame will be bridged
 // EBT_DROP means the frame will be routed
-static struct ebt_entries initial_chain =
-  {0, "BROUTING", 0, EBT_ACCEPT, 0};
+static struct ebt_entries initial_chain = {
+	.name	= "BROUTING",
+	.policy	= EBT_ACCEPT,
+};
 
 static struct ebt_replace initial_table =
 {
-  "broute", 1 << NF_BR_BROUTING, 0, sizeof(struct ebt_entries),
-  { [NF_BR_BROUTING]&initial_chain}, 0, NULL, (char *)&initial_chain
+	.name		= "broute",
+	.valid_hooks	= 1 << NF_BR_BROUTING,
+	.entries_size	= sizeof(struct ebt_entries),
+	.hook_entry	= {
+		[NF_BR_BROUTING]	= &initial_chain,
+	},
+	.entries	= (char *)&initial_chain
 };
 
 static int check(const struct ebt_table_info *info, unsigned int valid_hooks)
@@ -36,8 +43,11 @@
 
 static struct ebt_table broute_table =
 {
-  {NULL, NULL}, "broute", &initial_table, 1 << NF_BR_BROUTING,
-  RW_LOCK_UNLOCKED, check, NULL
+	.name		= "broute",
+	.table		= &initial_table,
+	.valid_hooks	= 1 << NF_BR_BROUTING,
+	.lock		= RW_LOCK_UNLOCKED,
+	.check		= check,
 };
 
 static int ebt_broute(struct sk_buff **pskb)
-- 
They that can give up essential liberty to obtain a little temporary safety
deserve neither liberty nor safety.
 -- Benjamin Franklin, Historical Review of Pennsylvania, 1759
