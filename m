From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/49]: Mark hooks __read_mostly
Date: Tue,  4 Dec 2007 13:02:27 +0100 (MET)
Message-ID: <20071204120227.2442.26114.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62170 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbXLDMC3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:29 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Mark hooks __read_mostly

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit eb9d6d08051c003ea481be88c27526d3cccb4507
tree 2c582cc5fad6f565fff9182d63e25fbaa2defc51
parent 3d8f7cb0e4708c09a6420a5130dea3852e8617cf
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:17 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:30:17 +0100

 net/bridge/br_netfilter.c                      |    2 +-
 net/bridge/netfilter/ebtable_filter.c          |    2 +-
 net/bridge/netfilter/ebtable_nat.c             |    2 +-
 net/decnet/netfilter/dn_rtmsg.c                |    2 +-
 net/ipv4/ipvs/ip_vs_core.c                     |    2 +-
 net/ipv4/netfilter/arptable_filter.c           |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    2 +-
 net/ipv4/netfilter/iptable_filter.c            |    2 +-
 net/ipv4/netfilter/iptable_mangle.c            |    2 +-
 net/ipv4/netfilter/iptable_raw.c               |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 +-
 net/ipv6/netfilter/ip6table_filter.c           |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c           |    2 +-
 net/ipv6/netfilter/ip6table_raw.c              |    2 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/sched/sch_ingress.c                        |    2 +-
 17 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 5f5b98a..32ac035 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -838,7 +838,7 @@ static unsigned int ip_sabotage_in(unsigned int hook, struct sk_buff *skb,
  * PF_BRIDGE/NF_BR_LOCAL_OUT functions don't get bridged traffic as input.
  * For br_nf_post_routing, we need (prio = NF_BR_PRI_LAST), because
  * ip_refrag() can return NF_STOLEN. */
-static struct nf_hook_ops br_nf_ops[] = {
+static struct nf_hook_ops br_nf_ops[] __read_mostly = {
 	{ .hook = br_nf_pre_routing,
 	  .owner = THIS_MODULE,
 	  .pf = PF_BRIDGE,
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 210493f..fb81090 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -67,7 +67,7 @@ ebt_hook(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
 	return ebt_do_table(hook, skb, in, out, &frame_filter);
 }
 
-static struct nf_hook_ops ebt_ops_filter[] = {
+static struct nf_hook_ops ebt_ops_filter[] __read_mostly = {
 	{
 		.hook		= ebt_hook,
 		.owner		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 3e58c2e..bc71273 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -74,7 +74,7 @@ ebt_nat_src(unsigned int hook, struct sk_buff *skb, const struct net_device *in
 	return ebt_do_table(hook, skb, in, out, &frame_nat);
 }
 
-static struct nf_hook_ops ebt_ops_nat[] = {
+static struct nf_hook_ops ebt_ops_nat[] __read_mostly = {
 	{
 		.hook		= ebt_nat_dst,
 		.owner		= THIS_MODULE,
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index 43fcd29..96375f2 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -115,7 +115,7 @@ static inline void dnrmg_receive_user_skb(struct sk_buff *skb)
 	RCV_SKB_FAIL(-EINVAL);
 }
 
-static struct nf_hook_ops dnrmg_ops = {
+static struct nf_hook_ops dnrmg_ops __read_mostly = {
 	.hook		= dnrmg_hook,
 	.pf		= PF_DECnet,
 	.hooknum	= NF_DN_ROUTE,
diff --git a/net/ipv4/ipvs/ip_vs_core.c b/net/ipv4/ipvs/ip_vs_core.c
index f5ba606..041f512 100644
--- a/net/ipv4/ipvs/ip_vs_core.c
+++ b/net/ipv4/ipvs/ip_vs_core.c
@@ -1025,7 +1025,7 @@ ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
 }
 
 
-static struct nf_hook_ops ip_vs_ops[]  = {
+static struct nf_hook_ops ip_vs_ops[] __read_mostly = {
 	/* After packet filtering, forward packet through VS/DR, VS/TUN,
 	 * or VS/NAT(change destination), so that filtering rules can be
 	 * applied to IPVS. */
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 302d3da..7201511 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -64,7 +64,7 @@ static unsigned int arpt_hook(unsigned int hook,
 	return arpt_do_table(skb, hook, in, out, &packet_filter);
 }
 
-static struct nf_hook_ops arpt_ops[] = {
+static struct nf_hook_ops arpt_ops[] __read_mostly = {
 	{
 		.hook		= arpt_hook,
 		.owner		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index b5de6bd..dc1e7b4 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -551,7 +551,7 @@ arp_mangle(unsigned int hook,
 	return NF_ACCEPT;
 }
 
-static struct nf_hook_ops cip_arp_ops = {
+static struct nf_hook_ops cip_arp_ops __read_mostly = {
 	.hook = arp_mangle,
 	.pf = NF_ARP,
 	.hooknum = NF_ARP_OUT,
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 06ab64e..29bb4f9 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -91,7 +91,7 @@ ipt_local_out_hook(unsigned int hook,
 	return ipt_do_table(skb, hook, in, out, &packet_filter);
 }
 
-static struct nf_hook_ops ipt_ops[] = {
+static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook		= ipt_hook,
 		.owner		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 0335827..5c4be20 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -128,7 +128,7 @@ ipt_local_hook(unsigned int hook,
 	return ret;
 }
 
-static struct nf_hook_ops ipt_ops[] = {
+static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook		= ipt_route_hook,
 		.owner		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 66be232..dc34aa2 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -74,7 +74,7 @@ ipt_local_hook(unsigned int hook,
 }
 
 /* 'raw' is the very first table. */
-static struct nf_hook_ops ipt_ops[] = {
+static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	{
 		.hook = ipt_hook,
 		.pf = PF_INET,
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 9ac3020..e0e09f5 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -185,7 +185,7 @@ static unsigned int ipv4_conntrack_local(unsigned int hooknum,
 
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
-static struct nf_hook_ops ipv4_conntrack_ops[] = {
+static struct nf_hook_ops ipv4_conntrack_ops[] __read_mostly = {
 	{
 		.hook		= ipv4_conntrack_defrag,
 		.owner		= THIS_MODULE,
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 84172e9..a2b02f0 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -273,7 +273,7 @@ nf_nat_adjust(unsigned int hooknum,
 
 /* We must be after connection tracking and before packet filtering. */
 
-static struct nf_hook_ops nf_nat_ops[] = {
+static struct nf_hook_ops nf_nat_ops[] __read_mostly = {
 	/* Before packet filtering, change destination */
 	{
 		.hook		= nf_nat_in,
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 0ae072d..87d38d0 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -90,7 +90,7 @@ ip6t_local_out_hook(unsigned int hook,
 	return ip6t_do_table(skb, hook, in, out, &packet_filter);
 }
 
-static struct nf_hook_ops ip6t_ops[] = {
+static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 		.hook		= ip6t_hook,
 		.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 8e62b23..d608260 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -120,7 +120,7 @@ ip6t_local_hook(unsigned int hook,
 	return ret;
 }
 
-static struct nf_hook_ops ip6t_ops[] = {
+static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 		.hook		= ip6t_route_hook,
 		.owner		= THIS_MODULE,
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 4fecd8d..eccbaaa 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -54,7 +54,7 @@ ip6t_hook(unsigned int hook,
 	return ip6t_do_table(skb, hook, in, out, &packet_raw);
 }
 
-static struct nf_hook_ops ip6t_ops[] = {
+static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
 	  .hook = ip6t_hook,
 	  .pf = PF_INET6,
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 50f4678..97a5530 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -258,7 +258,7 @@ static unsigned int ipv6_conntrack_local(unsigned int hooknum,
 	return ipv6_conntrack_in(hooknum, skb, in, out, okfn);
 }
 
-static struct nf_hook_ops ipv6_conntrack_ops[] = {
+static struct nf_hook_ops ipv6_conntrack_ops[] __read_mostly = {
 	{
 		.hook		= ipv6_defrag,
 		.owner		= THIS_MODULE,
diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index f4af9b6..89c32a9 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -231,7 +231,7 @@ ing_hook(unsigned int hook, struct sk_buff *skb,
 }
 
 /* after ipt_filter */
-static struct nf_hook_ops ing_ops[] = {
+static struct nf_hook_ops ing_ops[] __read_mostly = {
 	{
 		.hook           = ing_hook,
 		.owner		= THIS_MODULE,
