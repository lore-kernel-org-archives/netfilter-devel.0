From: Art Haas <ahaas@airmail.net>
Subject: [PATCH] Add C99 initializers to a few ipv6/netfilter files
Date: Fri, 7 Mar 2003 10:43:05 -0600
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030307164305.GE2247@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, linux-net@vger.kernel.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi.

Here is a set of two patches that add C99 initializers to files in the
subject directory. A similar patch for ipv4 files will follow.

There are some giant structures in the netfilter code that would benefit
from named initializers. I'll try to tackle them later.

Art Haas


===== net/ipv6/netfilter/ip6table_filter.c 1.4 vs edited =====
--- 1.4/net/ipv6/netfilter/ip6table_filter.c	Mon Feb 10 06:36:12 2003
+++ edited/net/ipv6/netfilter/ip6table_filter.c	Thu Mar  6 19:34:26 2003
@@ -81,9 +81,13 @@
     }
 };
 
-static struct ip6t_table packet_filter
-= { { NULL, NULL }, "filter", &initial_table.repl,
-    FILTER_VALID_HOOKS, RW_LOCK_UNLOCKED, NULL, THIS_MODULE };
+static struct ip6t_table packet_filter = {
+	.name		= "filter",
+	.table		= &initial_table.repl,
+	.valid_hooks	= FILTER_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.me		= THIS_MODULE,
+};
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
@@ -116,11 +120,25 @@
 	return ip6t_do_table(pskb, hook, in, out, &packet_filter, NULL);
 }
 
-static struct nf_hook_ops ip6t_ops[]
-= { { { NULL, NULL }, ip6t_hook, PF_INET6, NF_IP6_LOCAL_IN, NF_IP6_PRI_FILTER },
-    { { NULL, NULL }, ip6t_hook, PF_INET6, NF_IP6_FORWARD, NF_IP6_PRI_FILTER },
-    { { NULL, NULL }, ip6t_local_out_hook, PF_INET6, NF_IP6_LOCAL_OUT,
-		NF_IP6_PRI_FILTER }
+static struct nf_hook_ops ip6t_ops[] = {
+	{
+		.hook		= ip6t_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_IN,
+		.priority	= NF_IP6_PRI_FILTER,
+	},
+	{
+		.hook		= ip6t_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_FORWARD,
+		.priority	= NF_IP6_PRI_FILTER,
+	},
+	{
+		.hook		= ip6t_local_out_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_FILTER,
+	},
 };
 
 /* Default to forward because I got too much mail already. */
===== net/ipv6/netfilter/ip6table_mangle.c 1.5 vs edited =====
--- 1.5/net/ipv6/netfilter/ip6table_mangle.c	Mon Feb 10 06:36:12 2003
+++ edited/net/ipv6/netfilter/ip6table_mangle.c	Thu Mar  6 19:38:03 2003
@@ -111,9 +111,13 @@
     }
 };
 
-static struct ip6t_table packet_mangler
-= { { NULL, NULL }, "mangle", &initial_table.repl,
-    MANGLE_VALID_HOOKS, RW_LOCK_UNLOCKED, NULL, THIS_MODULE };
+static struct ip6t_table packet_mangler = {
+	.name		= "mangle",
+	.table		= &initial_table.repl,
+	.valid_hooks	= MANGLE_VALID_HOOKS,
+	.lock		= RW_LOCK_UNLOCKED,
+	.me		= THIS_MODULE,
+};
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
@@ -175,12 +179,37 @@
 	return ret;
 }
 
-static struct nf_hook_ops ip6t_ops[]
-= { { { NULL, NULL }, ip6t_route_hook, PF_INET6, NF_IP6_PRE_ROUTING,  NF_IP6_PRI_MANGLE },
-    { { NULL, NULL }, ip6t_local_hook, PF_INET6, NF_IP6_LOCAL_IN,     NF_IP6_PRI_MANGLE },
-    { { NULL, NULL }, ip6t_route_hook, PF_INET6, NF_IP6_FORWARD,      NF_IP6_PRI_MANGLE },
-    { { NULL, NULL }, ip6t_local_hook, PF_INET6, NF_IP6_LOCAL_OUT,    NF_IP6_PRI_MANGLE },
-    { { NULL, NULL }, ip6t_route_hook, PF_INET6, NF_IP6_POST_ROUTING, NF_IP6_PRI_MANGLE }
+static struct nf_hook_ops ip6t_ops[] = {
+	{
+		.hook		= ip6t_route_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_PRE_ROUTING,
+		.priority	= NF_IP6_PRI_MANGLE,
+	},
+	{
+		.hook		= ip6t_local_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_IN,
+		.priority	= NF_IP6_PRI_MANGLE,
+	},
+	{
+		.hook		= ip6t_route_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_FORWARD,
+		.priority	= NF_IP6_PRI_MANGLE,
+	},
+	{
+		.hook		= ip6t_local_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_LOCAL_OUT,
+		.priority	= NF_IP6_PRI_MANGLE,
+	},
+	{
+		.hook		= ip6t_route_hook,
+		.pf		= PF_INET6,
+		.hooknum	= NF_IP6_POST_ROUTING,
+		.priority	= NF_IP6_PRI_MANGLE,
+	},
 };
 
 static int __init init(void)
-- 
They that can give up essential liberty to obtain a little temporary safety
deserve neither liberty nor safety.
 -- Benjamin Franklin, Historical Review of Pennsylvania, 1759
