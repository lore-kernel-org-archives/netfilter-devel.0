From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/50]: Remove redundant parentheses/braces
Date: Sat,  7 Jul 2007 14:23:13 +0200 (MEST)
Message-ID: <20070707122229.1589.70872.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: Remove redundant parentheses/braces

Removes redundant parentheses and braces (And add one pair in a xt_tcpudp.c macro).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cb17d98047a9f0843ff4f04b2b563def0a154ea3
tree 8330a27c09bb586c29d255f5fb5f69dd18fcb099
parent 32b9ac8539a493fc11337b5d0a7623a24989aa6b
author Jan Engelhardt <jengelh@gmx.de> Sat, 07 Jul 2007 12:15:17 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:17 +0200

 net/ipv4/netfilter/ipt_CLUSTERIP.c   |   11 ++++-------
 net/ipv4/netfilter/ipt_ECN.c         |    4 ++--
 net/ipv4/netfilter/ipt_TTL.c         |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c        |    9 +++------
 net/ipv4/netfilter/ipt_iprange.c     |    8 ++++----
 net/ipv4/netfilter/ipt_recent.c      |    9 +++------
 net/ipv4/netfilter/ipt_ttl.c         |   12 ++++--------
 net/ipv6/netfilter/ip6t_HL.c         |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |   12 ++++++------
 net/ipv6/netfilter/ip6t_eui64.c      |    6 +++---
 net/ipv6/netfilter/ip6t_frag.c       |   18 +++++++++---------
 net/ipv6/netfilter/ip6t_hbh.c        |    2 +-
 net/ipv6/netfilter/ip6t_hl.c         |    8 ++++----
 net/ipv6/netfilter/ip6t_ipv6header.c |    6 +++---
 net/ipv6/netfilter/ip6t_owner.c      |    6 ++----
 net/ipv6/netfilter/ip6t_rt.c         |   16 ++++++++--------
 net/netfilter/xt_DSCP.c              |    2 +-
 net/netfilter/xt_TCPMSS.c            |    4 ++--
 net/netfilter/xt_connbytes.c         |    4 ++--
 net/netfilter/xt_connmark.c          |    2 +-
 net/netfilter/xt_dccp.c              |   10 +++++-----
 net/netfilter/xt_hashlimit.c         |    2 +-
 net/netfilter/xt_length.c            |    4 ++--
 net/netfilter/xt_mac.c               |   10 +++++-----
 net/netfilter/xt_pkttype.c           |    4 ++--
 net/netfilter/xt_sctp.c              |   23 +++++++++--------------
 net/netfilter/xt_tcpudp.c            |    2 +-
 28 files changed, 90 insertions(+), 110 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2de7ae0..5de13b4 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -122,9 +122,8 @@ __clusterip_config_find(__be32 clusterip)
 	list_for_each(pos, &clusterip_configs) {
 		struct clusterip_config *c = list_entry(pos,
 					struct clusterip_config, list);
-		if (c->clusterip == clusterip) {
+		if (c->clusterip == clusterip)
 			return c;
-		}
 	}
 
 	return NULL;
@@ -155,9 +154,8 @@ clusterip_config_init_nodelist(struct clusterip_config *c,
 {
 	int n;
 
-	for (n = 0; n < i->num_local_nodes; n++) {
+	for (n = 0; n < i->num_local_nodes; n++)
 		set_bit(i->local_nodes[n] - 1, &c->local_nodes);
-	}
 }
 
 static struct clusterip_config *
@@ -255,10 +253,9 @@ clusterip_hashfn(const struct sk_buff *skb,
 		dport = ports[1];
 		break;
 	default:
-		if (net_ratelimit()) {
+		if (net_ratelimit())
 			printk(KERN_NOTICE "CLUSTERIP: unknown protocol `%u'\n",
 				iph->protocol);
-		}
 		sport = dport = 0;
 	}
 
@@ -286,7 +283,7 @@ clusterip_hashfn(const struct sk_buff *skb,
 	}
 
 	/* node numbers are 1..n, not 0..n */
-	return ((hashval % config->num_total_nodes)+1);
+	return (hashval % config->num_total_nodes) + 1;
 }
 
 static inline int
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 0236701..a647c1d 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -58,8 +58,8 @@ set_ect_tcp(struct sk_buff **pskb, const struct ipt_ECN_info *einfo)
 
 	if ((!(einfo->operation & IPT_ECN_OP_SET_ECE) ||
 	     tcph->ece == einfo->proto.tcp.ece) &&
-	    ((!(einfo->operation & IPT_ECN_OP_SET_CWR) ||
-	     tcph->cwr == einfo->proto.tcp.cwr)))
+	    (!(einfo->operation & IPT_ECN_OP_SET_CWR) ||
+	     tcph->cwr == einfo->proto.tcp.cwr))
 		return true;
 
 	if (!skb_make_writable(pskb, ip_hdrlen(*pskb) + sizeof(*tcph)))
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index f53f2c4..737830b 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -75,7 +75,7 @@ static bool ipt_ttl_checkentry(const char *tablename,
 			info->mode);
 		return false;
 	}
-	if ((info->mode != IPT_TTL_SET) && (info->ttl == 0))
+	if (info->mode != IPT_TTL_SET && info->ttl == 0)
 		return false;
 	return true;
 }
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 282eb00..5b25ca6 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -179,12 +179,10 @@ static void ipt_ulog_packet(unsigned int hooknum,
 	unsigned int groupnum = ffs(loginfo->nl_group) - 1;
 
 	/* calculate the size of the skb needed */
-	if ((loginfo->copy_range == 0) ||
-	    (loginfo->copy_range > skb->len)) {
+	if (loginfo->copy_range == 0 || loginfo->copy_range > skb->len)
 		copy_len = skb->len;
-	} else {
+	else
 		copy_len = loginfo->copy_range;
-	}
 
 	size = NLMSG_SPACE(sizeof(*pm) + copy_len);
 
@@ -257,9 +255,8 @@ static void ipt_ulog_packet(unsigned int hooknum,
 		BUG();
 
 	/* check if we are building multi-part messages */
-	if (ub->qlen > 1) {
+	if (ub->qlen > 1)
 		ub->lastnlh->nlmsg_flags |= NLM_F_MULTI;
-	}
 
 	ub->lastnlh = nlh;
 
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index b266d98..854281c 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -35,8 +35,8 @@ match(const struct sk_buff *skb,
 	const struct iphdr *iph = ip_hdr(skb);
 
 	if (info->flags & IPRANGE_SRC) {
-		if (((ntohl(iph->saddr) < ntohl(info->src.min_ip))
-			  || (ntohl(iph->saddr) > ntohl(info->src.max_ip)))
+		if ((ntohl(iph->saddr) < ntohl(info->src.min_ip)
+			  || ntohl(iph->saddr) > ntohl(info->src.max_ip))
 			 ^ !!(info->flags & IPRANGE_SRC_INV)) {
 			DEBUGP("src IP %u.%u.%u.%u NOT in range %s"
 			       "%u.%u.%u.%u-%u.%u.%u.%u\n",
@@ -48,8 +48,8 @@ match(const struct sk_buff *skb,
 		}
 	}
 	if (info->flags & IPRANGE_DST) {
-		if (((ntohl(iph->daddr) < ntohl(info->dst.min_ip))
-			  || (ntohl(iph->daddr) > ntohl(info->dst.max_ip)))
+		if ((ntohl(iph->daddr) < ntohl(info->dst.min_ip)
+			  || ntohl(iph->daddr) > ntohl(info->dst.max_ip))
 			 ^ !!(info->flags & IPRANGE_DST_INV)) {
 			DEBUGP("dst IP %u.%u.%u.%u NOT in range %s"
 			       "%u.%u.%u.%u-%u.%u.%u.%u\n",
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index d03e6a6..68f7181 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -163,10 +163,9 @@ static void recent_table_flush(struct recent_table *t)
 	struct recent_entry *e, *next;
 	unsigned int i;
 
-	for (i = 0; i < ip_list_hash_size; i++) {
+	for (i = 0; i < ip_list_hash_size; i++)
 		list_for_each_entry_safe(e, next, &t->iphash[i], list)
 			recent_entry_remove(t, e);
-	}
 }
 
 static bool
@@ -329,12 +328,10 @@ static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
 
 	spin_lock_bh(&recent_lock);
 
-	for (st->bucket = 0; st->bucket < ip_list_hash_size; st->bucket++) {
-		list_for_each_entry(e, &t->iphash[st->bucket], list) {
+	for (st->bucket = 0; st->bucket < ip_list_hash_size; st->bucket++)
+		list_for_each_entry(e, &t->iphash[st->bucket], list)
 			if (p-- == 0)
 				return e;
-		}
-	}
 	return NULL;
 }
 
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index 82fe4ea..59a644d 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -28,17 +28,13 @@ static bool match(const struct sk_buff *skb,
 
 	switch (info->mode) {
 		case IPT_TTL_EQ:
-			return (ttl == info->ttl);
-			break;
+			return ttl == info->ttl;
 		case IPT_TTL_NE:
-			return (!(ttl == info->ttl));
-			break;
+			return ttl != info->ttl;
 		case IPT_TTL_LT:
-			return (ttl < info->ttl);
-			break;
+			return ttl < info->ttl;
 		case IPT_TTL_GT:
-			return (ttl > info->ttl);
-			break;
+			return ttl > info->ttl;
 		default:
 			printk(KERN_WARNING "ipt_ttl: unknown mode %d\n",
 				info->mode);
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 20047ff..33c4cb8 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -71,7 +71,7 @@ static bool ip6t_hl_checkentry(const char *tablename,
 			info->mode);
 		return false;
 	}
-	if ((info->mode != IP6T_HL_SET) && (info->hop_limit == 0)) {
+	if (info->mode != IP6T_HL_SET && info->hop_limit == 0) {
 		printk(KERN_WARNING "ip6t_HL: increment/decrement doesn't "
 			"make sense with value 0\n");
 		return false;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 4df07f0..0fa1f2c 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -69,7 +69,7 @@ static void send_reset(struct sk_buff *oldskb)
 	otcplen = oldskb->len - tcphoff;
 
 	/* IP header checks: fragment, too short. */
-	if ((proto != IPPROTO_TCP) || (otcplen < sizeof(struct tcphdr))) {
+	if (proto != IPPROTO_TCP || otcplen < sizeof(struct tcphdr)) {
 		DEBUGP("ip6t_REJECT: proto(%d) != IPPROTO_TCP, or too short. otcplen = %d\n",
 			proto, otcplen);
 		return;
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index b4b1d28..fbf3d77 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -78,9 +78,9 @@ match(const struct sk_buff *skb,
 	DEBUGP("SPI %u %08X\n", ntohl(ah->spi), ntohl(ah->spi));
 
 	DEBUGP("IPv6 AH spi %02X ",
-	       (spi_match(ahinfo->spis[0], ahinfo->spis[1],
-			  ntohl(ah->spi),
-			  !!(ahinfo->invflags & IP6T_AH_INV_SPI))));
+	       spi_match(ahinfo->spis[0], ahinfo->spis[1],
+			 ntohl(ah->spi),
+			 !!(ahinfo->invflags & IP6T_AH_INV_SPI)));
 	DEBUGP("len %02X %04X %02X ",
 	       ahinfo->hdrlen, hdrlen,
 	       (!ahinfo->hdrlen ||
@@ -92,9 +92,9 @@ match(const struct sk_buff *skb,
 
 	return (ah != NULL)
 	       &&
-	       (spi_match(ahinfo->spis[0], ahinfo->spis[1],
-			  ntohl(ah->spi),
-			  !!(ahinfo->invflags & IP6T_AH_INV_SPI)))
+	       spi_match(ahinfo->spis[0], ahinfo->spis[1],
+			 ntohl(ah->spi),
+			 !!(ahinfo->invflags & IP6T_AH_INV_SPI))
 	       &&
 	       (!ahinfo->hdrlen ||
 		(ahinfo->hdrlen == hdrlen) ^
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index bebb12a..2af99fc 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -33,7 +33,7 @@ match(const struct sk_buff *skb,
 	int i = 0;
 
 	if (!(skb_mac_header(skb) >= skb->head &&
-	      (skb_mac_header(skb) + ETH_HLEN) <= skb->data) &&
+	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
 	    offset != 0) {
 		*hotdrop = true;
 		return false;
@@ -50,8 +50,8 @@ match(const struct sk_buff *skb,
 			eui64[0] |= 0x02;
 
 			i = 0;
-			while ((ipv6_hdr(skb)->saddr.s6_addr[8 + i] == eui64[i])
-			       && (i < 8))
+			while (ipv6_hdr(skb)->saddr.s6_addr[8 + i] == eui64[i]
+			       && i < 8)
 				i++;
 
 			if (i == 8)
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index e0e416b..65482af 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -77,35 +77,35 @@ match(const struct sk_buff *skb,
 	       ntohl(fh->identification));
 
 	DEBUGP("IPv6 FRAG id %02X ",
-	       (id_match(fraginfo->ids[0], fraginfo->ids[1],
+	       id_match(fraginfo->ids[0], fraginfo->ids[1],
 			 ntohl(fh->identification),
-			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS))));
+			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)));
 	DEBUGP("res %02X %02X%04X %02X ",
-	       (fraginfo->flags & IP6T_FRAG_RES), fh->reserved,
+	       fraginfo->flags & IP6T_FRAG_RES, fh->reserved,
 	       ntohs(fh->frag_off) & 0x6,
 	       !((fraginfo->flags & IP6T_FRAG_RES)
 		 && (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
 	DEBUGP("first %02X %02X %02X ",
-	       (fraginfo->flags & IP6T_FRAG_FST),
+	       fraginfo->flags & IP6T_FRAG_FST,
 	       ntohs(fh->frag_off) & ~0x7,
 	       !((fraginfo->flags & IP6T_FRAG_FST)
 		 && (ntohs(fh->frag_off) & ~0x7)));
 	DEBUGP("mf %02X %02X %02X ",
-	       (fraginfo->flags & IP6T_FRAG_MF),
+	       fraginfo->flags & IP6T_FRAG_MF,
 	       ntohs(fh->frag_off) & IP6_MF,
 	       !((fraginfo->flags & IP6T_FRAG_MF)
 		 && !((ntohs(fh->frag_off) & IP6_MF))));
 	DEBUGP("last %02X %02X %02X\n",
-	       (fraginfo->flags & IP6T_FRAG_NMF),
+	       fraginfo->flags & IP6T_FRAG_NMF,
 	       ntohs(fh->frag_off) & IP6_MF,
 	       !((fraginfo->flags & IP6T_FRAG_NMF)
 		 && (ntohs(fh->frag_off) & IP6_MF)));
 
 	return (fh != NULL)
 	       &&
-	       (id_match(fraginfo->ids[0], fraginfo->ids[1],
-			 ntohl(fh->identification),
-			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)))
+	       id_match(fraginfo->ids[0], fraginfo->ids[1],
+			ntohl(fh->identification),
+			!!(fraginfo->invflags & IP6T_FRAG_INV_IDS))
 	       &&
 	       !((fraginfo->flags & IP6T_FRAG_RES)
 		 && (fh->reserved || (ntohs(fh->frag_off) & 0x6)))
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index bbd2615..8eecac1 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -160,7 +160,7 @@ match(const struct sk_buff *skb,
 			DEBUGP("len%04X \n", optlen);
 
 			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
-			    (temp < optinfo->optsnr - 1)) {
+			    temp < optinfo->optsnr - 1) {
 				DEBUGP("new pointer is too large! \n");
 				break;
 			}
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index b933e84..ddee088 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -29,16 +29,16 @@ static bool match(const struct sk_buff *skb,
 
 	switch (info->mode) {
 		case IP6T_HL_EQ:
-			return (ip6h->hop_limit == info->hop_limit);
+			return ip6h->hop_limit == info->hop_limit;
 			break;
 		case IP6T_HL_NE:
-			return (!(ip6h->hop_limit == info->hop_limit));
+			return ip6h->hop_limit != info->hop_limit;
 			break;
 		case IP6T_HL_LT:
-			return (ip6h->hop_limit < info->hop_limit);
+			return ip6h->hop_limit < info->hop_limit;
 			break;
 		case IP6T_HL_GT:
-			return (ip6h->hop_limit > info->hop_limit);
+			return ip6h->hop_limit > info->hop_limit;
 			break;
 		default:
 			printk(KERN_WARNING "ip6t_hl: unknown mode %d\n",
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 5ba6ef0..ca020ce 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -74,9 +74,9 @@ ipv6header_match(const struct sk_buff *skb,
 		BUG_ON(hp == NULL);
 
 		/* Calculate the header length */
-		if (nexthdr == NEXTHDR_FRAGMENT) {
+		if (nexthdr == NEXTHDR_FRAGMENT)
 			hdrlen = 8;
-		} else if (nexthdr == NEXTHDR_AUTH)
+		else if (nexthdr == NEXTHDR_AUTH)
 			hdrlen = (hp->hdrlen + 2) << 2;
 		else
 			hdrlen = ipv6_optlen(hp);
@@ -110,7 +110,7 @@ ipv6header_match(const struct sk_buff *skb,
 			break;
 	}
 
-	if ((nexthdr != NEXTHDR_NONE) && (nexthdr != NEXTHDR_ESP))
+	if (nexthdr != NEXTHDR_NONE && nexthdr != NEXTHDR_ESP)
 		temp |= MASK_PROTO;
 
 	if (info->modeflag)
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index 8cb6c94..d2bf320 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -38,17 +38,15 @@ match(const struct sk_buff *skb,
 	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
 		return false;
 
-	if (info->match & IP6T_OWNER_UID) {
+	if (info->match & IP6T_OWNER_UID)
 		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
 		    !!(info->invert & IP6T_OWNER_UID))
 			return false;
-	}
 
-	if (info->match & IP6T_OWNER_GID) {
+	if (info->match & IP6T_OWNER_GID)
 		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
 		    !!(info->invert & IP6T_OWNER_GID))
 			return false;
-	}
 
 	return true;
 }
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index bc5ff4b..f86fdcd 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -87,9 +87,9 @@ match(const struct sk_buff *skb,
 	DEBUGP("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
 
 	DEBUGP("IPv6 RT segsleft %02X ",
-	       (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-			       rh->segments_left,
-			       !!(rtinfo->invflags & IP6T_RT_INV_SGS))));
+	       segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+			      rh->segments_left,
+			      !!(rtinfo->invflags & IP6T_RT_INV_SGS)));
 	DEBUGP("type %02X %02X %02X ",
 	       rtinfo->rt_type, rh->type,
 	       (!(rtinfo->flags & IP6T_RT_TYP) ||
@@ -97,11 +97,11 @@ match(const struct sk_buff *skb,
 		 !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
 	DEBUGP("len %02X %04X %02X ",
 	       rtinfo->hdrlen, hdrlen,
-	       (!(rtinfo->flags & IP6T_RT_LEN) ||
+	       !(rtinfo->flags & IP6T_RT_LEN) ||
 		((rtinfo->hdrlen == hdrlen) ^
-		 !!(rtinfo->invflags & IP6T_RT_INV_LEN))));
+		 !!(rtinfo->invflags & IP6T_RT_INV_LEN)));
 	DEBUGP("res %02X %02X %02X ",
-	       (rtinfo->flags & IP6T_RT_RES),
+	       rtinfo->flags & IP6T_RT_RES,
 	       ((const struct rt0_hdr *)rh)->reserved,
 	       !((rtinfo->flags & IP6T_RT_RES) &&
 		 (((const struct rt0_hdr *)rh)->reserved)));
@@ -188,8 +188,8 @@ match(const struct sk_buff *skb,
 					break;
 			}
 			DEBUGP("temp=%d #%d\n", temp, rtinfo->addrnr);
-			if ((temp == rtinfo->addrnr) &&
-			    (temp == (unsigned int)((hdrlen - 8) / 16)))
+			if (temp == rtinfo->addrnr &&
+			    temp == (unsigned int)((hdrlen - 8) / 16))
 				return ret;
 			else
 				return false;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 2d779f6..ed6b524 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -74,7 +74,7 @@ static bool checkentry(const char *tablename,
 {
 	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
 
-	if ((dscp > XT_DSCP_MAX)) {
+	if (dscp > XT_DSCP_MAX) {
 		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
 		return false;
 	}
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 075051a..6ae6df9 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -93,7 +93,7 @@ tcpmss_mangle_packet(struct sk_buff **pskb,
 				return 0;
 
 			opt[i+2] = (newmss & 0xff00) >> 8;
-			opt[i+3] = (newmss & 0x00ff);
+			opt[i+3] = newmss & 0x00ff;
 
 			nf_proto_csum_replace2(&tcph->check, *pskb,
 					       htons(oldmss), htons(newmss), 0);
@@ -126,7 +126,7 @@ tcpmss_mangle_packet(struct sk_buff **pskb,
 	opt[0] = TCPOPT_MSS;
 	opt[1] = TCPOLEN_MSS;
 	opt[2] = (newmss & 0xff00) >> 8;
-	opt[3] = (newmss & 0x00ff);
+	opt[3] = newmss & 0x00ff;
 
 	nf_proto_csum_replace4(&tcph->check, *pskb, 0, *((__be32 *)opt), 0);
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 99c246e..d9b2e75 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -90,9 +90,9 @@ match(const struct sk_buff *skb,
 	}
 
 	if (sinfo->count.to)
-		return (what <= sinfo->count.to && what >= sinfo->count.from);
+		return what <= sinfo->count.to && what >= sinfo->count.from;
 	else
-		return (what >= sinfo->count.from);
+		return what >= sinfo->count.from;
 }
 
 static bool check(const char *tablename,
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 71f3c1a..3a6e16d 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -48,7 +48,7 @@ match(const struct sk_buff *skb,
 	if (!ct)
 		return false;
 
-	return (((ct->mark) & info->mask) == info->mark) ^ info->invert;
+	return ((ct->mark & info->mask) == info->mark) ^ info->invert;
 }
 
 static bool
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 1b77c5b..f07a68d 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -81,7 +81,7 @@ dccp_find_option(u_int8_t option,
 static inline bool
 match_types(const struct dccp_hdr *dh, u_int16_t typemask)
 {
-	return (typemask & (1 << dh->dccph_type));
+	return typemask & (1 << dh->dccph_type);
 }
 
 static inline bool
@@ -113,11 +113,11 @@ match(const struct sk_buff *skb,
 		return false;
 	}
 
-	return  DCCHECK(((ntohs(dh->dccph_sport) >= info->spts[0])
-			&& (ntohs(dh->dccph_sport) <= info->spts[1])),
+	return  DCCHECK(ntohs(dh->dccph_sport) >= info->spts[0]
+			&& ntohs(dh->dccph_sport) <= info->spts[1],
 			XT_DCCP_SRC_PORTS, info->flags, info->invflags)
-		&& DCCHECK(((ntohs(dh->dccph_dport) >= info->dpts[0])
-			&& (ntohs(dh->dccph_dport) <= info->dpts[1])),
+		&& DCCHECK(ntohs(dh->dccph_dport) >= info->dpts[0]
+			&& ntohs(dh->dccph_dport) <= info->dpts[1],
 			XT_DCCP_DEST_PORTS, info->flags, info->invflags)
 		&& DCCHECK(match_types(dh, info->typemask),
 			   XT_DCCP_TYPE, info->flags, info->invflags)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index deb5890..094da6e 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -239,7 +239,7 @@ static bool select_all(const struct xt_hashlimit_htable *ht,
 static bool select_gc(const struct xt_hashlimit_htable *ht,
 		      const struct dsthash_ent *he)
 {
-	return (jiffies >= he->expires);
+	return jiffies >= he->expires;
 }
 
 static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 57bcfac..ea4880b 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -47,8 +47,8 @@ match6(const struct sk_buff *skb,
        bool *hotdrop)
 {
 	const struct xt_length_info *info = matchinfo;
-	const u_int16_t pktlen = (ntohs(ipv6_hdr(skb)->payload_len) +
-				  sizeof(struct ipv6hdr));
+	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
+				 sizeof(struct ipv6hdr);
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 8602202..28ec08e 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -37,11 +37,11 @@ match(const struct sk_buff *skb,
     const struct xt_mac_info *info = matchinfo;
 
     /* Is mac pointer valid? */
-    return (skb_mac_header(skb) >= skb->head &&
-	    (skb_mac_header(skb) + ETH_HLEN) <= skb->data
-	    /* If so, compare... */
-	    && ((!compare_ether_addr(eth_hdr(skb)->h_source, info->srcaddr))
-		^ info->invert));
+    return skb_mac_header(skb) >= skb->head &&
+	   skb_mac_header(skb) + ETH_HLEN <= skb->data
+	   /* If so, compare... */
+	   && ((!compare_ether_addr(eth_hdr(skb)->h_source, info->srcaddr))
+		^ info->invert);
 }
 
 static struct xt_match xt_mac_match[] = {
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 6323972..e4c420b 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -34,9 +34,9 @@ static bool match(const struct sk_buff *skb,
 	const struct xt_pkttype_info *info = matchinfo;
 
 	if (skb->pkt_type == PACKET_LOOPBACK)
-		type = (MULTICAST(ip_hdr(skb)->daddr)
+		type = MULTICAST(ip_hdr(skb)->daddr)
 			? PACKET_MULTICAST
-			: PACKET_BROADCAST);
+			: PACKET_BROADCAST;
 	else
 		type = skb->pkt_type;
 
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 22df338..fefc846 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -31,11 +31,9 @@ match_flags(const struct xt_sctp_flag_info *flag_info,
 {
 	int i;
 
-	for (i = 0; i < flag_count; i++) {
-		if (flag_info[i].chunktype == chunktype) {
+	for (i = 0; i < flag_count; i++)
+		if (flag_info[i].chunktype == chunktype)
 			return (chunkflags & flag_info[i].flag_mask) == flag_info[i].flag;
-		}
-	}
 
 	return true;
 }
@@ -56,9 +54,8 @@ match_packet(const struct sk_buff *skb,
 	int i = 0;
 #endif
 
-	if (chunk_match_type == SCTP_CHUNK_MATCH_ALL) {
+	if (chunk_match_type == SCTP_CHUNK_MATCH_ALL)
 		SCTP_CHUNKMAP_COPY(chunkmapcopy, chunkmap);
-	}
 
 	do {
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
@@ -86,16 +83,14 @@ match_packet(const struct sk_buff *skb,
 
 			case SCTP_CHUNK_MATCH_ALL:
 				if (match_flags(flag_info, flag_count,
-					sch->type, sch->flags)) {
+				    sch->type, sch->flags))
 					SCTP_CHUNKMAP_CLEAR(chunkmapcopy, sch->type);
-				}
 				break;
 
 			case SCTP_CHUNK_MATCH_ONLY:
 				if (!match_flags(flag_info, flag_count,
-					sch->type, sch->flags)) {
+				    sch->type, sch->flags))
 					return false;
-				}
 				break;
 			}
 		} else {
@@ -145,11 +140,11 @@ match(const struct sk_buff *skb,
 	}
 	duprintf("spt: %d\tdpt: %d\n", ntohs(sh->source), ntohs(sh->dest));
 
-	return  SCCHECK(((ntohs(sh->source) >= info->spts[0])
-			&& (ntohs(sh->source) <= info->spts[1])),
+	return  SCCHECK(ntohs(sh->source) >= info->spts[0]
+			&& ntohs(sh->source) <= info->spts[1],
 			XT_SCTP_SRC_PORTS, info->flags, info->invflags)
-		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0])
-			&& (ntohs(sh->dest) <= info->dpts[1])),
+		&& SCCHECK(ntohs(sh->dest) >= info->dpts[0]
+			&& ntohs(sh->dest) <= info->dpts[1],
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
 		&& SCCHECK(match_packet(skb, protoff + sizeof (sctp_sctphdr_t),
 					info->chunkmap, info->chunk_match_type,
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 0dd3022..5cb345a 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -95,7 +95,7 @@ tcp_match(const struct sk_buff *skb,
 		return false;
 	}
 
-#define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
+#define FWINVTCP(bool, invflg) ((bool) ^ !!(tcpinfo->invflags & (invflg)))
 
 	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
 	if (th == NULL) {
