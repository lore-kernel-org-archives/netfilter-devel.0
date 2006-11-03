From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/05]: nf_nat: get rid of HW checksum invalidation
Date: Fri,  3 Nov 2006 17:46:26 +0100 (MET)
Message-ID: <20061103164839.15103.3915.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: get rid of HW checksum invalidation

Sync with commit 4cf411de49c65140b3c259748629b561c0d3340f:

Update hardware checksums incrementally to avoid breaking GSO.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b4b1bd0185d4054accbd925298f21b4d9eddfeec
tree 3058d0fbd03317712053af5b205d25a6e1f096d9
parent 64b20779232063e38df3a589f2dd8e1c26650921
author Patrick McHardy <kaber@trash.net> Fri, 03 Nov 2006 17:27:19 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Nov 2006 17:27:19 +0100

 include/net/netfilter/nf_nat.h         |    4 --
 include/net/netfilter/nf_nat_core.h    |    8 ++--
 net/ipv4/netfilter/nf_nat_core.c       |   52 +++++++++++-----------------
 net/ipv4/netfilter/nf_nat_helper.c     |   59 +++++++++++++++++++++++---------
 net/ipv4/netfilter/nf_nat_proto_icmp.c |    8 ++--
 net/ipv4/netfilter/nf_nat_proto_tcp.c  |    7 ++--
 net/ipv4/netfilter/nf_nat_proto_udp.c  |   14 +++++---
 net/ipv4/netfilter/nf_nat_standalone.c |    4 +-
 8 files changed, 84 insertions(+), 72 deletions(-)

diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index a4e2a1f..633f666 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -72,10 +72,6 @@ extern unsigned int nf_nat_setup_info(st
 extern int nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
-/* Calculate relative checksum. */
-extern u_int16_t nf_nat_cheat_check(u_int32_t oldvalinv,
-				    u_int32_t newval,
-				    u_int16_t oldcheck);
 #else  /* !__KERNEL__: iptables wants this to compile. */
 #define nf_nat_multi_range nf_nat_multi_range_compat
 #endif /*__KERNEL__*/
diff --git a/include/net/netfilter/nf_nat_core.h b/include/net/netfilter/nf_nat_core.h
index 6f2faa6..63f1635 100644
--- a/include/net/netfilter/nf_nat_core.h
+++ b/include/net/netfilter/nf_nat_core.h
@@ -11,10 +11,10 @@ extern unsigned int nf_nat_packet(struct
 			       unsigned int hooknum,
 			       struct sk_buff **pskb);
 
-extern int nf_nat_icmp_reply_translation(struct sk_buff **pskb,
-					 struct nf_conn *ct,
-					 enum nf_nat_manip_type manip,
-					 enum ip_conntrack_dir dir);
+extern int nf_nat_icmp_reply_translation(struct nf_conn *ct,
+					 enum ip_conntrack_info ctinfo,
+					 unsigned int hooknum,
+					 struct sk_buff **pskb);
 
 static inline int nf_nat_initialized(struct nf_conn *conntrack,
 				     enum nf_nat_manip_type manip)
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 34c2cd0..7b9f572 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -103,18 +103,6 @@ static void nf_nat_cleanup_conntrack(str
 	write_unlock_bh(&nf_nat_lock);
 }
 
-/* We do checksum mangling, so if they were wrong before they're still
- * wrong.  Also works for incomplete packets (eg. ICMP dest
- * unreachables.) */
-u_int16_t
-nf_nat_cheat_check(u_int32_t oldvalinv, u_int32_t newval, u_int16_t oldcheck)
-{
-	u_int32_t diffs[] = { oldvalinv, newval };
-	return csum_fold(csum_partial((char *)diffs, sizeof(diffs),
-				      oldcheck^0xFFFF));
-}
-EXPORT_SYMBOL(nf_nat_cheat_check);
-
 /* Is this tuple already taken? (not by us) */
 int
 nf_nat_used_tuple(const struct nf_conntrack_tuple *tuple,
@@ -383,12 +371,12 @@ manip_pkt(u_int16_t proto,
 	iph = (void *)(*pskb)->data + iphdroff;
 
 	if (maniptype == IP_NAT_MANIP_SRC) {
-		iph->check = nf_nat_cheat_check(~iph->saddr, target->src.u3.ip,
-						iph->check);
+		iph->check = nf_csum_update(~iph->saddr, target->src.u3.ip,
+					    iph->check);
 		iph->saddr = target->src.u3.ip;
 	} else {
-		iph->check = nf_nat_cheat_check(~iph->daddr, target->dst.u3.ip,
-						iph->check);
+		iph->check = nf_csum_update(~iph->daddr, target->dst.u3.ip,
+					    iph->check);
 		iph->daddr = target->dst.u3.ip;
 	}
 	return 1;
@@ -428,10 +416,10 @@ unsigned int nf_nat_packet(struct nf_con
 EXPORT_SYMBOL_GPL(nf_nat_packet);
 
 /* Dir is direction ICMP is coming from (opposite to packet it contains) */
-int nf_nat_icmp_reply_translation(struct sk_buff **pskb,
-				  struct nf_conn *ct,
-				  enum nf_nat_manip_type manip,
-				  enum ip_conntrack_dir dir)
+int nf_nat_icmp_reply_translation(struct nf_conn *ct,
+				  enum ip_conntrack_info ctinfo,
+				  unsigned int hooknum,
+				  struct sk_buff **pskb)
 {
 	struct {
 		struct icmphdr icmp;
@@ -439,7 +427,9 @@ int nf_nat_icmp_reply_translation(struct
 	} *inside;
 	struct nf_conntrack_tuple inner, target;
 	int hdrlen = (*pskb)->nh.iph->ihl * 4;
+	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	unsigned long statusbit;
+	enum nf_nat_manip_type manip = HOOK2MANIP(hooknum);
 
 	if (!skb_make_writable(pskb, hdrlen + sizeof(*inside)))
 		return 0;
@@ -448,12 +438,8 @@ int nf_nat_icmp_reply_translation(struct
 
 	/* We're actually going to mangle it beyond trivial checksum
 	   adjustment, so make sure the current checksum is correct. */
-	if ((*pskb)->ip_summed != CHECKSUM_UNNECESSARY) {
-		hdrlen = (*pskb)->nh.iph->ihl * 4;
-		if ((u16)csum_fold(skb_checksum(*pskb, hdrlen,
-						(*pskb)->len - hdrlen, 0)))
-			return 0;
-	}
+	if (nf_ip_checksum(*pskb, hooknum, hdrlen, 0))
+		return 0;
 
 	/* Must be RELATED */
 	NF_CT_ASSERT((*pskb)->nfctinfo == IP_CT_RELATED ||
@@ -498,12 +484,14 @@ int nf_nat_icmp_reply_translation(struct
 		       !manip))
 		return 0;
 
-	/* Reloading "inside" here since manip_pkt inner. */
-	inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
-	inside->icmp.checksum = 0;
-	inside->icmp.checksum = csum_fold(skb_checksum(*pskb, hdrlen,
-						       (*pskb)->len - hdrlen,
-						       0));
+	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
+		/* Reloading "inside" here since manip_pkt inner. */
+		inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
+		inside->icmp.checksum = 0;
+		inside->icmp.checksum = csum_fold(skb_checksum(*pskb, hdrlen,
+							       (*pskb)->len - hdrlen,
+							       0));
+	}
 
 	/* Change outer to look the reply to an incoming packet
 	 * (proto 0 means don't invert per-proto part). */
diff --git a/net/ipv4/netfilter/nf_nat_helper.c b/net/ipv4/netfilter/nf_nat_helper.c
index 4c9c88b..ccc39e6 100644
--- a/net/ipv4/netfilter/nf_nat_helper.c
+++ b/net/ipv4/netfilter/nf_nat_helper.c
@@ -163,7 +163,7 @@ nf_nat_mangle_tcp_packet(struct sk_buff 
 {
 	struct iphdr *iph;
 	struct tcphdr *tcph;
-	int datalen;
+	int oldlen, datalen;
 
 	if (!skb_make_writable(pskb, (*pskb)->len))
 		return 0;
@@ -178,13 +178,22 @@ nf_nat_mangle_tcp_packet(struct sk_buff 
 	iph = (*pskb)->nh.iph;
 	tcph = (void *)iph + iph->ihl*4;
 
+	oldlen = (*pskb)->len - iph->ihl*4;
 	mangle_contents(*pskb, iph->ihl*4 + tcph->doff*4,
 			match_offset, match_len, rep_buffer, rep_len);
 
 	datalen = (*pskb)->len - iph->ihl*4;
-	tcph->check = 0;
-	tcph->check = tcp_v4_check(tcph, datalen, iph->saddr, iph->daddr,
-				   csum_partial((char *)tcph, datalen, 0));
+	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
+		tcph->check = 0;
+		tcph->check = tcp_v4_check(tcph, datalen,
+					   iph->saddr, iph->daddr,
+					   csum_partial((char *)tcph,
+					   		datalen, 0));
+	} else
+		tcph->check = nf_proto_csum_update(*pskb,
+						   htons(oldlen) ^ 0xFFFF,
+						   htons(datalen),
+						   tcph->check, 1);
 
 	if (rep_len != match_len) {
 		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
@@ -222,6 +231,7 @@ nf_nat_mangle_udp_packet(struct sk_buff 
 {
 	struct iphdr *iph;
 	struct udphdr *udph;
+	int datalen, oldlen;
 
 	/* UDP helpers might accidentally mangle the wrong packet */
 	iph = (*pskb)->nh.iph;
@@ -239,21 +249,32 @@ nf_nat_mangle_udp_packet(struct sk_buff 
 
 	iph = (*pskb)->nh.iph;
 	udph = (void *)iph + iph->ihl*4;
+
+	oldlen = (*pskb)->len - iph->ihl*4;
 	mangle_contents(*pskb, iph->ihl*4 + sizeof(*udph),
 			match_offset, match_len, rep_buffer, rep_len);
 
 	/* update the length of the UDP packet */
-	udph->len = htons((*pskb)->len - iph->ihl*4);
+	datalen = (*pskb)->len - iph->ihl*4;
+	udph->len = htons(datalen);
 
 	/* fix udp checksum if udp checksum was previously calculated */
-	if (udph->check) {
-		int datalen = (*pskb)->len - iph->ihl * 4;
+	if (!udph->check && (*pskb)->ip_summed != CHECKSUM_PARTIAL)
+		return 1;
+
+	if ((*pskb)->ip_summed != CHECKSUM_PARTIAL) {
 		udph->check = 0;
 		udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
 		                                datalen, IPPROTO_UDP,
 		                                csum_partial((char *)udph,
 		                                             datalen, 0));
-	}
+		if (!udph->check)
+			udph->check = -1;
+	} else
+		udph->check = nf_proto_csum_update(*pskb,
+						   htons(oldlen) ^ 0xFFFF,
+						   htons(datalen),
+						   udph->check, 1);
 
 	return 1;
 }
@@ -294,11 +315,15 @@ sack_adjust(struct sk_buff *skb,
 			ntohl(sack->start_seq), new_start_seq,
 			ntohl(sack->end_seq), new_end_seq);
 
-		tcph->check = 
-			nf_nat_cheat_check(~sack->start_seq, new_start_seq,
-					   nf_nat_cheat_check(~sack->end_seq, 
-						   	      new_end_seq,
-							      tcph->check));
+		tcph->check = nf_proto_csum_update(skb,
+						   ~sack->start_seq,
+						   new_start_seq,
+						   tcph->check, 0);
+		tcph->check = nf_proto_csum_update(skb,
+						   ~sack->end_seq,
+						   new_end_seq,
+						   tcph->check, 0);
+
 		sack->start_seq = new_start_seq;
 		sack->end_seq = new_end_seq;
 		sackoff += sizeof(*sack);
@@ -384,10 +409,10 @@ nf_nat_seq_adjust(struct sk_buff **pskb,
 		newack = ntohl(tcph->ack_seq) - other_way->offset_before;
 	newack = htonl(newack);
 
-	tcph->check = nf_nat_cheat_check(~tcph->seq, newseq,
-					 nf_nat_cheat_check(~tcph->ack_seq, 
-					 		    newack, 
-							    tcph->check));
+	tcph->check = nf_proto_csum_update(*pskb, ~tcph->seq, newseq,
+					   tcph->check, 0);
+	tcph->check = nf_proto_csum_update(*pskb, ~tcph->ack_seq, newack,
+					   tcph->check, 0);
 
 	DEBUGP("Adjusting sequence number from %u->%u, ack from %u->%u\n",
 		ntohl(tcph->seq), ntohl(newseq), ntohl(tcph->ack_seq),
diff --git a/net/ipv4/netfilter/nf_nat_proto_icmp.c b/net/ipv4/netfilter/nf_nat_proto_icmp.c
index 6a2cf9f..cb7ce9a 100644
--- a/net/ipv4/netfilter/nf_nat_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_icmp.c
@@ -66,10 +66,10 @@ icmp_manip_pkt(struct sk_buff **pskb,
 		return 0;
 
 	hdr = (struct icmphdr *)((*pskb)->data + hdroff);
-
-	hdr->checksum = nf_nat_cheat_check(hdr->un.echo.id ^ 0xFFFF,
-					    tuple->src.u.icmp.id,
-					    hdr->checksum);
+	hdr->checksum = nf_proto_csum_update(*pskb,
+					     hdr->un.echo.id ^ 0xFFFF,
+					     tuple->src.u.icmp.id,
+					     hdr->checksum, 0);
 	hdr->un.echo.id = tuple->src.u.icmp.id;
 	return 1;
 }
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index f8474d2..0a8edde 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -129,10 +129,9 @@ tcp_manip_pkt(struct sk_buff **pskb,
 	if (hdrsize < sizeof(*hdr))
 		return 1;
 
-	hdr->check = nf_nat_cheat_check(~oldip, newip,
-					nf_nat_cheat_check(oldport ^ 0xFFFF,
-							   newport,
-							   hdr->check));
+	hdr->check = nf_proto_csum_update(*pskb, ~oldip, newip, hdr->check, 1);
+	hdr->check = nf_proto_csum_update(*pskb, oldport ^ 0xFFFF, newport,
+					  hdr->check, 0);
 	return 1;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index f9a2b12..99d0ac1 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -113,11 +113,15 @@ udp_manip_pkt(struct sk_buff **pskb,
 		newport = tuple->dst.u.udp.port;
 		portptr = &hdr->dest;
 	}
-	if (hdr->check) /* 0 is a special case meaning no checksum */
-		hdr->check = nf_nat_cheat_check(~oldip, newip,
-					nf_nat_cheat_check(*portptr ^ 0xFFFF,
-							   newport,
-							   hdr->check));
+	if (hdr->check || (*pskb)->ip_summed == CHECKSUM_PARTIAL) {
+		hdr->check = nf_proto_csum_update(*pskb, ~oldip, newip,
+						  hdr->check, 1);
+		hdr->check = nf_proto_csum_update(*pskb,
+						  *portptr ^ 0xFFFF, newport,
+						  hdr->check, 0);
+		if (!hdr->check)
+			hdr->check = -1;
+	}
 	*portptr = newport;
 	return 1;
 }
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 7310014..8d83c54 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -142,8 +142,8 @@ nf_nat_fn(unsigned int hooknum,
 	case IP_CT_RELATED:
 	case IP_CT_RELATED+IP_CT_IS_REPLY:
 		if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP) {
-			if (!nf_nat_icmp_reply_translation(pskb, ct, maniptype,
-							   CTINFO2DIR(ctinfo)))
+			if (!nf_nat_icmp_reply_translation(ct, ctinfo,
+							   hooknum, pskb))
 				return NF_DROP;
 			else
 				return NF_ACCEPT;
