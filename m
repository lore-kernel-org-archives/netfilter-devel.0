From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/05]: nf_nat: NAT annotations
Date: Fri,  3 Nov 2006 17:46:29 +0100 (MET)
Message-ID: <20061103164842.15103.39581.sendpatchset@localhost.localdomain>
References: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
In-Reply-To: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: NAT annotations

Sync with commit a76b11dd25957287af12ce6855be6d7fd415b3a9

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit aa3104784034fe4a9971de642e962c18b51f5a00
tree 7fc7312ddfc241db4bd0032fb67bfdc66b2b8db8
parent ce071a4e6fcee746b64936ac5c02317cbafdc4ab
author Patrick McHardy <kaber@trash.net> Fri, 03 Nov 2006 17:27:44 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Nov 2006 17:27:44 +0100

 include/net/netfilter/nf_nat.h         |    2 +-
 net/ipv4/netfilter/nf_nat_core.c       |   14 ++++++------
 net/ipv4/netfilter/nf_nat_ftp.c        |   10 ++++-----
 net/ipv4/netfilter/nf_nat_helper.c     |   37 +++++++++++++++-----------------
 net/ipv4/netfilter/nf_nat_proto_icmp.c |    2 +-
 net/ipv4/netfilter/nf_nat_proto_tcp.c  |   10 ++++-----
 net/ipv4/netfilter/nf_nat_proto_udp.c  |    8 +++----
 net/ipv4/netfilter/nf_nat_rule.c       |    6 +++--
 net/ipv4/netfilter/nf_nat_standalone.c |    2 +-
 9 files changed, 44 insertions(+), 47 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 633f666..b617949 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -33,7 +33,7 @@ struct nf_nat_range
 	unsigned int flags;
 
 	/* Inclusive: network order. */
-	u_int32_t min_ip, max_ip;
+	__be32 min_ip, max_ip;
 
 	/* Inclusive: network order */
 	union nf_conntrack_man_proto min, max;
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 7b9f572..ce59301 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -86,7 +86,7 @@ static inline unsigned int
 hash_by_src(const struct nf_conntrack_tuple *tuple)
 {
 	/* Original src, to ensure we map it consistently if poss. */
-	return jhash_3words(tuple->src.u3.ip, tuple->src.u.all,
+	return jhash_3words((__force u32)tuple->src.u3.ip, tuple->src.u.all,
 			    tuple->dst.protonum, 0) % nf_nat_htable_size;
 }
 
@@ -198,7 +198,7 @@ find_best_ips_proto(struct nf_conntrack_
 		    const struct nf_conn *conntrack,
 		    enum nf_nat_manip_type maniptype)
 {
-	u_int32_t *var_ipp;
+	__be32 *var_ipp;
 	/* Host order */
 	u_int32_t minip, maxip, j;
 
@@ -225,7 +225,7 @@ find_best_ips_proto(struct nf_conntrack_
 	 * like this), even across reboots. */
 	minip = ntohl(range->min_ip);
 	maxip = ntohl(range->max_ip);
-	j = jhash_2words(tuple->src.u3.ip, tuple->dst.u3.ip, 0);
+	j = jhash_2words((__force u32)tuple->src.u3.ip, tuple->dst.u3.ip, 0);
 	*var_ipp = htonl(minip + j % (maxip - minip + 1));
 }
 
@@ -549,9 +549,9 @@ int
 nf_nat_port_range_to_nfattr(struct sk_buff *skb, 
 			    const struct nf_nat_range *range)
 {
-	NFA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(u_int16_t),
+	NFA_PUT(skb, CTA_PROTONAT_PORT_MIN, sizeof(__be16),
 		&range->min.tcp.port);
-	NFA_PUT(skb, CTA_PROTONAT_PORT_MAX, sizeof(u_int16_t),
+	NFA_PUT(skb, CTA_PROTONAT_PORT_MAX, sizeof(__be16),
 		&range->max.tcp.port);
 
 	return 0;
@@ -570,7 +570,7 @@ nf_nat_port_nfattr_to_range(struct nfatt
 	if (tb[CTA_PROTONAT_PORT_MIN-1]) {
 		ret = 1;
 		range->min.tcp.port = 
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTONAT_PORT_MIN-1]);
+			*(__be16 *)NFA_DATA(tb[CTA_PROTONAT_PORT_MIN-1]);
 	}
 	
 	if (!tb[CTA_PROTONAT_PORT_MAX-1]) {
@@ -579,7 +579,7 @@ nf_nat_port_nfattr_to_range(struct nfatt
 	} else {
 		ret = 1;
 		range->max.tcp.port = 
-			*(u_int16_t *)NFA_DATA(tb[CTA_PROTONAT_PORT_MAX-1]);
+			*(__be16 *)NFA_DATA(tb[CTA_PROTONAT_PORT_MAX-1]);
 	}
 
 	return ret;
diff --git a/net/ipv4/netfilter/nf_nat_ftp.c b/net/ipv4/netfilter/nf_nat_ftp.c
index d2d8497..eab6e07 100644
--- a/net/ipv4/netfilter/nf_nat_ftp.c
+++ b/net/ipv4/netfilter/nf_nat_ftp.c
@@ -35,7 +35,7 @@ #endif
 
 static int
 mangle_rfc959_packet(struct sk_buff **pskb,
-		     u_int32_t newip,
+		     __be32 newip,
 		     u_int16_t port,
 		     unsigned int matchoff,
 		     unsigned int matchlen,
@@ -58,7 +58,7 @@ mangle_rfc959_packet(struct sk_buff **ps
 /* |1|132.235.1.2|6275| */
 static int
 mangle_eprt_packet(struct sk_buff **pskb,
-		   u_int32_t newip,
+		   __be32 newip,
 		   u_int16_t port,
 		   unsigned int matchoff,
 		   unsigned int matchlen,
@@ -80,7 +80,7 @@ mangle_eprt_packet(struct sk_buff **pskb
 /* |1|132.235.1.2|6275| */
 static int
 mangle_epsv_packet(struct sk_buff **pskb,
-		   u_int32_t newip,
+		   __be32 newip,
 		   u_int16_t port,
 		   unsigned int matchoff,
 		   unsigned int matchlen,
@@ -99,7 +99,7 @@ mangle_epsv_packet(struct sk_buff **pskb
 					matchlen, buffer, strlen(buffer));
 }
 
-static int (*mangle[])(struct sk_buff **, u_int32_t, u_int16_t,
+static int (*mangle[])(struct sk_buff **, __be32, u_int16_t,
 		     unsigned int,
 		     unsigned int,
 		     struct nf_conn *,
@@ -121,7 +121,7 @@ static unsigned int nf_nat_ftp(struct sk
 			       struct nf_conntrack_expect *exp,
 			       u32 *seq)
 {
-	u_int32_t newip;
+	__be32 newip;
 	u_int16_t port;
 	int dir = CTINFO2DIR(ctinfo);
 	struct nf_conn *ct = exp->master;
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 94aa972..e7bc82d 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -191,7 +191,7 @@ nf_nat_mangle_tcp_packet(struct sk_buff 
 					   		datalen, 0));
 	} else
 		tcph->check = nf_proto_csum_update(*pskb,
-						   htons(oldlen) ^ 0xFFFF,
+						   htons(oldlen) ^ htons(0xFFFF),
 						   htons(datalen),
 						   tcph->check, 1);
 
@@ -272,7 +272,7 @@ nf_nat_mangle_udp_packet(struct sk_buff 
 			udph->check = -1;
 	} else
 		udph->check = nf_proto_csum_update(*pskb,
-						   htons(oldlen) ^ 0xFFFF,
+						   htons(oldlen) ^ htons(0xFFFF),
 						   htons(datalen),
 						   udph->check, 1);
 
@@ -290,26 +290,24 @@ sack_adjust(struct sk_buff *skb,
 {
 	while (sackoff < sackend) {
 		struct tcp_sack_block_wire *sack;
-		u_int32_t new_start_seq, new_end_seq;
+		__be32 new_start_seq, new_end_seq;
 
 		sack = (void *)skb->data + sackoff;
 		if (after(ntohl(sack->start_seq) - natseq->offset_before,
 			  natseq->correction_pos))
-			new_start_seq = ntohl(sack->start_seq) 
-					- natseq->offset_after;
+			new_start_seq = htonl(ntohl(sack->start_seq)
+					- natseq->offset_after);
 		else
-			new_start_seq = ntohl(sack->start_seq) 
-					- natseq->offset_before;
-		new_start_seq = htonl(new_start_seq);
+			new_start_seq = htonl(ntohl(sack->start_seq)
+					- natseq->offset_before);
 
 		if (after(ntohl(sack->end_seq) - natseq->offset_before,
 			  natseq->correction_pos))
-			new_end_seq = ntohl(sack->end_seq)
-				      - natseq->offset_after;
+			new_end_seq = htonl(ntohl(sack->end_seq)
+				      - natseq->offset_after);
 		else
-			new_end_seq = ntohl(sack->end_seq)
-				      - natseq->offset_before;
-		new_end_seq = htonl(new_end_seq);
+			new_end_seq = htonl(ntohl(sack->end_seq)
+				      - natseq->offset_before);
 
 		DEBUGP("sack_adjust: start_seq: %d->%d, end_seq: %d->%d\n",
 			ntohl(sack->start_seq), new_start_seq,
@@ -383,7 +381,8 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
 		  enum ip_conntrack_info ctinfo)
 {
 	struct tcphdr *tcph;
-	int dir, newseq, newack;
+	int dir;
+	__be32 newseq, newack;
 	struct nf_conn_nat *nat = nfct_nat(ct);
 	struct nf_nat_seq *this_way, *other_way;	
 
@@ -397,17 +396,15 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
 
 	tcph = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
 	if (after(ntohl(tcph->seq), this_way->correction_pos))
-		newseq = ntohl(tcph->seq) + this_way->offset_after;
+		newseq = htonl(ntohl(tcph->seq) + this_way->offset_after);
 	else
-		newseq = ntohl(tcph->seq) + this_way->offset_before;
-	newseq = htonl(newseq);
+		newseq = htonl(ntohl(tcph->seq) + this_way->offset_before);
 
 	if (after(ntohl(tcph->ack_seq) - other_way->offset_before,
 		  other_way->correction_pos))
-		newack = ntohl(tcph->ack_seq) - other_way->offset_after;
+		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_after);
 	else
-		newack = ntohl(tcph->ack_seq) - other_way->offset_before;
-	newack = htonl(newack);
+		newack = htonl(ntohl(tcph->ack_seq) - other_way->offset_before);
 
 	tcph->check = nf_proto_csum_update(*pskb, ~tcph->seq, newseq,
 					   tcph->check, 0);
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index cb7ce9a..c28b0d2 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -67,7 +67,7 @@ icmp_manip_pkt(struct sk_buff **pskb,
 
 	hdr = (struct icmphdr *)((*pskb)->data + hdroff);
 	hdr->checksum = nf_proto_csum_update(*pskb,
-					     hdr->un.echo.id ^ 0xFFFF,
+					     hdr->un.echo.id ^ htons(0xFFFF),
 					     tuple->src.u.icmp.id,
 					     hdr->checksum, 0);
 	hdr->un.echo.id = tuple->src.u.icmp.id;
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 0a8edde..b516de0 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -24,7 +24,7 @@ tcp_in_range(const struct nf_conntrack_t
 	     const union nf_conntrack_man_proto *min,
 	     const union nf_conntrack_man_proto *max)
 {
-	u_int16_t port;
+	__be16 port;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
 		port = tuple->src.u.tcp.port;
@@ -42,7 +42,7 @@ tcp_unique_tuple(struct nf_conntrack_tup
 		 const struct nf_conn *conntrack)
 {
 	static u_int16_t port;
-	u_int16_t *portptr;
+	__be16 *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
@@ -93,8 +93,8 @@ tcp_manip_pkt(struct sk_buff **pskb,
 	struct iphdr *iph = (struct iphdr *)((*pskb)->data + iphdroff);
 	struct tcphdr *hdr;
 	unsigned int hdroff = iphdroff + iph->ihl*4;
-	u32 oldip, newip;
-	u16 *portptr, newport, oldport;
+	__be32 oldip, newip;
+	__be16 *portptr, newport, oldport;
 	int hdrsize = 8; /* TCP connection tracking guarantees this much */
 
 	/* this could be a inner header returned in icmp packet; in such
@@ -130,7 +130,7 @@ tcp_manip_pkt(struct sk_buff **pskb,
 		return 1;
 
 	hdr->check = nf_proto_csum_update(*pskb, ~oldip, newip, hdr->check, 1);
-	hdr->check = nf_proto_csum_update(*pskb, oldport ^ 0xFFFF, newport,
+	hdr->check = nf_proto_csum_update(*pskb, oldport ^ htons(0xFFFF), newport,
 					  hdr->check, 0);
 	return 1;
 }
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index 99d0ac1..b269bd9 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -24,7 +24,7 @@ udp_in_range(const struct nf_conntrack_t
 	     const union nf_conntrack_man_proto *min,
 	     const union nf_conntrack_man_proto *max)
 {
-	u_int16_t port;
+	__be16 port;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
 		port = tuple->src.u.udp.port;
@@ -42,7 +42,7 @@ udp_unique_tuple(struct nf_conntrack_tup
 		 const struct nf_conn *conntrack)
 {
 	static u_int16_t port;
-	u_int16_t *portptr;
+	__be16 *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
@@ -117,8 +117,8 @@ udp_manip_pkt(struct sk_buff **pskb,
 		hdr->check = nf_proto_csum_update(*pskb, ~oldip, newip,
 						  hdr->check, 1);
 		hdr->check = nf_proto_csum_update(*pskb,
-						  *portptr ^ 0xFFFF, newport,
-						  hdr->check, 0);
+						  *portptr ^ htons(0xFFFF),
+						  newport, hdr->check, 0);
 		if (!hdr->check)
 			hdr->check = -1;
 	}
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 4ce2ddf..a83310a 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -152,7 +152,7 @@ static unsigned int ipt_snat_target(stru
 }
 
 /* Before 2.6.11 we did implicit source NAT if required. Warn about change. */
-static void warn_if_extra_mangle(u32 dstip, u32 srcip)
+static void warn_if_extra_mangle(__be32 dstip, __be32 srcip)
 {
 	static int warned = 0;
 	struct flowi fl = { .nl_u = { .ip4_u = { .daddr = dstip } } };
@@ -238,7 +238,7 @@ alloc_null_binding(struct nf_conn *connt
 	   per-proto parts (hence not IP_NAT_RANGE_PROTO_SPECIFIED).
 	   Use reply in case it's already been mangled (eg local packet).
 	*/
-	u_int32_t ip
+	__be32 ip
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
 		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
 		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
@@ -255,7 +255,7 @@ alloc_null_binding_confirmed(struct nf_c
                              struct nf_nat_info *info,
                              unsigned int hooknum)
 {
-	u_int32_t ip
+	__be32 ip
 		= (HOOK2MANIP(hooknum) == IP_NAT_MANIP_SRC
 		   ? conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip
 		   : conntrack->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip);
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 8d83c54..f0391c1 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -197,7 +197,7 @@ nf_nat_in(unsigned int hooknum,
           int (*okfn)(struct sk_buff *))
 {
 	unsigned int ret;
-	u_int32_t daddr = (*pskb)->nh.iph->daddr;
+	__be32 daddr = (*pskb)->nh.iph->daddr;
 
 	ret = nf_nat_fn(hooknum, pskb, in, out, okfn);
 	if (ret != NF_DROP && ret != NF_STOLEN
