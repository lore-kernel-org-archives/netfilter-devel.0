From: Jan Engelhardt <jengelh@medozas.de>
Subject: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Fri, 3 Oct 2008 18:52:39 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40834 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149AbYJCWwm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:52:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 95a2f80cf91504b19b9c4eb18464c22ed0d175ca
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Oct 3 19:05:19 2008 -0400

[NETFILTER]: Move extensions' arguments into compound structure (1/2)

The function signatures for Xtables extensions have grown over time.
It involves a lot of typing/replication, and also a bit of stack space
even if they are not used. Realize an NFWS2008 idea and pack them into
structs. The skb remains outside of the struct so gcc can continue to
apply its optimizations.

This patch does this for matches (only).

A few ambiguities have also been addressed. The "offset" parameter for
example has been renamed to "fragoff" (there are so many different
offsets already) and "protoff" to "thoff" (there is more than just one
protocol here, so clarify).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h   |   54 ++++++++++++++++------
 net/bridge/netfilter/ebt_802_3.c     |   14 ++----
 net/bridge/netfilter/ebt_among.c     |   16 ++----
 net/bridge/netfilter/ebt_arp.c       |   16 ++----
 net/bridge/netfilter/ebt_ip.c        |   16 ++----
 net/bridge/netfilter/ebt_ip6.c       |   16 ++----
 net/bridge/netfilter/ebt_limit.c     |   14 ++----
 net/bridge/netfilter/ebt_mark_m.c    |   14 ++----
 net/bridge/netfilter/ebt_pkttype.c   |   14 ++----
 net/bridge/netfilter/ebt_stp.c       |   16 ++----
 net/bridge/netfilter/ebt_vlan.c      |   16 ++----
 net/bridge/netfilter/ebtables.c      |   12 ++++-
 net/ipv4/netfilter/ip_tables.c       |   59 ++++++++++++------------
 net/ipv4/netfilter/ipt_addrtype.c    |   31 +++++--------
 net/ipv4/netfilter/ipt_ah.c          |   22 +++------
 net/ipv4/netfilter/ipt_ecn.c         |   18 ++-----
 net/ipv4/netfilter/ipt_ttl.c         |    7 +--
 net/ipv6/netfilter/ip6_tables.c      |   58 ++++++++++++------------
 net/ipv6/netfilter/ip6t_ah.c         |   19 ++-----
 net/ipv6/netfilter/ip6t_eui64.c      |   10 +---
 net/ipv6/netfilter/ip6t_frag.c       |   20 ++------
 net/ipv6/netfilter/ip6t_hbh.c        |   22 +++------
 net/ipv6/netfilter/ip6t_hl.c         |    7 +--
 net/ipv6/netfilter/ip6t_ipv6header.c |   14 ++----
 net/ipv6/netfilter/ip6t_mh.c         |   23 +++------
 net/ipv6/netfilter/ip6t_rt.c         |   19 ++-----
 net/netfilter/xt_comment.c           |    6 +--
 net/netfilter/xt_connbytes.c         |   22 +++------
 net/netfilter/xt_connlimit.c         |   31 +++++--------
 net/netfilter/xt_connmark.c          |   35 ++++----------
 net/netfilter/xt_conntrack.c         |   32 ++++--------
 net/netfilter/xt_dccp.c              |   24 ++++------
 net/netfilter/xt_dscp.c              |   42 +++++------------
 net/netfilter/xt_esp.c               |   21 +++------
 net/netfilter/xt_hashlimit.c         |   47 +++++++------------
 net/netfilter/xt_helper.c            |   19 ++-----
 net/netfilter/xt_iprange.c           |   23 ++-------
 net/netfilter/xt_length.c            |   16 ++-----
 net/netfilter/xt_limit.c             |   15 ++----
 net/netfilter/xt_mac.c               |    7 +--
 net/netfilter/xt_mark.c              |   22 ++------
 net/netfilter/xt_multiport.c         |   64 +++++++++-----------------
 net/netfilter/xt_owner.c             |   38 ++++-----------
 net/netfilter/xt_physdev.c           |   21 +++------
 net/netfilter/xt_pkttype.c           |   12 ++---
 net/netfilter/xt_policy.c            |   27 ++++-------
 net/netfilter/xt_quota.c             |   15 ++----
 net/netfilter/xt_rateest.c           |   20 ++------
 net/netfilter/xt_realm.c             |    8 +--
 net/netfilter/xt_recent.c            |   25 ++++------
 net/netfilter/xt_sctp.c              |   24 ++++------
 net/netfilter/xt_state.c             |   17 ++-----
 net/netfilter/xt_statistic.c         |   15 ++----
 net/netfilter/xt_string.c            |   19 ++-----
 net/netfilter/xt_tcpmss.c            |   14 ++----
 net/netfilter/xt_tcpudp.c            |   52 ++++++++-------------
 net/netfilter/xt_time.c              |   14 ++----
 net/netfilter/xt_u32.c               |    7 +--
 58 files changed, 466 insertions(+), 835 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 6989b22..6c6babd 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -173,6 +173,44 @@ struct xt_counters_info
 
 #include <linux/netdevice.h>
 
+/**
+ * struct xt_match_param - parameters for match functions
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
+/**
+ * struct xt_mtchk_param - parameters for match checkentry functions
+ *
+ * @table:	table the rule is tried to be inserted into
+ * @entryinfo:	the family-specific rule data
+ * 		(struct ipt_ip, ip6t_ip, arpt_arp, ebt_entry)
+ * @match:	struct xt_match through which this function was invoked
+ * @matchinfo:	per-match data
+ * @hook_mask:	via which hooks the new rule is reachable
+ */
+struct xt_mtchk_param {
+	const char *table;
+	const void *entryinfo;
+	const struct xt_match *match;
+	void *matchinfo;
+	unsigned int hook_mask;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -184,22 +222,10 @@ struct xt_match
 	/* Arguments changed since 2.6.9, as this must now handle
 	   non-linear skb, using skb_header_pointer and
 	   skb_ip_make_writable. */
-	bool (*match)(const struct sk_buff *skb,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const struct xt_match *match,
-		      const void *matchinfo,
-		      int offset,
-		      unsigned int protoff,
-		      bool *hotdrop);
+	bool (*match)(const struct sk_buff *skb, struct xt_match_param *);
 
 	/* Called when user tries to insert an entry of this type. */
-	/* Should return true or false. */
-	bool (*checkentry)(const char *tablename,
-			   const void *ip,
-			   const struct xt_match *match,
-			   void *matchinfo,
-			   unsigned int hook_mask);
+	bool (*checkentry)(struct xt_mtchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_match *match, void *matchinfo);
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 6fc2a59..759d9b1 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -12,12 +12,9 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_802_3.h>
 
-static bool
-ebt_802_3_mt(const struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, const struct xt_match *match,
-	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_802_3_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_802_3_info *info = data;
+	const struct ebt_802_3_info *info = par->matchinfo;
 	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
 	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
 
@@ -38,12 +35,9 @@ ebt_802_3_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_802_3_mt_check(const char *table, const void *entry,
-		   const struct xt_match *match, void *data,
-		   unsigned int hook_mask)
+static bool ebt_802_3_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_802_3_info *info = data;
+	const struct ebt_802_3_info *info = par->matchinfo;
 
 	if (info->bitmask & ~EBT_802_3_MASK || info->invflags & ~EBT_802_3_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 084559e..fa7aa63 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -127,12 +127,9 @@ static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 	return 0;
 }
 
-static bool
-ebt_among_mt(const struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, const struct xt_match *match,
-	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_among_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_among_info *info = data;
+	const struct ebt_among_info *info = par->matchinfo;
 	const char *dmac, *smac;
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	__be32 dip = 0, sip = 0;
@@ -173,14 +170,11 @@ ebt_among_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_among_mt_check(const char *table, const void *entry,
-		   const struct xt_match *match, void *data,
-		   unsigned int hook_mask)
+static bool ebt_among_mt_check(struct xt_mtchk_param *par)
 {
+	const struct ebt_among_info *info = par->matchinfo;
 	const struct ebt_entry_match *em =
-		container_of(data, const struct ebt_entry_match, data);
-	const struct ebt_among_info *info = data;
+		container_of(par->matchinfo, const struct ebt_entry_match, data);
 	int expected_length = sizeof(struct ebt_among_info);
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	int err;
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index a073dff..0c11f3d 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -15,12 +15,9 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_arp.h>
 
-static bool
-ebt_arp_mt(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const struct xt_match *match,
-	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_arp_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_arp_info *info = data;
+	const struct ebt_arp_info *info = par->matchinfo;
 	const struct arphdr *ah;
 	struct arphdr _arph;
 
@@ -102,13 +99,10 @@ ebt_arp_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_arp_mt_check(const char *table, const void *entry,
-		 const struct xt_match *match, void *data,
-		 unsigned int hook_mask)
+static bool ebt_arp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_arp_info *info = data;
-	const struct ebt_entry *e = entry;
+	const struct ebt_arp_info *info = par->matchinfo;
+	const struct ebt_entry *e = par->entryinfo;
 
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index b42c7ce..b3b9077 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -24,12 +24,9 @@ struct tcpudphdr {
 	__be16 dst;
 };
 
-static bool
-ebt_ip_mt(const struct sk_buff *skb, const struct net_device *in,
-	  const struct net_device *out, const struct xt_match *match,
-	  const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_ip_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_ip_info *info = data;
+	const struct ebt_ip_info *info = par->matchinfo;
 	const struct iphdr *ih;
 	struct iphdr _iph;
 	const struct tcpudphdr *pptr;
@@ -79,13 +76,10 @@ ebt_ip_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_ip_mt_check(const char *table, const void *entry,
-		const struct xt_match *match, void *data,
-		unsigned int hook_mask)
+static bool ebt_ip_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_ip_info *info = data;
-	const struct ebt_entry *e = entry;
+	const struct ebt_ip_info *info = par->matchinfo;
+	const struct ebt_entry *e = par->entryinfo;
 
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 7bd9831..805140d 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -27,12 +27,9 @@ struct tcpudphdr {
 	__be16 dst;
 };
 
-static bool
-ebt_ip6_mt(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const struct xt_match *match,
-	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_ip6_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_ip6_info *info = data;
+	const struct ebt_ip6_info *info = par->matchinfo;
 	const struct ipv6hdr *ih6;
 	struct ipv6hdr _ip6h;
 	const struct tcpudphdr *pptr;
@@ -92,13 +89,10 @@ ebt_ip6_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_ip6_mt_check(const char *table, const void *entry,
-		 const struct xt_match *match, void *data,
-		 unsigned int hook_mask)
+static bool ebt_ip6_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_entry *e = entry;
-	struct ebt_ip6_info *info = data;
+	const struct ebt_entry *e = par->entryinfo;
+	struct ebt_ip6_info *info = par->matchinfo;
 
 	if (e->ethproto != htons(ETH_P_IPV6) || e->invflags & EBT_IPROTO)
 		return false;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 58aaaa1..889d7d4 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -30,12 +30,9 @@ static DEFINE_SPINLOCK(limit_lock);
 
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
-static bool
-ebt_limit_mt(const struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, const struct xt_match *match,
-	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_limit_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	struct ebt_limit_info *info = (void *)data;
+	struct ebt_limit_info *info = (void *)par->matchinfo;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
@@ -66,12 +63,9 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / EBT_LIMIT_SCALE;
 }
 
-static bool
-ebt_limit_mt_check(const char *table, const void *e,
-		   const struct xt_match *match, void *data,
-		   unsigned int hook_mask)
+static bool ebt_limit_mt_check(struct xt_mtchk_param *par)
 {
-	struct ebt_limit_info *info = data;
+	struct ebt_limit_info *info = par->matchinfo;
 
 	/* Check for overflow. */
 	if (info->burst == 0 ||
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index aa6781c..6cd1595 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -12,24 +12,18 @@
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_m.h>
 
-static bool
-ebt_mark_mt(const struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, const struct xt_match *match,
-	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_mark_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_mark_m_info *info = data;
+	const struct ebt_mark_m_info *info = par->matchinfo;
 
 	if (info->bitmask & EBT_MARK_OR)
 		return !!(skb->mark & info->mask) ^ info->invert;
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool
-ebt_mark_mt_check(const char *table, const void *e,
-		  const struct xt_match *match, void *data,
-		  unsigned int hook_mask)
+static bool ebt_mark_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_mark_m_info *info = data;
+	const struct ebt_mark_m_info *info = par->matchinfo;
 
 	if (info->bitmask & ~EBT_MARK_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 1c04ce5..a0a751d 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -13,22 +13,16 @@
 #include <linux/netfilter_bridge/ebt_pkttype.h>
 
 static bool
-ebt_pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
-	       const struct net_device *out, const struct xt_match *match,
-	       const void *data, int offset, unsigned int protoff,
-	       bool *hotdrop)
+ebt_pkttype_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_pkttype_info *info = data;
+	const struct ebt_pkttype_info *info = par->matchinfo;
 
 	return (skb->pkt_type == info->pkt_type) ^ info->invert;
 }
 
-static bool
-ebt_pkttype_mt_check(const char *table, const void *e,
-		     const struct xt_match *match, void *data,
-		     unsigned int hook_mask)
+static bool ebt_pkttype_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_pkttype_info *info = data;
+	const struct ebt_pkttype_info *info = par->matchinfo;
 
 	if (info->invert != 0 && info->invert != 1)
 		return false;
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 28bb48b..2238518 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -119,12 +119,9 @@ static bool ebt_filter_config(const struct ebt_stp_info *info,
 	return true;
 }
 
-static bool
-ebt_stp_mt(const struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, const struct xt_match *match,
-	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_stp_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_stp_info *info = data;
+	const struct ebt_stp_info *info = par->matchinfo;
 	const struct stp_header *sp;
 	struct stp_header _stph;
 	const uint8_t header[6] = {0x42, 0x42, 0x03, 0x00, 0x00, 0x00};
@@ -155,15 +152,12 @@ ebt_stp_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_stp_mt_check(const char *table, const void *entry,
-		 const struct xt_match *match, void *data,
-		 unsigned int hook_mask)
+static bool ebt_stp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ebt_stp_info *info = data;
+	const struct ebt_stp_info *info = par->matchinfo;
 	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
 	const uint8_t msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	const struct ebt_entry *e = entry;
+	const struct ebt_entry *e = par->entryinfo;
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 5addef6..6912e3b 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -40,12 +40,9 @@ MODULE_LICENSE("GPL");
 #define GET_BITMASK(_BIT_MASK_) info->bitmask & _BIT_MASK_
 #define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return false; }
 
-static bool
-ebt_vlan_mt(const struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, const struct xt_match *match,
-	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
+static bool ebt_vlan_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ebt_vlan_info *info = data;
+	const struct ebt_vlan_info *info = par->matchinfo;
 	const struct vlan_hdr *fp;
 	struct vlan_hdr _frame;
 
@@ -86,13 +83,10 @@ ebt_vlan_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-ebt_vlan_mt_check(const char *table, const void *entry,
-		  const struct xt_match *match, void *data,
-		  unsigned int hook_mask)
+static bool ebt_vlan_mt_check(struct xt_mtchk_param *par)
 {
-	struct ebt_vlan_info *info = data;
-	const struct ebt_entry *e = entry;
+	struct ebt_vlan_info *info = par->matchinfo;
+	const struct ebt_entry *e = par->entryinfo;
 
 	/* Is it 802.1Q frame checked? */
 	if (e->ethproto != htons(ETH_P_8021Q)) {
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index e3c0f37..2e6c0d2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -76,8 +76,16 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
    const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, bool *hotdrop)
 {
-	return m->u.match->match(skb, in, out, m->u.match,
-	       m->data, 0, 0, hotdrop);
+	struct xt_match_param par = {
+		.in        = in,
+		.out       = out,
+		.match     = m->u.match,
+		.matchinfo = m->data,
+		.fragoff   = 0, /* Ethernet does not have such */
+		.thoff     = 0, /* not looking for L4 proto by default */
+		.hotdrop   = hotdrop,
+	};
+	return m->u.match->match(skb, &par);
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4e7c719..aea16a4 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -193,9 +193,18 @@ do_match(struct ipt_entry_match *m,
 	      int offset,
 	      bool *hotdrop)
 {
+	struct xt_match_param par = {
+		.in        = in,
+		.out       = out,
+		.match     = m->u.kernel.match,
+		.matchinfo = m->data,
+		.fragoff   = offset,
+		.thoff     = ip_hdrlen(skb),
+		.hotdrop   = hotdrop,
+	};
+
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, ip_hdrlen(skb), hotdrop))
+	if (!par.match->match(skb, &par))
 		return true;
 	else
 		return false;
@@ -610,18 +619,22 @@ check_match(struct ipt_entry_match *m, const char *name,
 			      const struct ipt_ip *ip,
 			      unsigned int hookmask, unsigned int *i)
 {
-	struct xt_match *match;
+	struct xt_mtchk_param par = {
+		.table     = name,
+		.entryinfo = ip,
+		.match     = m->u.kernel.match,
+		.matchinfo = m->data,
+		.hook_mask = hookmask,
+	};
 	int ret;
 
-	match = m->u.kernel.match;
-	ret = xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
+	ret = xt_check_match(par.match, AF_INET, m->u.match_size - sizeof(*m),
 			     name, hookmask, ip->proto,
 			     ip->invflags & IPT_INV_PROTO);
-	if (!ret && m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
-					      hookmask)) {
+	if (!ret && par.match->checkentry != NULL &&
+	    !par.match->checkentry(&par)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
+			 par.match->name);
 		ret = -EINVAL;
 	}
 	if (!ret)
@@ -2120,31 +2133,23 @@ icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 		^ invert;
 }
 
-static bool
-icmp_match(const struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
-	   const struct xt_match *match,
-	   const void *matchinfo,
-	   int offset,
-	   unsigned int protoff,
-	   bool *hotdrop)
+static bool icmp_match(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -2155,15 +2160,9 @@ icmp_match(const struct sk_buff *skb,
 				    !!(icmpinfo->invflags&IPT_ICMP_INV));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-icmp_checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+static bool icmp_checkentry(struct xt_mtchk_param *par)
 {
-	const struct ipt_icmp *icmpinfo = matchinfo;
+	const struct ipt_icmp *icmpinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
 	return !(icmpinfo->invflags & ~IPT_ICMP_INV);
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 2c9d88a..c69a8ee 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -30,12 +30,9 @@ static inline bool match_type(const struct net_device *dev, __be32 addr,
 }
 
 static bool
-addrtype_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-	       const struct net_device *out, const struct xt_match *match,
-	       const void *matchinfo, int offset, unsigned int protoff,
-	       bool *hotdrop)
+addrtype_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
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
+addrtype_mt_v1(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -74,12 +68,9 @@ addrtype_mt_v1(const struct sk_buff *skb, const struct net_device *in,
 	return ret;
 }
 
-static bool
-addrtype_mt_checkentry_v1(const char *tablename, const void *ip_void,
-			  const struct xt_match *match, void *matchinfo,
-			  unsigned int hook_mask)
+static bool addrtype_mt_checkentry_v1(struct xt_mtchk_param *par)
 {
-	struct ipt_addrtype_info_v1 *info = matchinfo;
+	struct ipt_addrtype_info_v1 *info = par->matchinfo;
 
 	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN &&
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
@@ -88,14 +79,16 @@ addrtype_mt_checkentry_v1(const char *tablename, const void *ip_void,
 		return false;
 	}
 
-	if (hook_mask & (1 << NF_INET_PRE_ROUTING | 1 << NF_INET_LOCAL_IN) &&
+	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
+	    (1 << NF_INET_LOCAL_IN)) &&
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_OUT) {
 		printk(KERN_ERR "ipt_addrtype: output interface limitation "
 				"not valid in PRE_ROUTING and INPUT\n");
 		return false;
 	}
 
-	if (hook_mask & (1 << NF_INET_POST_ROUTING | 1 << NF_INET_LOCAL_OUT) &&
+	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
+	    (1 << NF_INET_LOCAL_OUT)) &&
 	    info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
 		printk(KERN_ERR "ipt_addrtype: input interface limitation "
 				"not valid in POST_ROUTING and OUTPUT\n");
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index e2e993e..be44c16 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -36,27 +36,23 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool
-ah_mt(const struct sk_buff *skb, const struct net_device *in,
-      const struct net_device *out, const struct xt_match *match,
-      const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ah_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -65,13 +61,9 @@ ah_mt(const struct sk_buff *skb, const struct net_device *in,
 			 !!(ahinfo->invflags & IPT_AH_INV_SPI));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-ah_mt_check(const char *tablename, const void *ip_void,
-            const struct xt_match *match, void *matchinfo,
-            unsigned int hook_mask)
+static bool ah_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ipt_ah *ahinfo = matchinfo;
+	const struct ipt_ah *ahinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
 	if (ahinfo->invflags & ~IPT_AH_INV_MASK) {
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 2c45b4b..070442c 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -67,12 +67,9 @@ static inline bool match_tcp(const struct sk_buff *skb,
 	return true;
 }
 
-static bool
-ecn_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ecn_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ipt_ecn_info *info = matchinfo;
+	const struct ipt_ecn_info *info = par->matchinfo;
 
 	if (info->operation & IPT_ECN_OP_MATCH_IP)
 		if (!match_ip(skb, info))
@@ -81,20 +78,17 @@ ecn_mt(const struct sk_buff *skb, const struct net_device *in,
 	if (info->operation & (IPT_ECN_OP_MATCH_ECE|IPT_ECN_OP_MATCH_CWR)) {
 		if (ip_hdr(skb)->protocol != IPPROTO_TCP)
 			return false;
-		if (!match_tcp(skb, info, hotdrop))
+		if (!match_tcp(skb, info, par->hotdrop))
 			return false;
 	}
 
 	return true;
 }
 
-static bool
-ecn_mt_check(const char *tablename, const void *ip_void,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool ecn_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ipt_ecn_info *info = matchinfo;
-	const struct ipt_ip *ip = ip_void;
+	const struct ipt_ecn_info *info = par->matchinfo;
+	const struct ipt_ip *ip = par->entryinfo;
 
 	if (info->operation & IPT_ECN_OP_MATCH_MASK)
 		return false;
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index d4c3fdc..0f089e7 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -18,12 +18,9 @@ MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: IPv4 TTL field match");
 MODULE_LICENSE("GPL");
 
-static bool
-ttl_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ttl_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ipt_ttl_info *info = matchinfo;
+	const struct ipt_ttl_info *info = par->matchinfo;
 	const u8 ttl = ip_hdr(skb)->ttl;
 
 	switch (info->mode) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0b4557e..1b3dacb 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -223,9 +223,18 @@ do_match(struct ip6t_entry_match *m,
 	      unsigned int protoff,
 	      bool *hotdrop)
 {
+	struct xt_match_param par = {
+		.in        = in,
+		.out       = out,
+		.match     = m->u.kernel.match,
+		.matchinfo = m->data,
+		.fragoff   = offset,
+		.thoff     = protoff,
+		.hotdrop   = hotdrop,
+	};
+
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->u.kernel.match, m->data,
-				      offset, protoff, hotdrop))
+	if (!m->u.kernel.match->match(skb, &par))
 		return true;
 	else
 		return false;
@@ -636,18 +645,22 @@ static int check_match(struct ip6t_entry_match *m, const char *name,
 			      const struct ip6t_ip6 *ipv6,
 			      unsigned int hookmask, unsigned int *i)
 {
-	struct xt_match *match;
+	struct xt_mtchk_param par = {
+		.table     = name,
+		.entryinfo = ipv6,
+		.match     = m->u.kernel.match,
+		.matchinfo = m->data,
+		.hook_mask = hookmask,
+	};
 	int ret;
 
-	match = m->u.kernel.match;
-	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
+	ret = xt_check_match(par.match, AF_INET6, m->u.match_size - sizeof(*m),
 			     name, hookmask, ipv6->proto,
 			     ipv6->invflags & IP6T_INV_PROTO);
-	if (!ret && m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, match, m->data,
-					      hookmask)) {
+	if (!ret && par.match->checkentry != NULL &&
+	    !par.match->checkentry(&par)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
+			 par.match->name);
 		ret = -EINVAL;
 	}
 	if (!ret)
@@ -2145,31 +2158,23 @@ icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 		^ invert;
 }
 
-static bool
-icmp6_match(const struct sk_buff *skb,
-	   const struct net_device *in,
-	   const struct net_device *out,
-	   const struct xt_match *match,
-	   const void *matchinfo,
-	   int offset,
-	   unsigned int protoff,
-	   bool *hotdrop)
+static bool icmp6_match(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -2181,14 +2186,9 @@ icmp6_match(const struct sk_buff *skb,
 }
 
 /* Called when user tries to insert an entry of this type. */
-static bool
-icmp6_checkentry(const char *tablename,
-	   const void *entry,
-	   const struct xt_match *match,
-	   void *matchinfo,
-	   unsigned int hook_mask)
+static bool icmp6_checkentry(struct xt_mtchk_param *par)
 {
-	const struct ip6t_icmp *icmpinfo = matchinfo;
+	const struct ip6t_icmp *icmpinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
 	return !(icmpinfo->invflags & ~IP6T_ICMP_INV);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 061f89b..ae2f5d2 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -36,14 +36,11 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool
-ah_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool ah_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -93,13 +90,9 @@ ah_mt6(const struct sk_buff *skb, const struct net_device *in,
 	       !(ahinfo->hdrres && ah->reserved);
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-ah_mt6_check(const char *tablename, const void *entry,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool ah_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_ah *ahinfo = matchinfo;
+	const struct ip6t_ah *ahinfo = par->matchinfo;
 
 	if (ahinfo->invflags & ~IP6T_AH_INV_MASK) {
 		pr_debug("ip6t_ah: unknown flags %X\n", ahinfo->invflags);
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index ba38df1..fc40fc2 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -19,19 +19,15 @@ MODULE_DESCRIPTION("Xtables: IPv6 EUI64 address match");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
-static bool
-eui64_mt6(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool eui64_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
index 972f699..b1a786e 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -34,28 +34,24 @@ id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 	return r;
 }
 
-static bool
-frag_mt6(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool frag_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -110,13 +106,9 @@ frag_mt6(const struct sk_buff *skb, const struct net_device *in,
 		 && (ntohs(fh->frag_off) & IP6_MF));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-frag_mt6_check(const char *tablename, const void *ip,
-               const struct xt_match *match, void *matchinfo,
-               unsigned int hook_mask)
+static bool frag_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_frag *fraginfo = matchinfo;
+	const struct ip6t_frag *fraginfo = par->matchinfo;
 
 	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
 		pr_debug("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 85ff370..85876ba 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -41,15 +41,11 @@ MODULE_ALIAS("ip6t_dst");
  *	5	-> RTALERT 2 x x
  */
 
-static bool
-hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff,
-        bool *hotdrop)
+static bool hbh_mt6(const struct sk_buff *skb, struct xt_match_param *par)
 {
 	struct ipv6_opt_hdr _optsh;
 	const struct ipv6_opt_hdr *oh;
-	const struct ip6t_opts *optinfo = matchinfo;
+	const struct ip6t_opts *optinfo = par->matchinfo;
 	unsigned int temp;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
@@ -61,16 +57,16 @@ hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
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
 
@@ -165,13 +161,9 @@ hbh_mt6(const struct sk_buff *skb, const struct net_device *in,
 	return false;
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-hbh_mt6_check(const char *tablename, const void *entry,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+static bool hbh_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_opts *optsinfo = matchinfo;
+	const struct ip6t_opts *optsinfo = par->matchinfo;
 
 	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
 		pr_debug("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index 25c1eb9..5e89353 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -19,12 +19,9 @@ MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
 MODULE_DESCRIPTION("Xtables: IPv6 Hop Limit field match");
 MODULE_LICENSE("GPL");
 
-static bool
-hl_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool hl_mt6(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ip6t_hl_info *info = matchinfo;
+	const struct ip6t_hl_info *info = par->matchinfo;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
 
 	switch (info->mode) {
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index ef0661a..63805a9 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -27,12 +27,9 @@ MODULE_DESCRIPTION("Xtables: IPv6 header types match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 static bool
-ipv6header_mt6(const struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, const struct xt_match *match,
-               const void *matchinfo, int offset, unsigned int protoff,
-               bool *hotdrop)
+ipv6header_mt6(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ip6t_ipv6header_info *info = matchinfo;
+	const struct ip6t_ipv6header_info *info = par->matchinfo;
 	unsigned int temp;
 	int len;
 	u8 nexthdr;
@@ -121,12 +118,9 @@ ipv6header_mt6(const struct sk_buff *skb, const struct net_device *in,
 	}
 }
 
-static bool
-ipv6header_mt6_check(const char *tablename, const void *ip,
-                     const struct xt_match *match, void *matchinfo,
-                     unsigned int hook_mask)
+static bool ipv6header_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_ipv6header_info *info = matchinfo;
+	const struct ip6t_ipv6header_info *info = par->matchinfo;
 
 	/* invflags is 0 or 0xff in hard mode */
 	if ((!info->modeflag) && info->invflags != 0x00 &&
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index dd87627..5b8abf0 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -37,32 +37,29 @@ type_match(u_int8_t min, u_int8_t max, u_int8_t type, bool invert)
 	return (type >= min && type <= max) ^ invert;
 }
 
-static bool
-mh_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool mh_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -70,13 +67,9 @@ mh_mt6(const struct sk_buff *skb, const struct net_device *in,
 			  !!(mhinfo->invflags & IP6T_MH_INV_TYPE));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-mh_mt6_check(const char *tablename, const void *entry,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool mh_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_mh *mhinfo = matchinfo;
+	const struct ip6t_mh *mhinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
 	return !(mhinfo->invflags & ~IP6T_MH_INV_MASK);
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 7c544ae..d49dfb3 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -36,14 +36,11 @@ segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 	return r;
 }
 
-static bool
-rt_mt6(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool rt_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -189,13 +186,9 @@ rt_mt6(const struct sk_buff *skb, const struct net_device *in,
 	return false;
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-rt_mt6_check(const char *tablename, const void *entry,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool rt_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_rt *rtinfo = matchinfo;
+	const struct ip6t_rt *rtinfo = par->matchinfo;
 
 	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
 		pr_debug("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index fa211b2..0de1207 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -15,11 +15,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_comment");
 MODULE_ALIAS("ip6t_comment");
 
-static bool
-comment_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protooff,
-           bool *hotdrop)
+static bool comment_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
 	/* We always match */
 	return true;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index d2cd22a..9fb78d9 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -16,13 +16,9 @@ MODULE_DESCRIPTION("Xtables: Number of packets/bytes per connection matching");
 MODULE_ALIAS("ipt_connbytes");
 MODULE_ALIAS("ip6t_connbytes");
 
-static bool
-connbytes_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool connbytes_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_connbytes_info *sinfo = matchinfo;
+	const struct xt_connbytes_info *sinfo = par->matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int64_t what = 0;	/* initialize to make gcc happy */
@@ -95,12 +91,9 @@ connbytes_mt(const struct sk_buff *skb, const struct net_device *in,
 		return what >= sinfo->count.from;
 }
 
-static bool
-connbytes_mt_check(const char *tablename, const void *ip,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool connbytes_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_connbytes_info *sinfo = matchinfo;
+	const struct xt_connbytes_info *sinfo = par->matchinfo;
 
 	if (sinfo->what != XT_CONNBYTES_PKTS &&
 	    sinfo->what != XT_CONNBYTES_BYTES &&
@@ -112,17 +105,16 @@ connbytes_mt_check(const char *tablename, const void *ip,
 	    sinfo->direction != XT_CONNBYTES_DIR_BOTH)
 		return false;
 
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", match->family);
+				    "proto=%u\n", par->match->family);
 		return false;
 	}
 
 	return true;
 }
 
-static void
-connbytes_mt_destroy(const struct xt_match *match, void *matchinfo)
+static void connbytes_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
 	nf_ct_l3proto_module_put(match->family);
 }
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index bd00830..2b40ae1 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -177,13 +177,9 @@ static int count_them(struct xt_connlimit_data *data,
 	return matches;
 }
 
-static bool
-connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool connlimit_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_connlimit_info *info = matchinfo;
+	const struct xt_connlimit_info *info = par->matchinfo;
 	union nf_inet_addr addr;
 	struct nf_conntrack_tuple tuple;
 	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
@@ -195,10 +191,10 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
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
@@ -208,40 +204,37 @@ connlimit_mt(const struct sk_buff *skb, const struct net_device *in,
 
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
 
-static bool
-connlimit_mt_check(const char *tablename, const void *ip,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool connlimit_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_connlimit_info *info = matchinfo;
+	struct xt_connlimit_info *info = par->matchinfo;
 	unsigned int i;
 
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "address family %u\n", match->family);
+		       "address family %u\n", par->match->family);
 		return false;
 	}
 
 	/* init private data */
 	info->data = kmalloc(sizeof(struct xt_connlimit_data), GFP_KERNEL);
 	if (info->data == NULL) {
-		nf_ct_l3proto_module_put(match->family);
+		nf_ct_l3proto_module_put(par->match->family);
 		return false;
 	}
 
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 0577b8f..559d522 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -33,13 +33,9 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
-static bool
-connmark_mt(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+static bool connmark_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_connmark_mtinfo1 *info = matchinfo;
+	const struct xt_connmark_mtinfo1 *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 
@@ -51,12 +47,9 @@ connmark_mt(const struct sk_buff *skb, const struct net_device *in,
 }
 
 static bool
-connmark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, const struct xt_match *match,
-               const void *matchinfo, int offset, unsigned int protoff,
-               bool *hotdrop)
+connmark_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_connmark_info *info = matchinfo;
+	const struct xt_connmark_info *info = par->matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 
@@ -67,33 +60,27 @@ connmark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool
-connmark_mt_check_v0(const char *tablename, const void *ip,
-                     const struct xt_match *match, void *matchinfo,
-                     unsigned int hook_mask)
+static bool connmark_mt_check_v0(struct xt_mtchk_param *par)
 {
-	const struct xt_connmark_info *cm = matchinfo;
+	const struct xt_connmark_info *cm = par->matchinfo;
 
 	if (cm->mark > 0xffffffff || cm->mask > 0xffffffff) {
 		printk(KERN_WARNING "connmark: only support 32bit mark\n");
 		return false;
 	}
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", match->family);
+				    "proto=%u\n", par->match->family);
 		return false;
 	}
 	return true;
 }
 
-static bool
-connmark_mt_check(const char *tablename, const void *ip,
-                  const struct xt_match *match, void *matchinfo,
-                  unsigned int hook_mask)
+static bool connmark_mt_check(struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", match->family);
+		       "proto=%u\n", par->match->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index 392b457..294ace1 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -25,12 +25,9 @@ MODULE_ALIAS("ipt_conntrack");
 MODULE_ALIAS("ip6t_conntrack");
 
 static bool
-conntrack_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                const struct net_device *out, const struct xt_match *match,
-                const void *matchinfo, int offset, unsigned int protoff,
-                bool *hotdrop)
+conntrack_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_conntrack_info *sinfo = matchinfo;
+	const struct xt_conntrack_info *sinfo = par->matchinfo;
 	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
@@ -204,13 +201,9 @@ ct_proto_port_check(const struct xt_conntrack_mtinfo1 *info,
 	return true;
 }
 
-static bool
-conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool conntrack_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_conntrack_mtinfo1 *info = matchinfo;
+	const struct xt_conntrack_mtinfo1 *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	unsigned int statebit;
@@ -244,22 +237,22 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
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
 
@@ -284,14 +277,11 @@ conntrack_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-conntrack_mt_check(const char *tablename, const void *ip,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool conntrack_mt_check(struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", match->family);
+				    "proto=%u\n", par->match->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 87971f4..80d65b6 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -92,21 +92,18 @@ match_option(u_int8_t option, const struct sk_buff *skb, unsigned int protoff,
 	return dccp_find_option(option, skb, protoff, dh, hotdrop);
 }
 
-static bool
-dccp_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool dccp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -118,17 +115,14 @@ dccp_mt(const struct sk_buff *skb, const struct net_device *in,
 			XT_DCCP_DEST_PORTS, info->flags, info->invflags)
 		&& DCCHECK(match_types(dh, info->typemask),
 			   XT_DCCP_TYPE, info->flags, info->invflags)
-		&& DCCHECK(match_option(info->option, skb, protoff, dh,
-					hotdrop),
+		&& DCCHECK(match_option(info->option, skb, par->thoff, dh,
+					par->hotdrop),
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 
-static bool
-dccp_mt_check(const char *tablename, const void *inf,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+static bool dccp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_dccp_info *info = matchinfo;
+	const struct xt_dccp_info *info = par->matchinfo;
 
 	return !(info->flags & ~XT_DCCP_VALID_FLAGS)
 		&& !(info->invflags & ~XT_DCCP_VALID_FLAGS)
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 7f03aa1..218b809 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -25,62 +25,46 @@ MODULE_ALIAS("ip6t_dscp");
 MODULE_ALIAS("ipt_tos");
 MODULE_ALIAS("ip6t_tos");
 
-static bool
-dscp_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool dscp_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_dscp_info *info = matchinfo;
+	const struct xt_dscp_info *info = par->matchinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static bool
-dscp_mt6(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool dscp_mt6(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_dscp_info *info = matchinfo;
+	const struct xt_dscp_info *info = par->matchinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	return (dscp == info->dscp) ^ !!info->invert;
 }
 
-static bool
-dscp_mt_check(const char *tablename, const void *info,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+static bool dscp_mt_check(struct xt_mtchk_param *par)
 {
-	const u_int8_t dscp = ((struct xt_dscp_info *)matchinfo)->dscp;
+	const struct xt_dscp_info *info = par->matchinfo;
 
-	if (dscp > XT_DSCP_MAX) {
-		printk(KERN_ERR "xt_dscp: dscp %x out of range\n", dscp);
+	if (info->dscp > XT_DSCP_MAX) {
+		printk(KERN_ERR "xt_dscp: dscp %x out of range\n", info->dscp);
 		return false;
 	}
 
 	return true;
 }
 
-static bool tos_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                      const struct net_device *out,
-                      const struct xt_match *match, const void *matchinfo,
-                      int offset, unsigned int protoff, bool *hotdrop)
+static bool tos_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ipt_tos_info *info = matchinfo;
+	const struct ipt_tos_info *info = par->matchinfo;
 
 	return (ip_hdr(skb)->tos == info->tos) ^ info->invert;
 }
 
-static bool tos_mt(const struct sk_buff *skb, const struct net_device *in,
-                   const struct net_device *out, const struct xt_match *match,
-                   const void *matchinfo, int offset, unsigned int protoff,
-                   bool *hotdrop)
+static bool tos_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_tos_match_info *info = matchinfo;
+	const struct xt_tos_match_info *info = par->matchinfo;
 
-	if (match->family == NFPROTO_IPV4)
+	if (par->match->family == NFPROTO_IPV4)
 		return ((ip_hdr(skb)->tos & info->tos_mask) ==
 		       info->tos_value) ^ !!info->invert;
 	else
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 045c4de..fdf04b5 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -42,26 +42,23 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool
-esp_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool esp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -69,13 +66,9 @@ esp_mt(const struct sk_buff *skb, const struct net_device *in,
 			 !!(espinfo->invflags & XT_ESP_INV_SPI));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-esp_mt_check(const char *tablename, const void *ip_void,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool esp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_esp *espinfo = matchinfo;
+	const struct xt_esp *espinfo = par->matchinfo;
 
 	if (espinfo->invflags & ~XT_ESP_INV_MASK) {
 		duprintf("xt_esp: unknown flags %X\n", espinfo->invflags);
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 7bae369..5208f9c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -563,19 +563,16 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 }
 
 static bool
-hashlimit_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                const struct net_device *out, const struct xt_match *match,
-                const void *matchinfo, int offset, unsigned int protoff,
-                bool *hotdrop)
+hashlimit_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -613,23 +610,19 @@ hashlimit_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	return false;
 
 hotdrop:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
-static bool
-hashlimit_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool hashlimit_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -666,16 +659,13 @@ hashlimit_mt(const struct sk_buff *skb, const struct net_device *in,
 	return info->cfg.mode & XT_HASHLIMIT_INVERT;
 
  hotdrop:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
-static bool
-hashlimit_mt_check_v0(const char *tablename, const void *inf,
-                      const struct xt_match *match, void *matchinfo,
-                      unsigned int hook_mask)
+static bool hashlimit_mt_check_v0(struct xt_mtchk_param *par)
 {
-	struct xt_hashlimit_info *r = matchinfo;
+	struct xt_hashlimit_info *r = par->matchinfo;
 
 	/* Check for overflow. */
 	if (r->cfg.burst == 0 ||
@@ -704,8 +694,8 @@ hashlimit_mt_check_v0(const char *tablename, const void *inf,
 	 * the list of htable's in htable_create(), since then we would
 	 * create duplicate proc files. -HW */
 	mutex_lock(&hlimit_mutex);
-	r->hinfo = htable_find_get(r->name, match->family);
-	if (!r->hinfo && htable_create_v0(r, match->family) != 0) {
+	r->hinfo = htable_find_get(r->name, par->match->family);
+	if (!r->hinfo && htable_create_v0(r, par->match->family) != 0) {
 		mutex_unlock(&hlimit_mutex);
 		return false;
 	}
@@ -716,12 +706,9 @@ hashlimit_mt_check_v0(const char *tablename, const void *inf,
 	return true;
 }
 
-static bool
-hashlimit_mt_check(const char *tablename, const void *inf,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool hashlimit_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_hashlimit_mtinfo1 *info = matchinfo;
+	struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 
 	/* Check for overflow. */
 	if (info->cfg.burst == 0 ||
@@ -735,7 +722,7 @@ hashlimit_mt_check(const char *tablename, const void *inf,
 		return false;
 	if (info->name[sizeof(info->name)-1] != '\0')
 		return false;
-	if (match->family == NFPROTO_IPV4) {
+	if (par->match->family == NFPROTO_IPV4) {
 		if (info->cfg.srcmask > 32 || info->cfg.dstmask > 32)
 			return false;
 	} else {
@@ -750,8 +737,8 @@ hashlimit_mt_check(const char *tablename, const void *inf,
 	 * the list of htable's in htable_create(), since then we would
 	 * create duplicate proc files. -HW */
 	mutex_lock(&hlimit_mutex);
-	info->hinfo = htable_find_get(info->name, match->family);
-	if (!info->hinfo && htable_create(info, match->family) != 0) {
+	info->hinfo = htable_find_get(info->name, par->match->family);
+	if (!info->hinfo && htable_create(info, par->match->family) != 0) {
 		mutex_unlock(&hlimit_mutex);
 		return false;
 	}
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 134d943..3ce867e 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -23,13 +23,9 @@ MODULE_ALIAS("ipt_helper");
 MODULE_ALIAS("ip6t_helper");
 
 
-static bool
-helper_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool helper_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_helper_info *info = matchinfo;
+	const struct xt_helper_info *info = par->matchinfo;
 	const struct nf_conn *ct;
 	const struct nf_conn_help *master_help;
 	const struct nf_conntrack_helper *helper;
@@ -57,16 +53,13 @@ helper_mt(const struct sk_buff *skb, const struct net_device *in,
 	return ret;
 }
 
-static bool
-helper_mt_check(const char *tablename, const void *inf,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
+static bool helper_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_helper_info *info = matchinfo;
+	struct xt_helper_info *info = par->matchinfo;
 
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", match->family);
+				    "proto=%u\n", par->match->family);
 		return false;
 	}
 	info->name[29] = '\0';
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index a7498cc..a3eac3b 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -17,12 +17,9 @@
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
 static bool
-iprange_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-              const struct net_device *out, const struct xt_match *match,
-              const void *matchinfo, int offset, unsigned int protoff,
-              bool *hotdrop)
+iprange_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ipt_iprange_info *info = matchinfo;
+	const struct ipt_iprange_info *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 
 	if (info->flags & IPRANGE_SRC) {
@@ -54,13 +51,9 @@ iprange_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-iprange_mt4(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+static bool iprange_mt4(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_iprange_mtinfo *info = matchinfo;
+	const struct xt_iprange_mtinfo *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
 	bool m;
 
@@ -110,13 +103,9 @@ iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
 	return 0;
 }
 
-static bool
-iprange_mt6(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+static bool iprange_mt6(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_iprange_mtinfo *info = matchinfo;
+	const struct xt_iprange_mtinfo *info = par->matchinfo;
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
 	bool m;
 
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index b8612d1..dca4682 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -20,25 +20,17 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
 
-static bool
-length_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool length_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_length_info *info = matchinfo;
+	const struct xt_length_info *info = par->matchinfo;
 	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
 
-static bool
-length_mt6(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+static bool length_mt6(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_length_info *info = matchinfo;
+	const struct xt_length_info *info = par->matchinfo;
 	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
 				 sizeof(struct ipv6hdr);
 
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 00247bd..9af09ba 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -57,14 +57,10 @@ static DEFINE_SPINLOCK(limit_lock);
 
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
-static bool
-limit_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool limit_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
 	struct xt_rateinfo *r =
-		((const struct xt_rateinfo *)matchinfo)->master;
+		((const struct xt_rateinfo *)par->matchinfo)->master;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
@@ -95,12 +91,9 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / XT_LIMIT_SCALE;
 }
 
-static bool
-limit_mt_check(const char *tablename, const void *inf,
-               const struct xt_match *match, void *matchinfo,
-               unsigned int hook_mask)
+static bool limit_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_rateinfo *r = matchinfo;
+	struct xt_rateinfo *r = par->matchinfo;
 
 	/* Check for overflow. */
 	if (r->burst == 0
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 60db240..045e0f4 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -24,12 +24,9 @@ MODULE_DESCRIPTION("Xtables: MAC address match");
 MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
-static bool
-mac_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool mac_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-    const struct xt_mac_info *info = matchinfo;
+    const struct xt_mac_info *info = par->matchinfo;
 
     /* Is mac pointer valid? */
     return skb_mac_header(skb) >= skb->head &&
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 96dd2b6..88fe214 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -22,33 +22,23 @@ MODULE_DESCRIPTION("Xtables: packet mark match");
 MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
-static bool
-mark_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+static bool mark_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_mark_info *info = matchinfo;
+	const struct xt_mark_info *info = par->matchinfo;
 
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool
-mark_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool mark_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_mark_mtinfo1 *info = matchinfo;
+	const struct xt_mark_mtinfo1 *info = par->matchinfo;
 
 	return ((skb->mark & info->mask) == info->mark) ^ info->invert;
 }
 
-static bool
-mark_mt_check_v0(const char *tablename, const void *entry,
-                 const struct xt_match *match, void *matchinfo,
-                 unsigned int hook_mask)
+static bool mark_mt_check_v0(struct xt_mtchk_param *par)
 {
-	const struct xt_mark_info *minfo = matchinfo;
+	const struct xt_mark_info *minfo = par->matchinfo;
 
 	if (minfo->mark > 0xffffffff || minfo->mask > 0xffffffff) {
 		printk(KERN_WARNING "mark: only supports 32bit mark\n");
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index f6fe008..0d3c63d 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -95,25 +95,22 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 }
 
 static bool
-multiport_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-                const struct net_device *out, const struct xt_match *match,
-                const void *matchinfo, int offset, unsigned int protoff,
-                bool *hotdrop)
+multiport_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -121,26 +118,22 @@ multiport_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	       multiinfo->count, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
-static bool
-multiport_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool multiport_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -164,50 +157,37 @@ check(u_int16_t proto,
 		&& count <= XT_MULTI_PORTS;
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-multiport_mt_check_v0(const char *tablename, const void *info,
-                      const struct xt_match *match, void *matchinfo,
-                      unsigned int hook_mask)
+static bool multiport_mt_check_v0(struct xt_mtchk_param *par)
 {
-	const struct ipt_ip *ip = info;
-	const struct xt_multiport *multiinfo = matchinfo;
+	const struct ipt_ip *ip = par->entryinfo;
+	const struct xt_multiport *multiinfo = par->matchinfo;
 
 	return check(ip->proto, ip->invflags, multiinfo->flags,
 		     multiinfo->count);
 }
 
-static bool
-multiport_mt_check(const char *tablename, const void *info,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool multiport_mt_check(struct xt_mtchk_param *par)
 {
-	const struct ipt_ip *ip = info;
-	const struct xt_multiport_v1 *multiinfo = matchinfo;
+	const struct ipt_ip *ip = par->entryinfo;
+	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
 	return check(ip->proto, ip->invflags, multiinfo->flags,
 		     multiinfo->count);
 }
 
-static bool
-multiport_mt6_check_v0(const char *tablename, const void *info,
-                       const struct xt_match *match, void *matchinfo,
-                       unsigned int hook_mask)
+static bool multiport_mt6_check_v0(struct xt_mtchk_param *par)
 {
-	const struct ip6t_ip6 *ip = info;
-	const struct xt_multiport *multiinfo = matchinfo;
+	const struct ip6t_ip6 *ip = par->entryinfo;
+	const struct xt_multiport *multiinfo = par->matchinfo;
 
 	return check(ip->proto, ip->invflags, multiinfo->flags,
 		     multiinfo->count);
 }
 
-static bool
-multiport_mt6_check(const char *tablename, const void *info,
-                    const struct xt_match *match, void *matchinfo,
-                    unsigned int hook_mask)
+static bool multiport_mt6_check(struct xt_mtchk_param *par)
 {
-	const struct ip6t_ip6 *ip = info;
-	const struct xt_multiport_v1 *multiinfo = matchinfo;
+	const struct ip6t_ip6 *ip = par->entryinfo;
+	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
 	return check(ip->proto, ip->invflags, multiinfo->flags,
 		     multiinfo->count);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index d1c3b7a..3e40d77 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -20,13 +20,9 @@
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv6/ip6t_owner.h>
 
-static bool
-owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, const struct xt_match *match,
-            const void *matchinfo, int offset, unsigned int protoff,
-            bool *hotdrop)
+static bool owner_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ipt_owner_info *info = matchinfo;
+	const struct ipt_owner_info *info = par->matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
@@ -49,13 +45,9 @@ owner_mt_v0(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool owner_mt6_v0(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct ip6t_owner_info *info = matchinfo;
+	const struct ip6t_owner_info *info = par->matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
@@ -78,13 +70,9 @@ owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-owner_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool owner_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_owner_match_info *info = matchinfo;
+	const struct xt_owner_match_info *info = par->matchinfo;
 	const struct file *filp;
 
 	if (skb->sk == NULL || skb->sk->sk_socket == NULL)
@@ -116,12 +104,9 @@ owner_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-owner_mt_check_v0(const char *tablename, const void *ip,
-                  const struct xt_match *match, void *matchinfo,
-                  unsigned int hook_mask)
+static bool owner_mt_check_v0(struct xt_mtchk_param *par)
 {
-	const struct ipt_owner_info *info = matchinfo;
+	const struct ipt_owner_info *info = par->matchinfo;
 
 	if (info->match & (IPT_OWNER_PID | IPT_OWNER_SID | IPT_OWNER_COMM)) {
 		printk(KERN_WARNING KBUILD_MODNAME
@@ -133,12 +118,9 @@ owner_mt_check_v0(const char *tablename, const void *ip,
 	return true;
 }
 
-static bool
-owner_mt6_check_v0(const char *tablename, const void *ip,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool owner_mt6_check_v0(struct xt_mtchk_param *par)
 {
-	const struct ip6t_owner_info *info = matchinfo;
+	const struct ip6t_owner_info *info = par->matchinfo;
 
 	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
 		printk(KERN_WARNING KBUILD_MODNAME
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 72a0bdd..072e8fd 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -20,15 +20,11 @@ MODULE_DESCRIPTION("Xtables: Bridge physical device match");
 MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
-static bool
-physdev_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+static bool physdev_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
 	int i;
 	static const char nulldevname[IFNAMSIZ];
-	const struct xt_physdev_info *info = matchinfo;
+	const struct xt_physdev_info *info = par->matchinfo;
 	bool ret;
 	const char *indev, *outdev;
 	const struct nf_bridge_info *nf_bridge;
@@ -94,12 +90,9 @@ match_outdev:
 	return ret ^ !(info->invert & XT_PHYSDEV_OP_OUT);
 }
 
-static bool
-physdev_mt_check(const char *tablename, const void *ip,
-                 const struct xt_match *match, void *matchinfo,
-                 unsigned int hook_mask)
+static bool physdev_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_physdev_info *info = matchinfo;
+	const struct xt_physdev_info *info = par->matchinfo;
 
 	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
 	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
@@ -107,12 +100,12 @@ physdev_mt_check(const char *tablename, const void *ip,
 	if (info->bitmask & XT_PHYSDEV_OP_OUT &&
 	    (!(info->bitmask & XT_PHYSDEV_OP_BRIDGED) ||
 	     info->invert & XT_PHYSDEV_OP_BRIDGED) &&
-	    hook_mask & ((1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_FORWARD) |
-			 (1 << NF_INET_POST_ROUTING))) {
+	    par->hook_mask & ((1 << NF_INET_LOCAL_OUT) |
+	    (1 << NF_INET_FORWARD) | (1 << NF_INET_POST_ROUTING))) {
 		printk(KERN_WARNING "physdev match: using --physdev-out in the "
 		       "OUTPUT, FORWARD and POSTROUTING chains for non-bridged "
 		       "traffic is not supported anymore.\n");
-		if (hook_mask & (1 << NF_INET_LOCAL_OUT))
+		if (par->hook_mask & (1 << NF_INET_LOCAL_OUT))
 			return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 81e86d3..046ed24 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -22,21 +22,17 @@ MODULE_DESCRIPTION("Xtables: link layer packet type match");
 MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
-static bool
-pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, const struct xt_match *match,
-           const void *matchinfo, int offset, unsigned int protoff,
-           bool *hotdrop)
+static bool pkttype_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index f1d514e..64431c0 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -109,19 +109,15 @@ match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
 	return strict ? i == info->len : 0;
 }
 
-static bool
-policy_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool policy_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -131,26 +127,23 @@ policy_mt(const struct sk_buff *skb, const struct net_device *in,
 	return ret;
 }
 
-static bool
-policy_mt_check(const char *tablename, const void *ip_void,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
+static bool policy_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_policy_info *info = matchinfo;
+	const struct xt_policy_info *info = par->matchinfo;
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "xt_policy: neither incoming nor "
 				"outgoing policy selected\n");
 		return false;
 	}
-	if (hook_mask & (1 << NF_INET_PRE_ROUTING | 1 << NF_INET_LOCAL_IN)
-	    && info->flags & XT_POLICY_MATCH_OUT) {
+	if (par->hook_mask & ((1 << NF_INET_PRE_ROUTING) |
+	    (1 << NF_INET_LOCAL_IN)) && info->flags & XT_POLICY_MATCH_OUT) {
 		printk(KERN_ERR "xt_policy: output policy not valid in "
 				"PRE_ROUTING and INPUT\n");
 		return false;
 	}
-	if (hook_mask & (1 << NF_INET_POST_ROUTING | 1 << NF_INET_LOCAL_OUT)
-	    && info->flags & XT_POLICY_MATCH_IN) {
+	if (par->hook_mask & ((1 << NF_INET_POST_ROUTING) |
+	    (1 << NF_INET_LOCAL_OUT)) && info->flags & XT_POLICY_MATCH_IN) {
 		printk(KERN_ERR "xt_policy: input policy not valid in "
 				"POST_ROUTING and OUTPUT\n");
 		return false;
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index a3c8798..badb6b4 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -17,14 +17,10 @@ MODULE_ALIAS("ip6t_quota");
 
 static DEFINE_SPINLOCK(quota_lock);
 
-static bool
-quota_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool quota_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
 	struct xt_quota_info *q =
-		((const struct xt_quota_info *)matchinfo)->master;
+		((const struct xt_quota_info *)par->matchinfo)->master;
 	bool ret = q->flags & XT_QUOTA_INVERT;
 
 	spin_lock_bh(&quota_lock);
@@ -40,12 +36,9 @@ quota_mt(const struct sk_buff *skb, const struct net_device *in,
 	return ret;
 }
 
-static bool
-quota_mt_check(const char *tablename, const void *entry,
-               const struct xt_match *match, void *matchinfo,
-               unsigned int hook_mask)
+static bool quota_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_quota_info *q = matchinfo;
+	struct xt_quota_info *q = par->matchinfo;
 
 	if (q->flags & ~XT_QUOTA_MASK)
 		return false;
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 4dcfd73..8244eb7 100644
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
+xt_rateest_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_rateest_match_info *info = matchinfo;
+	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est *r;
 	u_int32_t bps1, bps2, pps1, pps2;
 	bool ret = true;
@@ -80,13 +74,9 @@ static bool xt_rateest_mt(const struct sk_buff *skb,
 	return ret;
 }
 
-static bool xt_rateest_mt_checkentry(const char *tablename,
-				     const void *ip,
-				     const struct xt_match *match,
-				     void *matchinfo,
-				     unsigned int hook_mask)
+static bool xt_rateest_mt_checkentry(struct xt_mtchk_param *par)
 {
-	struct xt_rateest_match_info *info = matchinfo;
+	struct xt_rateest_match_info *info = par->matchinfo;
 	struct xt_rateest *est1, *est2;
 
 	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index ef65756..ad0f15a 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -21,13 +21,9 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Xtables: Routing realm match");
 MODULE_ALIAS("ipt_realm");
 
-static bool
-realm_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool realm_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_realm_info *info = matchinfo;
+	const struct xt_realm_info *info = par->matchinfo;
 	const struct dst_entry *dst = skb->dst;
 
 	return (info->id == (dst->tclassid & info->mask)) ^ info->invert;
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 4a916e2..1cc5d71 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -203,20 +203,16 @@ static void recent_table_flush(struct recent_table *t)
 			recent_entry_remove(t, e);
 }
 
-static bool
-recent_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool recent_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -237,19 +233,19 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
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
@@ -283,12 +279,9 @@ out:
 	return ret;
 }
 
-static bool
-recent_mt_check(const char *tablename, const void *ip,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
+static bool recent_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_recent_mtinfo *info = matchinfo;
+	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
 	unsigned i;
 	bool ret = false;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index ab67aca..07efd06 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -116,24 +116,21 @@ match_packet(const struct sk_buff *skb,
 	return false;
 }
 
-static bool
-sctp_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool sctp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -144,17 +141,14 @@ sctp_mt(const struct sk_buff *skb, const struct net_device *in,
 		&& SCCHECK(ntohs(sh->dest) >= info->dpts[0]
 			&& ntohs(sh->dest) <= info->dpts[1],
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
-		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
-					info, hotdrop),
+		&& SCCHECK(match_packet(skb, par->thoff + sizeof(sctp_sctphdr_t),
+					info, par->hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);
 }
 
-static bool
-sctp_mt_check(const char *tablename, const void *inf,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+static bool sctp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_sctp_info *info = matchinfo;
+	const struct xt_sctp_info *info = par->matchinfo;
 
 	return !(info->flags & ~XT_SCTP_VALID_FLAGS)
 		&& !(info->invflags & ~XT_SCTP_VALID_FLAGS)
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index f92f8bc..be9cc8d 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -20,13 +20,9 @@ MODULE_DESCRIPTION("ip[6]_tables connection tracking state match module");
 MODULE_ALIAS("ipt_state");
 MODULE_ALIAS("ip6t_state");
 
-static bool
-state_mt(const struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, const struct xt_match *match,
-         const void *matchinfo, int offset, unsigned int protoff,
-         bool *hotdrop)
+static bool state_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_state_info *sinfo = matchinfo;
+	const struct xt_state_info *sinfo = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
@@ -40,14 +36,11 @@ state_mt(const struct sk_buff *skb, const struct net_device *in,
 	return (sinfo->statemask & statebit);
 }
 
-static bool
-state_mt_check(const char *tablename, const void *inf,
-               const struct xt_match *match, void *matchinfo,
-               unsigned int hook_mask)
+static bool state_mt_check(struct xt_mtchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", match->family);
+				    "proto=%u\n", par->match->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index f41a923..34465ce 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -24,13 +24,9 @@ MODULE_ALIAS("ip6t_statistic");
 
 static DEFINE_SPINLOCK(nth_lock);
 
-static bool
-statistic_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *match,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+static bool statistic_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	struct xt_statistic_info *info = (struct xt_statistic_info *)matchinfo;
+	struct xt_statistic_info *info = (void *)par->matchinfo;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
 
 	switch (info->mode) {
@@ -52,12 +48,9 @@ statistic_mt(const struct sk_buff *skb, const struct net_device *in,
 	return ret;
 }
 
-static bool
-statistic_mt_check(const char *tablename, const void *entry,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+static bool statistic_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_statistic_info *info = matchinfo;
+	struct xt_statistic_info *info = par->matchinfo;
 
 	if (info->mode > XT_STATISTIC_MODE_MAX ||
 	    info->flags & ~XT_STATISTIC_MASK)
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 18d8884..a53001b 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -21,19 +21,15 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
 
-static bool
-string_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool string_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -43,12 +39,9 @@ string_mt(const struct sk_buff *skb, const struct net_device *in,
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *)(m))
 
-static bool
-string_mt_check(const char *tablename, const void *ip,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
+static bool string_mt_check(struct xt_mtchk_param *par)
 {
-	struct xt_string_info *conf = matchinfo;
+	struct xt_string_info *conf = par->matchinfo;
 	struct ts_config *ts_conf;
 	int flags = TS_AUTOLOAD;
 
@@ -59,7 +52,7 @@ string_mt_check(const char *tablename, const void *ip,
 		return false;
 	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
 		return false;
-	if (match->revision == 1) {
+	if (par->match->revision == 1) {
 		if (conf->u.v1.flags &
 		    ~(XT_STRING_FLAG_IGNORECASE | XT_STRING_FLAG_INVERT))
 			return false;
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 4791c7c..3483600 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -24,13 +24,9 @@ MODULE_DESCRIPTION("Xtables: TCP MSS match");
 MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
 
-static bool
-tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
+static bool tcpmss_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_tcpmss_match_info *info = matchinfo;
+	const struct xt_tcpmss_match_info *info = par->matchinfo;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
@@ -39,7 +35,7 @@ tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
 	unsigned int i, optlen;
 
 	/* If we don't have the whole header, drop packet. */
-	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
+	th = skb_header_pointer(skb, par->thoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		goto dropit;
 
@@ -52,7 +48,7 @@ tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
 		goto out;
 
 	/* Truncated options. */
-	op = skb_header_pointer(skb, protoff + sizeof(*th), optlen, _opt);
+	op = skb_header_pointer(skb, par->thoff + sizeof(*th), optlen, _opt);
 	if (op == NULL)
 		goto dropit;
 
@@ -76,7 +72,7 @@ out:
 	return info->invert;
 
 dropit:
-	*hotdrop = true;
+	*par->hotdrop = true;
 	return false;
 }
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 5a6268c..9576d97 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -68,25 +68,22 @@ tcp_find_option(u_int8_t option,
 	return invert;
 }
 
-static bool
-tcp_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool tcp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -117,49 +114,42 @@ tcp_mt(const struct sk_buff *skb, const struct net_device *in,
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
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-tcp_mt_check(const char *tablename, const void *info,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool tcp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_tcp *tcpinfo = matchinfo;
+	const struct xt_tcp *tcpinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
 	return !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
 }
 
-static bool
-udp_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool udp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
 
@@ -171,13 +161,9 @@ udp_mt(const struct sk_buff *skb, const struct net_device *in,
 			      !!(udpinfo->invflags & XT_UDP_INV_DSTPT));
 }
 
-/* Called when user tries to insert an entry of this type. */
-static bool
-udp_mt_check(const char *tablename, const void *info,
-             const struct xt_match *match, void *matchinfo,
-             unsigned int hook_mask)
+static bool udp_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_udp *udpinfo = matchinfo;
+	const struct xt_udp *udpinfo = par->matchinfo;
 
 	/* Must specify no unknown invflags */
 	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index b00452b..a550dae 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -150,12 +150,9 @@ static void localtime_3(struct xtm *r, time_t time)
 	return;
 }
 
-static bool
-time_mt(const struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, const struct xt_match *match,
-        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool time_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_time_info *info = matchinfo;
+	const struct xt_time_info *info = par->matchinfo;
 	unsigned int packet_time;
 	struct xtm current_time;
 	s64 stamp;
@@ -218,12 +215,9 @@ time_mt(const struct sk_buff *skb, const struct net_device *in,
 	return true;
 }
 
-static bool
-time_mt_check(const char *tablename, const void *ip,
-              const struct xt_match *match, void *matchinfo,
-              unsigned int hook_mask)
+static bool time_mt_check(struct xt_mtchk_param *par)
 {
-	const struct xt_time_info *info = matchinfo;
+	const struct xt_time_info *info = par->matchinfo;
 
 	if (info->daytime_start > XT_TIME_MAX_DAYTIME ||
 	    info->daytime_stop > XT_TIME_MAX_DAYTIME) {
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index a6b971d..2fdaae1 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -87,12 +87,9 @@ static bool u32_match_it(const struct xt_u32 *data,
 	return true;
 }
 
-static bool
-u32_mt(const struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, const struct xt_match *match,
-       const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
+static bool u32_mt(const struct sk_buff *skb, struct xt_match_param *par)
 {
-	const struct xt_u32 *data = matchinfo;
+	const struct xt_u32 *data = par->matchinfo;
 	bool ret;
 
 	ret = u32_match_it(data, skb);

