From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/16] [NETFILTER]: Move extension arguments into compound structure (2/6)
Date: Sat,  4 Oct 2008 15:41:23 -0400
Message-ID: <15280747e4f4194e9c4fbba335b1d8e9dc3e5e94.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34317 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYJDTlg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:36 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch does this for match extensions' checkentry functions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h   |   32 ++++++++++++++++++++---------
 net/bridge/netfilter/ebt_802_3.c     |    7 +----
 net/bridge/netfilter/ebt_among.c     |    9 ++-----
 net/bridge/netfilter/ebt_arp.c       |    9 ++-----
 net/bridge/netfilter/ebt_ip.c        |    9 ++-----
 net/bridge/netfilter/ebt_ip6.c       |    9 ++-----
 net/bridge/netfilter/ebt_limit.c     |    7 +----
 net/bridge/netfilter/ebt_mark_m.c    |    7 +----
 net/bridge/netfilter/ebt_pkttype.c   |    7 +----
 net/bridge/netfilter/ebt_stp.c       |    9 ++-----
 net/bridge/netfilter/ebt_vlan.c      |    9 ++-----
 net/bridge/netfilter/ebtables.c      |   11 +++++++--
 net/ipv4/netfilter/ip_tables.c       |   26 +++++++++++------------
 net/ipv4/netfilter/ipt_addrtype.c    |   13 +++++------
 net/ipv4/netfilter/ipt_ah.c          |    8 +-----
 net/ipv4/netfilter/ipt_ecn.c         |    9 ++-----
 net/ipv6/netfilter/ip6_tables.c      |   25 +++++++++++------------
 net/ipv6/netfilter/ip6t_ah.c         |    8 +-----
 net/ipv6/netfilter/ip6t_frag.c       |    8 +-----
 net/ipv6/netfilter/ip6t_hbh.c        |    8 +-----
 net/ipv6/netfilter/ip6t_ipv6header.c |    7 +----
 net/ipv6/netfilter/ip6t_mh.c         |    8 +-----
 net/ipv6/netfilter/ip6t_rt.c         |    8 +-----
 net/netfilter/x_tables.c             |   32 ++++++++++++++--------------
 net/netfilter/xt_connbytes.c         |   14 ++++--------
 net/netfilter/xt_connlimit.c         |   13 ++++-------
 net/netfilter/xt_connmark.c          |   20 ++++++------------
 net/netfilter/xt_conntrack.c         |    9 ++-----
 net/netfilter/xt_dccp.c              |    7 +----
 net/netfilter/xt_dscp.c              |   11 +++------
 net/netfilter/xt_esp.c               |    8 +-----
 net/netfilter/xt_hashlimit.c         |   24 ++++++++-------------
 net/netfilter/xt_helper.c            |   11 +++------
 net/netfilter/xt_limit.c             |    7 +----
 net/netfilter/xt_mark.c              |    7 +----
 net/netfilter/xt_multiport.c         |   37 +++++++++++-----------------------
 net/netfilter/xt_owner.c             |   14 +++---------
 net/netfilter/xt_physdev.c           |   13 ++++-------
 net/netfilter/xt_policy.c            |   15 +++++--------
 net/netfilter/xt_quota.c             |    7 +----
 net/netfilter/xt_rateest.c           |    8 +-----
 net/netfilter/xt_recent.c            |    7 +----
 net/netfilter/xt_sctp.c              |    7 +----
 net/netfilter/xt_state.c             |    9 ++-----
 net/netfilter/xt_statistic.c         |    7 +----
 net/netfilter/xt_string.c            |    9 ++-----
 net/netfilter/xt_tcpudp.c            |   16 +++-----------
 net/netfilter/xt_time.c              |    7 +----
 48 files changed, 213 insertions(+), 359 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c009d14..7282eaf 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -193,6 +193,25 @@ struct xt_match_param {
 	bool *hotdrop;
 };
 
+/**
+ * struct xt_mtchk_param - parameters for match extensions'
+ * checkentry functions
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
@@ -207,12 +226,7 @@ struct xt_match
 	bool (*match)(const struct sk_buff *skb, struct xt_match_param *);
 
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
@@ -341,10 +355,8 @@ extern void xt_unregister_match(struct xt_match *target);
 extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
-extern int xt_check_match(const struct xt_match *match, unsigned short family,
-			  unsigned int size, const char *table, unsigned int hook,
-			  unsigned short proto, int inv_proto,
-			  const void *entry, void *matchinfo);
+extern int xt_check_match(struct xt_mtchk_param *, u_int8_t family,
+			  unsigned int size, u_int8_t proto, bool inv_proto);
 extern int xt_check_target(const struct xt_target *target, unsigned short family,
 			   unsigned int size, const char *table, unsigned int hook,
 			   unsigned short proto, int inv_proto,
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 32e35ea..759d9b1 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -35,12 +35,9 @@ static bool ebt_802_3_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 9447523..fa7aa63 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -170,14 +170,11 @@ static bool ebt_among_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 8889798..0c11f3d 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -99,13 +99,10 @@ static bool ebt_arp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index cdf18fd..b3b9077 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -76,13 +76,10 @@ static bool ebt_ip_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 49f547f..805140d 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -89,13 +89,10 @@ static bool ebt_ip6_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index f7d6fc9..889d7d4 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -63,12 +63,9 @@ user2credits(u_int32_t user)
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
index fdba489..6cd1595 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -21,12 +21,9 @@ static bool ebt_mark_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 457b86c..a0a751d 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -20,12 +20,9 @@ ebt_pkttype_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index b67efc4..2238518 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -152,15 +152,12 @@ static bool ebt_stp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 9e64491..6912e3b 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -83,13 +83,10 @@ static bool ebt_vlan_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index df3b61e..c4c75db 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -330,6 +330,7 @@ static inline int
 ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
    const char *name, unsigned int hookmask, unsigned int *cnt)
 {
+	struct xt_mtchk_param par;
 	struct xt_match *match;
 	size_t left = ((char *)e + e->watchers_offset) - (char *)m;
 	int ret;
@@ -346,9 +347,13 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 		return -ENOENT;
 	m->u.match = match;
 
-	ret = xt_check_match(match, NFPROTO_BRIDGE, m->match_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
-	      e, m->data);
+	par.table     = name;
+	par.entryinfo = e;
+	par.match     = match;
+	par.matchinfo = m->data;
+	par.hook_mask = hookmask;
+	ret = xt_check_match(&par, NFPROTO_BRIDGE, m->match_size,
+	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(match->me);
 		return ret;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b0f17a6..c042144 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -619,16 +619,20 @@ check_match(struct ipt_entry_match *m, const char *name,
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
-			     name, hookmask, ip->proto,
-			     ip->invflags & IPT_INV_PROTO, ip, m->data);
+	ret = xt_check_match(&par, NFPROTO_IPV4, m->u.match_size - sizeof(*m),
+	      ip->proto, ip->invflags & IPT_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
+			 par.match->name);
 		return ret;
 	}
 	++*i;
@@ -2151,15 +2155,9 @@ static bool icmp_match(const struct sk_buff *skb, struct xt_match_param *par)
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
index 48a182a..c69a8ee 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -68,12 +68,9 @@ addrtype_mt_v1(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -82,14 +79,16 @@ addrtype_mt_checkentry_v1(const char *tablename, const void *ip_void,
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
index 85c0ef1..be44c16 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -61,13 +61,9 @@ static bool ah_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 0401753..070442c 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -85,13 +85,10 @@ static bool ecn_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ed755d8..36cf8de 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -645,16 +645,20 @@ static int check_match(struct ip6t_entry_match *m, const char *name,
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
-			     name, hookmask, ipv6->proto,
-			     ipv6->invflags & IP6T_INV_PROTO, ipv6, m->data);
+	ret = xt_check_match(&par, NFPROTO_IPV6, m->u.match_size - sizeof(*m),
+			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
+			 par.match->name);
 		return ret;
 	}
 	++*i;
@@ -2177,14 +2181,9 @@ static bool icmp6_match(const struct sk_buff *skb, struct xt_match_param *par)
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
index 737593c..ae2f5d2 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -90,13 +90,9 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index eebb1dc..b1a786e 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -106,13 +106,9 @@ static bool frag_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
index c7d8e74..85876ba 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -161,13 +161,9 @@ static bool hbh_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 7fba67c..63805a9 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -118,12 +118,9 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
index 34e50e8..5b8abf0 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -67,13 +67,9 @@ static bool mh_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
index 1747455..d49dfb3 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -186,13 +186,9 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index aeb3e43..6a372ee 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -321,39 +321,39 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
-int xt_check_match(const struct xt_match *match, unsigned short family,
-		   unsigned int size, const char *table, unsigned int hook_mask,
-		   unsigned short proto, int inv_proto, const void *entry,
-		   void *matchinfo)
+int xt_check_match(struct xt_mtchk_param *par, u_int8_t family,
+		   unsigned int size, u_int8_t proto, bool inv_proto)
 {
-	if (XT_ALIGN(match->matchsize) != size &&
-	    match->matchsize != -1) {
+	if (XT_ALIGN(par->match->matchsize) != size &&
+	    par->match->matchsize != -1) {
 		/*
 		 * ebt_among is exempt from centralized matchsize checking
 		 * because it uses a dynamic-size data set.
 		 */
 		printk("%s_tables: %s match: invalid size %Zu != %u\n",
-		       xt_prefix[family], match->name,
-		       XT_ALIGN(match->matchsize), size);
+		       xt_prefix[family], par->match->name,
+		       XT_ALIGN(par->match->matchsize), size);
 		return -EINVAL;
 	}
-	if (match->table && strcmp(match->table, table)) {
+	if (par->match->table != NULL &&
+	    strcmp(par->match->table, par->table) != 0) {
 		printk("%s_tables: %s match: only valid in %s table, not %s\n",
-		       xt_prefix[family], match->name, match->table, table);
+		       xt_prefix[family], par->match->name,
+		       par->match->table, par->table);
 		return -EINVAL;
 	}
-	if (match->hooks && (hook_mask & ~match->hooks) != 0) {
+	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
 		printk("%s_tables: %s match: bad hook_mask %u/%u\n",
-		       xt_prefix[family], match->name, hook_mask, match->hooks);
+		       xt_prefix[family], par->match->name,
+		       par->hook_mask, par->match->hooks);
 		return -EINVAL;
 	}
-	if (match->proto && (match->proto != proto || inv_proto)) {
+	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
 		printk("%s_tables: %s match: only valid for protocol %u\n",
-		       xt_prefix[family], match->name, match->proto);
+		       xt_prefix[family], par->match->name, par->match->proto);
 		return -EINVAL;
 	}
-	if (match->checkentry != NULL &&
-	    !match->checkentry(table, entry, match, matchinfo, hook_mask))
+	if (par->match->checkentry != NULL && !par->match->checkentry(par))
 		return -EINVAL;
 	return 0;
 }
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 1eda70b..9fb78d9 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -91,12 +91,9 @@ static bool connbytes_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -108,17 +105,16 @@ connbytes_mt_check(const char *tablename, const void *ip,
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
index 151336e..2b40ae1 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -220,24 +220,21 @@ static bool connlimit_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index a74ede8..559d522 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -60,33 +60,27 @@ connmark_mt_v0(const struct sk_buff *skb, struct xt_match_param *par)
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
index b12004b..294ace1 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -277,14 +277,11 @@ static bool conntrack_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 2a34eee..80d65b6 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -120,12 +120,9 @@ static bool dccp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 4e67f42..218b809 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -41,15 +41,12 @@ static bool dscp_mt6(const struct sk_buff *skb, struct xt_match_param *par)
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
 
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index d9a6126..fdf04b5 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -66,13 +66,9 @@ static bool esp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 6a06880..5208f9c 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -663,12 +663,9 @@ static bool hashlimit_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -697,8 +694,8 @@ hashlimit_mt_check_v0(const char *tablename, const void *inf,
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
@@ -709,12 +706,9 @@ hashlimit_mt_check_v0(const char *tablename, const void *inf,
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
@@ -728,7 +722,7 @@ hashlimit_mt_check(const char *tablename, const void *inf,
 		return false;
 	if (info->name[sizeof(info->name)-1] != '\0')
 		return false;
-	if (match->family == NFPROTO_IPV4) {
+	if (par->match->family == NFPROTO_IPV4) {
 		if (info->cfg.srcmask > 32 || info->cfg.dstmask > 32)
 			return false;
 	} else {
@@ -743,8 +737,8 @@ hashlimit_mt_check(const char *tablename, const void *inf,
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
index 56769da..3ce867e 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -53,16 +53,13 @@ static bool helper_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 376789f..9af09ba 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -91,12 +91,9 @@ user2credits(u_int32_t user)
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
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 463c0d3..88fe214 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -36,12 +36,9 @@ static bool mark_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index b4832ad..0d3c63d 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -157,50 +157,37 @@ check(u_int16_t proto,
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
index 45213c9..3e40d77 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -104,12 +104,9 @@ static bool owner_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -121,12 +118,9 @@ owner_mt_check_v0(const char *tablename, const void *ip,
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
index 06aa09c..072e8fd 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -90,12 +90,9 @@ match_outdev:
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
@@ -103,12 +100,12 @@ physdev_mt_check(const char *tablename, const void *ip,
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
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 6d55b76..64431c0 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -127,26 +127,23 @@ static bool policy_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 13c7c02..badb6b4 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -36,12 +36,9 @@ static bool quota_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index d273817..8244eb7 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -74,13 +74,9 @@ xt_rateest_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 9ff94e0..1cc5d71 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -279,12 +279,9 @@ out:
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
index 2f54bd6..07efd06 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -146,12 +146,9 @@ static bool sctp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index c69ecb0..be9cc8d 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -36,14 +36,11 @@ static bool state_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 6eea44d..34465ce 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -48,12 +48,9 @@ static bool statistic_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 4230e99..a53001b 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -39,12 +39,9 @@ static bool string_mt(const struct sk_buff *skb, struct xt_match_param *par)
 
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
 
@@ -55,7 +52,7 @@ string_mt_check(const char *tablename, const void *ip,
 		return false;
 	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
 		return false;
-	if (match->revision == 1) {
+	if (par->match->revision == 1) {
 		if (conf->u.v1.flags &
 		    ~(XT_STRING_FLAG_IGNORECASE | XT_STRING_FLAG_INVERT))
 			return false;
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 48138b3..9576d97 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -126,13 +126,9 @@ static bool tcp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
@@ -165,13 +161,9 @@ static bool udp_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
index 8987b8f..a550dae 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -215,12 +215,9 @@ static bool time_mt(const struct sk_buff *skb, struct xt_match_param *par)
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
-- 
1.6.0.1

