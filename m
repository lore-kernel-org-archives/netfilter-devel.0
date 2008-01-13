From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [xt_RAWNAT 2/3] Extend iptable_raw by POSTROUTING hook
Date: Sun, 13 Jan 2008 17:10:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801131709390.21665@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48343 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbYAMQKM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2008 11:10:12 -0500
In-Reply-To: <Pine.LNX.4.64.0801131648010.21665@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

origin git://computergmbh.de/linux patchomatic

commit b13cafd71d94ee3bd88aa2aa5755b27c390c2f97
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 10 23:49:04 2008 +0100

    [NETFILTER]: Extend iptable_raw by POSTROUTING hook
    
    iptable_raw and ip6table_raw will get a POSTROUTING hook for the
    xt_RAWNAT targets, because it needs a hook _after_ conntrack has
    applied address transformation.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 7378d17..5ee8ce0 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -65,6 +65,7 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_CONNTRACK_HELPER = 500,
 	NF_IP_PRI_NAT_SEQ_ADJUST = 520,
 	NF_IP_PRI_CONNTRACK_CONFIRM = 540,
+	NF_IP_PRI_RAW_POST = 800,
 	NF_IP_PRI_LAST = INT_MAX,
 };
 
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3475a65..610ac89 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -66,6 +66,7 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_FILTER = 0,
 	NF_IP6_PRI_NAT_SRC = 100,
 	NF_IP6_PRI_SELINUX_LAST = 225,
+	NF_IP6_PRI_RAW_POST = 800,
 	NF_IP6_PRI_LAST = INT_MAX,
 };
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index dc34aa2..7ce4c4c 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -7,31 +7,34 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <net/ip.h>
 
-#define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
+#define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_POST_ROUTING))
 
 static struct
 {
 	struct ipt_replace repl;
-	struct ipt_standard entries[2];
+	struct ipt_standard entries[3];
 	struct ipt_error term;
 } initial_table __initdata = {
 	.repl = {
 		.name = "raw",
 		.valid_hooks = RAW_VALID_HOOKS,
-		.num_entries = 3,
-		.size = sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
+		.num_entries = 4,
+		.size = sizeof(struct ipt_standard) * 3 + sizeof(struct ipt_error),
 		.hook_entry = {
 			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard)
+			[NF_INET_LOCAL_OUT] = sizeof(struct ipt_standard),
+			[NF_INET_POST_ROUTING] = sizeof(struct ipt_standard) * 2,
 		},
 		.underflow = {
 			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT]  = sizeof(struct ipt_standard)
+			[NF_INET_LOCAL_OUT]  = sizeof(struct ipt_standard),
+			[NF_INET_POST_ROUTING] = sizeof(struct ipt_standard) * 2,
 		},
 	},
 	.entries = {
 		IPT_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
 		IPT_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+		IPT_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
 	},
 	.term = IPT_ERROR_INIT,			/* ERROR */
 };
@@ -89,6 +92,13 @@ static struct nf_hook_ops ipt_ops[] __read_mostly = {
 		.priority = NF_IP_PRI_RAW,
 		.owner = THIS_MODULE,
 	},
+	{
+		.hook     = ipt_hook,
+		.pf       = PF_INET,
+		.hooknum  = NF_INET_POST_ROUTING,
+		.priority = NF_IP_PRI_RAW_POST,
+		.owner    = THIS_MODULE,
+	},
 };
 
 static int __init iptable_raw_init(void)
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index eccbaaa..9f32c2a 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -6,31 +6,34 @@
 #include <linux/module.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
-#define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT))
+#define RAW_VALID_HOOKS ((1 << NF_INET_PRE_ROUTING) | (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_POST_ROUTING))
 
 static struct
 {
 	struct ip6t_replace repl;
-	struct ip6t_standard entries[2];
+	struct ip6t_standard entries[3];
 	struct ip6t_error term;
 } initial_table __initdata = {
 	.repl = {
 		.name = "raw",
 		.valid_hooks = RAW_VALID_HOOKS,
-		.num_entries = 3,
-		.size = sizeof(struct ip6t_standard) * 2 + sizeof(struct ip6t_error),
+		.num_entries = 4,
+		.size = sizeof(struct ip6t_standard) * 3 + sizeof(struct ip6t_error),
 		.hook_entry = {
 			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard)
+			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard),
+			[NF_INET_POST_ROUTING] = sizeof(struct ip6t_standard) * 2,
 		},
 		.underflow = {
 			[NF_INET_PRE_ROUTING] = 0,
-			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard)
+			[NF_INET_LOCAL_OUT] = sizeof(struct ip6t_standard),
+			[NF_INET_POST_ROUTING] = sizeof(struct ip6t_standard) * 2,
 		},
 	},
 	.entries = {
 		IP6T_STANDARD_INIT(NF_ACCEPT),	/* PRE_ROUTING */
 		IP6T_STANDARD_INIT(NF_ACCEPT),	/* LOCAL_OUT */
+		IP6T_STANDARD_INIT(NF_ACCEPT),	/* POST_ROUTING */
 	},
 	.term = IP6T_ERROR_INIT,		/* ERROR */
 };
@@ -69,6 +72,13 @@ static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	  .priority = NF_IP6_PRI_FIRST,
 	  .owner = THIS_MODULE,
 	},
+	{
+		.hook     = ip6t_hook,
+		.pf       = PF_INET6,
+		.hooknum  = NF_INET_POST_ROUTING,
+		.priority = NF_IP6_PRI_RAW_POST,
+		.owner    = THIS_MODULE,
+	},
 };
 
 static int __init ip6table_raw_init(void)
