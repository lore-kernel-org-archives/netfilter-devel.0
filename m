From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 09/11] netfilter: make nf_hook_ops.priv available to hooks
Date: Fri, 16 Nov 2012 02:23:43 +0100
Message-ID: <1353029025-31635-10-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45180 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab2KPBX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:58 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A table execution hook currently knows which table to use by means of
each table module looking into a well-known object (such as
net->ipv6.ip6table_filter), for example.

A generic implementation however needs to be able to distinguish
between the requested object solely based upon parameters passed to
the hook, and that info is currently missing.

A previous commit already added "void *priv" to struct nf_hook_ops,
now it is time to actually deliver nf_hook_ops to the functions.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/linux/netfilter.h                      |    6 ++-
 net/bridge/br_netfilter.c                      |   60 ++++++++++++------------
 net/bridge/netfilter/ebtable_filter.c          |   16 ++++---
 net/bridge/netfilter/ebtable_nat.c             |   16 ++++---
 net/decnet/netfilter/dn_rtmsg.c                |    9 ++--
 net/ipv4/netfilter/arptable_filter.c           |    5 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    6 +--
 net/ipv4/netfilter/iptable_filter.c            |    7 +--
 net/ipv4/netfilter/iptable_mangle.c            |   16 +++----
 net/ipv4/netfilter/iptable_nat.c               |   38 ++++++---------
 net/ipv4/netfilter/iptable_raw.c               |    6 +--
 net/ipv4/netfilter/iptable_security.c          |    7 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   42 ++++++++---------
 net/ipv4/netfilter/nf_defrag_ipv4.c            |   14 +++---
 net/ipv6/netfilter/ip6table_filter.c           |    5 +-
 net/ipv6/netfilter/ip6table_mangle.c           |   10 ++--
 net/ipv6/netfilter/ip6table_nat.c              |   39 +++++++--------
 net/ipv6/netfilter/ip6table_raw.c              |    5 +-
 net/ipv6/netfilter/ip6table_security.c         |    5 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   44 +++++++++--------
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |   13 +++--
 net/netfilter/core.c                           |    2 +-
 net/netfilter/ipvs/ip_vs_core.c                |   40 ++++++++--------
 security/selinux/hooks.c                       |   47 +++++++++----------
 24 files changed, 223 insertions(+), 235 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 3813e84c..341b8f6 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -40,10 +40,12 @@ extern void netfilter_init(void);
 /* Largest hook number + 1 */
 #define NF_MAX_HOOKS 8
 
+struct net_device;
+struct nf_hook_ops;
 struct sk_buff;
 
-typedef unsigned int nf_hookfn(unsigned int hooknum,
-			       struct sk_buff *skb,
+typedef unsigned int nf_hookfn(struct sk_buff *skb,
+			       const struct nf_hook_ops *ops,
 			       const struct net_device *in,
 			       const struct net_device *out,
 			       int (*okfn)(struct sk_buff *));
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fe43bc7..cf5a406 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -618,11 +618,11 @@ bad:
 
 /* Replicate the checks that IPv6 does on packet reception and pass the packet
  * to ip6tables, which doesn't support NAT, so things are fairly simple. */
-static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
-					   struct sk_buff *skb,
-					   const struct net_device *in,
-					   const struct net_device *out,
-					   int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_pre_routing_ipv6(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		       const struct net_device *in,
+		       const struct net_device *out,
+		       int (*okfn)(struct sk_buff *))
 {
 	const struct ipv6hdr *hdr;
 	u32 pkt_len;
@@ -668,10 +668,10 @@ static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
  * receiving device) to make netfilter happy, the REDIRECT
  * target in particular.  Save the original destination IP
  * address to be able to detect DNAT afterwards. */
-static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_pre_routing(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		  const struct net_device *in, const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
 {
 	struct net_bridge_port *p;
 	struct net_bridge *br;
@@ -690,7 +690,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 			return NF_ACCEPT;
 
 		nf_bridge_pull_encap_header_rcsum(skb);
-		return br_nf_pre_routing_ipv6(hook, skb, in, out, okfn);
+		return br_nf_pre_routing_ipv6(skb, ops, in, out, okfn);
 	}
 
 	if (!brnf_call_iptables && !br->nf_call_iptables)
@@ -726,10 +726,10 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
  * took place when the packet entered the bridge), but we
  * register an IPv4 PRE_ROUTING 'sabotage' hook that will
  * prevent this from happening. */
-static unsigned int br_nf_local_in(unsigned int hook, struct sk_buff *skb,
-				   const struct net_device *in,
-				   const struct net_device *out,
-				   int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_local_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
+	       int (*okfn)(struct sk_buff *))
 {
 	br_drop_fake_rtable(skb);
 	return NF_ACCEPT;
@@ -764,10 +764,10 @@ static int br_nf_forward_finish(struct sk_buff *skb)
  * but we are still able to filter on the 'real' indev/outdev
  * because of the physdev module. For ARP, indev and outdev are the
  * bridge ports. */
-static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
-				     const struct net_device *in,
-				     const struct net_device *out,
-				     int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_forward_ip(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		 const struct net_device *in, const struct net_device *out,
+		 int (*okfn)(struct sk_buff *))
 {
 	struct nf_bridge_info *nf_bridge;
 	struct net_device *parent;
@@ -817,10 +817,10 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_forward_arp(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		  const struct net_device *in, const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
 {
 	struct net_bridge_port *p;
 	struct net_bridge *br;
@@ -877,10 +877,10 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 #endif
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
-static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
-				       const struct net_device *in,
-				       const struct net_device *out,
-				       int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_post_routing(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		   const struct net_device *in, const struct net_device *out,
+		   int (*okfn)(struct sk_buff *))
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct net_device *realoutdev = bridge_parent(skb->dev);
@@ -922,10 +922,10 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 /* IP/SABOTAGE *****************************************************/
 /* Don't hand locally destined packets to PF_INET(6)/PRE_ROUTING
  * for the second time. */
-static unsigned int ip_sabotage_in(unsigned int hook, struct sk_buff *skb,
-				   const struct net_device *in,
-				   const struct net_device *out,
-				   int (*okfn)(struct sk_buff *))
+static unsigned int
+ip_sabotage_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
+	       int (*okfn)(struct sk_buff *))
 {
 	if (skb->nf_bridge &&
 	    !(skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)) {
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 3c2e9dc..017d2ce 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -60,17 +60,21 @@ static const struct ebt_table frame_filter =
 };
 
 static unsigned int
-ebt_in_hook(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, int (*okfn)(struct sk_buff *))
+ebt_in_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	    const struct net_device *in, const struct net_device *out,
+	    int (*okfn)(struct sk_buff *))
 {
-	return ebt_do_table(hook, skb, in, out, dev_net(in)->xt.frame_filter);
+	return ebt_do_table(ops->hooknum, skb, in, out,
+			    dev_net(in)->xt.frame_filter);
 }
 
 static unsigned int
-ebt_out_hook(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, int (*okfn)(struct sk_buff *))
+ebt_out_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	     const struct net_device *in, const struct net_device *out,
+	     int (*okfn)(struct sk_buff *))
 {
-	return ebt_do_table(hook, skb, in, out, dev_net(out)->xt.frame_filter);
+	return ebt_do_table(ops->hooknum, skb, in, out,
+			    dev_net(out)->xt.frame_filter);
 }
 
 static struct nf_hook_ops ebt_ops_filter[] __read_mostly = {
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 10871bc..00ca38c 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -60,17 +60,21 @@ static struct ebt_table frame_nat =
 };
 
 static unsigned int
-ebt_nat_in(unsigned int hook, struct sk_buff *skb, const struct net_device *in
-   , const struct net_device *out, int (*okfn)(struct sk_buff *))
+ebt_nat_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	   const struct net_device *in, const struct net_device *out,
+	   int (*okfn)(struct sk_buff *))
 {
-	return ebt_do_table(hook, skb, in, out, dev_net(in)->xt.frame_nat);
+	return ebt_do_table(ops->hooknum, skb, in, out,
+			    dev_net(in)->xt.frame_nat);
 }
 
 static unsigned int
-ebt_nat_out(unsigned int hook, struct sk_buff *skb, const struct net_device *in
-   , const struct net_device *out, int (*okfn)(struct sk_buff *))
+ebt_nat_out(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	    const struct net_device *in, const struct net_device *out,
+	    int (*okfn)(struct sk_buff *))
 {
-	return ebt_do_table(hook, skb, in, out, dev_net(out)->xt.frame_nat);
+	return ebt_do_table(ops->hooknum, skb, in, out,
+			    dev_net(out)->xt.frame_nat);
 }
 
 static struct nf_hook_ops ebt_ops_nat[] __read_mostly = {
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index dfe4201..12a8eda 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -87,11 +87,10 @@ static void dnrmg_send_peer(struct sk_buff *skb)
 }
 
 
-static unsigned int dnrmg_hook(unsigned int hook,
-			struct sk_buff *skb,
-			const struct net_device *in,
-			const struct net_device *out,
-			int (*okfn)(struct sk_buff *))
+static unsigned int
+dnrmg_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	   const struct net_device *in, const struct net_device *out,
+	   int (*okfn)(struct sk_buff *))
 {
 	dnrmg_send_peer(skb);
 	return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 79ca5e7..01c6f2e 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -27,13 +27,14 @@ static const struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c */
 static unsigned int
-arptable_filter_hook(unsigned int hook, struct sk_buff *skb,
+arptable_filter_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	return arpt_do_table(skb, hook, in, out, net->ipv4.arptable_filter);
+	return arpt_do_table(skb, ops->hooknum, in, out,
+			     net->ipv4.arptable_filter);
 }
 
 static struct nf_hook_ops *arpfilter_ops __read_mostly;
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index fe5daea..16b0838 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -483,10 +483,8 @@ static void arp_print(struct arp_payload *payload)
 #endif
 
 static unsigned int
-arp_mangle(unsigned int hook,
-	   struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
+arp_mangle(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	   const struct net_device *in, const struct net_device *out,
 	   int (*okfn)(struct sk_buff *))
 {
 	struct arphdr *arp = arp_hdr(skb);
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 6b3da5c..a61278f 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -33,20 +33,21 @@ static const struct xt_table packet_filter = {
 };
 
 static unsigned int
-iptable_filter_hook(unsigned int hook, struct sk_buff *skb,
+iptable_filter_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		    const struct net_device *in, const struct net_device *out,
 		    int (*okfn)(struct sk_buff *))
 {
 	const struct net *net;
 
-	if (hook == NF_INET_LOCAL_OUT &&
+	if (ops->hooknum == NF_INET_LOCAL_OUT &&
 	    (skb->len < sizeof(struct iphdr) ||
 	     ip_hdrlen(skb) < sizeof(struct iphdr)))
 		/* root is playing with raw sockets. */
 		return NF_ACCEPT;
 
 	net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_filter);
+	return ipt_do_table(skb, ops->hooknum, in, out,
+			    net->ipv4.iptable_filter);
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 85d88f2..c0b45d2 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -76,19 +76,17 @@ ipt_mangle_out(struct sk_buff *skb, const struct net_device *out)
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-iptable_mangle_hook(unsigned int hook,
-		     struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+iptable_mangle_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		    const struct net_device *in, const struct net_device *out,
+		    int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
+	if (ops->hooknum == NF_INET_LOCAL_OUT)
 		return ipt_mangle_out(skb, out);
-	if (hook == NF_INET_POST_ROUTING)
-		return ipt_do_table(skb, hook, in, out,
+	if (ops->hooknum == NF_INET_POST_ROUTING)
+		return ipt_do_table(skb, ops->hooknum, in, out,
 				    dev_net(out)->ipv4.iptable_mangle);
 	/* PREROUTING/INPUT/FORWARD: */
-	return ipt_do_table(skb, hook, in, out,
+	return ipt_do_table(skb, ops->hooknum, in, out,
 			    dev_net(in)->ipv4.iptable_mangle);
 }
 
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 9e0ffaf..7a62e20 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -61,17 +61,15 @@ static unsigned int nf_nat_rule_find(struct sk_buff *skb, unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_ipv4_fn(unsigned int hooknum,
-	       struct sk_buff *skb,
-	       const struct net_device *in,
-	       const struct net_device *out,
+nf_nat_ipv4_fn(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
 	       int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_nat *nat;
 	/* maniptype == SRC for postrouting. */
-	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
+	enum nf_nat_manip_type maniptype = HOOK2MANIP(ops->hooknum);
 
 	/* We never see fragments: conntrack defrags on pre-routing
 	 * and local-out, and nf_nat_out protects post-routing.
@@ -108,7 +106,7 @@ nf_nat_ipv4_fn(unsigned int hooknum,
 	case IP_CT_RELATED_REPLY:
 		if (ip_hdr(skb)->protocol == IPPROTO_ICMP) {
 			if (!nf_nat_icmp_reply_translation(skb, ct, ctinfo,
-							   hooknum))
+							   ops->hooknum))
 				return NF_DROP;
 			else
 				return NF_ACCEPT;
@@ -121,7 +119,7 @@ nf_nat_ipv4_fn(unsigned int hooknum,
 		if (!nf_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
-			ret = nf_nat_rule_find(skb, hooknum, in, out, ct);
+			ret = nf_nat_rule_find(skb, ops->hooknum, in, out, ct);
 			if (ret != NF_ACCEPT)
 				return ret;
 		} else
@@ -136,20 +134,18 @@ nf_nat_ipv4_fn(unsigned int hooknum,
 			     ctinfo == IP_CT_ESTABLISHED_REPLY);
 	}
 
-	return nf_nat_packet(ct, ctinfo, hooknum, skb);
+	return nf_nat_packet(ct, ctinfo, ops->hooknum, skb);
 }
 
 static unsigned int
-nf_nat_ipv4_in(unsigned int hooknum,
-	       struct sk_buff *skb,
-	       const struct net_device *in,
-	       const struct net_device *out,
+nf_nat_ipv4_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
 	       int (*okfn)(struct sk_buff *))
 {
 	unsigned int ret;
 	__be32 daddr = ip_hdr(skb)->daddr;
 
-	ret = nf_nat_ipv4_fn(hooknum, skb, in, out, okfn);
+	ret = nf_nat_ipv4_fn(skb, ops, in, out, okfn);
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    daddr != ip_hdr(skb)->daddr)
 		skb_dst_drop(skb);
@@ -158,10 +154,8 @@ nf_nat_ipv4_in(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_ipv4_out(unsigned int hooknum,
-		struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
+nf_nat_ipv4_out(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		const struct net_device *in, const struct net_device *out,
 		int (*okfn)(struct sk_buff *))
 {
 #ifdef CONFIG_XFRM
@@ -175,7 +169,7 @@ nf_nat_ipv4_out(unsigned int hooknum,
 	    ip_hdrlen(skb) < sizeof(struct iphdr))
 		return NF_ACCEPT;
 
-	ret = nf_nat_ipv4_fn(hooknum, skb, in, out, okfn);
+	ret = nf_nat_ipv4_fn(skb, ops, in, out, okfn);
 #ifdef CONFIG_XFRM
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    !(IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED) &&
@@ -194,10 +188,8 @@ nf_nat_ipv4_out(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_ipv4_local_fn(unsigned int hooknum,
-		     struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
+nf_nat_ipv4_local_fn(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
 	const struct nf_conn *ct;
@@ -209,7 +201,7 @@ nf_nat_ipv4_local_fn(unsigned int hooknum,
 	    ip_hdrlen(skb) < sizeof(struct iphdr))
 		return NF_ACCEPT;
 
-	ret = nf_nat_ipv4_fn(hooknum, skb, in, out, okfn);
+	ret = nf_nat_ipv4_fn(skb, ops, in, out, okfn);
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    (ct = nf_ct_get(skb, &ctinfo)) != NULL) {
 		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 03d9696..829f453 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -20,20 +20,20 @@ static const struct xt_table packet_raw = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-iptable_raw_hook(unsigned int hook, struct sk_buff *skb,
+iptable_raw_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		 const struct net_device *in, const struct net_device *out,
 		 int (*okfn)(struct sk_buff *))
 {
 	const struct net *net;
 
-	if (hook == NF_INET_LOCAL_OUT && 
+	if (ops->hooknum == NF_INET_LOCAL_OUT &&
 	    (skb->len < sizeof(struct iphdr) ||
 	     ip_hdrlen(skb) < sizeof(struct iphdr)))
 		/* root is playing with raw sockets. */
 		return NF_ACCEPT;
 
 	net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_raw);
+	return ipt_do_table(skb, ops->hooknum, in, out, net->ipv4.iptable_raw);
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index b283d8e..a02bbb0 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -37,21 +37,22 @@ static const struct xt_table security_table = {
 };
 
 static unsigned int
-iptable_security_hook(unsigned int hook, struct sk_buff *skb,
+iptable_security_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		      const struct net_device *in,
 		      const struct net_device *out,
 		      int (*okfn)(struct sk_buff *))
 {
 	const struct net *net;
 
-	if (hook == NF_INET_LOCAL_OUT &&
+	if (ops->hooknum == NF_INET_LOCAL_OUT &&
 	    (skb->len < sizeof(struct iphdr) ||
 	     ip_hdrlen(skb) < sizeof(struct iphdr)))
 		/* Somebody is playing with raw sockets. */
 		return NF_ACCEPT;
 
 	net = dev_net((in != NULL) ? in : out);
-	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_security);
+	return ipt_do_table(skb, ops->hooknum, in, out,
+			    net->ipv4.iptable_security);
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index fcdd0c2..7e99174 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -90,11 +90,10 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	return NF_ACCEPT;
 }
 
-static unsigned int ipv4_helper(unsigned int hooknum,
-				struct sk_buff *skb,
-				const struct net_device *in,
-				const struct net_device *out,
-				int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_helper(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	    const struct net_device *in, const struct net_device *out,
+	    int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -119,17 +118,16 @@ static unsigned int ipv4_helper(unsigned int hooknum,
 	ret = helper->help(skb, skb_network_offset(skb) + ip_hdrlen(skb),
 			   ct, ctinfo);
 	if (ret != NF_ACCEPT && (ret & NF_VERDICT_MASK) != NF_QUEUE) {
-		nf_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, NULL,
+		nf_log_packet(NFPROTO_IPV4, ops->hooknum, skb, in, out, NULL,
 			      "nf_ct_%s: dropping packet", helper->name);
 	}
 	return ret;
 }
 
-static unsigned int ipv4_confirm(unsigned int hooknum,
-				 struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_confirm(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	     const struct net_device *in, const struct net_device *out,
+	     int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -155,26 +153,24 @@ out:
 	return nf_conntrack_confirm(skb);
 }
 
-static unsigned int ipv4_conntrack_in(unsigned int hooknum,
-				      struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_conntrack_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		  const struct net_device *in, const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
 {
-	return nf_conntrack_in(dev_net(in), PF_INET, hooknum, skb);
+	return nf_conntrack_in(dev_net(in), PF_INET, ops->hooknum, skb);
 }
 
-static unsigned int ipv4_conntrack_local(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_conntrack_local(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		     const struct net_device *in, const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
 {
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct iphdr) ||
 	    ip_hdrlen(skb) < sizeof(struct iphdr))
 		return NF_ACCEPT;
-	return nf_conntrack_in(dev_net(out), PF_INET, hooknum, skb);
+	return nf_conntrack_in(dev_net(out), PF_INET, ops->hooknum, skb);
 }
 
 /* Connection tracking may drop packets, but never alters them, so
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 7428155..3dd4631 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -60,11 +60,11 @@ static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
 		return IP_DEFRAG_CONNTRACK_OUT + zone;
 }
 
-static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
-					  struct sk_buff *skb,
-					  const struct net_device *in,
-					  const struct net_device *out,
-					  int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_conntrack_defrag(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		      const struct net_device *in,
+		      const struct net_device *out,
+		      int (*okfn)(struct sk_buff *))
 {
 	struct sock *sk = skb->sk;
 	struct inet_sock *inet = inet_sk(skb->sk);
@@ -83,7 +83,9 @@ static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
 #endif
 	/* Gather fragments. */
 	if (ip_is_fragment(ip_hdr(skb))) {
-		enum ip_defrag_users user = nf_ct_defrag_user(hooknum, skb);
+		enum ip_defrag_users user;
+
+		user = nf_ct_defrag_user(ops->hooknum, skb);
 		if (nf_ct_ipv4_gather_frags(skb, user))
 			return NF_STOLEN;
 	}
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index beb5777..35c5b28 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -32,13 +32,14 @@ static const struct xt_table packet_filter = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_filter_hook(unsigned int hook, struct sk_buff *skb,
+ip6table_filter_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_filter);
+	return ip6t_do_table(skb, ops->hooknum, in, out,
+			     net->ipv6.ip6table_filter);
 }
 
 static struct nf_hook_ops *filter_ops __read_mostly;
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 7431121..ceefe23 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -72,17 +72,17 @@ ip6t_mangle_out(struct sk_buff *skb, const struct net_device *out)
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
+ip6table_mangle_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
-	if (hook == NF_INET_LOCAL_OUT)
+	if (ops->hooknum == NF_INET_LOCAL_OUT)
 		return ip6t_mangle_out(skb, out);
-	if (hook == NF_INET_POST_ROUTING)
-		return ip6t_do_table(skb, hook, in, out,
+	if (ops->hooknum == NF_INET_POST_ROUTING)
+		return ip6t_do_table(skb, ops->hooknum, in, out,
 				     dev_net(out)->ipv6.ip6table_mangle);
 	/* INPUT/FORWARD */
-	return ip6t_do_table(skb, hook, in, out,
+	return ip6t_do_table(skb, ops->hooknum, in, out,
 			     dev_net(in)->ipv6.ip6table_mangle);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index e418bd6..4ae0c37 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -63,16 +63,14 @@ static unsigned int nf_nat_rule_find(struct sk_buff *skb, unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_ipv6_fn(unsigned int hooknum,
-	       struct sk_buff *skb,
-	       const struct net_device *in,
-	       const struct net_device *out,
+nf_nat_ipv6_fn(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
 	       int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_nat *nat;
-	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
+	enum nf_nat_manip_type maniptype = HOOK2MANIP(ops->hooknum);
 	__be16 frag_off;
 	int hdrlen;
 	u8 nexthdr;
@@ -111,7 +109,8 @@ nf_nat_ipv6_fn(unsigned int hooknum,
 
 		if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
 			if (!nf_nat_icmpv6_reply_translation(skb, ct, ctinfo,
-							     hooknum, hdrlen))
+							     ops->hooknum,
+							     hdrlen))
 				return NF_DROP;
 			else
 				return NF_ACCEPT;
@@ -124,7 +123,7 @@ nf_nat_ipv6_fn(unsigned int hooknum,
 		if (!nf_nat_initialized(ct, maniptype)) {
 			unsigned int ret;
 
-			ret = nf_nat_rule_find(skb, hooknum, in, out, ct);
+			ret = nf_nat_rule_find(skb, ops->hooknum, in, out, ct);
 			if (ret != NF_ACCEPT)
 				return ret;
 		} else
@@ -139,20 +138,18 @@ nf_nat_ipv6_fn(unsigned int hooknum,
 			     ctinfo == IP_CT_ESTABLISHED_REPLY);
 	}
 
-	return nf_nat_packet(ct, ctinfo, hooknum, skb);
+	return nf_nat_packet(ct, ctinfo, ops->hooknum, skb);
 }
 
 static unsigned int
-nf_nat_ipv6_in(unsigned int hooknum,
-	       struct sk_buff *skb,
-	       const struct net_device *in,
-	       const struct net_device *out,
+nf_nat_ipv6_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
 	       int (*okfn)(struct sk_buff *))
 {
 	unsigned int ret;
 	struct in6_addr daddr = ipv6_hdr(skb)->daddr;
 
-	ret = nf_nat_ipv6_fn(hooknum, skb, in, out, okfn);
+	ret = nf_nat_ipv6_fn(skb, ops, in, out, okfn);
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    ipv6_addr_cmp(&daddr, &ipv6_hdr(skb)->daddr))
 		skb_dst_drop(skb);
@@ -161,10 +158,8 @@ nf_nat_ipv6_in(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_ipv6_out(unsigned int hooknum,
-		struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
+nf_nat_ipv6_out(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		const struct net_device *in, const struct net_device *out,
 		int (*okfn)(struct sk_buff *))
 {
 #ifdef CONFIG_XFRM
@@ -177,7 +172,7 @@ nf_nat_ipv6_out(unsigned int hooknum,
 	if (skb->len < sizeof(struct ipv6hdr))
 		return NF_ACCEPT;
 
-	ret = nf_nat_ipv6_fn(hooknum, skb, in, out, okfn);
+	ret = nf_nat_ipv6_fn(skb, ops, in, out, okfn);
 #ifdef CONFIG_XFRM
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    !(IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED) &&
@@ -196,10 +191,8 @@ nf_nat_ipv6_out(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_ipv6_local_fn(unsigned int hooknum,
-		     struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
+nf_nat_ipv6_local_fn(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
 	const struct nf_conn *ct;
@@ -210,7 +203,7 @@ nf_nat_ipv6_local_fn(unsigned int hooknum,
 	if (skb->len < sizeof(struct ipv6hdr))
 		return NF_ACCEPT;
 
-	ret = nf_nat_ipv6_fn(hooknum, skb, in, out, okfn);
+	ret = nf_nat_ipv6_fn(skb, ops, in, out, okfn);
 	if (ret != NF_DROP && ret != NF_STOLEN &&
 	    (ct = nf_ct_get(skb, &ctinfo)) != NULL) {
 		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 60d1bdd..8306c5a 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -19,13 +19,14 @@ static const struct xt_table packet_raw = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6table_raw_hook(unsigned int hook, struct sk_buff *skb,
+ip6table_raw_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		  const struct net_device *in, const struct net_device *out,
 		  int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_raw);
+	return ip6t_do_table(skb, ops->hooknum, in, out,
+			     net->ipv6.ip6table_raw);
 }
 
 static struct nf_hook_ops *rawtable_ops __read_mostly;
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index db15535..a896012 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -36,14 +36,15 @@ static const struct xt_table security_table = {
 };
 
 static unsigned int
-ip6table_security_hook(unsigned int hook, struct sk_buff *skb,
+ip6table_security_hook(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		       const struct net_device *in,
 		       const struct net_device *out,
 		       int (*okfn)(struct sk_buff *))
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
-	return ip6t_do_table(skb, hook, in, out, net->ipv6.ip6table_security);
+	return ip6t_do_table(skb, ops->hooknum, in, out,
+			     net->ipv6.ip6table_security);
 }
 
 static struct nf_hook_ops *sectbl_ops __read_mostly;
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 8860d23..5a56e13 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -93,11 +93,10 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	return NF_ACCEPT;
 }
 
-static unsigned int ipv6_helper(unsigned int hooknum,
-				struct sk_buff *skb,
-				const struct net_device *in,
-				const struct net_device *out,
-				int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_helper(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	    const struct net_device *in, const struct net_device *out,
+	    int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
 	const struct nf_conn_help *help;
@@ -131,17 +130,16 @@ static unsigned int ipv6_helper(unsigned int hooknum,
 
 	ret = helper->help(skb, protoff, ct, ctinfo);
 	if (ret != NF_ACCEPT && (ret & NF_VERDICT_MASK) != NF_QUEUE) {
-		nf_log_packet(NFPROTO_IPV6, hooknum, skb, in, out, NULL,
+		nf_log_packet(NFPROTO_IPV6, ops->hooknum, skb, in, out, NULL,
 			      "nf_ct_%s: dropping packet", helper->name);
 	}
 	return ret;
 }
 
-static unsigned int ipv6_confirm(unsigned int hooknum,
-				 struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_confirm(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	     const struct net_device *in, const struct net_device *out,
+	     int (*okfn)(struct sk_buff *))
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -227,27 +225,27 @@ static unsigned int __ipv6_conntrack_in(struct net *net,
 	return nf_conntrack_in(net, PF_INET6, hooknum, skb);
 }
 
-static unsigned int ipv6_conntrack_in(unsigned int hooknum,
-				      struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_conntrack_in(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		  const struct net_device *in, const struct net_device *out,
+		  int (*okfn)(struct sk_buff *))
 {
-	return __ipv6_conntrack_in(dev_net(in), hooknum, skb, in, out, okfn);
+	return __ipv6_conntrack_in(dev_net(in), ops->hooknum, skb,
+				   in, out, okfn);
 }
 
-static unsigned int ipv6_conntrack_local(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_conntrack_local(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		     const struct net_device *in, const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
 {
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct ipv6hdr)) {
 		net_notice_ratelimited("ipv6_conntrack_local: packet too short\n");
 		return NF_ACCEPT;
 	}
-	return __ipv6_conntrack_in(dev_net(out), hooknum, skb, in, out, okfn);
+	return __ipv6_conntrack_in(dev_net(out), ops->hooknum, skb,
+				   in, out, okfn);
 }
 
 static struct nf_hook_ops ipv6_conntrack_ops[] __read_mostly = {
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index cdd6d04..1b90103 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -52,11 +52,10 @@ static enum ip6_defrag_users nf_ct6_defrag_user(unsigned int hooknum,
 
 }
 
-static unsigned int ipv6_defrag(unsigned int hooknum,
-				struct sk_buff *skb,
-				const struct net_device *in,
-				const struct net_device *out,
-				int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_defrag(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	    const struct net_device *in, const struct net_device *out,
+	    int (*okfn)(struct sk_buff *))
 {
 	struct sk_buff *reasm;
 
@@ -66,7 +65,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 		return NF_ACCEPT;
 #endif
 
-	reasm = nf_ct_frag6_gather(skb, nf_ct6_defrag_user(hooknum, skb));
+	reasm = nf_ct_frag6_gather(skb, nf_ct6_defrag_user(ops->hooknum, skb));
 	/* queued */
 	if (reasm == NULL)
 		return NF_STOLEN;
@@ -75,7 +74,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 	if (reasm == skb)
 		return NF_ACCEPT;
 
-	nf_ct_frag6_output(hooknum, reasm, (struct net_device *)in,
+	nf_ct_frag6_output(ops->hooknum, reasm, (struct net_device *)in,
 			   (struct net_device *)out, okfn);
 
 	return NF_STOLEN;
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 68912dad..fef430e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -143,7 +143,7 @@ unsigned int nf_iterate(struct list_head *head,
 		/* Optimization: we don't need to hold module
 		   reference here, since function can't sleep. --RR */
 repeat:
-		verdict = (*elemp)->hook(hook, skb, indev, outdev, okfn);
+		verdict = (*elemp)->hook(skb, *elemp, indev, outdev, okfn);
 		if (verdict != NF_ACCEPT) {
 #ifdef CONFIG_NETFILTER_DEBUG
 			if (unlikely((verdict & NF_VERDICT_MASK)
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 58918e2..a8fe44e 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1226,11 +1226,11 @@ ip_vs_out(unsigned int hooknum, struct sk_buff *skb, int af)
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_reply4(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_reply4(struct sk_buff *skb, const struct nf_hook_ops *ops,
 	     const struct net_device *in, const struct net_device *out,
 	     int (*okfn)(struct sk_buff *))
 {
-	return ip_vs_out(hooknum, skb, AF_INET);
+	return ip_vs_out(ops->hooknum, skb, AF_INET);
 }
 
 /*
@@ -1238,7 +1238,7 @@ ip_vs_reply4(unsigned int hooknum, struct sk_buff *skb,
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_local_reply4(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_local_reply4(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		   const struct net_device *in, const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
@@ -1246,7 +1246,7 @@ ip_vs_local_reply4(unsigned int hooknum, struct sk_buff *skb,
 
 	/* Disable BH in LOCAL_OUT until all places are fixed */
 	local_bh_disable();
-	verdict = ip_vs_out(hooknum, skb, AF_INET);
+	verdict = ip_vs_out(ops->hooknum, skb, AF_INET);
 	local_bh_enable();
 	return verdict;
 }
@@ -1259,11 +1259,11 @@ ip_vs_local_reply4(unsigned int hooknum, struct sk_buff *skb,
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_reply6(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_reply6(struct sk_buff *skb, const struct nf_hook_ops *ops,
 	     const struct net_device *in, const struct net_device *out,
 	     int (*okfn)(struct sk_buff *))
 {
-	return ip_vs_out(hooknum, skb, AF_INET6);
+	return ip_vs_out(ops->hooknum, skb, AF_INET6);
 }
 
 /*
@@ -1271,7 +1271,7 @@ ip_vs_reply6(unsigned int hooknum, struct sk_buff *skb,
  *	Check if packet is reply for established ip_vs_conn.
  */
 static unsigned int
-ip_vs_local_reply6(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_local_reply6(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		   const struct net_device *in, const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
@@ -1279,7 +1279,7 @@ ip_vs_local_reply6(unsigned int hooknum, struct sk_buff *skb,
 
 	/* Disable BH in LOCAL_OUT until all places are fixed */
 	local_bh_disable();
-	verdict = ip_vs_out(hooknum, skb, AF_INET6);
+	verdict = ip_vs_out(ops->hooknum, skb, AF_INET6);
 	local_bh_enable();
 	return verdict;
 }
@@ -1695,12 +1695,12 @@ ip_vs_in(unsigned int hooknum, struct sk_buff *skb, int af)
  *	Schedule and forward packets from remote clients
  */
 static unsigned int
-ip_vs_remote_request4(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_remote_request4(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		      const struct net_device *in,
 		      const struct net_device *out,
 		      int (*okfn)(struct sk_buff *))
 {
-	return ip_vs_in(hooknum, skb, AF_INET);
+	return ip_vs_in(ops->hooknum, skb, AF_INET);
 }
 
 /*
@@ -1708,7 +1708,7 @@ ip_vs_remote_request4(unsigned int hooknum, struct sk_buff *skb,
  *	Schedule and forward packets from local clients
  */
 static unsigned int
-ip_vs_local_request4(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_local_request4(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
@@ -1716,7 +1716,7 @@ ip_vs_local_request4(unsigned int hooknum, struct sk_buff *skb,
 
 	/* Disable BH in LOCAL_OUT until all places are fixed */
 	local_bh_disable();
-	verdict = ip_vs_in(hooknum, skb, AF_INET);
+	verdict = ip_vs_in(ops->hooknum, skb, AF_INET);
 	local_bh_enable();
 	return verdict;
 }
@@ -1728,12 +1728,12 @@ ip_vs_local_request4(unsigned int hooknum, struct sk_buff *skb,
  *	Schedule and forward packets from remote clients
  */
 static unsigned int
-ip_vs_remote_request6(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_remote_request6(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		      const struct net_device *in,
 		      const struct net_device *out,
 		      int (*okfn)(struct sk_buff *))
 {
-	return ip_vs_in(hooknum, skb, AF_INET6);
+	return ip_vs_in(ops->hooknum, skb, AF_INET6);
 }
 
 /*
@@ -1741,7 +1741,7 @@ ip_vs_remote_request6(unsigned int hooknum, struct sk_buff *skb,
  *	Schedule and forward packets from local clients
  */
 static unsigned int
-ip_vs_local_request6(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_local_request6(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		     const struct net_device *in, const struct net_device *out,
 		     int (*okfn)(struct sk_buff *))
 {
@@ -1749,7 +1749,7 @@ ip_vs_local_request6(unsigned int hooknum, struct sk_buff *skb,
 
 	/* Disable BH in LOCAL_OUT until all places are fixed */
 	local_bh_disable();
-	verdict = ip_vs_in(hooknum, skb, AF_INET6);
+	verdict = ip_vs_in(ops->hooknum, skb, AF_INET6);
 	local_bh_enable();
 	return verdict;
 }
@@ -1767,7 +1767,7 @@ ip_vs_local_request6(unsigned int hooknum, struct sk_buff *skb,
  *      and send them to ip_vs_in_icmp.
  */
 static unsigned int
-ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_forward_icmp(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		   const struct net_device *in, const struct net_device *out,
 		   int (*okfn)(struct sk_buff *))
 {
@@ -1782,12 +1782,12 @@ ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
 	if (!net_ipvs(net)->enable)
 		return NF_ACCEPT;
 
-	return ip_vs_in_icmp(skb, &r, hooknum);
+	return ip_vs_in_icmp(skb, &r, ops->hooknum);
 }
 
 #ifdef CONFIG_IP_VS_IPV6
 static unsigned int
-ip_vs_forward_icmp_v6(unsigned int hooknum, struct sk_buff *skb,
+ip_vs_forward_icmp_v6(struct sk_buff *skb, const struct nf_hook_ops *ops,
 		      const struct net_device *in, const struct net_device *out,
 		      int (*okfn)(struct sk_buff *))
 {
@@ -1802,7 +1802,7 @@ ip_vs_forward_icmp_v6(unsigned int hooknum, struct sk_buff *skb,
 	if (!net_ipvs(net)->enable)
 		return NF_ACCEPT;
 
-	return ip_vs_in_icmp_v6(skb, &r, hooknum);
+	return ip_vs_in_icmp_v6(skb, &r, ops->hooknum);
 }
 #endif
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 61a5336..b73506f 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4545,21 +4545,19 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb, int ifindex,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_forward(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv4_forward(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		     const struct net_device *in, const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
 {
 	return selinux_ip_forward(skb, in->ifindex, PF_INET);
 }
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-static unsigned int selinux_ipv6_forward(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv6_forward(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		     const struct net_device *in, const struct net_device *out,
+		     int (*okfn)(struct sk_buff *))
 {
 	return selinux_ip_forward(skb, in->ifindex, PF_INET6);
 }
@@ -4587,11 +4585,10 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_output(unsigned int hooknum,
-					struct sk_buff *skb,
-					const struct net_device *in,
-					const struct net_device *out,
-					int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv4_output(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		    const struct net_device *in, const struct net_device *out,
+		    int (*okfn)(struct sk_buff *))
 {
 	return selinux_ip_output(skb, PF_INET);
 }
@@ -4714,21 +4711,21 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_postroute(unsigned int hooknum,
-					   struct sk_buff *skb,
-					   const struct net_device *in,
-					   const struct net_device *out,
-					   int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv4_postroute(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		       const struct net_device *in,
+		       const struct net_device *out,
+		       int (*okfn)(struct sk_buff *))
 {
 	return selinux_ip_postroute(skb, out->ifindex, PF_INET);
 }
 
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-static unsigned int selinux_ipv6_postroute(unsigned int hooknum,
-					   struct sk_buff *skb,
-					   const struct net_device *in,
-					   const struct net_device *out,
-					   int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv6_postroute(struct sk_buff *skb, const struct nf_hook_ops *ops,
+		       const struct net_device *in,
+		       const struct net_device *out,
+		       int (*okfn)(struct sk_buff *))
 {
 	return selinux_ip_postroute(skb, out->ifindex, PF_INET6);
 }
-- 
1.7.10.4

