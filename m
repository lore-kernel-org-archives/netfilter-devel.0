From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: use NFPROTO_* constants in nf_hook_ops structures
Date: Fri, 17 Oct 2008 10:44:34 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810171044180.30268@fbirervta.pbzchgretzou.qr>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr> <48F72B07.1040706@trash.net>
 <48F72BE8.80602@netfilter.org> <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbYJQOog (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:44:36 -0400
In-Reply-To: <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 6f1807f67c1cb202096e03d1106e3dba06dd610d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Oct 17 10:29:50 2008 -0400

netfilter: use NFPROTO_* constants in nf_hook_ops structures

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/br_netfilter.c                      |   16 ++++++++--------
 net/bridge/netfilter/ebtable_filter.c          |    6 +++---
 net/bridge/netfilter/ebtable_nat.c             |    6 +++---
 net/decnet/netfilter/dn_rtmsg.c                |    2 +-
 net/ipv4/netfilter/iptable_filter.c            |    6 +++---
 net/ipv4/netfilter/iptable_mangle.c            |   10 +++++-----
 net/ipv4/netfilter/iptable_raw.c               |    4 ++--
 net/ipv4/netfilter/iptable_security.c          |    6 +++---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++----
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    4 ++--
 net/ipv4/netfilter/nf_nat_standalone.c         |    8 ++++----
 net/ipv6/netfilter/ip6table_filter.c           |    6 +++---
 net/ipv6/netfilter/ip6table_mangle.c           |   10 +++++-----
 net/ipv6/netfilter/ip6table_raw.c              |    4 ++--
 net/ipv6/netfilter/ip6table_security.c         |    6 +++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   12 ++++++------
 net/netfilter/ipvs/ip_vs_core.c                |   16 ++++++++--------
 security/selinux/hooks.c                       |   10 +++++-----
 18 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 13e8cb3..1ace89e 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -878,42 +878,42 @@ static unsigned int ip_sabotage_in(unsigned int hook, struct sk_buff *skb,
 static struct nf_hook_ops br_nf_ops[] __read_mostly = {
 	{ .hook = br_nf_pre_routing,
 	  .owner = THIS_MODULE,
-	  .pf = PF_BRIDGE,
+	  .pf = NFPROTO_BRIDGE,
 	  .hooknum = NF_BR_PRE_ROUTING,
 	  .priority = NF_BR_PRI_BRNF, },
 	{ .hook = br_nf_local_in,
 	  .owner = THIS_MODULE,
-	  .pf = PF_BRIDGE,
+	  .pf = NFPROTO_BRIDGE,
 	  .hooknum = NF_BR_LOCAL_IN,
 	  .priority = NF_BR_PRI_BRNF, },
 	{ .hook = br_nf_forward_ip,
 	  .owner = THIS_MODULE,
-	  .pf = PF_BRIDGE,
+	  .pf = NFPROTO_BRIDGE,
 	  .hooknum = NF_BR_FORWARD,
 	  .priority = NF_BR_PRI_BRNF - 1, },
 	{ .hook = br_nf_forward_arp,
 	  .owner = THIS_MODULE,
-	  .pf = PF_BRIDGE,
+	  .pf = NFPROTO_BRIDGE,
 	  .hooknum = NF_BR_FORWARD,
 	  .priority = NF_BR_PRI_BRNF, },
 	{ .hook = br_nf_local_out,
 	  .owner = THIS_MODULE,
-	  .pf = PF_BRIDGE,
+	  .pf = NFPROTO_BRIDGE,
 	  .hooknum = NF_BR_LOCAL_OUT,
 	  .priority = NF_BR_PRI_FIRST, },
 	{ .hook = br_nf_post_routing,
 	  .owner = THIS_MODULE,
-	  .pf = PF_BRIDGE,
+	  .pf = NFPROTO_BRIDGE,
 	  .hooknum = NF_BR_POST_ROUTING,
 	  .priority = NF_BR_PRI_LAST, },
 	{ .hook = ip_sabotage_in,
 	  .owner = THIS_MODULE,
-	  .pf = PF_INET,
+	  .pf = NFPROTO_IPV4,
 	  .hooknum = NF_INET_PRE_ROUTING,
 	  .priority = NF_IP_PRI_FIRST, },
 	{ .hook = ip_sabotage_in,
 	  .owner = THIS_MODULE,
-	  .pf = PF_INET6,
+	  .pf = NFPROTO_IPV6,
 	  .hooknum = NF_INET_PRE_ROUTING,
 	  .priority = NF_IP6_PRI_FIRST, },
 };
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 1a58af5..439f172 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -71,21 +71,21 @@ static struct nf_hook_ops ebt_ops_filter[] __read_mostly = {
 	{
 		.hook		= ebt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_BRIDGE,
+		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_IN,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
 		.hook		= ebt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_BRIDGE,
+		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_FORWARD,
 		.priority	= NF_BR_PRI_FILTER_BRIDGED,
 	},
 	{
 		.hook		= ebt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_BRIDGE,
+		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_FILTER_OTHER,
 	},
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index f60c1e7..5f49fe4 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -78,21 +78,21 @@ static struct nf_hook_ops ebt_ops_nat[] __read_mostly = {
 	{
 		.hook		= ebt_nat_dst,
 		.owner		= THIS_MODULE,
-		.pf		= PF_BRIDGE,
+		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_LOCAL_OUT,
 		.priority	= NF_BR_PRI_NAT_DST_OTHER,
 	},
 	{
 		.hook		= ebt_nat_src,
 		.owner		= THIS_MODULE,
-		.pf		= PF_BRIDGE,
+		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_POST_ROUTING,
 		.priority	= NF_BR_PRI_NAT_SRC,
 	},
 	{
 		.hook		= ebt_nat_dst,
 		.owner		= THIS_MODULE,
-		.pf		= PF_BRIDGE,
+		.pf		= NFPROTO_BRIDGE,
 		.hooknum	= NF_BR_PRE_ROUTING,
 		.priority	= NF_BR_PRI_NAT_DST_BRIDGED,
 	},
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index 6d2bd32..937ce4c 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -117,7 +117,7 @@ static inline void dnrmg_receive_user_skb(struct sk_buff *skb)
 
 static struct nf_hook_ops dnrmg_ops __read_mostly = {
 	.hook		= dnrmg_hook,
-	.pf		= PF_DECnet,
+	.pf		= NFPROTO_DECNET,
 	.hooknum	= NF_DN_ROUTE,
 	.priority	= NF_DN_PRI_DNRTMSG,
 };
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index c922431..404b386 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -108,21 +108,21 @@ static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook		= ipt_local_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= ipt_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP_PRI_FILTER,
 	},
 	{
 		.hook		= ipt_local_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_FILTER,
 	},
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 69f2c42..79a1c4d 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -167,35 +167,35 @@ static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook		= ipt_pre_routing_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_local_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_forward_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_local_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
 	{
 		.hook		= ipt_post_routing_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_MANGLE,
 	},
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 8faebfe..e9401e6 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -79,14 +79,14 @@ ipt_local_hook(unsigned int hook,
 static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook = ipt_hook,
-		.pf = PF_INET,
+		.pf = NFPROTO_IPV4,
 		.hooknum = NF_INET_PRE_ROUTING,
 		.priority = NF_IP_PRI_RAW,
 		.owner = THIS_MODULE,
 	},
 	{
 		.hook = ipt_local_hook,
-		.pf = PF_INET,
+		.pf = NFPROTO_IPV4,
 		.hooknum = NF_INET_LOCAL_OUT,
 		.priority = NF_IP_PRI_RAW,
 		.owner = THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 36f3be3..e120f33 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -110,21 +110,21 @@ static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook		= ipt_local_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_SECURITY,
 	},
 	{
 		.hook		= ipt_forward_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP_PRI_SECURITY,
 	},
 	{
 		.hook		= ipt_local_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_SECURITY,
 	},
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 4a7c352..47cfed1 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -160,28 +160,28 @@ static struct nf_hook_ops ipv4_conntrack_ops[] __read_mostly = {
 	{
 		.hook		= ipv4_conntrack_in,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
 	{
 		.hook		= ipv4_conntrack_local,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_CONNTRACK,
 	},
 	{
 		.hook		= ipv4_confirm,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 	},
 	{
 		.hook		= ipv4_confirm,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 	},
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index aa2c50a..a19135f 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -62,14 +62,14 @@ static struct nf_hook_ops ipv4_defrag_ops[] = {
 	{
 		.hook		= ipv4_conntrack_defrag,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_CONNTRACK_DEFRAG,
 	},
 	{
 		.hook           = ipv4_conntrack_defrag,
 		.owner          = THIS_MODULE,
-		.pf             = PF_INET,
+		.pf             = NFPROTO_IPV4,
 		.hooknum        = NF_INET_LOCAL_OUT,
 		.priority       = NF_IP_PRI_CONNTRACK_DEFRAG,
 	},
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index b7dd695..56152ed 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -252,7 +252,7 @@ static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 	{
 		.hook		= nf_nat_in,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP_PRI_NAT_DST,
 	},
@@ -260,7 +260,7 @@ static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 	{
 		.hook		= nf_nat_out,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
@@ -268,7 +268,7 @@ static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 	{
 		.hook		= nf_nat_local_fn,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP_PRI_NAT_DST,
 	},
@@ -276,7 +276,7 @@ static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 	{
 		.hook		= nf_nat_fn,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP_PRI_NAT_SRC,
 	},
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index b110a8a..e6b7309 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -107,21 +107,21 @@ static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 		.hook		= ip6t_local_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
 		.hook		= ip6t_forward_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
 	{
 		.hook		= ip6t_local_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_FILTER,
 	},
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index d0b31b2..2086054 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -137,35 +137,35 @@ static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 		.hook		= ip6t_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_local_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
 	{
 		.hook		= ip6t_post_routing_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_MANGLE,
 	},
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 109fab6..6e38627 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -69,14 +69,14 @@ ip6t_local_out_hook(unsigned int hook,
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 	  .hook = ip6t_pre_routing_hook,
-	  .pf = PF_INET6,
+	  .pf = NFPROTO_IPV6,
 	  .hooknum = NF_INET_PRE_ROUTING,
 	  .priority = NF_IP6_PRI_FIRST,
 	  .owner = THIS_MODULE,
 	},
 	{
 	  .hook = ip6t_local_out_hook,
-	  .pf = PF_INET6,
+	  .pf = NFPROTO_IPV6,
 	  .hooknum = NF_INET_LOCAL_OUT,
 	  .priority = NF_IP6_PRI_FIRST,
 	  .owner = THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 20bc52f..cbee23f 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -102,21 +102,21 @@ static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 		.hook		= ip6t_local_in_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_SECURITY,
 	},
 	{
 		.hook		= ip6t_forward_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_FORWARD,
 		.priority	= NF_IP6_PRI_SECURITY,
 	},
 	{
 		.hook		= ip6t_local_out_hook,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_SECURITY,
 	},
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index e91db16..059a0a1 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -265,42 +265,42 @@ static struct nf_hook_ops ipv6_conntrack_ops[] __read_mostly = {
 	{
 		.hook		= ipv6_defrag,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_CONNTRACK_DEFRAG,
 	},
 	{
 		.hook		= ipv6_conntrack_in,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_PRE_ROUTING,
 		.priority	= NF_IP6_PRI_CONNTRACK,
 	},
 	{
 		.hook		= ipv6_conntrack_local,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_CONNTRACK,
 	},
 	{
 		.hook		= ipv6_defrag,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_OUT,
 		.priority	= NF_IP6_PRI_CONNTRACK_DEFRAG,
 	},
 	{
 		.hook		= ipv6_confirm,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_POST_ROUTING,
 		.priority	= NF_IP6_PRI_LAST,
 	},
 	{
 		.hook		= ipv6_confirm,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum	= NF_INET_LOCAL_IN,
 		.priority	= NF_IP6_PRI_LAST-1,
 	},
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 958abf3..49e712c 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1407,7 +1407,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_in,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum        = NF_INET_LOCAL_IN,
 		.priority       = 100,
 	},
@@ -1415,7 +1415,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_out,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum        = NF_INET_FORWARD,
 		.priority       = 100,
 	},
@@ -1424,7 +1424,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_forward_icmp,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum        = NF_INET_FORWARD,
 		.priority       = 99,
 	},
@@ -1432,7 +1432,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_post_routing,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET,
+		.pf		= NFPROTO_IPV4,
 		.hooknum        = NF_INET_POST_ROUTING,
 		.priority       = NF_IP_PRI_NAT_SRC-1,
 	},
@@ -1443,7 +1443,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_in,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum        = NF_INET_LOCAL_IN,
 		.priority       = 100,
 	},
@@ -1451,7 +1451,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_out,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum        = NF_INET_FORWARD,
 		.priority       = 100,
 	},
@@ -1460,7 +1460,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_forward_icmp_v6,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum        = NF_INET_FORWARD,
 		.priority       = 99,
 	},
@@ -1468,7 +1468,7 @@ static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	{
 		.hook		= ip_vs_post_routing,
 		.owner		= THIS_MODULE,
-		.pf		= PF_INET6,
+		.pf		= NFPROTO_IPV6,
 		.hooknum        = NF_INET_POST_ROUTING,
 		.priority       = NF_IP6_PRI_NAT_SRC-1,
 	},
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 576e511..b1e14cc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5748,21 +5748,21 @@ static struct nf_hook_ops selinux_ipv4_ops[] = {
 	{
 		.hook =		selinux_ipv4_postroute,
 		.owner =	THIS_MODULE,
-		.pf =		PF_INET,
+		.pf =		NFPROTO_IPV4,
 		.hooknum =	NF_INET_POST_ROUTING,
 		.priority =	NF_IP_PRI_SELINUX_LAST,
 	},
 	{
 		.hook =		selinux_ipv4_forward,
 		.owner =	THIS_MODULE,
-		.pf =		PF_INET,
+		.pf =		NFPROTO_IPV4,
 		.hooknum =	NF_INET_FORWARD,
 		.priority =	NF_IP_PRI_SELINUX_FIRST,
 	},
 	{
 		.hook =		selinux_ipv4_output,
 		.owner =	THIS_MODULE,
-		.pf =		PF_INET,
+		.pf =		NFPROTO_IPV4,
 		.hooknum =	NF_INET_LOCAL_OUT,
 		.priority =	NF_IP_PRI_SELINUX_FIRST,
 	}
@@ -5774,14 +5774,14 @@ static struct nf_hook_ops selinux_ipv6_ops[] = {
 	{
 		.hook =		selinux_ipv6_postroute,
 		.owner =	THIS_MODULE,
-		.pf =		PF_INET6,
+		.pf =		NFPROTO_IPV6,
 		.hooknum =	NF_INET_POST_ROUTING,
 		.priority =	NF_IP6_PRI_SELINUX_LAST,
 	},
 	{
 		.hook =		selinux_ipv6_forward,
 		.owner =	THIS_MODULE,
-		.pf =		PF_INET6,
+		.pf =		NFPROTO_IPV6,
 		.hooknum =	NF_INET_FORWARD,
 		.priority =	NF_IP6_PRI_SELINUX_FIRST,
 	}
