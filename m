From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/69]: ebtables: remove casts, use consts
Date: Wed, 30 Jan 2008 21:17:06 +0100 (MET)
Message-ID: <20080130201703.29874.6812.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60660 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbYA3URJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:09 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ebtables: remove casts, use consts

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b98625021b5c086ec97c2121eaf9f06873339d3e
tree d6d438e305b31a69c641d6461c30688ed2174501
parent 1b8b1c29feb7a42aceb8f62ea9378d492437acbe
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:21:54 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:13 +0100

 include/net/arp.h                   |    8 +++++---
 net/bridge/netfilter/ebt_802_3.c    |    6 +++---
 net/bridge/netfilter/ebt_among.c    |   24 +++++++++++++++---------
 net/bridge/netfilter/ebt_arp.c      |   13 ++++++++-----
 net/bridge/netfilter/ebt_arpreply.c |   13 ++++++++-----
 net/bridge/netfilter/ebt_dnat.c     |    4 ++--
 net/bridge/netfilter/ebt_ip.c       |   10 ++++++----
 net/bridge/netfilter/ebt_limit.c    |    2 +-
 net/bridge/netfilter/ebt_log.c      |   18 +++++++++++-------
 net/bridge/netfilter/ebt_mark.c     |    4 ++--
 net/bridge/netfilter/ebt_mark_m.c   |    4 ++--
 net/bridge/netfilter/ebt_pkttype.c  |    4 ++--
 net/bridge/netfilter/ebt_redirect.c |    4 ++--
 net/bridge/netfilter/ebt_snat.c     |    7 ++++---
 net/bridge/netfilter/ebt_stp.c      |   24 +++++++++++++-----------
 net/bridge/netfilter/ebt_ulog.c     |    4 ++--
 net/bridge/netfilter/ebt_vlan.c     |    7 ++++---
 net/ipv4/arp.c                      |    9 +++++----
 18 files changed, 95 insertions(+), 70 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index 752eb47..c236270 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -13,15 +13,17 @@ extern int	arp_find(unsigned char *haddr, struct sk_buff *skb);
 extern int	arp_ioctl(struct net *net, unsigned int cmd, void __user *arg);
 extern void     arp_send(int type, int ptype, __be32 dest_ip,
 			 struct net_device *dev, __be32 src_ip,
-			 unsigned char *dest_hw, unsigned char *src_hw, unsigned char *th);
+			 const unsigned char *dest_hw,
+			 const unsigned char *src_hw, const unsigned char *th);
 extern int	arp_bind_neighbour(struct dst_entry *dst);
 extern int	arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
 extern void	arp_ifdown(struct net_device *dev);
 
 extern struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 				  struct net_device *dev, __be32 src_ip,
-				  unsigned char *dest_hw, unsigned char *src_hw,
-				  unsigned char *target_hw);
+				  const unsigned char *dest_hw,
+				  const unsigned char *src_hw,
+				  const unsigned char *target_hw);
 extern void arp_xmit(struct sk_buff *skb);
 
 extern struct neigh_ops arp_broken_ops;
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 41a7807..ac1730b 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -15,8 +15,8 @@
 static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
 {
-	struct ebt_802_3_info *info = (struct ebt_802_3_info *)data;
-	struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
+	const struct ebt_802_3_info *info = data;
+	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
 	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
 
 	if (info->bitmask & EBT_802_3_SAP) {
@@ -40,7 +40,7 @@ static struct ebt_match filter_802_3;
 static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_802_3_info *info = (struct ebt_802_3_info *)data;
+	const struct ebt_802_3_info *info = data;
 
 	if (datalen < sizeof(struct ebt_802_3_info))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 6436d30..318157e 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -25,7 +25,7 @@ static int ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
 	const struct ebt_mac_wormhash_tuple *p;
 	int start, limit, i;
 	uint32_t cmp[2] = { 0, 0 };
-	int key = (const unsigned char) mac[5];
+	int key = ((const unsigned char *)mac)[5];
 
 	memcpy(((char *) cmp) + 2, mac, 6);
 	start = wh->table[key];
@@ -73,15 +73,18 @@ static int ebt_mac_wormhash_check_integrity(const struct ebt_mac_wormhash
 static int get_ip_dst(const struct sk_buff *skb, __be32 *addr)
 {
 	if (eth_hdr(skb)->h_proto == htons(ETH_P_IP)) {
-		struct iphdr _iph, *ih;
+		const struct iphdr *ih;
+		struct iphdr _iph;
 
 		ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 		if (ih == NULL)
 			return -1;
 		*addr = ih->daddr;
 	} else if (eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) {
-		struct arphdr _arph, *ah;
-		__be32 buf, *bp;
+		const struct arphdr *ah;
+		struct arphdr _arph;
+		const __be32 *bp;
+		__be32 buf;
 
 		ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 		if (ah == NULL ||
@@ -101,15 +104,18 @@ static int get_ip_dst(const struct sk_buff *skb, __be32 *addr)
 static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 {
 	if (eth_hdr(skb)->h_proto == htons(ETH_P_IP)) {
-		struct iphdr _iph, *ih;
+		const struct iphdr *ih;
+		struct iphdr _iph;
 
 		ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 		if (ih == NULL)
 			return -1;
 		*addr = ih->saddr;
 	} else if (eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) {
-		struct arphdr _arph, *ah;
-		__be32 buf, *bp;
+		const struct arphdr *ah;
+		struct arphdr _arph;
+		const __be32 *bp;
+		__be32 buf;
 
 		ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 		if (ah == NULL ||
@@ -130,7 +136,7 @@ static int ebt_filter_among(const struct sk_buff *skb,
 			    const struct net_device *out, const void *data,
 			    unsigned int datalen)
 {
-	struct ebt_among_info *info = (struct ebt_among_info *) data;
+	const struct ebt_among_info *info = data;
 	const char *dmac, *smac;
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	__be32 dip = 0, sip = 0;
@@ -175,7 +181,7 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 			   const struct ebt_entry *e, void *data,
 			   unsigned int datalen)
 {
-	struct ebt_among_info *info = (struct ebt_among_info *) data;
+	const struct ebt_among_info *info = data;
 	int expected_length = sizeof(struct ebt_among_info);
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	int err;
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 1814139..933433e 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -18,8 +18,9 @@
 static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
 {
-	struct ebt_arp_info *info = (struct ebt_arp_info *)data;
-	struct arphdr _arph, *ah;
+	const struct ebt_arp_info *info = data;
+	const struct arphdr *ah;
+	struct arphdr _arph;
 
 	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 	if (ah == NULL)
@@ -35,7 +36,8 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 		return EBT_NOMATCH;
 
 	if (info->bitmask & (EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_GRAT)) {
-		__be32 saddr, daddr, *sap, *dap;
+		const __be32 *sap, *dap;
+		__be32 saddr, daddr;
 
 		if (ah->ar_pln != sizeof(__be32) || ah->ar_pro != htons(ETH_P_IP))
 			return EBT_NOMATCH;
@@ -61,7 +63,8 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 	}
 
 	if (info->bitmask & (EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC)) {
-		unsigned char _mac[ETH_ALEN], *mp;
+		const unsigned char *mp;
+		unsigned char _mac[ETH_ALEN];
 		uint8_t verdict, i;
 
 		if (ah->ar_hln != ETH_ALEN || ah->ar_hrd != htons(ARPHRD_ETHER))
@@ -100,7 +103,7 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 static int ebt_arp_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_arp_info *info = (struct ebt_arp_info *)data;
+	const struct ebt_arp_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_arp_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 48a80e4..7b6a8c1 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -19,10 +19,13 @@ static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_arpreply_info *info = (struct ebt_arpreply_info *)data;
-	__be32 _sip, *siptr, _dip, *diptr;
-	struct arphdr _ah, *ap;
-	unsigned char _sha[ETH_ALEN], *shp;
+	struct ebt_arpreply_info *info = (void *)data;
+	const __be32 *siptr, *diptr;
+	__be32 _sip, _dip;
+	const struct arphdr *ap;
+	struct arphdr _ah;
+	const unsigned char *shp;
+	unsigned char _sha[ETH_ALEN];
 
 	ap = skb_header_pointer(skb, 0, sizeof(_ah), &_ah);
 	if (ap == NULL)
@@ -58,7 +61,7 @@ static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
 static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_arpreply_info *info = (struct ebt_arpreply_info *)data;
+	const struct ebt_arpreply_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_arpreply_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 74262e9..6ad9160 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -18,7 +18,7 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_nat_info *info = (struct ebt_nat_info *)data;
+	const struct ebt_nat_info *info = data;
 
 	if (skb_make_writable(skb, 0))
 		return NF_DROP;
@@ -30,7 +30,7 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_nat_info *info = (struct ebt_nat_info *)data;
+	const struct ebt_nat_info *info = data;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 69f7f0a..82934f9 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -28,9 +28,11 @@ static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const void *data,
    unsigned int datalen)
 {
-	struct ebt_ip_info *info = (struct ebt_ip_info *)data;
-	struct iphdr _iph, *ih;
-	struct tcpudphdr _ports, *pptr;
+	const struct ebt_ip_info *info = data;
+	const struct iphdr *ih;
+	struct iphdr _iph;
+	const struct tcpudphdr *pptr;
+	struct tcpudphdr _ports;
 
 	ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 	if (ih == NULL)
@@ -79,7 +81,7 @@ static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
 static int ebt_ip_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_ip_info *info = (struct ebt_ip_info *)data;
+	const struct ebt_ip_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_ip_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index d48fa5c..2eb5cb7 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -69,7 +69,7 @@ user2credits(u_int32_t user)
 static int ebt_limit_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_limit_info *info = (struct ebt_limit_info *)data;
+	struct ebt_limit_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_limit_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 3be9e98..40560d6 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,7 +24,7 @@ static DEFINE_SPINLOCK(ebt_log_lock);
 static int ebt_log_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_log_info *info = (struct ebt_log_info *)data;
+	struct ebt_log_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_log_info)))
 		return -EINVAL;
@@ -50,7 +50,7 @@ struct arppayload
 	unsigned char ip_dst[4];
 };
 
-static void print_MAC(unsigned char *p)
+static void print_MAC(const unsigned char *p)
 {
 	int i;
 
@@ -84,7 +84,8 @@ ebt_log_packet(unsigned int pf, unsigned int hooknum,
 
 	if ((bitmask & EBT_LOG_IP) && eth_hdr(skb)->h_proto ==
 	   htons(ETH_P_IP)){
-		struct iphdr _iph, *ih;
+		const struct iphdr *ih;
+		struct iphdr _iph;
 
 		ih = skb_header_pointer(skb, 0, sizeof(_iph), &_iph);
 		if (ih == NULL) {
@@ -99,7 +100,8 @@ ebt_log_packet(unsigned int pf, unsigned int hooknum,
 		    ih->protocol == IPPROTO_UDPLITE ||
 		    ih->protocol == IPPROTO_SCTP ||
 		    ih->protocol == IPPROTO_DCCP) {
-			struct tcpudphdr _ports, *pptr;
+			const struct tcpudphdr *pptr;
+			struct tcpudphdr _ports;
 
 			pptr = skb_header_pointer(skb, ih->ihl*4,
 						  sizeof(_ports), &_ports);
@@ -116,7 +118,8 @@ ebt_log_packet(unsigned int pf, unsigned int hooknum,
 	if ((bitmask & EBT_LOG_ARP) &&
 	    ((eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) ||
 	     (eth_hdr(skb)->h_proto == htons(ETH_P_RARP)))) {
-		struct arphdr _arph, *ah;
+		const struct arphdr *ah;
+		struct arphdr _arph;
 
 		ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 		if (ah == NULL) {
@@ -132,7 +135,8 @@ ebt_log_packet(unsigned int pf, unsigned int hooknum,
 		if (ah->ar_hrd == htons(1) &&
 		    ah->ar_hln == ETH_ALEN &&
 		    ah->ar_pln == sizeof(__be32)) {
-			struct arppayload _arpp, *ap;
+			const struct arppayload *ap;
+			struct arppayload _arpp;
 
 			ap = skb_header_pointer(skb, sizeof(_arph),
 						sizeof(_arpp), &_arpp);
@@ -160,7 +164,7 @@ static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_log_info *info = (struct ebt_log_info *)data;
+	const struct ebt_log_info *info = data;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 6cba543..6fe93df 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -21,7 +21,7 @@ static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)data;
+	const struct ebt_mark_t_info *info = data;
 	int action = info->target & -16;
 
 	if (action == MARK_SET_VALUE)
@@ -39,7 +39,7 @@ static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
 static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)data;
+	const struct ebt_mark_t_info *info = data;
 	int tmp;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_t_info)))
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 6b0d216..0acab09 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -16,7 +16,7 @@ static int ebt_filter_mark(const struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out, const void *data,
    unsigned int datalen)
 {
-	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *) data;
+	const struct ebt_mark_m_info *info = data;
 
 	if (info->bitmask & EBT_MARK_OR)
 		return !(!!(skb->mark & info->mask) ^ info->invert);
@@ -26,7 +26,7 @@ static int ebt_filter_mark(const struct sk_buff *skb,
 static int ebt_mark_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_mark_m_info *info = (struct ebt_mark_m_info *) data;
+	const struct ebt_mark_m_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_m_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 4fffd70..a15cf06 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -18,7 +18,7 @@ static int ebt_filter_pkttype(const struct sk_buff *skb,
    const void *data,
    unsigned int datalen)
 {
-	struct ebt_pkttype_info *info = (struct ebt_pkttype_info *)data;
+	const struct ebt_pkttype_info *info = data;
 
 	return (skb->pkt_type != info->pkt_type) ^ info->invert;
 }
@@ -26,7 +26,7 @@ static int ebt_filter_pkttype(const struct sk_buff *skb,
 static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_pkttype_info *info = (struct ebt_pkttype_info *)data;
+	const struct ebt_pkttype_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_pkttype_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 422cb83..c1f9ca2 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -19,7 +19,7 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_redirect_info *info = (struct ebt_redirect_info *)data;
+	const struct ebt_redirect_info *info = data;
 
 	if (skb_make_writable(skb, 0))
 		return NF_DROP;
@@ -36,7 +36,7 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
 static int ebt_target_redirect_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_redirect_info *info = (struct ebt_redirect_info *)data;
+	const struct ebt_redirect_info *info = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_redirect_info)))
 		return -EINVAL;
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 425ac92..6bc263c 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -20,7 +20,7 @@ static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
+	const struct ebt_nat_info *info = data;
 
 	if (skb_make_writable(skb, 0))
 		return NF_DROP;
@@ -28,7 +28,8 @@ static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
 	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
 	if (!(info->target & NAT_ARP_BIT) &&
 	    eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) {
-		struct arphdr _ah, *ap;
+		const struct arphdr *ap;
+		struct arphdr _ah;
 
 		ap = skb_header_pointer(skb, 0, sizeof(_ah), &_ah);
 		if (ap == NULL)
@@ -45,7 +46,7 @@ out:
 static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_nat_info *info = (struct ebt_nat_info *) data;
+	const struct ebt_nat_info *info = data;
 	int tmp;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_nat_info)))
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 31b7736..fe323c4 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -40,10 +40,10 @@ struct stp_config_pdu {
 #define NR16(p) (p[0] << 8 | p[1])
 #define NR32(p) ((p[0] << 24) | (p[1] << 16) | (p[2] << 8) | p[3])
 
-static int ebt_filter_config(struct ebt_stp_info *info,
-   struct stp_config_pdu *stpc)
+static int ebt_filter_config(const struct ebt_stp_info *info,
+   const struct stp_config_pdu *stpc)
 {
-	struct ebt_stp_config_info *c;
+	const struct ebt_stp_config_info *c;
 	uint16_t v16;
 	uint32_t v32;
 	int verdict, i;
@@ -122,9 +122,10 @@ static int ebt_filter_config(struct ebt_stp_info *info,
 static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out, const void *data, unsigned int datalen)
 {
-	struct ebt_stp_info *info = (struct ebt_stp_info *)data;
-	struct stp_header _stph, *sp;
-	uint8_t header[6] = {0x42, 0x42, 0x03, 0x00, 0x00, 0x00};
+	const struct ebt_stp_info *info = data;
+	const struct stp_header *sp;
+	struct stp_header _stph;
+	const uint8_t header[6] = {0x42, 0x42, 0x03, 0x00, 0x00, 0x00};
 
 	sp = skb_header_pointer(skb, 0, sizeof(_stph), &_stph);
 	if (sp == NULL)
@@ -140,7 +141,8 @@ static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in
 
 	if (sp->type == BPDU_TYPE_CONFIG &&
 	    info->bitmask & EBT_STP_CONFIG_MASK) {
-		struct stp_config_pdu _stpc, *st;
+		const struct stp_config_pdu *st;
+		struct stp_config_pdu _stpc;
 
 		st = skb_header_pointer(skb, sizeof(_stph),
 					sizeof(_stpc), &_stpc);
@@ -154,10 +156,10 @@ static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in
 static int ebt_stp_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_stp_info *info = (struct ebt_stp_info *)data;
-	int len = EBT_ALIGN(sizeof(struct ebt_stp_info));
-	uint8_t bridge_ula[6] = { 0x01, 0x80, 0xc2, 0x00, 0x00, 0x00 };
-	uint8_t msk[6] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	const struct ebt_stp_info *info = data;
+	const unsigned int len = EBT_ALIGN(sizeof(struct ebt_stp_info));
+	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
+	const uint8_t msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 8e7b00b..2015711 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -249,7 +249,7 @@ static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
    const struct net_device *in, const struct net_device *out,
    const void *data, unsigned int datalen)
 {
-	struct ebt_ulog_info *uloginfo = (struct ebt_ulog_info *)data;
+	const struct ebt_ulog_info *uloginfo = data;
 
 	ebt_ulog_packet(hooknr, skb, in, out, uloginfo, NULL);
 }
@@ -258,7 +258,7 @@ static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
 static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_ulog_info *uloginfo = (struct ebt_ulog_info *)data;
+	struct ebt_ulog_info *uloginfo = data;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_ulog_info)) ||
 	    uloginfo->nlgroup > 31)
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 0ddf749..097d067 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -46,8 +46,9 @@ ebt_filter_vlan(const struct sk_buff *skb,
 		const struct net_device *out,
 		const void *data, unsigned int datalen)
 {
-	struct ebt_vlan_info *info = (struct ebt_vlan_info *) data;
-	struct vlan_hdr _frame, *fp;
+	const struct ebt_vlan_info *info = data;
+	const struct vlan_hdr *fp;
+	struct vlan_hdr _frame;
 
 	unsigned short TCI;	/* Whole TCI, given from parsed frame */
 	unsigned short id;	/* VLAN ID, given from frame TCI */
@@ -91,7 +92,7 @@ ebt_check_vlan(const char *tablename,
 	       unsigned int hooknr,
 	       const struct ebt_entry *e, void *data, unsigned int datalen)
 {
-	struct ebt_vlan_info *info = (struct ebt_vlan_info *) data;
+	struct ebt_vlan_info *info = data;
 
 	/* Parameters buffer overflow check */
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_vlan_info))) {
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 5976c59..8e17f65 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -558,8 +558,9 @@ static inline int arp_fwd_proxy(struct in_device *in_dev, struct rtable *rt)
  */
 struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 			   struct net_device *dev, __be32 src_ip,
-			   unsigned char *dest_hw, unsigned char *src_hw,
-			   unsigned char *target_hw)
+			   const unsigned char *dest_hw,
+			   const unsigned char *src_hw,
+			   const unsigned char *target_hw)
 {
 	struct sk_buff *skb;
 	struct arphdr *arp;
@@ -672,8 +673,8 @@ void arp_xmit(struct sk_buff *skb)
  */
 void arp_send(int type, int ptype, __be32 dest_ip,
 	      struct net_device *dev, __be32 src_ip,
-	      unsigned char *dest_hw, unsigned char *src_hw,
-	      unsigned char *target_hw)
+	      const unsigned char *dest_hw, const unsigned char *src_hw,
+	      const unsigned char *target_hw)
 {
 	struct sk_buff *skb;
 
