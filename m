From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/23] netfilter: xtables: move extension arguments into compound structure (1/6)
Date: Mon,  6 Oct 2008 08:15:17 -0400
Message-ID: <f2c244bfb599465f55831331087b82ea613c5dfe.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57111 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJFMPd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:33 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The function signatures for Xtables extensions have grown over time.
It involves a lot of typing/replication, and also a bit of stack space
even if they are not used. Realize an NFWS2008 idea and pack them into
structs. The skb remains outside of the struct so gcc can continue to
apply its optimizations.

This patch does this for match extensions' match functions.

A few ambiguities have also been addressed. The "offset" parameter for
example has been renamed to "fragoff" (there are so many different
offsets already) and "protoff" to "thoff" (there is more than just one
protocol here, so clarify).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h   |   28 +++++++++++++++-----
 net/bridge/netfilter/ebt_802_3.c     |    6 +---
 net/bridge/netfilter/ebt_among.c     |    6 +---
 net/bridge/netfilter/ebt_arp.c       |    6 +---
 net/bridge/netfilter/ebt_ip.c        |    6 +---
 net/bridge/netfilter/ebt_ip6.c       |    6 +---
 net/bridge/netfilter/ebt_limit.c     |    6 +---
 net/bridge/netfilter/ebt_mark_m.c    |    6 +---
 net/bridge/netfilter/ebt_pkttype.c   |    7 +---
 net/bridge/netfilter/ebt_stp.c       |    6 +---
 net/bridge/netfilter/ebt_vlan.c      |    6 +---
 net/bridge/netfilter/ebtables.c      |   16 +++++++----
 net/ipv4/netfilter/ip_tables.c       |   46 ++++++++++++++-------------------
 net/ipv4/netfilter/ipt_addrtype.c    |   18 ++++---------
 net/ipv4/netfilter/ipt_ah.c          |   14 +++------
 net/ipv4/netfilter/ipt_ecn.c         |    9 ++----
 net/ipv4/netfilter/ipt_ttl.c         |    7 +---
 net/ipv6/netfilter/ip6_tables.c      |   44 ++++++++++++--------------------
 net/ipv6/netfilter/ip6t_ah.c         |   11 +++-----
 net/ipv6/netfilter/ip6t_eui64.c      |    9 ++----
 net/ipv6/netfilter/ip6t_frag.c       |   11 +++-----
 net/ipv6/netfilter/ip6t_hbh.c        |   13 +++------
 net/ipv6/netfilter/ip6t_hl.c         |    7 +---
 net/ipv6/netfilter/ip6t_ipv6header.c |    7 +---
 net/ipv6/netfilter/ip6t_mh.c         |   15 ++++------
 net/ipv6/netfilter/ip6t_rt.c         |   11 +++-----
 net/netfilter/xt_comment.c           |    5 +---
 net/netfilter/xt_connbytes.c         |    7 +---
 net/netfilter/xt_connlimit.c         |   17 +++++-------
 net/netfilter/xt_connmark.c          |   14 +++-------
 net/netfilter/xt_conntrack.c         |   22 ++++++----------
 net/netfilter/xt_dccp.c              |   16 +++++------
 net/netfilter/xt_dscp.c              |   30 +++++++--------------
 net/netfilter/xt_esp.c               |   13 +++------
 net/netfilter/xt_hashlimit.c         |   22 ++++++----------
 net/netfilter/xt_helper.c            |    7 +---
 net/netfilter/xt_iprange.c           |   21 ++++-----------
 net/netfilter/xt_length.c            |   14 +++-------
 net/netfilter/xt_limit.c             |    7 +---
 net/netfilter/xt_mac.c               |    7 +---
 net/netfilter/xt_mark.c              |   13 +++------
 net/netfilter/xt_multiport.c         |   26 +++++++------------
 net/netfilter/xt_owner.c             |   21 ++++-----------
 net/netfilter/xt_physdev.c           |    7 +---
 net/netfilter/xt_pkttype.c           |   11 +++-----
 net/netfilter/xt_policy.c            |   11 +++-----
 net/netfilter/xt_quota.c             |    7 +---
 net/netfilter/xt_rateest.c           |   12 ++------
 net/netfilter/xt_realm.c             |    7 +---
 net/netfilter/xt_recent.c            |   17 +++++-------
 net/netfilter/xt_sctp.c              |   16 +++++------
 net/netfilter/xt_socket.c            |   11 +------
 net/netfilter/xt_state.c             |    7 +---
 net/netfilter/xt_statistic.c         |    7 +---
 net/netfilter/xt_string.c            |    9 ++----
 net/netfilter/xt_tcpmss.c            |   13 +++------
 net/netfilter/xt_tcpudp.c            |   36 +++++++++++---------------
 net/netfilter/xt_time.c              |    6 +---
 net/netfilter/xt_u32.c               |    7 +---
 59 files changed, 286 insertions(+), 487 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 85aa427..bcd40ec 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -173,6 +173,26 @@ struct xt_counters_info
 
 #include <linux/netdevice.h>
 
+/**
+ * struct xt_match_param - parameters for match extensions' match functions
+ *
+ * @in:		input netdevice
+ * @out:	output netdevice
+ * @match:	struct xt_match through which this function was invoked
+ * @matchinfo:	per-match data
+ * @fragoff:	packet is a fragment, this is the data offset
+ * @thoff:	position of transport header relative to skb->data
+ * @hotdrop:	drop packet if we had inspection problems
+ */
+struct xt_match_param {
+	const struct net_device *in, *out;
+	const struct xt_match *match;
+	const void *matchinfo;
+	int fragoff;
+	unsigned int thoff;
+	bool *hotdrop;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -185,13 +205,7 @@ struct xt_match
 	   non-linear skb, using skb_header_pointer and
 	   skb_ip_make_writable. */
 	bool (*match)(const struct sk_buff *skb,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const struct xt_match *match,
-		      const void *matchinfo,
-		      int offset,
-		      unsigned int protoff,
-		      bool *hotdrop);
+		      const struct xt_match_param *);
 
 	/* Called when user tries to insert an entry of this type. */
 	/* Should return true or false. */
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 6fc2a59..c9e1bc1 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -13,11 +13,9 @@
 #include <linux/netfilter_bridge/ebt_802_3.h>
 
 static bool
-ebt_802_3_mt(const struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, const struct xt_match *match,
-	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_802_3_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_802_3_info *info = data;
+	const struct ebt_802_3_info *info = par->matchinfo;
 	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
 	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
 
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 084559e..0ad0db3 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -128,11 +128,9 @@ static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 }
 
 static bool
-ebt_among_mt(const struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, const struct xt_match *match,
-	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_among_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_among_info *info = data;
+	const struct ebt_among_info *info = par->matchinfo;
 	const char *dmac, *smac;
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	__be32 dip = 0, sip = 0;
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index a073dff..1ff8fa3 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -16,11 +16,9 @@
 #include <linux/netfilter_bridge/ebt_arp.h>
 
 static bool
-ebt_arp_mt(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const struct xt_match *match,
-	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_arp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_arp_info *info = data;
+	const struct ebt_arp_info *info = par->matchinfo;
 	const struct arphdr *ah;
 	struct arphdr _arph;
 
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index b42c7ce..c70ea39 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -25,11 +25,9 @@ struct tcpudphdr {
 };
 
 static bool
-ebt_ip_mt(const struct sk_buff *skb, const struct net_device *in,
-	  const struct net_device *out, const struct xt_match *match,
-	  const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_ip_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_ip_info *info = data;
+	const struct ebt_ip_info *info = par->matchinfo;
 	const struct iphdr *ih;
 	struct iphdr _iph;
 	const struct tcpudphdr *pptr;
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 7bd9831..5acee02 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -28,11 +28,9 @@ struct tcpudphdr {
 };
 
 static bool
-ebt_ip6_mt(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const struct xt_match *match,
-	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_ip6_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_ip6_info *info = data;
+	const struct ebt_ip6_info *info = par->matchinfo;
 	const struct ipv6hdr *ih6;
 	struct ipv6hdr _ip6h;
 	const struct tcpudphdr *pptr;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 58aaaa1..9a3ec8c 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -31,11 +31,9 @@ static DEFINE_SPINLOCK(limit_lock);
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static bool
-ebt_limit_mt(const struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, const struct xt_match *match,
-	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_limit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	struct ebt_limit_info *info = (void *)data;
+	struct ebt_limit_info *info = (void *)par->matchinfo;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index aa6781c..5b22ef9 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -13,11 +13,9 @@
 #include <linux/netfilter_bridge/ebt_mark_m.h>
 
 static bool
-ebt_mark_mt(const struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, const struct xt_match *match,
-	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_mark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_mark_m_info *info = data;
+	const struct ebt_mark_m_info *info = par->matchinfo;
 
 	if (info->bitmask & EBT_MARK_OR)
 		return !!(skb->mark & info->mask) ^ info->invert;
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 1c04ce5..b756f88 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -13,12 +13,9 @@
 #include <linux/netfilter_bridge/ebt_pkttype.h>
 
 static bool
-ebt_pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
-	       const struct net_device *out, const struct xt_match *match,
-	       const void *data, int offset, unsigned int protoff,
-	       bool *hotdrop)
+ebt_pkttype_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_pkttype_info *info = data;
+	const struct ebt_pkttype_info *info = par->matchinfo;
 
 	return (skb->pkt_type == info->pkt_type) ^ info->invert;
 }
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 28bb48b..06d777c 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -120,11 +120,9 @@ static bool ebt_filter_config(const struct ebt_stp_info *info,
 }
 
 static bool
-ebt_stp_mt(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const struct xt_match *match,
-	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_stp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_stp_info *info = data;
+	const struct ebt_stp_info *info = par->matchinfo;
 	const struct stp_header *sp;
 	struct stp_header _stph;
 	const uint8_t header[6] = {0x42, 0x42, 0x03, 0x00, 0x00, 0x00};
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 5addef6..b05b4a8 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -41,11 +41,9 @@ MODULE_LICENSE("GPL");
 #define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return false; }
 
 static bool
-ebt_vlan_mt(const struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, const struct xt_match *match,
-	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
+ebt_vlan_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ebt_vlan_info *info = data;
+	const struct ebt_vlan_info *info = par->matchinfo;
 	const struct vlan_hdr *fp;
 	struct vlan_hdr _frame;
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 7ee72b7..f8e1822 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -74,11 +74,11 @@ static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
 }
 
 static inline int ebt_do_match (struct ebt_entry_match *m,
-   const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, bool *hotdrop)
+   const struct sk_buff *skb, struct xt_match_param *par)
 {
-	return m->u.match->match(skb, in, out, m->u.match,
-	       m->data, 0, 0, hotdrop);
+	par->match     = m->u.match;
+	par->matchinfo = m->data;
+	return m->u.match->match(skb, par);
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
@@ -155,6 +155,11 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	char *base;
 	struct ebt_table_info *private;
 	bool hotdrop = false;
+	struct xt_match_param mtpar;
+
+	mtpar.in      = in;
+	mtpar.out     = out;
+	mtpar.hotdrop = &hotdrop;
 
 	read_lock_bh(&table->lock);
 	private = table->private;
@@ -175,8 +180,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (ebt_basic_match(point, eth_hdr(skb), in, out))
 			goto letscontinue;
 
-		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb,
-		    in, out, &hotdrop) != 0)
+		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &mtpar) != 0)
 			goto letscontinue;
 		if (hotdrop) {
 			read_unlock_bh(&table->lock);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b4c74a7..99fdb59 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -186,16 +186,14 @@ ipt_error(struct sk_buff *skb,
 
 /* Performance critical - called for every packet */
 static inline bool
-do_match(struct ipt_entry_match *m,
-	      const struct sk_buff *skb,
-	      const struct net_device *in,
-	      const struct net_device *out,
-	      int offset,
-	      bool *hotdrop)
+do_match(struct ipt_entry_match *m, const struct sk_buff *skb,
+	 struct xt_match_param *par)
 {
+	par->match     = m->u.kernel.match;
+	par->matchinfo = m->data;
+
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, ip_hdrlen(skb), hotdrop))
+	if (!m->u.kernel.match->match(skb, par))
 		return true;
 	else
 		return false;
@@ -326,7 +324,6 @@ ipt_do_table(struct sk_buff *skb,
 	     struct xt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
-	u_int16_t offset;
 	const struct iphdr *ip;
 	u_int16_t datalen;
 	bool hotdrop = false;
@@ -336,6 +333,7 @@ ipt_do_table(struct sk_buff *skb,
 	void *table_base;
 	struct ipt_entry *e, *back;
 	struct xt_table_info *private;
+	struct xt_match_param mtpar;
 
 	/* Initialization */
 	ip = ip_hdr(skb);
@@ -348,7 +346,11 @@ ipt_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
-	offset = ntohs(ip->frag_off) & IP_OFFSET;
+	mtpar.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
+	mtpar.thoff   = ip_hdrlen(skb);
+	mtpar.hotdrop = &hotdrop;
+	mtpar.in      = in;
+	mtpar.out     = out;
 
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
@@ -362,12 +364,11 @@ ipt_do_table(struct sk_buff *skb,
 	do {
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
-		if (ip_packet_match(ip, indev, outdev, &e->ip, offset)) {
+		if (ip_packet_match(ip, indev, outdev,
+		    &e->ip, mtpar.fragoff)) {
 			struct ipt_entry_target *t;
 
-			if (IPT_MATCH_ITERATE(e, do_match,
-					      skb, in, out,
-					      offset, &hotdrop) != 0)
+			if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
 				goto no_match;
 
 			ADD_COUNTER(e->counters, ntohs(ip->tot_len), 1);
@@ -2116,30 +2117,23 @@ icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 }
 
 static bool
-icmp_match(const struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
-	   const struct xt_match *match,
-	   const void *matchinfo,
-	   int offset,
-	   unsigned int protoff,
-	   bool *hotdrop)
+icmp_match(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct icmphdr *ic;
 	struct icmphdr _icmph;
-	const struct ipt_icmp *icmpinfo = matchinfo;
+	const struct ipt_icmp *icmpinfo = par->matchinfo;
 
 	/* Must not be a fragment. */
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	ic = skb_header_pointer(skb, protoff, sizeof(_icmph), &_icmph);
+	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
 	if (ic == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 2c9d88a..e60995e 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -30,12 +30,9 @@ static inline bool match_type(const struct net_device *dev, __be32 addr,
 }
 
 static bool
-addrtype_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-	       const struct net_device *out, const struct xt_match *match,
-	       const void *matchinfo, int offset, unsigned int protoff,
-	       bool *hotdrop)
+addrtype_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_addrtype_info *info = matchinfo;
+	const struct ipt_addrtype_info *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool ret = true;
 
@@ -50,20 +47,17 @@ addrtype_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-addrtype_mt_v1(const struct sk_buff *skb, const struct net_device *in,
-	       const struct net_device *out, const struct xt_match *match,
-	       const void *matchinfo, int offset, unsigned int protoff,
-	       bool *hotdrop)
+addrtype_mt_v1(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_addrtype_info_v1 *info = matchinfo;
+	const struct ipt_addrtype_info_v1 *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	const struct net_device *dev = NULL;
 	bool ret = true;
 
 	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN)
-		dev = in;
+		dev = par->in;
 	else if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT)
-		dev = out;
+		dev = par->out;
 
 	if (info->source)
 		ret &= match_type(dev, iph->saddr, info->source) ^
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index e2e993e..2fce19e 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -36,27 +36,23 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool
-ah_mt(const struct sk_buff *skb, const struct net_device *in,
-      const struct net_device *out, const struct xt_match *match,
-      const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ah_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct ip_auth_hdr _ahdr;
 	const struct ip_auth_hdr *ah;
-	const struct ipt_ah *ahinfo = matchinfo;
+	const struct ipt_ah *ahinfo = par->matchinfo;
 
 	/* Must not be a fragment. */
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	ah = skb_header_pointer(skb, protoff,
-				sizeof(_ahdr), &_ahdr);
+	ah = skb_header_pointer(skb, par->thoff, sizeof(_ahdr), &_ahdr);
 	if (ah == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil AH tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return 0;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 2c45b4b..0691546 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -67,12 +67,9 @@ static inline bool match_tcp(const struct sk_buff *skb,
 	return true;
 }
 
-static bool
-ecn_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ecn_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_ecn_info *info = matchinfo;
+	const struct ipt_ecn_info *info = par->matchinfo;
 
 	if (info->operation & IPT_ECN_OP_MATCH_IP)
 		if (!match_ip(skb, info))
@@ -81,7 +78,7 @@ ecn_mt(const struct sk_buff *skb, const struct net_device *in,
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
 		if (ip_hdr(skb)->protocol != IPPROTO_TCP)
 			return false;
-		if (!match_tcp(skb, info, hotdrop))
+		if (!match_tcp(skb, info, par->hotdrop))
 			return false;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index d4c3fdc..297f1cb 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -18,12 +18,9 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: IPv4 TTL field match");
 MODULE_LICENSE("GPL");
 
-static bool
-ttl_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ttl_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_ttl_info *info = matchinfo;
+	const struct ipt_ttl_info *info = par->matchinfo;
 	const u8 ttl = ip_hdr(skb)->ttl;
 
 	switch (info->mode) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 12c41b8..cf2c537 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -215,17 +215,14 @@ ip6t_error(struct sk_buff *skb,
 
 /* Performance critical - called for every packet */
 static inline bool
-do_match(struct ip6t_entry_match *m,
-	      const struct sk_buff *skb,
-	      const struct net_device *in,
-	      const struct net_device *out,
-	      int offset,
-	      unsigned int protoff,
-	      bool *hotdrop)
+do_match(struct ip6t_entry_match *m, const struct sk_buff *skb,
+	 struct xt_match_param *par)
 {
+	par->match     = m->u.kernel.match;
+	par->matchinfo = m->data;
+
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, protoff, hotdrop))
+	if (!m->u.kernel.match->match(skb, par))
 		return true;
 	else
 		return false;
@@ -355,8 +352,6 @@ ip6t_do_table(struct sk_buff *skb,
 	      struct xt_table *table)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
-	int offset = 0;
-	unsigned int protoff = 0;
 	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
@@ -364,6 +359,7 @@ ip6t_do_table(struct sk_buff *skb,
 	void *table_base;
 	struct ip6t_entry *e, *back;
 	struct xt_table_info *private;
+	struct xt_match_param mtpar;
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -374,6 +370,9 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
+	mtpar.hotdrop = &hotdrop;
+	mtpar.in      = in;
+	mtpar.out     = out;
 
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
@@ -388,12 +387,10 @@ ip6t_do_table(struct sk_buff *skb,
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		if (ip6_packet_match(skb, indev, outdev, &e->ipv6,
-			&protoff, &offset, &hotdrop)) {
+			&mtpar.thoff, &mtpar.fragoff, &hotdrop)) {
 			struct ip6t_entry_target *t;
 
-			if (IP6T_MATCH_ITERATE(e, do_match,
-					       skb, in, out,
-					       offset, protoff, &hotdrop) != 0)
+			if (IP6T_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
 				goto no_match;
 
 			ADD_COUNTER(e->counters,
@@ -2141,30 +2138,23 @@ icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 }
 
 static bool
-icmp6_match(const struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
-	   const struct xt_match *match,
-	   const void *matchinfo,
-	   int offset,
-	   unsigned int protoff,
-	   bool *hotdrop)
+icmp6_match(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct icmp6hdr *ic;
 	struct icmp6hdr _icmph;
-	const struct ip6t_icmp *icmpinfo = matchinfo;
+	const struct ip6t_icmp *icmpinfo = par->matchinfo;
 
 	/* Must not be a fragment. */
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	ic = skb_header_pointer(skb, protoff, sizeof(_icmph), &_icmph);
+	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
 	if (ic == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 061f89b..a04f2b8 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -36,14 +36,11 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool
-ah_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ah_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct ip_auth_hdr _ah;
 	const struct ip_auth_hdr *ah;
-	const struct ip6t_ah *ahinfo = matchinfo;
+	const struct ip6t_ah *ahinfo = par->matchinfo;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 	int err;
@@ -51,13 +48,13 @@ ah_mt6(const struct sk_buff *skb, const struct net_device *in,
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = true;
+			*par->hotdrop = true;
 		return false;
 	}
 
 	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
 	if (ah == NULL) {
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index ba38df1..db610ba 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -20,18 +20,15 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 static bool
-eui64_mt6(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+eui64_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	unsigned char eui64[8];
 	int i = 0;
 
 	if (!(skb_mac_header(skb) >= skb->head &&
 	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
-	    offset != 0) {
-		*hotdrop = true;
+	    par->fragoff != 0) {
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index 972f699..6951d0d 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -35,27 +35,24 @@ id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 }
 
 static bool
-frag_mt6(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+frag_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct frag_hdr _frag;
 	const struct frag_hdr *fh;
-	const struct ip6t_frag *fraginfo = matchinfo;
+	const struct ip6t_frag *fraginfo = par->matchinfo;
 	unsigned int ptr;
 	int err;
 
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = true;
+			*par->hotdrop = true;
 		return false;
 	}
 
 	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
 	if (fh == NULL) {
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index d5edb51..d335197 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -42,14 +42,11 @@ MODULE_ALIAS("ip6t_dst");
  */
 
 static bool
-hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff,
-        bool *hotdrop)
+hbh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct ipv6_opt_hdr _optsh;
 	const struct ipv6_opt_hdr *oh;
-	const struct ip6t_opts *optinfo = matchinfo;
+	const struct ip6t_opts *optinfo = par->matchinfo;
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
@@ -61,16 +58,16 @@ hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
 	unsigned int optlen;
 	int err;
 
-	err = ipv6_find_hdr(skb, &ptr, match->data, NULL);
+	err = ipv6_find_hdr(skb, &ptr, par->match->data, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = true;
+			*par->hotdrop = true;
 		return false;
 	}
 
 	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
 	if (oh == NULL) {
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index 25c1eb9..c964dca 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -19,12 +19,9 @@ MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
 MODULE_DESCRIPTION("Xtables: IPv6 Hop Limit field match");
 MODULE_LICENSE("GPL");
 
-static bool
-hl_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool hl_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ip6t_hl_info *info = matchinfo;
+	const struct ip6t_hl_info *info = par->matchinfo;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 
 	switch (info->mode) {
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index ef0661a..6aaca51 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -27,12 +27,9 @@ MODULE_DESCRIPTION("Xtables: IPv6 header types match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 static bool
-ipv6header_mt6(const struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, const struct xt_match *match,
-               const void *matchinfo, int offset, unsigned int protoff,
-               bool *hotdrop)
+ipv6header_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ip6t_ipv6header_info *info = matchinfo;
+	const struct ip6t_ipv6header_info *info = par->matchinfo;
 	unsigned int temp;
 	int len;
 	u8 nexthdr;
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index dd87627..2803258 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -37,32 +37,29 @@ type_match(u_int8_t min, u_int8_t max, u_int8_t type, bool invert)
 	return (type >= min && type <= max) ^ invert;
 }
 
-static bool
-mh_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool mh_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct ip6_mh _mh;
 	const struct ip6_mh *mh;
-	const struct ip6t_mh *mhinfo = matchinfo;
+	const struct ip6t_mh *mhinfo = par->matchinfo;
 
 	/* Must not be a fragment. */
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	mh = skb_header_pointer(skb, protoff, sizeof(_mh), &_mh);
+	mh = skb_header_pointer(skb, par->thoff, sizeof(_mh), &_mh);
 	if (mh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil MH tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
 	if (mh->ip6mh_proto != IPPROTO_NONE) {
 		duprintf("Dropping invalid MH Payload Proto: %u\n",
 			 mh->ip6mh_proto);
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 7c544ae..9cf4b8a 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -36,14 +36,11 @@ segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 	return r;
 }
 
-static bool
-rt_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool rt_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct ipv6_rt_hdr _route;
 	const struct ipv6_rt_hdr *rh;
-	const struct ip6t_rt *rtinfo = matchinfo;
+	const struct ip6t_rt *rtinfo = par->matchinfo;
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
@@ -55,13 +52,13 @@ rt_mt6(const struct sk_buff *skb, const struct net_device *in,
 	err = ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL);
 	if (err < 0) {
 		if (err != -ENOENT)
-			*hotdrop = true;
+			*par->hotdrop = true;
 		return false;
 	}
 
 	rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
 	if (rh == NULL) {
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index fa211b2..bd7aa57 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -16,10 +16,7 @@ MODULE_ALIAS("ipt_comment");
 MODULE_ALIAS("ip6t_comment");
 
 static bool
-comment_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protooff,
-           bool *hotdrop)
+comment_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	/* We always match */
 	return true;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d2cd22a..30c19b5 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -17,12 +17,9 @@ MODULE_ALIAS("ipt_connbytes");
 MODULE_ALIAS("ip6t_connbytes");
 
 static bool
-connbytes_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+connbytes_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_connbytes_info *sinfo = matchinfo;
+	const struct xt_connbytes_info *sinfo = par->matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index bd00830..8b8f70e 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -178,12 +178,9 @@ static int count_them(struct xt_connlimit_data *data,
 }
 
 static bool
-connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+connlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_connlimit_info *info = matchinfo;
+	const struct xt_connlimit_info *info = par->matchinfo;
 	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
@@ -195,10 +192,10 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
 	if (ct != NULL)
 		tuple_ptr = &ct->tuplehash[0].tuple;
 	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				    match->family, &tuple))
+				    par->match->family, &tuple))
 		goto hotdrop;
 
-	if (match->family == NFPROTO_IPV6) {
+	if (par->match->family == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
 		memcpy(&addr.ip6, &iph->saddr, sizeof(iph->saddr));
 	} else {
@@ -208,19 +205,19 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
 
 	spin_lock_bh(&info->data->lock);
 	connections = count_them(info->data, tuple_ptr, &addr,
-	                         &info->mask, match);
+	                         &info->mask, par->match);
 	spin_unlock_bh(&info->data->lock);
 
 	if (connections < 0) {
 		/* kmalloc failed, drop it entirely */
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
 	return (connections > info->limit) ^ info->inverse;
 
  hotdrop:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 0577b8f..df4f4a8 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -34,12 +34,9 @@ MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
 static bool
-connmark_mt(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+connmark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_connmark_mtinfo1 *info = matchinfo;
+	const struct xt_connmark_mtinfo1 *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 
@@ -51,12 +48,9 @@ connmark_mt(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-connmark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, const struct xt_match *match,
-               const void *matchinfo, int offset, unsigned int protoff,
-               bool *hotdrop)
+connmark_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_connmark_info *info = matchinfo;
+	const struct xt_connmark_info *info = par->matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 392b457..13a7e4e 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -25,12 +25,9 @@ MODULE_ALIAS("ipt_conntrack");
 MODULE_ALIAS("ip6t_conntrack");
 
 static bool
-conntrack_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                const struct net_device *out, const struct xt_match *match,
-                const void *matchinfo, int offset, unsigned int protoff,
-                bool *hotdrop)
+conntrack_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_conntrack_info *sinfo = matchinfo;
+	const struct xt_conntrack_info *sinfo = par->matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
@@ -205,12 +202,9 @@ ct_proto_port_check(const struct xt_conntrack_mtinfo1 *info,
 }
 
 static bool
-conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+conntrack_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_conntrack_mtinfo1 *info = matchinfo;
+	const struct xt_conntrack_mtinfo1 *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	unsigned int statebit;
@@ -244,22 +238,22 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 		return false;
 
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC)
-		if (conntrack_mt_origsrc(ct, info, match->family) ^
+		if (conntrack_mt_origsrc(ct, info, par->match->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_ORIGSRC))
 			return false;
 
 	if (info->match_flags & XT_CONNTRACK_ORIGDST)
-		if (conntrack_mt_origdst(ct, info, match->family) ^
+		if (conntrack_mt_origdst(ct, info, par->match->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_ORIGDST))
 			return false;
 
 	if (info->match_flags & XT_CONNTRACK_REPLSRC)
-		if (conntrack_mt_replsrc(ct, info, match->family) ^
+		if (conntrack_mt_replsrc(ct, info, par->match->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_REPLSRC))
 			return false;
 
 	if (info->match_flags & XT_CONNTRACK_REPLDST)
-		if (conntrack_mt_repldst(ct, info, match->family) ^
+		if (conntrack_mt_repldst(ct, info, par->match->family) ^
 		    !(info->invert_flags & XT_CONNTRACK_REPLDST))
 			return false;
 
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 87971f4..7aa30bb 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -93,20 +93,18 @@ match_option(u_int8_t option, const struct sk_buff *skb, unsigned int protoff,
 }
 
 static bool
-dccp_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+dccp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_dccp_info *info = matchinfo;
+	const struct xt_dccp_info *info = par->matchinfo;
 	const struct dccp_hdr *dh;
 	struct dccp_hdr _dh;
 
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	dh = skb_header_pointer(skb, protoff, sizeof(_dh), &_dh);
+	dh = skb_header_pointer(skb, par->thoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
@@ -118,8 +116,8 @@ dccp_mt(const struct sk_buff *skb, const struct net_device *in,
 			XT_DCCP_DEST_PORTS, info->flags, info->invflags)
 		&& DCCHECK(match_types(dh, info->typemask),
 			   XT_DCCP_TYPE, info->flags, info->invflags)
-		&& DCCHECK(match_option(info->option, skb, protoff, dh,
-					hotdrop),
+		&& DCCHECK(match_option(info->option, skb, par->thoff, dh,
+					par->hotdrop),
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 7f03aa1..57d6120 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -26,23 +26,18 @@ MODULE_ALIAS("ipt_tos");
 MODULE_ALIAS("ip6t_tos");
 
 static bool
-dscp_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+dscp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_dscp_info *info = matchinfo;
+	const struct xt_dscp_info *info = par->matchinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
 static bool
-dscp_mt6(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+dscp_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_dscp_info *info = matchinfo;
+	const struct xt_dscp_info *info = par->matchinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
@@ -63,24 +58,19 @@ dscp_mt_check(const char *tablename, const void *info,
 	return true;
 }
 
-static bool tos_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                      const struct net_device *out,
-                      const struct xt_match *match, const void *matchinfo,
-                      int offset, unsigned int protoff, bool *hotdrop)
+static bool
+tos_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_tos_info *info = matchinfo;
+	const struct ipt_tos_info *info = par->matchinfo;
 
 	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
 }
 
-static bool tos_mt(const struct sk_buff *skb, const struct net_device *in,
-                   const struct net_device *out, const struct xt_match *match,
-                   const void *matchinfo, int offset, unsigned int protoff,
-                   bool *hotdrop)
+static bool tos_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_tos_match_info *info = matchinfo;
+	const struct xt_tos_match_info *info = par->matchinfo;
 
-	if (match->family == NFPROTO_IPV4)
+	if (par->match->family == NFPROTO_IPV4)
 		return ((ip_hdr(skb)->tos & info->tos_mask) ==
 		       info->tos_value) ^ !!info->invert;
 	else
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 045c4de..6d59f2e 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -42,26 +42,23 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool
-esp_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool esp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct ip_esp_hdr *eh;
 	struct ip_esp_hdr _esp;
-	const struct xt_esp *espinfo = matchinfo;
+	const struct xt_esp *espinfo = par->matchinfo;
 
 	/* Must not be a fragment. */
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	eh = skb_header_pointer(skb, protoff, sizeof(_esp), &_esp);
+	eh = skb_header_pointer(skb, par->thoff, sizeof(_esp), &_esp);
 	if (eh == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("Dropping evil ESP tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 7bae369..22a60a7 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -563,19 +563,16 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 }
 
 static bool
-hashlimit_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                const struct net_device *out, const struct xt_match *match,
-                const void *matchinfo, int offset, unsigned int protoff,
-                bool *hotdrop)
+hashlimit_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct xt_hashlimit_info *r =
-		((const struct xt_hashlimit_info *)matchinfo)->u.master;
+		((const struct xt_hashlimit_info *)par->matchinfo)->u.master;
 	struct xt_hashlimit_htable *hinfo = r->hinfo;
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
 	struct dsthash_dst dst;
 
-	if (hashlimit_init_dst(hinfo, &dst, skb, protoff) < 0)
+	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
 		goto hotdrop;
 
 	spin_lock_bh(&hinfo->lock);
@@ -613,23 +610,20 @@ hashlimit_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	return false;
 
 hotdrop:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
 static bool
-hashlimit_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+hashlimit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_hashlimit_mtinfo1 *info = matchinfo;
+	const struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 	struct xt_hashlimit_htable *hinfo = info->hinfo;
 	unsigned long now = jiffies;
 	struct dsthash_ent *dh;
 	struct dsthash_dst dst;
 
-	if (hashlimit_init_dst(hinfo, &dst, skb, protoff) < 0)
+	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
 		goto hotdrop;
 
 	spin_lock_bh(&hinfo->lock);
@@ -666,7 +660,7 @@ hashlimit_mt(const struct sk_buff *skb, const struct net_device *in,
 	return info->cfg.mode & XT_HASHLIMIT_INVERT;
 
  hotdrop:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 134d943..73bdc3b 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -24,12 +24,9 @@ MODULE_ALIAS("ip6t_helper");
 
 
 static bool
-helper_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+helper_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_helper_info *info = matchinfo;
+	const struct xt_helper_info *info = par->matchinfo;
 	const struct nf_conn *ct;
 	const struct nf_conn_help *master_help;
 	const struct nf_conntrack_helper *helper;
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index a7498cc..6f62c36 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -17,12 +17,9 @@
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 static bool
-iprange_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-              const struct net_device *out, const struct xt_match *match,
-              const void *matchinfo, int offset, unsigned int protoff,
-              bool *hotdrop)
+iprange_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_iprange_info *info = matchinfo;
+	const struct ipt_iprange_info *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 
 	if (info->flags & IPRANGE_SRC) {
@@ -55,12 +52,9 @@ iprange_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+iprange_mt4(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_iprange_mtinfo *info = matchinfo;
+	const struct xt_iprange_mtinfo *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool m;
 
@@ -111,12 +105,9 @@ iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
 }
 
 static bool
-iprange_mt6(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+iprange_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_iprange_mtinfo *info = matchinfo;
+	const struct xt_iprange_mtinfo *info = par->matchinfo;
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	bool m;
 
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index b8612d1..c4871ca 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -21,24 +21,18 @@ MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
 
 static bool
-length_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+length_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_length_info *info = matchinfo;
+	const struct xt_length_info *info = par->matchinfo;
 	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
 static bool
-length_mt6(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+length_mt6(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_length_info *info = matchinfo;
+	const struct xt_length_info *info = par->matchinfo;
 	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
 				 sizeof(struct ipv6hdr);
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 00247bd..c475eac 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -58,13 +58,10 @@ static DEFINE_SPINLOCK(limit_lock);
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static bool
-limit_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+limit_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct xt_rateinfo *r =
-		((const struct xt_rateinfo *)matchinfo)->master;
+		((const struct xt_rateinfo *)par->matchinfo)->master;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 60db240..269f9d8 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -24,12 +24,9 @@ MODULE_DESCRIPTION("Xtables: MAC address match");
 MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
-static bool
-mac_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-    const struct xt_mac_info *info = matchinfo;
+    const struct xt_mac_info *info = par->matchinfo;
 
     /* Is mac pointer valid? */
     return skb_mac_header(skb) >= skb->head &&
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 96dd2b6..8854761 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -23,22 +23,17 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
 static bool
-mark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+mark_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_mark_info *info = matchinfo;
+	const struct xt_mark_info *info = par->matchinfo;
 
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
 static bool
-mark_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+mark_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_mark_mtinfo1 *info = matchinfo;
+	const struct xt_mark_mtinfo1 *info = par->matchinfo;
 
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index f6fe008..7087e29 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -95,25 +95,22 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 }
 
 static bool
-multiport_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                const struct net_device *out, const struct xt_match *match,
-                const void *matchinfo, int offset, unsigned int protoff,
-                bool *hotdrop)
+multiport_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const __be16 *pptr;
 	__be16 _ports[2];
-	const struct xt_multiport *multiinfo = matchinfo;
+	const struct xt_multiport *multiinfo = par->matchinfo;
 
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), _ports);
+	pptr = skb_header_pointer(skb, par->thoff, sizeof(_ports), _ports);
 	if (pptr == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
@@ -122,25 +119,22 @@ multiport_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-multiport_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+multiport_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const __be16 *pptr;
 	__be16 _ports[2];
-	const struct xt_multiport_v1 *multiinfo = matchinfo;
+	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), _ports);
+	pptr = skb_header_pointer(skb, par->thoff, sizeof(_ports), _ports);
 	if (pptr == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
 		duprintf("xt_multiport: Dropping evil offset=0 tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index d1c3b7a..493b5eb 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -21,12 +21,9 @@
 #include <linux/netfilter_ipv6/ip6t_owner.h>
 
 static bool
-owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+owner_mt_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ipt_owner_info *info = matchinfo;
+	const struct ipt_owner_info *info = par->matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
@@ -50,12 +47,9 @@ owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+owner_mt6_v0(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct ip6t_owner_info *info = matchinfo;
+	const struct ip6t_owner_info *info = par->matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
@@ -79,12 +73,9 @@ owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-owner_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+owner_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_owner_match_info *info = matchinfo;
+	const struct xt_owner_match_info *info = par->matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 72a0bdd..e980e17 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -21,14 +21,11 @@ MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
 static bool
-physdev_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+physdev_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
-	const struct xt_physdev_info *info = matchinfo;
+	const struct xt_physdev_info *info = par->matchinfo;
 	bool ret;
 	const char *indev, *outdev;
 	const struct nf_bridge_info *nf_bridge;
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 81e86d3..37753a3 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -23,20 +23,17 @@ MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
 static bool
-pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+pkttype_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_pkttype_info *info = matchinfo;
+	const struct xt_pkttype_info *info = par->matchinfo;
 	u_int8_t type;
 
 	if (skb->pkt_type != PACKET_LOOPBACK)
 		type = skb->pkt_type;
-	else if (match->family == NFPROTO_IPV4 &&
+	else if (par->match->family == NFPROTO_IPV4 &&
 	    ipv4_is_multicast(ip_hdr(skb)->daddr))
 		type = PACKET_MULTICAST;
-	else if (match->family == NFPROTO_IPV6 &&
+	else if (par->match->family == NFPROTO_IPV6 &&
 	    ipv6_hdr(skb)->daddr.s6_addr[0] == 0xFF)
 		type = PACKET_MULTICAST;
 	else
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index f1d514e..b0a00fb 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -110,18 +110,15 @@ match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
 }
 
 static bool
-policy_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+policy_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_policy_info *info = matchinfo;
+	const struct xt_policy_info *info = par->matchinfo;
 	int ret;
 
 	if (info->flags & XT_POLICY_MATCH_IN)
-		ret = match_policy_in(skb, info, match->family);
+		ret = match_policy_in(skb, info, par->match->family);
 	else
-		ret = match_policy_out(skb, info, match->family);
+		ret = match_policy_out(skb, info, par->match->family);
 
 	if (ret < 0)
 		ret = info->flags & XT_POLICY_MATCH_NONE ? true : false;
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index a3c8798..3ab9266 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -18,13 +18,10 @@ MODULE_ALIAS("ip6t_quota");
 static DEFINE_SPINLOCK(quota_lock);
 
 static bool
-quota_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+quota_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	struct xt_quota_info *q =
-		((const struct xt_quota_info *)matchinfo)->master;
+		((const struct xt_quota_info *)par->matchinfo)->master;
 	bool ret = q->flags & XT_QUOTA_INVERT;
 
 	spin_lock_bh(&quota_lock);
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 4dcfd73..e9f64ef 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -14,16 +14,10 @@
 #include <net/netfilter/xt_rateest.h>
 
 
-static bool xt_rateest_mt(const struct sk_buff *skb,
-			  const struct net_device *in,
-			  const struct net_device *out,
-			  const struct xt_match *match,
-			  const void *matchinfo,
-			  int offset,
-			  unsigned int protoff,
-			  bool *hotdrop)
+static bool
+xt_rateest_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_rateest_match_info *info = matchinfo;
+	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est *r;
 	u_int32_t bps1, bps2, pps1, pps2;
 	bool ret = true;
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index ef65756..b259421 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -22,12 +22,9 @@ MODULE_DESCRIPTION("Xtables: Routing realm match");
 MODULE_ALIAS("ipt_realm");
 
 static bool
-realm_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+realm_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_realm_info *info = matchinfo;
+	const struct xt_realm_info *info = par->matchinfo;
 	const struct dst_entry *dst = skb->dst;
 
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 4a916e2..baeb90a 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -204,19 +204,16 @@ static void recent_table_flush(struct recent_table *t)
 }
 
 static bool
-recent_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_recent_mtinfo *info = matchinfo;
+	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
 	struct recent_entry *e;
 	union nf_inet_addr addr = {};
 	u_int8_t ttl;
 	bool ret = info->invert;
 
-	if (match->family == NFPROTO_IPV4) {
+	if (par->match->family == NFPROTO_IPV4) {
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (info->side == XT_RECENT_DEST)
@@ -237,19 +234,19 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
 	}
 
 	/* use TTL as seen before forwarding */
-	if (out && !skb->sk)
+	if (par->out != NULL && skb->sk == NULL)
 		ttl++;
 
 	spin_lock_bh(&recent_lock);
 	t = recent_table_lookup(info->name);
-	e = recent_entry_lookup(t, &addr, match->family,
+	e = recent_entry_lookup(t, &addr, par->match->family,
 				(info->check_set & XT_RECENT_TTL) ? ttl : 0);
 	if (e == NULL) {
 		if (!(info->check_set & XT_RECENT_SET))
 			goto out;
-		e = recent_entry_init(t, &addr, match->family, ttl);
+		e = recent_entry_init(t, &addr, par->match->family, ttl);
 		if (e == NULL)
-			*hotdrop = true;
+			*par->hotdrop = true;
 		ret = !ret;
 		goto out;
 	}
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index ab67aca..b0014ab 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -117,23 +117,21 @@ match_packet(const struct sk_buff *skb,
 }
 
 static bool
-sctp_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+sctp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_sctp_info *info = matchinfo;
+	const struct xt_sctp_info *info = par->matchinfo;
 	const sctp_sctphdr_t *sh;
 	sctp_sctphdr_t _sh;
 
-	if (offset) {
+	if (par->fragoff != 0) {
 		duprintf("Dropping non-first fragment.. FIXME\n");
 		return false;
 	}
 
-	sh = skb_header_pointer(skb, protoff, sizeof(_sh), &_sh);
+	sh = skb_header_pointer(skb, par->thoff, sizeof(_sh), &_sh);
 	if (sh == NULL) {
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
@@ -144,8 +142,8 @@ sctp_mt(const struct sk_buff *skb, const struct net_device *in,
 		&& SCCHECK(ntohs(sh->dest) >= info->dpts[0]
 			&& ntohs(sh->dest) <= info->dpts[1],
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
-		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
-					info, hotdrop),
+		&& SCCHECK(match_packet(skb, par->thoff + sizeof(sctp_sctphdr_t),
+					info, par->hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index ac9db17..02a8fed 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -86,14 +86,7 @@ extract_icmp_fields(const struct sk_buff *skb,
 
 
 static bool
-socket_mt(const struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  const struct xt_match *match,
-	  const void *matchinfo,
-	  int offset,
-	  unsigned int protoff,
-	  bool *hotdrop)
+socket_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	struct udphdr _hdr, *hp = NULL;
@@ -146,7 +139,7 @@ socket_mt(const struct sk_buff *skb,
 #endif
 
 	sk = nf_tproxy_get_sock_v4(dev_net(skb->dev), protocol,
-				   saddr, daddr, sport, dport, in, false);
+				   saddr, daddr, sport, dport, par->in, false);
 	if (sk != NULL) {
 		bool wildcard = (inet_sk(sk)->rcv_saddr == 0);
 
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index f92f8bc..29f5a8a 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -21,12 +21,9 @@ MODULE_ALIAS("ipt_state");
 MODULE_ALIAS("ip6t_state");
 
 static bool
-state_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+state_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_state_info *sinfo = matchinfo;
+	const struct xt_state_info *sinfo = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index f41a923..dcadc49 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -25,12 +25,9 @@ MODULE_ALIAS("ip6t_statistic");
 static DEFINE_SPINLOCK(nth_lock);
 
 static bool
-statistic_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+statistic_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
+	struct xt_statistic_info *info = (void *)par->matchinfo;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
 
 	switch (info->mode) {
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 18d8884..33f2d29 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -22,18 +22,15 @@ MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
 
 static bool
-string_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+string_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_string_info *conf = matchinfo;
+	const struct xt_string_info *conf = par->matchinfo;
 	struct ts_state state;
 	int invert;
 
 	memset(&state, 0, sizeof(struct ts_state));
 
-	invert = (match->revision == 0 ? conf->u.v0.invert :
+	invert = (par->match->revision == 0 ? conf->u.v0.invert :
 				    conf->u.v1.flags & XT_STRING_FLAG_INVERT);
 
 	return (skb_find_text((struct sk_buff *)skb, conf->from_offset,
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 4791c7c..4809b34 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -25,12 +25,9 @@ MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
 
 static bool
-tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+tcpmss_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_tcpmss_match_info *info = matchinfo;
+	const struct xt_tcpmss_match_info *info = par->matchinfo;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
@@ -39,7 +36,7 @@ tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
 	unsigned int i, optlen;
 
 	/* If we don't have the whole header, drop packet. */
-	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
+	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		goto dropit;
 
@@ -52,7 +49,7 @@ tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
 		goto out;
 
 	/* Truncated options. */
-	op = skb_header_pointer(skb, protoff + sizeof(*th), optlen, _opt);
+	op = skb_header_pointer(skb, par->thoff + sizeof(*th), optlen, _opt);
 	if (op == NULL)
 		goto dropit;
 
@@ -76,7 +73,7 @@ out:
 	return info->invert;
 
 dropit:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 5a6268c..66cf71b 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -68,25 +68,22 @@ tcp_find_option(u_int8_t option,
 	return invert;
 }
 
-static bool
-tcp_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool tcp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
-	const struct xt_tcp *tcpinfo = matchinfo;
+	const struct xt_tcp *tcpinfo = par->matchinfo;
 
-	if (offset) {
+	if (par->fragoff != 0) {
 		/* To quote Alan:
 
 		   Don't allow a fragment of TCP 8 bytes in. Nobody normal
 		   causes this. Its a cracker trying to break in by doing a
 		   flag overwrite to pass the direction checks.
 		*/
-		if (offset == 1) {
+		if (par->fragoff == 1) {
 			duprintf("Dropping evil TCP offset=1 frag.\n");
-			*hotdrop = true;
+			*par->hotdrop = true;
 		}
 		/* Must not be a fragment. */
 		return false;
@@ -94,12 +91,12 @@ tcp_mt(const struct sk_buff *skb, const struct net_device *in,
 
 #define FWINVTCP(bool, invflg) ((bool) ^ !!(tcpinfo->invflags & (invflg)))
 
-	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
+	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
 	if (th == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
@@ -117,13 +114,13 @@ tcp_mt(const struct sk_buff *skb, const struct net_device *in,
 		return false;
 	if (tcpinfo->option) {
 		if (th->doff * 4 < sizeof(_tcph)) {
-			*hotdrop = true;
+			*par->hotdrop = true;
 			return false;
 		}
-		if (!tcp_find_option(tcpinfo->option, skb, protoff,
+		if (!tcp_find_option(tcpinfo->option, skb, par->thoff,
 				     th->doff*4 - sizeof(_tcph),
 				     tcpinfo->invflags & XT_TCP_INV_OPTION,
-				     hotdrop))
+				     par->hotdrop))
 			return false;
 	}
 	return true;
@@ -141,25 +138,22 @@ tcp_mt_check(const char *tablename, const void *info,
 	return !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
 }
 
-static bool
-udp_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool udp_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
 	const struct udphdr *uh;
 	struct udphdr _udph;
-	const struct xt_udp *udpinfo = matchinfo;
+	const struct xt_udp *udpinfo = par->matchinfo;
 
 	/* Must not be a fragment. */
-	if (offset)
+	if (par->fragoff != 0)
 		return false;
 
-	uh = skb_header_pointer(skb, protoff, sizeof(_udph), &_udph);
+	uh = skb_header_pointer(skb, par->thoff, sizeof(_udph), &_udph);
 	if (uh == NULL) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
-		*hotdrop = true;
+		*par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 32d4c76..28599d3 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -153,11 +153,9 @@ static void localtime_3(struct xtm *r, time_t time)
 }
 
 static bool
-time_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+time_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_time_info *info = matchinfo;
+	const struct xt_time_info *info = par->matchinfo;
 	unsigned int packet_time;
 	struct xtm current_time;
 	s64 stamp;
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index a6b971d..24a5276 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -87,12 +87,9 @@ static bool u32_match_it(const struct xt_u32 *data,
 	return true;
 }
 
-static bool
-u32_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool u32_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 {
-	const struct xt_u32 *data = matchinfo;
+	const struct xt_u32 *data = par->matchinfo;
 	bool ret;
 
 	ret = u32_match_it(data, skb);
-- 
1.6.0.1

