From: Art Haas <ahaas@airmail.net>
Subject: [PATCH] Add C99 initializers for some ipv4/netfilter files
Date: Fri, 7 Mar 2003 10:44:32 -0600
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030307164432.GF2247@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi.

Here is the patch set for the ipv4/netfilter files mentioned in the
ipv6/netfilter mail.

Art Haas

===== net/ipv4/netfilter/arptable_filter.c 1.2 vs edited =====
--- 1.2/net/ipv4/netfilter/arptable_filter.c	Mon Feb 10 04:35:55 2003
+++ edited/net/ipv4/netfilter/arptable_filter.c	Thu Mar  6 19:28:01 2003
@@ -111,9 +111,14 @@
     }
 };
 
-static struct arpt_table packet_filter
-= { { NULL, NULL }, "filter", &initial_table.repl,
-    FILTER_VALID_HOOKS, RW_LOCK_UNLOCKED, NULL, THIS_MODULE };
+static struct arpt_table packet_filter = {
+	.name		= "filter",
+	.table		= &initial_table.repl,
+	.valid_hooks	= FILTER_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.private	= NULL,
+	.me		= THIS_MODULE,
+};
 
 /* The work comes in here from netfilter.c */
 static unsigned int arpt_hook(unsigned int hook,
@@ -125,9 +130,17 @@
 	return arpt_do_table(pskb, hook, in, out, &packet_filter, NULL);
 }
 
-static struct nf_hook_ops arpt_ops[]
-= { { { NULL, NULL }, arpt_hook, NF_ARP, NF_ARP_IN, 0 },
-    { { NULL, NULL }, arpt_hook, NF_ARP, NF_ARP_OUT, 0 }
+static struct nf_hook_ops arpt_ops[] = {
+	{
+		.hook		= arpt_hook,
+		.pf		= NF_ARP,
+		.hooknum	= NF_ARP_IN,
+	},
+	{
+		.hook		= arpt_hook,
+		.pf		= NF_ARP,
+		.hooknum	= NF_ARP_OUT,
+	},
 };
 
 static int __init init(void)
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.13 vs edited =====
--- 1.13/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Mar  3 03:25:39 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Thu Mar  6 19:16:30 2003
@@ -226,17 +226,34 @@
 
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
-static struct nf_hook_ops ip_conntrack_in_ops
-= { { NULL, NULL }, ip_conntrack_in, PF_INET, NF_IP_PRE_ROUTING,
-	NF_IP_PRI_CONNTRACK };
-static struct nf_hook_ops ip_conntrack_local_out_ops
-= { { NULL, NULL }, ip_conntrack_local, PF_INET, NF_IP_LOCAL_OUT,
-	NF_IP_PRI_CONNTRACK };
+static struct nf_hook_ops ip_conntrack_in_ops = {
+	.hook		= ip_conntrack_in,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_PRE_ROUTING,
+	.priority	= NF_IP_PRI_CONNTRACK,
+};
+
+static struct nf_hook_ops ip_conntrack_local_out_ops = {
+	.hook		= ip_conntrack_local,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_OUT,
+	.priority	= NF_IP_PRI_CONNTRACK,
+};
+
 /* Refragmenter; last chance. */
-static struct nf_hook_ops ip_conntrack_out_ops
-= { { NULL, NULL }, ip_refrag, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_LAST };
-static struct nf_hook_ops ip_conntrack_local_in_ops
-= { { NULL, NULL }, ip_confirm, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_LAST-1 };
+static struct nf_hook_ops ip_conntrack_out_ops = {
+	.hook		= ip_refrag,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_POST_ROUTING,
+	.priority	= NF_IP_PRI_LAST,
+};
+
+static struct nf_hook_ops ip_conntrack_local_in_ops = {
+	.hook		= ip_confirm,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_IN,
+	.priority	= NF_IP_PRI_LAST-1,
+};
 
 static int init_or_cleanup(int init)
 {
===== net/ipv4/netfilter/ip_fw_compat.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_fw_compat.c	Wed Feb 19 14:23:25 2003
+++ edited/net/ipv4/netfilter/ip_fw_compat.c	Thu Mar  6 19:20:22 2003
@@ -216,21 +216,40 @@
 	return -ip_fw_ctl(optval, &tmp_fw, len);
 }
 
-static struct nf_hook_ops preroute_ops
-= { { NULL, NULL }, fw_in, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_FILTER };
+static struct nf_hook_ops preroute_ops = {
+	.hook		= fw_in,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_PRE_ROUTING,
+	.priority	= NF_IP_PRI_FILTER,
+};
 
-static struct nf_hook_ops postroute_ops
-= { { NULL, NULL }, fw_in, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_FILTER };
+static struct nf_hook_ops postroute_ops = {
+	.hook		= fw_in,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_POST_ROUTING,
+	.priority	= NF_IP_PRI_FILTER,
+};
 
-static struct nf_hook_ops forward_ops
-= { { NULL, NULL }, fw_in, PF_INET, NF_IP_FORWARD, NF_IP_PRI_FILTER };
+static struct nf_hook_ops forward_ops = {
+	.hook		= fw_in,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_FORWARD,
+	.priority	= NF_IP_PRI_FILTER,
+};
 
-static struct nf_hook_ops local_in_ops
-= { { NULL, NULL }, fw_confirm, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_LAST - 1 };
+static struct nf_hook_ops local_in_ops = {
+	.hook		= fw_confirm,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_IN,
+	.priority	= NF_IP_PRI_LAST - 1,
+};
 
-static struct nf_sockopt_ops sock_ops
-= { { NULL, NULL }, PF_INET, 64, 64 + 1024 + 1, &sock_fn, 0, 0, NULL,
-    0, NULL };
+static struct nf_sockopt_ops sock_ops = {
+	.pf		= PF_INET,
+	.set_optmin	= 64,
+	.set_optmax	= 64 + 1024 + 1,
+	.set		= &sock_fn,
+};
 
 extern int ipfw_init_or_cleanup(int init);
 
===== net/ipv4/netfilter/ip_nat_rule.c 1.7 vs edited =====
--- 1.7/net/ipv4/netfilter/ip_nat_rule.c	Sat Feb 22 18:15:34 2003
+++ edited/net/ipv4/netfilter/ip_nat_rule.c	Thu Mar  6 19:11:39 2003
@@ -101,9 +101,13 @@
     }
 };
 
-static struct ipt_table nat_table
-= { { NULL, NULL }, "nat", &nat_initial_table.repl,
-    NAT_VALID_HOOKS, RW_LOCK_UNLOCKED, NULL, THIS_MODULE };
+static struct ipt_table nat_table = {
+	.name		= "nat",
+	.table		= &nat_initial_table.repl,
+	.valid_hooks	= NAT_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.me		= THIS_MODULE,
+};
 
 /* Source NAT */
 static unsigned int ipt_snat_target(struct sk_buff **pskb,
@@ -270,10 +274,17 @@
 	return ret;
 }
 
-static struct ipt_target ipt_snat_reg
-= { { NULL, NULL }, "SNAT", ipt_snat_target, ipt_snat_checkentry, NULL };
-static struct ipt_target ipt_dnat_reg
-= { { NULL, NULL }, "DNAT", ipt_dnat_target, ipt_dnat_checkentry, NULL };
+static struct ipt_target ipt_snat_reg = {
+	.name		= "SNAT",
+	.target		= ipt_snat_target,
+	.checkentry	= ipt_snat_checkentry,
+};
+
+static struct ipt_target ipt_dnat_reg = {
+	.name		= "DNAT",
+	.target		= ipt_dnat_target,
+	.checkentry	= ipt_dnat_checkentry,
+};
 
 int __init ip_nat_rule_init(void)
 {
===== net/ipv4/netfilter/ip_nat_standalone.c 1.16 vs edited =====
--- 1.16/net/ipv4/netfilter/ip_nat_standalone.c	Mon Mar  3 03:15:36 2003
+++ edited/net/ipv4/netfilter/ip_nat_standalone.c	Thu Mar  6 19:23:24 2003
@@ -225,18 +225,36 @@
 /* We must be after connection tracking and before packet filtering. */
 
 /* Before packet filtering, change destination */
-static struct nf_hook_ops ip_nat_in_ops
-= { { NULL, NULL }, ip_nat_fn, PF_INET, NF_IP_PRE_ROUTING, NF_IP_PRI_NAT_DST };
+static struct nf_hook_ops ip_nat_in_ops = {
+	.hook		= ip_nat_fn,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_PRE_ROUTING,
+	.priority	= NF_IP_PRI_NAT_DST,
+};
+
 /* After packet filtering, change source */
-static struct nf_hook_ops ip_nat_out_ops
-= { { NULL, NULL }, ip_nat_out, PF_INET, NF_IP_POST_ROUTING, NF_IP_PRI_NAT_SRC};
+static struct nf_hook_ops ip_nat_out_ops = {
+	.hook		= ip_nat_out,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_POST_ROUTING,
+	.priority	= NF_IP_PRI_NAT_SRC,
+};
+
 /* Before packet filtering, change destination */
-static struct nf_hook_ops ip_nat_local_out_ops
-= { { NULL, NULL }, ip_nat_local_fn, PF_INET, NF_IP_LOCAL_OUT, NF_IP_PRI_NAT_DST };
+static struct nf_hook_ops ip_nat_local_out_ops = {
+	.hook		= ip_nat_local_fn,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_OUT,
+	.priority	= NF_IP_PRI_NAT_DST,
+};
 
 #ifdef CONFIG_IP_NF_NAT_LOCAL
-static struct nf_hook_ops ip_nat_local_in_ops
-= { { NULL, NULL }, ip_nat_fn, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_NAT_SRC };
+static struct nf_hook_ops ip_nat_local_in_ops = {
+	.hook		= ip_nat_fn,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_IN,
+	.priority	= NF_IP_PRI_NAT_SRC,
+};
 #endif
 
 /* Protocol registration. */
===== net/ipv4/netfilter/iptable_filter.c 1.4 vs edited =====
--- 1.4/net/ipv4/netfilter/iptable_filter.c	Mon Feb 10 04:35:55 2003
+++ edited/net/ipv4/netfilter/iptable_filter.c	Thu Mar  6 19:02:48 2003
@@ -81,9 +81,13 @@
     }
 };
 
-static struct ipt_table packet_filter
-= { { NULL, NULL }, "filter", &initial_table.repl,
-    FILTER_VALID_HOOKS, RW_LOCK_UNLOCKED, NULL, THIS_MODULE };
+static struct ipt_table packet_filter = {
+	.name		= "filter",
+	.table		= &initial_table.repl,
+	.valid_hooks	= FILTER_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.me		= THIS_MODULE
+};
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
@@ -114,11 +118,25 @@
 	return ipt_do_table(pskb, hook, in, out, &packet_filter, NULL);
 }
 
-static struct nf_hook_ops ipt_ops[]
-= { { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_LOCAL_IN, NF_IP_PRI_FILTER },
-    { { NULL, NULL }, ipt_hook, PF_INET, NF_IP_FORWARD, NF_IP_PRI_FILTER },
-    { { NULL, NULL }, ipt_local_out_hook, PF_INET, NF_IP_LOCAL_OUT,
-		NF_IP_PRI_FILTER }
+static struct nf_hook_ops ipt_ops[] = {
+	{
+		.hook		= ipt_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_FILTER,
+	},
+	{
+		.hook		= ipt_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_FORWARD,
+		.priority	= NF_IP_PRI_FILTER,
+	},
+	{
+		.hook		= ipt_local_out_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_FILTER,
+	},
 };
 
 /* Default to forward because I got too much mail already. */
===== net/ipv4/netfilter/iptable_mangle.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/iptable_mangle.c	Mon Feb 10 04:35:55 2003
+++ edited/net/ipv4/netfilter/iptable_mangle.c	Thu Mar  6 19:07:33 2003
@@ -114,9 +114,13 @@
     }
 };
 
-static struct ipt_table packet_mangler
-= { { NULL, NULL }, "mangle", &initial_table.repl,
-    MANGLE_VALID_HOOKS, RW_LOCK_UNLOCKED, NULL, THIS_MODULE };
+static struct ipt_table packet_mangler = {
+	.name		= "mangle",
+	.table		= &initial_table.repl,
+	.valid_hooks	= MANGLE_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.me		= THIS_MODULE,
+};
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
@@ -167,17 +171,37 @@
 	return ret;
 }
 
-static struct nf_hook_ops ipt_ops[]
-= { { { NULL, NULL }, ipt_route_hook, PF_INET, NF_IP_PRE_ROUTING, 
-	NF_IP_PRI_MANGLE },
-    { { NULL, NULL }, ipt_local_hook, PF_INET, NF_IP_LOCAL_IN,
-	NF_IP_PRI_MANGLE },
-    { { NULL, NULL }, ipt_route_hook, PF_INET, NF_IP_FORWARD,
-	NF_IP_PRI_MANGLE },
-    { { NULL, NULL }, ipt_local_hook, PF_INET, NF_IP_LOCAL_OUT,
-	NF_IP_PRI_MANGLE },
-    { { NULL, NULL }, ipt_route_hook, PF_INET, NF_IP_POST_ROUTING,
-	NF_IP_PRI_MANGLE }
+static struct nf_hook_ops ipt_ops[] = {
+	{
+		.hook		= ipt_route_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_PRE_ROUTING, 
+		.priority	= NF_IP_PRI_MANGLE,
+	},
+	{
+		.hook		= ipt_local_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_IN,
+		.priority	= NF_IP_PRI_MANGLE,
+	},
+	{
+		.hook		= ipt_route_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_FORWARD,
+		.priority	= NF_IP_PRI_MANGLE,
+	},
+	{
+		.hook		= ipt_local_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_LOCAL_OUT,
+		.priority	= NF_IP_PRI_MANGLE,
+	},
+	{
+		.hook		= ipt_route_hook,
+		.pf		= PF_INET,
+		.hooknum	= NF_IP_POST_ROUTING,
+		.priority	= NF_IP_PRI_MANGLE,
+	},
 };
 
 static int __init init(void)
-- 
They that can give up essential liberty to obtain a little temporary safety
deserve neither liberty nor safety.
 -- Benjamin Franklin, Historical Review of Pennsylvania, 1759
