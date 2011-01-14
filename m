From: Jan Engelhardt <jengelh@medozas.de>
Subject: netfilter: add a typedef for the recurring okfn use
Date: Fri, 14 Jan 2011 22:54:00 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101142253330.15697@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54427 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011Ab1ANVyG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:54:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 0134e89c7bcc9fde1da962c82a120691e185619f (v2.6.37-3800-g0134e89)
commit 7994a5e014b1b85469a83463e35145aa5e17333c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jan 14 22:03:19 2011 +0100

netfilter: add a typedef for the recurring okfn use

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter.h                      |   42 ++++++------
 include/net/netfilter/ipv6/nf_defrag_ipv6.h    |    2 +-
 include/net/netfilter/nf_queue.h               |    2 +-
 net/bridge/br_netfilter.c                      |   57 ++++++++--------
 net/bridge/netfilter/ebtable_filter.c          |    4 +-
 net/bridge/netfilter/ebtable_nat.c             |    9 ++-
 net/decnet/netfilter/dn_rtmsg.c                |    8 +--
 net/ipv4/netfilter/arptable_filter.c           |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    7 +--
 net/ipv4/netfilter/iptable_filter.c            |    2 +-
 net/ipv4/netfilter/iptable_mangle.c            |    8 +--
 net/ipv4/netfilter/iptable_raw.c               |    2 +-
 net/ipv4/netfilter/iptable_security.c          |    3 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   27 +++----
 net/ipv4/netfilter/nf_defrag_ipv4.c            |    9 +--
 net/ipv4/netfilter/nf_nat_standalone.c         |   32 +++------
 net/ipv6/netfilter/ip6table_filter.c           |    2 +-
 net/ipv6/netfilter/ip6table_mangle.c           |    2 +-
 net/ipv6/netfilter/ip6table_raw.c              |    2 +-
 net/ipv6/netfilter/ip6table_security.c         |    3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   34 ++++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    2 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c      |    9 +--
 net/netfilter/core.c                           |   18 ++---
 net/netfilter/ipvs/ip_vs_core.c                |   22 +++---
 net/netfilter/nf_internals.h                   |   23 ++----
 net/netfilter/nf_queue.c                       |   21 ++----
 security/selinux/hooks.c                       |   45 ++++++-------
 28 files changed, 172 insertions(+), 227 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0ab7ca7..40392b7 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -89,11 +89,12 @@ extern void netfilter_init(void);
 
 struct sk_buff;
 
+typedef int (*nf_okfn_t)(struct sk_buff *);
 typedef unsigned int nf_hookfn(unsigned int hooknum,
 			       struct sk_buff *skb,
 			       const struct net_device *in,
 			       const struct net_device *out,
-			       int (*okfn)(struct sk_buff *));
+			       nf_okfn_t okfn);
 
 struct nf_hook_ops {
 	struct list_head list;
@@ -152,7 +153,7 @@ extern struct list_head nf_hooks[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 
 int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 		 struct net_device *indev, struct net_device *outdev,
-		 int (*okfn)(struct sk_buff *), int thresh);
+		 nf_okfn_t okfn, int thresh);
 
 /**
  *	nf_hook_thresh - call a netfilter hook
@@ -161,11 +162,10 @@ int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
  *	okfn must be invoked by the caller in this case.  Any other return
  *	value indicates the packet has been consumed by the hook.
  */
-static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
-				 struct sk_buff *skb,
-				 struct net_device *indev,
-				 struct net_device *outdev,
-				 int (*okfn)(struct sk_buff *), int thresh)
+static inline int
+nf_hook_thresh(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
+	       struct net_device *indev, struct net_device *outdev,
+	       nf_okfn_t okfn, int thresh)
 {
 #ifndef CONFIG_NETFILTER_DEBUG
 	if (list_empty(&nf_hooks[pf][hook]))
@@ -174,9 +174,9 @@ static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
 	return nf_hook_slow(pf, hook, skb, indev, outdev, okfn, thresh);
 }
 
-static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
-			  struct net_device *indev, struct net_device *outdev,
-			  int (*okfn)(struct sk_buff *))
+static inline int
+nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
+	struct net_device *indev, struct net_device *outdev, nf_okfn_t okfn)
 {
 	return nf_hook_thresh(pf, hook, skb, indev, outdev, okfn, INT_MIN);
 }
@@ -201,7 +201,7 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
 static inline int
 NF_HOOK_THRESH(uint8_t pf, unsigned int hook, struct sk_buff *skb,
 	       struct net_device *in, struct net_device *out,
-	       int (*okfn)(struct sk_buff *), int thresh)
+	       nf_okfn_t okfn, int thresh)
 {
 	int ret = nf_hook_thresh(pf, hook, skb, in, out, okfn, thresh);
 	if (ret == 1)
@@ -212,7 +212,7 @@ NF_HOOK_THRESH(uint8_t pf, unsigned int hook, struct sk_buff *skb,
 static inline int
 NF_HOOK_COND(uint8_t pf, unsigned int hook, struct sk_buff *skb,
 	     struct net_device *in, struct net_device *out,
-	     int (*okfn)(struct sk_buff *), bool cond)
+	     nf_okfn_t okfn, bool cond)
 {
 	int ret;
 
@@ -224,8 +224,7 @@ NF_HOOK_COND(uint8_t pf, unsigned int hook, struct sk_buff *skb,
 
 static inline int
 NF_HOOK(uint8_t pf, unsigned int hook, struct sk_buff *skb,
-	struct net_device *in, struct net_device *out,
-	int (*okfn)(struct sk_buff *))
+	struct net_device *in, struct net_device *out, nf_okfn_t okfn)
 {
 	return NF_HOOK_THRESH(pf, hook, skb, in, out, okfn, INT_MIN);
 }
@@ -335,17 +334,16 @@ extern struct proc_dir_entry *proc_net_netfilter;
 #else /* !CONFIG_NETFILTER */
 #define NF_HOOK(pf, hook, skb, indev, outdev, okfn) (okfn)(skb)
 #define NF_HOOK_COND(pf, hook, skb, indev, outdev, okfn, cond) (okfn)(skb)
-static inline int nf_hook_thresh(u_int8_t pf, unsigned int hook,
-				 struct sk_buff *skb,
-				 struct net_device *indev,
-				 struct net_device *outdev,
-				 int (*okfn)(struct sk_buff *), int thresh)
+static inline int
+nf_hook_thresh(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
+	       struct net_device *indev, struct net_device *outdev,
+	       nf_okfn_t okfn, int thresh)
 {
 	return okfn(skb);
 }
-static inline int nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
-			  struct net_device *indev, struct net_device *outdev,
-			  int (*okfn)(struct sk_buff *))
+static inline int
+nf_hook(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
+	struct net_device *indev, struct net_device *outdev, nf_okfn_t okfn)
 {
 	return 1;
 }
diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index fd79c9a..5fcd207 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -9,7 +9,7 @@ extern struct sk_buff *nf_ct_frag6_gather(struct sk_buff *skb, u32 user);
 extern void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 			       struct net_device *in,
 			       struct net_device *out,
-			       int (*okfn)(struct sk_buff *));
+			       nf_okfn_t okfn);
 
 struct inet_frags_ctl;
 
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 252fd10..598d898 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -12,7 +12,7 @@ struct nf_queue_entry {
 	unsigned int		hook;
 	struct net_device	*indev;
 	struct net_device	*outdev;
-	int			(*okfn)(struct sk_buff *);
+	nf_okfn_t		okfn;
 };
 
 #define nf_queue_entry_reroute(x) ((void *)x + sizeof(struct nf_queue_entry))
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 4b5b66d..81cacc3 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -552,11 +552,10 @@ bad:
 
 /* Replicate the checks that IPv6 does on packet reception and pass the packet
  * to ip6tables, which doesn't support NAT, so things are fairly simple. */
-static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
-					   struct sk_buff *skb,
-					   const struct net_device *in,
-					   const struct net_device *out,
-					   int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_pre_routing_ipv6(unsigned int hook, struct sk_buff *skb,
+		       const struct net_device *in,
+		       const struct net_device *out, nf_okfn_t okfn)
 {
 	struct ipv6hdr *hdr;
 	u32 pkt_len;
@@ -602,10 +601,10 @@ static unsigned int br_nf_pre_routing_ipv6(unsigned int hook,
  * receiving device) to make netfilter happy, the REDIRECT
  * target in particular.  Save the original destination IP
  * address to be able to detect DNAT afterwards. */
-static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  nf_okfn_t okfn)
 {
 	struct net_bridge_port *p;
 	struct net_bridge *br;
@@ -662,10 +661,10 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
  * took place when the packet entered the bridge), but we
  * register an IPv4 PRE_ROUTING 'sabotage' hook that will
  * prevent this from happening. */
-static unsigned int br_nf_local_in(unsigned int hook, struct sk_buff *skb,
-				   const struct net_device *in,
-				   const struct net_device *out,
-				   int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_local_in(unsigned int hook, struct sk_buff *skb,
+	       const struct net_device *in, const struct net_device *out,
+	       nf_okfn_t okfn)
 {
 	struct rtable *rt = skb_rtable(skb);
 
@@ -703,10 +702,10 @@ static int br_nf_forward_finish(struct sk_buff *skb)
  * but we are still able to filter on the 'real' indev/outdev
  * because of the physdev module. For ARP, indev and outdev are the
  * bridge ports. */
-static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
-				     const struct net_device *in,
-				     const struct net_device *out,
-				     int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
+		 const struct net_device *in, const struct net_device *out,
+		 nf_okfn_t okfn)
 {
 	struct nf_bridge_info *nf_bridge;
 	struct net_device *parent;
@@ -755,10 +754,10 @@ static unsigned int br_nf_forward_ip(unsigned int hook, struct sk_buff *skb,
 	return NF_STOLEN;
 }
 
-static unsigned int br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_forward_arp(unsigned int hook, struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  nf_okfn_t okfn)
 {
 	struct net_bridge_port *p;
 	struct net_bridge *br;
@@ -815,10 +814,10 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 #endif
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
-static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
-				       const struct net_device *in,
-				       const struct net_device *out,
-				       int (*okfn)(struct sk_buff *))
+static unsigned int
+br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
+		   const struct net_device *in, const struct net_device *out,
+		   nf_okfn_t okfn)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 	struct net_device *realoutdev = bridge_parent(skb->dev);
@@ -862,10 +861,10 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 /* IP/SABOTAGE *****************************************************/
 /* Don't hand locally destined packets to PF_INET(6)/PRE_ROUTING
  * for the second time. */
-static unsigned int ip_sabotage_in(unsigned int hook, struct sk_buff *skb,
-				   const struct net_device *in,
-				   const struct net_device *out,
-				   int (*okfn)(struct sk_buff *))
+static unsigned int
+ip_sabotage_in(unsigned int hook, struct sk_buff *skb,
+	       const struct net_device *in, const struct net_device *out,
+	       nf_okfn_t okfn)
 {
 	if (skb->nf_bridge &&
 	    !(skb->nf_bridge->mask & BRNF_NF_BRIDGE_PREROUTING)) {
diff --git a/net/bridge/netfilter/ebtable_filter.c b/net/bridge/netfilter/ebtable_filter.c
index 42e6bd0..c2aeb6a 100644
--- a/net/bridge/netfilter/ebtable_filter.c
+++ b/net/bridge/netfilter/ebtable_filter.c
@@ -61,14 +61,14 @@ static const struct ebt_table frame_filter =
 
 static unsigned int
 ebt_in_hook(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, int (*okfn)(struct sk_buff *))
+	    const struct net_device *out, nf_okfn_t okfn)
 {
 	return ebt_do_table(hook, skb, in, out, dev_net(in)->xt.frame_filter);
 }
 
 static unsigned int
 ebt_out_hook(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, int (*okfn)(struct sk_buff *))
+	     const struct net_device *out, nf_okfn_t okfn)
 {
 	return ebt_do_table(hook, skb, in, out, dev_net(out)->xt.frame_filter);
 }
diff --git a/net/bridge/netfilter/ebtable_nat.c b/net/bridge/netfilter/ebtable_nat.c
index 6dc2f87..bc9bfb2 100644
--- a/net/bridge/netfilter/ebtable_nat.c
+++ b/net/bridge/netfilter/ebtable_nat.c
@@ -60,15 +60,16 @@ static struct ebt_table frame_nat =
 };
 
 static unsigned int
-ebt_nat_in(unsigned int hook, struct sk_buff *skb, const struct net_device *in
-   , const struct net_device *out, int (*okfn)(struct sk_buff *))
+ebt_nat_in(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, nf_okfn_t okfn)
 {
 	return ebt_do_table(hook, skb, in, out, dev_net(in)->xt.frame_nat);
 }
 
 static unsigned int
-ebt_nat_out(unsigned int hook, struct sk_buff *skb, const struct net_device *in
-   , const struct net_device *out, int (*okfn)(struct sk_buff *))
+ebt_nat_out(unsigned int hook, struct sk_buff *skb,
+	    const struct net_device *in, const struct net_device *out,
+	    nf_okfn_t okfn)
 {
 	return ebt_do_table(hook, skb, in, out, dev_net(out)->xt.frame_nat);
 }
diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index 64a7f39..3ea8f9e 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -88,11 +88,9 @@ static void dnrmg_send_peer(struct sk_buff *skb)
 }
 
 
-static unsigned int dnrmg_hook(unsigned int hook,
-			struct sk_buff *skb,
-			const struct net_device *in,
-			const struct net_device *out,
-			int (*okfn)(struct sk_buff *))
+static unsigned int
+dnrmg_hook(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, nf_okfn_t okfn)
 {
 	dnrmg_send_peer(skb);
 	return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 79ca5e7..48c091c 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -29,7 +29,7 @@ static const struct xt_table packet_filter = {
 static unsigned int
 arptable_filter_hook(unsigned int hook, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+		     nf_okfn_t okfn)
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 1e26a48..3fa9f05 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -490,11 +490,8 @@ static void arp_print(struct arp_payload *payload)
 #endif
 
 static unsigned int
-arp_mangle(unsigned int hook,
-	   struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
-	   int (*okfn)(struct sk_buff *))
+arp_mangle(unsigned int hook, struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, nf_okfn_t okfn)
 {
 	struct arphdr *arp = arp_hdr(skb);
 	struct arp_payload *payload;
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index c37641e..1958fe9 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -35,7 +35,7 @@ static const struct xt_table packet_filter = {
 static unsigned int
 iptable_filter_hook(unsigned int hook, struct sk_buff *skb,
 		    const struct net_device *in, const struct net_device *out,
-		    int (*okfn)(struct sk_buff *))
+		    nf_okfn_t okfn)
 {
 	const struct net *net;
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index 294a2a3..bf25c6b 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -76,11 +76,9 @@ ipt_mangle_out(struct sk_buff *skb, const struct net_device *out)
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-iptable_mangle_hook(unsigned int hook,
-		     struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+iptable_mangle_hook(unsigned int hook, struct sk_buff *skb,
+		    const struct net_device *in, const struct net_device *out,
+		    nf_okfn_t okfn)
 {
 	if (hook == NF_INET_LOCAL_OUT)
 		return ipt_mangle_out(skb, out);
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 07fb710..fa23535 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -22,7 +22,7 @@ static const struct xt_table packet_raw = {
 static unsigned int
 iptable_raw_hook(unsigned int hook, struct sk_buff *skb,
 		 const struct net_device *in, const struct net_device *out,
-		 int (*okfn)(struct sk_buff *))
+		 nf_okfn_t okfn)
 {
 	const struct net *net;
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index be45bdc..e707890 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -39,8 +39,7 @@ static const struct xt_table security_table = {
 static unsigned int
 iptable_security_hook(unsigned int hook, struct sk_buff *skb,
 		      const struct net_device *in,
-		      const struct net_device *out,
-		      int (*okfn)(struct sk_buff *))
+		      const struct net_device *out, nf_okfn_t okfn)
 {
 	const struct net *net;
 
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index 5a03c02..a575851 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -87,11 +87,10 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	return NF_ACCEPT;
 }
 
-static unsigned int ipv4_confirm(unsigned int hooknum,
-				 struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_confirm(unsigned int hooknum, struct sk_buff *skb,
+	     const struct net_device *in, const struct net_device *out,
+	     nf_okfn_t okfn)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -135,20 +134,18 @@ out:
 	return nf_conntrack_confirm(skb);
 }
 
-static unsigned int ipv4_conntrack_in(unsigned int hooknum,
-				      struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_conntrack_in(unsigned int hooknum, struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  nf_okfn_t okfn)
 {
 	return nf_conntrack_in(dev_net(in), PF_INET, hooknum, skb);
 }
 
-static unsigned int ipv4_conntrack_local(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_conntrack_local(unsigned int hooknum, struct sk_buff *skb,
+		     const struct net_device *in, const struct net_device *out,
+		     nf_okfn_t okfn)
 {
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct iphdr) ||
diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index f3a9b42..2a2b565 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -60,11 +60,10 @@ static enum ip_defrag_users nf_ct_defrag_user(unsigned int hooknum,
 		return IP_DEFRAG_CONNTRACK_OUT + zone;
 }
 
-static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
-					  struct sk_buff *skb,
-					  const struct net_device *in,
-					  const struct net_device *out,
-					  int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv4_conntrack_defrag(unsigned int hooknum, struct sk_buff *skb,
+		      const struct net_device *in,
+		      const struct net_device *out, nf_okfn_t okfn)
 {
 	struct sock *sk = skb->sk;
 	struct inet_sock *inet = inet_sk(skb->sk);
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 95481fe..69006f6 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -73,11 +73,9 @@ static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 #endif
 
 static unsigned int
-nf_nat_fn(unsigned int hooknum,
-	  struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  int (*okfn)(struct sk_buff *))
+nf_nat_fn(unsigned int hooknum, struct sk_buff *skb,
+	  const struct net_device *in, const struct net_device *out,
+	  nf_okfn_t okfn)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
@@ -150,11 +148,9 @@ nf_nat_fn(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_in(unsigned int hooknum,
-	  struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  int (*okfn)(struct sk_buff *))
+nf_nat_in(unsigned int hooknum, struct sk_buff *skb,
+	  const struct net_device *in, const struct net_device *out,
+	  nf_okfn_t okfn)
 {
 	unsigned int ret;
 	__be32 daddr = ip_hdr(skb)->daddr;
@@ -168,11 +164,9 @@ nf_nat_in(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_out(unsigned int hooknum,
-	   struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
-	   int (*okfn)(struct sk_buff *))
+nf_nat_out(unsigned int hooknum, struct sk_buff *skb,
+	   const struct net_device *in, const struct net_device *out,
+	   nf_okfn_t okfn)
 {
 #ifdef CONFIG_XFRM
 	const struct nf_conn *ct;
@@ -203,11 +197,9 @@ nf_nat_out(unsigned int hooknum,
 }
 
 static unsigned int
-nf_nat_local_fn(unsigned int hooknum,
-		struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		int (*okfn)(struct sk_buff *))
+nf_nat_local_fn(unsigned int hooknum, struct sk_buff *skb,
+		const struct net_device *in, const struct net_device *out,
+		nf_okfn_t okfn)
 {
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index c9e37c8..cc457fd 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -34,7 +34,7 @@ static const struct xt_table packet_filter = {
 static unsigned int
 ip6table_filter_hook(unsigned int hook, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+		     nf_okfn_t okfn)
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 679a0a3..2bb8e9e 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -74,7 +74,7 @@ ip6t_mangle_out(struct sk_buff *skb, const struct net_device *out)
 static unsigned int
 ip6table_mangle_hook(unsigned int hook, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+		     nf_okfn_t okfn)
 {
 	if (hook == NF_INET_LOCAL_OUT)
 		return ip6t_mangle_out(skb, out);
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 5b9926a..232c53f 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -21,7 +21,7 @@ static const struct xt_table packet_raw = {
 static unsigned int
 ip6table_raw_hook(unsigned int hook, struct sk_buff *skb,
 		  const struct net_device *in, const struct net_device *out,
-		  int (*okfn)(struct sk_buff *))
+		  nf_okfn_t okfn)
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 91aa2b4..8f7605b 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -38,8 +38,7 @@ static const struct xt_table security_table = {
 static unsigned int
 ip6table_security_hook(unsigned int hook, struct sk_buff *skb,
 		       const struct net_device *in,
-		       const struct net_device *out,
-		       int (*okfn)(struct sk_buff *))
+		       const struct net_device *out, nf_okfn_t okfn)
 {
 	const struct net *net = dev_net((in != NULL) ? in : out);
 
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index c8af58b..7d7585a 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -143,11 +143,10 @@ static int ipv6_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	return NF_ACCEPT;
 }
 
-static unsigned int ipv6_confirm(unsigned int hooknum,
-				 struct sk_buff *skb,
-				 const struct net_device *in,
-				 const struct net_device *out,
-				 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_confirm(unsigned int hooknum, struct sk_buff *skb,
+	     const struct net_device *in, const struct net_device *out,
+	     nf_okfn_t okfn)
 {
 	struct nf_conn *ct;
 	const struct nf_conn_help *help;
@@ -189,10 +188,9 @@ out:
 	return nf_conntrack_confirm(skb);
 }
 
-static unsigned int __ipv6_conntrack_in(struct net *net,
-					unsigned int hooknum,
-					struct sk_buff *skb,
-					int (*okfn)(struct sk_buff *))
+static unsigned int
+__ipv6_conntrack_in(struct net *net, unsigned int hooknum, struct sk_buff *skb,
+		    nf_okfn_t okfn)
 {
 	struct sk_buff *reasm = skb->nfct_reasm;
 
@@ -215,20 +213,18 @@ static unsigned int __ipv6_conntrack_in(struct net *net,
 	return nf_conntrack_in(net, PF_INET6, hooknum, skb);
 }
 
-static unsigned int ipv6_conntrack_in(unsigned int hooknum,
-				      struct sk_buff *skb,
-				      const struct net_device *in,
-				      const struct net_device *out,
-				      int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_conntrack_in(unsigned int hooknum, struct sk_buff *skb,
+		  const struct net_device *in, const struct net_device *out,
+		  nf_okfn_t okfn)
 {
 	return __ipv6_conntrack_in(dev_net(in), hooknum, skb, okfn);
 }
 
-static unsigned int ipv6_conntrack_local(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+ipv6_conntrack_local(unsigned int hooknum, struct sk_buff *skb,
+		     const struct net_device *in, const struct net_device *out,
+		     nf_okfn_t okfn)
 {
 	/* root is playing with raw sockets. */
 	if (skb->len < sizeof(struct ipv6hdr)) {
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 66e003e..8b3d871 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -590,7 +590,7 @@ ret_orig:
 
 void nf_ct_frag6_output(unsigned int hooknum, struct sk_buff *skb,
 			struct net_device *in, struct net_device *out,
-			int (*okfn)(struct sk_buff *))
+			nf_okfn_t okfn)
 {
 	struct sk_buff *s, *s2;
 
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index 97c5b21..26e4d04 100644
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
+ipv6_defrag(unsigned int hooknum, struct sk_buff *skb,
+	    const struct net_device *in, const struct net_device *out,
+	    nf_okfn_t okfn)
 {
 	struct sk_buff *reasm;
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e69d537..d1c2b5a 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -110,14 +110,10 @@ void nf_unregister_hooks(struct nf_hook_ops *reg, unsigned int n)
 }
 EXPORT_SYMBOL(nf_unregister_hooks);
 
-unsigned int nf_iterate(struct list_head *head,
-			struct sk_buff *skb,
-			unsigned int hook,
-			const struct net_device *indev,
-			const struct net_device *outdev,
-			struct list_head **i,
-			int (*okfn)(struct sk_buff *),
-			int hook_thresh)
+unsigned int
+nf_iterate(struct list_head *head, struct sk_buff *skb, unsigned int hook,
+	   const struct net_device *indev, const struct net_device *outdev,
+	   struct list_head **i, nf_okfn_t okfn, int hook_thresh)
 {
 	unsigned int verdict;
 
@@ -155,10 +151,8 @@ unsigned int nf_iterate(struct list_head *head,
 /* Returns 1 if okfn() needs to be executed by the caller,
  * -EPERM for NF_DROP, 0 otherwise. */
 int nf_hook_slow(u_int8_t pf, unsigned int hook, struct sk_buff *skb,
-		 struct net_device *indev,
-		 struct net_device *outdev,
-		 int (*okfn)(struct sk_buff *),
-		 int hook_thresh)
+		 struct net_device *indev, struct net_device *outdev,
+		 nf_okfn_t okfn, int hook_thresh)
 {
 	struct list_head *elem;
 	unsigned int verdict;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index f36a84f..622ac2a 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1204,7 +1204,7 @@ ip_vs_out(unsigned int hooknum, struct sk_buff *skb, int af)
 static unsigned int
 ip_vs_reply4(unsigned int hooknum, struct sk_buff *skb,
 	     const struct net_device *in, const struct net_device *out,
-	     int (*okfn)(struct sk_buff *))
+	     nf_okfn_t okfn)
 {
 	return ip_vs_out(hooknum, skb, AF_INET);
 }
@@ -1216,7 +1216,7 @@ ip_vs_reply4(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_local_reply4(unsigned int hooknum, struct sk_buff *skb,
 		   const struct net_device *in, const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+		   nf_okfn_t okfn)
 {
 	unsigned int verdict;
 
@@ -1237,7 +1237,7 @@ ip_vs_local_reply4(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_reply6(unsigned int hooknum, struct sk_buff *skb,
 	     const struct net_device *in, const struct net_device *out,
-	     int (*okfn)(struct sk_buff *))
+	     nf_okfn_t okfn)
 {
 	return ip_vs_out(hooknum, skb, AF_INET6);
 }
@@ -1249,7 +1249,7 @@ ip_vs_reply6(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_local_reply6(unsigned int hooknum, struct sk_buff *skb,
 		   const struct net_device *in, const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+		   nf_okfn_t okfn)
 {
 	unsigned int verdict;
 
@@ -1666,8 +1666,7 @@ out:
 static unsigned int
 ip_vs_remote_request4(unsigned int hooknum, struct sk_buff *skb,
 		      const struct net_device *in,
-		      const struct net_device *out,
-		      int (*okfn)(struct sk_buff *))
+		      const struct net_device *out, nf_okfn_t okfn)
 {
 	return ip_vs_in(hooknum, skb, AF_INET);
 }
@@ -1679,7 +1678,7 @@ ip_vs_remote_request4(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_local_request4(unsigned int hooknum, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+		     nf_okfn_t okfn)
 {
 	unsigned int verdict;
 
@@ -1699,8 +1698,7 @@ ip_vs_local_request4(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_remote_request6(unsigned int hooknum, struct sk_buff *skb,
 		      const struct net_device *in,
-		      const struct net_device *out,
-		      int (*okfn)(struct sk_buff *))
+		      const struct net_device *out, nf_okfn_t okfn)
 {
 	return ip_vs_in(hooknum, skb, AF_INET6);
 }
@@ -1712,7 +1710,7 @@ ip_vs_remote_request6(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_local_request6(unsigned int hooknum, struct sk_buff *skb,
 		     const struct net_device *in, const struct net_device *out,
-		     int (*okfn)(struct sk_buff *))
+		     nf_okfn_t okfn)
 {
 	unsigned int verdict;
 
@@ -1738,7 +1736,7 @@ ip_vs_local_request6(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
 		   const struct net_device *in, const struct net_device *out,
-		   int (*okfn)(struct sk_buff *))
+		   nf_okfn_t okfn)
 {
 	int r;
 
@@ -1752,7 +1750,7 @@ ip_vs_forward_icmp(unsigned int hooknum, struct sk_buff *skb,
 static unsigned int
 ip_vs_forward_icmp_v6(unsigned int hooknum, struct sk_buff *skb,
 		      const struct net_device *in, const struct net_device *out,
-		      int (*okfn)(struct sk_buff *))
+		      nf_okfn_t okfn)
 {
 	int r;
 
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 770f764..75c33bd 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -13,23 +13,16 @@
 
 
 /* core.c */
-extern unsigned int nf_iterate(struct list_head *head,
-				struct sk_buff *skb,
-				unsigned int hook,
-				const struct net_device *indev,
-				const struct net_device *outdev,
-				struct list_head **i,
-				int (*okfn)(struct sk_buff *),
-				int hook_thresh);
+extern unsigned int
+nf_iterate(struct list_head *head, struct sk_buff *skb, unsigned int hook,
+	   const struct net_device *indev, const struct net_device *outdev,
+	   struct list_head **i, nf_okfn_t okfn, int hook_thresh);
 
 /* nf_queue.c */
-extern int nf_queue(struct sk_buff *skb,
-		    struct list_head *elem,
-		    u_int8_t pf, unsigned int hook,
-		    struct net_device *indev,
-		    struct net_device *outdev,
-		    int (*okfn)(struct sk_buff *),
-		    unsigned int queuenum);
+extern int
+nf_queue(struct sk_buff *skb, struct list_head *elem, u_int8_t pf,
+	 unsigned int hook, struct net_device *indev,
+	 struct net_device *outdev, nf_okfn_t okfn, unsigned int queuenum);
 extern int __init netfilter_queue_init(void);
 
 /* nf_log.c */
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 1876f74..d7091c4 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -117,13 +117,10 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
  * Any packet that leaves via this function must come back
  * through nf_reinject().
  */
-static int __nf_queue(struct sk_buff *skb,
-		      struct list_head *elem,
-		      u_int8_t pf, unsigned int hook,
-		      struct net_device *indev,
-		      struct net_device *outdev,
-		      int (*okfn)(struct sk_buff *),
-		      unsigned int queuenum)
+static int
+__nf_queue(struct sk_buff *skb, struct list_head *elem, u_int8_t pf,
+	   unsigned int hook, struct net_device *indev,
+	   struct net_device *outdev, nf_okfn_t okfn, unsigned int queuenum)
 {
 	int status;
 	struct nf_queue_entry *entry = NULL;
@@ -202,13 +199,9 @@ err:
 	return 1;
 }
 
-int nf_queue(struct sk_buff *skb,
-	     struct list_head *elem,
-	     u_int8_t pf, unsigned int hook,
-	     struct net_device *indev,
-	     struct net_device *outdev,
-	     int (*okfn)(struct sk_buff *),
-	     unsigned int queuenum)
+int nf_queue(struct sk_buff *skb, struct list_head *elem, u_int8_t pf,
+	     unsigned int hook, struct net_device *indev,
+	     struct net_device *outdev, nf_okfn_t okfn, unsigned int queuenum)
 {
 	struct sk_buff *segs;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 6f637d2..6786491 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4446,21 +4446,19 @@ static unsigned int selinux_ip_forward(struct sk_buff *skb, int ifindex,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_forward(unsigned int hooknum,
-					 struct sk_buff *skb,
-					 const struct net_device *in,
-					 const struct net_device *out,
-					 int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv4_forward(unsigned int hooknum, struct sk_buff *skb,
+		     const struct net_device *in, const struct net_device *out,
+		     nf_okfn_t okfn)
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
+selinux_ipv6_forward(unsigned int hooknum, struct sk_buff *skb,
+		     const struct net_device *in, const struct net_device *out,
+		     nf_okfn_t okfn)
 {
 	return selinux_ip_forward(skb, in->ifindex, PF_INET6);
 }
@@ -4488,11 +4486,10 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_output(unsigned int hooknum,
-					struct sk_buff *skb,
-					const struct net_device *in,
-					const struct net_device *out,
-					int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv4_output(unsigned int hooknum, struct sk_buff *skb,
+		    const struct net_device *in, const struct net_device *out,
+		    nf_okfn_t okfn)
 {
 	return selinux_ip_output(skb, PF_INET);
 }
@@ -4625,21 +4622,19 @@ static unsigned int selinux_ip_postroute(struct sk_buff *skb, int ifindex,
 	return NF_ACCEPT;
 }
 
-static unsigned int selinux_ipv4_postroute(unsigned int hooknum,
-					   struct sk_buff *skb,
-					   const struct net_device *in,
-					   const struct net_device *out,
-					   int (*okfn)(struct sk_buff *))
+static unsigned int
+selinux_ipv4_postroute(unsigned int hooknum, struct sk_buff *skb,
+		       const struct net_device *in,
+		       const struct net_device *out, nf_okfn_t okfn)
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
+selinux_ipv6_postroute(unsigned int hooknum, struct sk_buff *skb,
+		       const struct net_device *in,
+		       const struct net_device *out, nf_okfn_t okfn)
 {
 	return selinux_ip_postroute(skb, out->ifindex, PF_INET6);
 }
-- 
# Created with git-export-patch

