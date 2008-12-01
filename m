From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 01/18] add ukey_* function for key assignation
Date: Mon,  1 Dec 2008 22:35:59 +0100
Message-ID: <1228167376-22101-2-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39294 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751774AbYLAVgV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:21 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch cleans up the current key assignation by introducing a
set of functions ukey_* to set the key value as Eric Leblond and
we discussed during the latest Netfilter Workshop. This patch is
based on an idea from Holger Eitzenberger.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c  |  217 ++++++++++------------------
 filter/raw2packet/ulogd_raw2packet_LOCAL.c |    7 +-
 filter/ulogd_filter_HWHDR.c                |   76 +++++-----
 filter/ulogd_filter_IFINDEX.c              |   30 +++--
 filter/ulogd_filter_IP2BIN.c               |    9 +-
 filter/ulogd_filter_IP2STR.c               |   15 +-
 filter/ulogd_filter_MARK.c                 |    4 +-
 filter/ulogd_filter_PRINTFLOW.c            |    3 +-
 filter/ulogd_filter_PRINTPKT.c             |    3 +-
 filter/ulogd_filter_PWSNIFF.c              |   27 ++--
 include/ulogd/ulogd.h                      |   60 ++++++++-
 input/flow/ulogd_inpflow_NFCT.c            |  159 +++++++--------------
 input/packet/ulogd_inppkt_NFLOG.c          |  101 +++++---------
 input/packet/ulogd_inppkt_ULOG.c           |   45 ++----
 output/pcap/ulogd_output_PCAP.c            |   11 +-
 output/ulogd_output_NACCT.c                |   34 +++---
 util/printflow.c                           |   52 ++++----
 util/printpkt.c                            |  146 ++++++++++---------
 18 files changed, 448 insertions(+), 551 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index e61d904..c38c696 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -521,43 +521,25 @@ static int _interp_tcp(struct ulogd_pluginstance *pi, struct tcphdr *tcph,
 	if (len < sizeof(struct tcphdr))
 		return ULOGD_IRET_OK;
 	
-	ret[KEY_TCP_SPORT].u.value.ui16 = ntohs(tcph->source);
-	ret[KEY_TCP_SPORT].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_DPORT].u.value.ui16 = ntohs(tcph->dest);
-	ret[KEY_TCP_DPORT].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_SEQ].u.value.ui32 = ntohl(tcph->seq);
-	ret[KEY_TCP_SEQ].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_ACKSEQ].u.value.ui32 = ntohl(tcph->ack_seq);
-	ret[KEY_TCP_ACKSEQ].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_OFFSET].u.value.ui8 = ntohs(tcph->doff);
-	ret[KEY_TCP_OFFSET].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_RESERVED].u.value.ui8 = ntohs(tcph->res1);
-	ret[KEY_TCP_RESERVED].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_WINDOW].u.value.ui16 = ntohs(tcph->window);
-	ret[KEY_TCP_WINDOW].flags |= ULOGD_RETF_VALID;
-
-	ret[KEY_TCP_URG].u.value.b = tcph->urg;
-	ret[KEY_TCP_URG].flags |= ULOGD_RETF_VALID;
-	if (tcph->urg) {
-		ret[KEY_TCP_URGP].u.value.ui16 = ntohs(tcph->urg_ptr);
-		ret[KEY_TCP_URGP].flags |= ULOGD_RETF_VALID;
-	}
-	ret[KEY_TCP_ACK].u.value.b = tcph->ack;
-	ret[KEY_TCP_ACK].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_PSH].u.value.b = tcph->psh;
-	ret[KEY_TCP_PSH].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_RST].u.value.b = tcph->rst;
-	ret[KEY_TCP_RST].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_SYN].u.value.b = tcph->syn;
-	ret[KEY_TCP_SYN].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_FIN].u.value.b = tcph->fin;
-	ret[KEY_TCP_FIN].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_RES1].u.value.b = tcph->res1;
-	ret[KEY_TCP_RES1].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_RES2].u.value.b = tcph->res2;
-	ret[KEY_TCP_RES2].flags |= ULOGD_RETF_VALID;
-	ret[KEY_TCP_CSUM].u.value.ui16 = ntohs(tcph->check);
-	ret[KEY_TCP_CSUM].u.value.ui16 = ULOGD_RETF_VALID;
+	okey_set_u16(&ret[KEY_TCP_SPORT], ntohs(tcph->source));
+	okey_set_u16(&ret[KEY_TCP_DPORT], ntohs(tcph->dest));
+	okey_set_u32(&ret[KEY_TCP_SEQ], ntohl(tcph->seq));
+	okey_set_u32(&ret[KEY_TCP_ACKSEQ], ntohl(tcph->ack_seq));
+	okey_set_u8(&ret[KEY_TCP_OFFSET], ntohs(tcph->doff));
+	okey_set_u8(&ret[KEY_TCP_RESERVED], ntohs(tcph->res1));
+	okey_set_u16(&ret[KEY_TCP_WINDOW], ntohs(tcph->window));
+
+	okey_set_b(&ret[KEY_TCP_URG], tcph->urg);
+	if (tcph->urg)
+		okey_set_u16(&ret[KEY_TCP_URGP], ntohs(tcph->urg_ptr));
+	okey_set_b(&ret[KEY_TCP_ACK], tcph->ack);
+	okey_set_b(&ret[KEY_TCP_PSH], tcph->psh);
+	okey_set_b(&ret[KEY_TCP_RST], tcph->rst);
+	okey_set_b(&ret[KEY_TCP_SYN], tcph->syn);
+	okey_set_b(&ret[KEY_TCP_FIN], tcph->fin);
+	okey_set_b(&ret[KEY_TCP_RES1], tcph->res1);
+	okey_set_b(&ret[KEY_TCP_RES2], tcph->res2);
+	okey_set_u16(&ret[KEY_TCP_CSUM], ntohs(tcph->check));
 	
 	return ULOGD_IRET_OK;
 }
@@ -575,14 +557,10 @@ static int _interp_udp(struct ulogd_pluginstance *pi, struct udphdr *udph,
 	if (len < sizeof(struct udphdr))
 		return ULOGD_IRET_OK;
 
-	ret[KEY_UDP_SPORT].u.value.ui16 = ntohs(udph->source);
-	ret[KEY_UDP_SPORT].flags |= ULOGD_RETF_VALID;
-	ret[KEY_UDP_DPORT].u.value.ui16 = ntohs(udph->dest);
-	ret[KEY_UDP_DPORT].flags |= ULOGD_RETF_VALID;
-	ret[KEY_UDP_LEN].u.value.ui16 = ntohs(udph->len);
-	ret[KEY_UDP_LEN].flags |= ULOGD_RETF_VALID;
-	ret[KEY_UDP_CSUM].u.value.ui16 = ntohs(udph->check);
-	ret[KEY_UDP_CSUM].flags |= ULOGD_RETF_VALID;
+	okey_set_u16(&ret[KEY_UDP_SPORT], ntohs(udph->source));
+	okey_set_u16(&ret[KEY_UDP_DPORT], ntohs(udph->dest));
+	okey_set_u16(&ret[KEY_UDP_LEN], ntohs(udph->len));
+	okey_set_u16(&ret[KEY_UDP_CSUM], ntohs(udph->check));
 	
 	return ULOGD_IRET_OK;
 }
@@ -599,33 +577,28 @@ static int _interp_icmp(struct ulogd_pluginstance *pi, struct icmphdr *icmph,
 	if (len < sizeof(struct icmphdr))
 		return ULOGD_IRET_OK;
 
-	ret[KEY_ICMP_TYPE].u.value.ui8 = icmph->type;
-	ret[KEY_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
-	ret[KEY_ICMP_CODE].u.value.ui8 = icmph->code;
-	ret[KEY_ICMP_CODE].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[KEY_ICMP_TYPE], icmph->type);
+	okey_set_u8(&ret[KEY_ICMP_CODE], icmph->code);
 
 	switch (icmph->type) {
 	case ICMP_ECHO:
 	case ICMP_ECHOREPLY:
-		ret[KEY_ICMP_ECHOID].u.value.ui16 = ntohs(icmph->un.echo.id);
-		ret[KEY_ICMP_ECHOID].flags |= ULOGD_RETF_VALID;
-		ret[KEY_ICMP_ECHOSEQ].u.value.ui16 = ntohs(icmph->un.echo.sequence);
-		ret[KEY_ICMP_ECHOSEQ].flags |= ULOGD_RETF_VALID;
+		okey_set_u16(&ret[KEY_ICMP_ECHOID], ntohs(icmph->un.echo.id));
+		okey_set_u16(&ret[KEY_ICMP_ECHOSEQ],
+			     ntohs(icmph->un.echo.sequence));
 		break;
 	case ICMP_REDIRECT:
 	case ICMP_PARAMETERPROB:
-		ret[KEY_ICMP_GATEWAY].u.value.ui32 = ntohl(icmph->un.gateway);
-		ret[KEY_ICMP_GATEWAY].flags |= ULOGD_RETF_VALID;
+		okey_set_u32(&ret[KEY_ICMP_GATEWAY], ntohl(icmph->un.gateway));
 		break;
 	case ICMP_DEST_UNREACH:
 		if (icmph->code == ICMP_FRAG_NEEDED) {
-			ret[KEY_ICMP_FRAGMTU].u.value.ui16 = ntohs(icmph->un.frag.mtu);
-			ret[KEY_ICMP_FRAGMTU].flags |= ULOGD_RETF_VALID;
+			okey_set_u16(&ret[KEY_ICMP_FRAGMTU],
+				     ntohs(icmph->un.frag.mtu));
 		}
 		break;
 	}
-	ret[KEY_ICMP_CSUM].u.value.ui16 = icmph->checksum;
-	ret[KEY_ICMP_CSUM].flags |= ULOGD_RETF_VALID;
+	okey_set_u16(&ret[KEY_ICMP_CSUM], icmph->checksum);
 
 	return ULOGD_IRET_OK;
 }
@@ -642,22 +615,18 @@ static int _interp_icmpv6(struct ulogd_pluginstance *pi, struct icmp6_hdr *icmph
 	if (len < sizeof(struct icmp6_hdr))
 		return ULOGD_IRET_OK;
 
-	ret[KEY_ICMPV6_TYPE].u.value.ui8 = icmph->icmp6_type;
-	ret[KEY_ICMPV6_TYPE].flags |= ULOGD_RETF_VALID;
-	ret[KEY_ICMPV6_CODE].u.value.ui8 = icmph->icmp6_code;
-	ret[KEY_ICMPV6_CODE].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[KEY_ICMPV6_TYPE], icmph->icmp6_type);
+	okey_set_u8(&ret[KEY_ICMPV6_CODE], icmph->icmp6_code);
 
 	switch (icmph->icmp6_type) {
 	case ICMP6_ECHO_REQUEST:
 	case ICMP6_ECHO_REPLY:
-		ret[KEY_ICMPV6_ECHOID].u.value.ui16 = ntohs(icmph->icmp6_id);
-		ret[KEY_ICMPV6_ECHOID].flags |= ULOGD_RETF_VALID;
-		ret[KEY_ICMPV6_ECHOSEQ].u.value.ui16 = ntohs(icmph->icmp6_seq);
-		ret[KEY_ICMPV6_ECHOSEQ].flags |= ULOGD_RETF_VALID;
+		okey_set_u16(&ret[KEY_ICMPV6_ECHOID], ntohs(icmph->icmp6_id));
+		okey_set_u16(&ret[KEY_ICMPV6_ECHOSEQ],
+			      ntohs(icmph->icmp6_seq));
 		break;
 	}
-	ret[KEY_ICMPV6_CSUM].u.value.ui16 = icmph->icmp6_cksum;
-	ret[KEY_ICMPV6_CSUM].flags |= ULOGD_RETF_VALID;
+	okey_set_u16(&ret[KEY_ICMPV6_CSUM], icmph->icmp6_cksum);
 
 	return ULOGD_IRET_OK;
 }
@@ -691,33 +660,23 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct iphdr *iph =
-		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
+		ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
 	void *nexthdr = (u_int32_t *)iph + iph->ihl;
 
 	if (len < sizeof(struct iphdr) || len <= (u_int32_t)(iph->ihl * 4))
 		return ULOGD_IRET_OK;
 	len -= iph->ihl * 4;
 
-	ret[KEY_IP_SADDR].u.value.ui32 = iph->saddr;
-	ret[KEY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_DADDR].u.value.ui32 = iph->daddr;
-	ret[KEY_IP_DADDR].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_PROTOCOL].u.value.ui8 = iph->protocol;
-	ret[KEY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_TOS].u.value.ui8 = iph->tos;
-	ret[KEY_IP_TOS].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_TTL].u.value.ui8 = iph->ttl;
-	ret[KEY_IP_TTL].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_TOTLEN].u.value.ui16 = ntohs(iph->tot_len);
-	ret[KEY_IP_TOTLEN].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_IHL].u.value.ui8 = iph->ihl;
-	ret[KEY_IP_IHL].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_CSUM].u.value.ui16 = ntohs(iph->check);
-	ret[KEY_IP_CSUM].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_ID].u.value.ui16 = ntohs(iph->id);
-	ret[KEY_IP_ID].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP_FRAGOFF].u.value.ui16 = ntohs(iph->frag_off);
-	ret[KEY_IP_FRAGOFF].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[KEY_IP_SADDR], iph->saddr);
+	okey_set_u32(&ret[KEY_IP_DADDR], iph->daddr);
+	okey_set_u8(&ret[KEY_IP_PROTOCOL], iph->protocol);
+	okey_set_u8(&ret[KEY_IP_TOS], iph->tos);
+	okey_set_u8(&ret[KEY_IP_TTL], iph->ttl);
+	okey_set_u16(&ret[KEY_IP_TOTLEN], ntohs(iph->tot_len));
+	okey_set_u8(&ret[KEY_IP_IHL], iph->ihl);
+	okey_set_u16(&ret[KEY_IP_CSUM], ntohs(iph->check));
+	okey_set_u16(&ret[KEY_IP_ID], ntohs(iph->id));
+	okey_set_u16(&ret[KEY_IP_FRAGOFF], ntohs(iph->frag_off));
 
 	switch (iph->protocol) {
 	case IPPROTO_TCP:
@@ -760,8 +719,7 @@ static int ip6_ext_hdr(u_int8_t nexthdr)
 static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 {
 	struct ulogd_key *ret = pi->output.keys;
-	struct ip6_hdr *ipv6h =
-		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
+	struct ip6_hdr *ipv6h = ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
 	unsigned int ptr, hdrlen = 0;
 	u_int8_t curhdr;
 	int fragment = 0;
@@ -769,20 +727,14 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	if (len < sizeof(struct ip6_hdr))
 		return ULOGD_IRET_OK;
 
-	memcpy(ret[KEY_IP_SADDR].u.value.ui128, &ipv6h->ip6_src,
-	       sizeof(ipv6h->ip6_src));
-	ret[KEY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-	memcpy(ret[KEY_IP_DADDR].u.value.ui128, &ipv6h->ip6_dst,
-	       sizeof(ipv6h->ip6_dst));
-	ret[KEY_IP_DADDR].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP6_PAYLOAD_LEN].u.value.ui16 = ntohs(ipv6h->ip6_plen);
-	ret[KEY_IP6_PAYLOAD_LEN].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP6_PRIORITY].u.value.ui8 = ntohl(ipv6h->ip6_flow & 0x0ff00000) >> 20;
-	ret[KEY_IP6_PRIORITY].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP6_FLOWLABEL].u.value.ui32 = ntohl(ipv6h->ip6_flow & 0x000fffff);
-	ret[KEY_IP6_FLOWLABEL].flags |= ULOGD_RETF_VALID;
-	ret[KEY_IP6_HOPLIMIT].u.value.ui8 = ipv6h->ip6_hlim;
-	ret[KEY_IP6_HOPLIMIT].flags |= ULOGD_RETF_VALID;
+	okey_set_u128(&ret[KEY_IP_SADDR], &ipv6h->ip6_src);
+	okey_set_u128(&ret[KEY_IP_DADDR], &ipv6h->ip6_dst);
+	okey_set_u16(&ret[KEY_IP6_PAYLOAD_LEN], ntohs(ipv6h->ip6_plen));
+	okey_set_u8(&ret[KEY_IP6_PRIORITY],
+		    ntohl(ipv6h->ip6_flow & 0x0ff00000) >> 20);
+	okey_set_u32(&ret[KEY_IP6_FLOWLABEL],
+		     ntohl(ipv6h->ip6_flow & 0x000fffff));
+	okey_set_u8(&ret[KEY_IP6_HOPLIMIT], ipv6h->ip6_hlim);
 
 	curhdr = ipv6h->ip6_nxt;
 	ptr = sizeof(struct ip6_hdr);
@@ -803,10 +755,10 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 				return ULOGD_IRET_OK;
 			len -= hdrlen;
 
-			ret[KEY_IP6_FRAG_OFF].u.value.ui16 = ntohs(fh->ip6f_offlg & IP6F_OFF_MASK);
-			ret[KEY_IP6_FRAG_OFF].flags |= ULOGD_RETF_VALID;
-			ret[KEY_IP6_FRAG_ID].u.value.ui32 = ntohl(fh->ip6f_ident);
-			ret[KEY_IP6_FRAG_ID].flags |= ULOGD_RETF_VALID;
+			okey_set_u16(&ret[KEY_IP6_FRAG_OFF],
+				     ntohs(fh->ip6f_offlg & IP6F_OFF_MASK));
+			okey_set_u32(&ret[KEY_IP6_FRAG_ID],
+				     ntohl(fh->ip6f_ident));
 
 			if (ntohs(fh->ip6f_offlg & IP6F_OFF_MASK))
 				fragment = 1;
@@ -857,8 +809,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 		goto out;
 
 
-	ret[KEY_IP_PROTOCOL].u.value.ui8 = curhdr;
-	ret[KEY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[KEY_IP_PROTOCOL], curhdr);
 
 	switch (curhdr) {
 	case IPPROTO_TCP:
@@ -873,8 +824,7 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	}
 
 out:
-	ret[KEY_IP6_NEXTHDR].u.value.ui8 = curhdr;
-	ret[KEY_IP6_NEXTHDR].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[KEY_IP6_NEXTHDR], curhdr);
 	return ULOGD_IRET_OK;
 }
 
@@ -885,31 +835,19 @@ static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	const struct ether_arp *arph =
-		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
+		ikey_get_ptr(&pi->input.keys[INKEY_RAW_PCKT]);
 
 	if (len < sizeof(struct ether_arp))
 		return ULOGD_IRET_OK;
 
-	ret[KEY_ARP_HTYPE].u.value.ui16 = ntohs(arph->arp_hrd);
-	SET_VALID(ret[KEY_ARP_HTYPE]);
-	ret[KEY_ARP_PTYPE].u.value.ui16 = ntohs(arph->arp_pro);
-	SET_VALID(ret[KEY_ARP_PTYPE]);
-	ret[KEY_ARP_OPCODE].u.value.ui16 = ntohs(arph->arp_op);
-	SET_VALID(ret[KEY_ARP_OPCODE]);
-
-	ret[KEY_ARP_SHA].u.value.ptr = &arph->arp_sha;
-	SET_VALID(ret[KEY_ARP_SHA]);
-
-	memcpy(&ret[KEY_ARP_SPA].u.value.ui32, &arph->arp_spa,
-	       sizeof(u_int32_t));
-	SET_VALID(ret[KEY_ARP_SPA]);
-
-	ret[KEY_ARP_THA].u.value.ptr = &arph->arp_tha;
-	SET_VALID(ret[KEY_ARP_THA]);
+	okey_set_u16(&ret[KEY_ARP_HTYPE], ntohs(arph->arp_hrd));
+	okey_set_u16(&ret[KEY_ARP_PTYPE], ntohs(arph->arp_pro));
+	okey_set_u16(&ret[KEY_ARP_OPCODE], ntohs(arph->arp_op));
 
-	memcpy(&ret[KEY_ARP_TPA].u.value.ui32, &arph->arp_tpa,
-	       sizeof(u_int32_t));
-	SET_VALID(ret[KEY_ARP_TPA]);
+	okey_set_ptr(&ret[KEY_ARP_SHA], &arph->arp_sha);
+	okey_set_ptr(&ret[KEY_ARP_SPA], &arph->arp_spa),
+	okey_set_ptr(&ret[KEY_ARP_THA], &arph->arp_tha);
+	okey_set_ptr(&ret[KEY_ARP_TPA], &arph->arp_tpa);
 
 	return ULOGD_IRET_OK;
 }
@@ -921,7 +859,7 @@ static int _interp_arp(struct ulogd_pluginstance *pi, u_int32_t len)
 static int _interp_bridge(struct ulogd_pluginstance *pi, u_int32_t len)
 {
 	const u_int16_t proto =
-		GET_VALUE(pi->input.keys, INKEY_OOB_PROTOCOL).ui16;
+		ikey_get_u16(&pi->input.keys[INKEY_OOB_PROTOCOL]);
 
 	switch (proto) {
 	case ETH_P_IP:
@@ -942,13 +880,12 @@ static int _interp_bridge(struct ulogd_pluginstance *pi, u_int32_t len)
 
 static int _interp_pkt(struct ulogd_pluginstance *pi)
 {
-	u_int32_t len = GET_VALUE(pi->input.keys, INKEY_RAW_PCKTLEN).ui32;
-	u_int8_t family = GET_VALUE(pi->input.keys, INKEY_OOB_FAMILY).ui8;
+	u_int32_t len = ikey_get_u32(&pi->input.keys[INKEY_RAW_PCKTLEN]);
+	u_int8_t family = ikey_get_u8(&pi->input.keys[INKEY_OOB_FAMILY]);
 	struct ulogd_key *ret = pi->output.keys;
 
-	ret[KEY_OOB_PROTOCOL].u.value.ui16 =
-		GET_VALUE(pi->input.keys, INKEY_OOB_PROTOCOL).ui16;
-	SET_VALID(ret[KEY_OOB_PROTOCOL]);
+	okey_set_u16(&ret[KEY_OOB_PROTOCOL],
+		     ikey_get_u16(&pi->input.keys[INKEY_OOB_PROTOCOL]));
 
 	switch (family) {
 	case AF_INET:
diff --git a/filter/raw2packet/ulogd_raw2packet_LOCAL.c b/filter/raw2packet/ulogd_raw2packet_LOCAL.c
index bf400d7..fdfc7c8 100644
--- a/filter/raw2packet/ulogd_raw2packet_LOCAL.c
+++ b/filter/raw2packet/ulogd_raw2packet_LOCAL.c
@@ -51,11 +51,8 @@ static ulog_iret_t *_interp_local(ulog_interpreter_t *ip,
     gettimeofday(&tv, NULL);
 
     /* put date */
-    ret[0].value.ui32 = (unsigned long) tv.tv_sec;
-    ret[0].flags |= ULOGD_RETF_VALID;
-
-    ret[1].value.ptr = hostname;
-    ret[1].flags |= ULOGD_RETF_VALID;
+    okey_set_ui32(&ret[0], (unsigned long) tv.tv_sec);
+    okey_set_ptr(&ret[1], hostname);
 
     return ret;
 }
diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 8df4f00..33e8316 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -3,6 +3,7 @@
  * ulogd interpreter plugin for HWMAC
  *
  * (C) 2008 by Eric Leblond <eric@inl.fr>
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * Based on ulogd_filter_IFINDEX.c Harald Welte <laforge@gnumonks.org>
  *
@@ -128,32 +129,41 @@ static int parse_mac2str(struct ulogd_key *ret, unsigned char *mac,
 		buf_cur += sprintf(buf_cur, "%02x%c", mac[i],
 				i == len - 1 ? 0 : ':');
 
-	ret[okey].u.value.ptr = mac_str;
-	ret[okey].flags |= ULOGD_RETF_VALID;
+	okey_set_ptr(&ret[okey], mac_str);
 
 	return ULOGD_IRET_OK;
 }
 
+static void *hwhdr_get_saddr(struct ulogd_key *inp)
+{
+	return ikey_get_ptr(&inp[KEY_RAW_MAC]) + ETH_ALEN;
+}
+
+static void *hwhdr_get_daddr(struct ulogd_key *inp)
+{
+	return ikey_get_ptr(&inp[KEY_RAW_MAC]);
+}
+
+static u_int16_t hwhdr_get_len(struct ulogd_key *inp)
+{
+	void *len = ikey_get_ptr(&inp[KEY_RAW_MAC]) + 2 * ETH_ALEN;
+	return ntohs(*(u_int16_t *) len);
+}
 static int parse_ethernet(struct ulogd_key *ret, struct ulogd_key *inp)
 {
 	int fret;
 	if (!pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
-		fret = parse_mac2str(ret, 
-				     GET_VALUE(inp, KEY_RAW_MAC).ptr
-					+ ETH_ALEN,
+		fret = parse_mac2str(ret, hwhdr_get_saddr(inp),
 				     KEY_MAC_SADDR, ETH_ALEN);
 		if (fret != ULOGD_IRET_OK)
 			return fret;
 	}
-	fret = parse_mac2str(ret, GET_VALUE(inp, KEY_RAW_MAC).ptr,
+	fret = parse_mac2str(ret, hwhdr_get_daddr(inp),
 			     KEY_MAC_DADDR, ETH_ALEN);
 	if (fret != ULOGD_IRET_OK)
 		return fret;
 
-	ret[KEY_MAC_PROTOCOL].u.value.ui16 =
-		ntohs(*(u_int16_t *) (GET_VALUE(inp, KEY_RAW_MAC).ptr
-					+ 2 * ETH_ALEN));
-	ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	okey_set_u16(&ret[KEY_MAC_PROTOCOL], hwhdr_get_len(inp));
 
 	return ULOGD_IRET_OK;
 }
@@ -164,46 +174,41 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 	struct ulogd_key *inp = pi->input.keys;
 	u_int16_t type = 0;
 
-	if (pp_is_valid(inp, KEY_OOB_PROTOCOL)) {
-		ret[KEY_MAC_PROTOCOL].u.value.ui16 =
-			GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16;
-		ret[KEY_MAC_PROTOCOL].flags |= ULOGD_RETF_VALID;
-	}
+	if (pp_is_valid(inp, KEY_OOB_PROTOCOL))
+		okey_set_u16(&ret[KEY_MAC_PROTOCOL],
+			     ikey_get_u16(&inp[KEY_OOB_PROTOCOL]));
 
 	if (pp_is_valid(inp, KEY_RAW_MAC_SADDR)) {
 		int fret;
 		fret = parse_mac2str(ret,
-				     GET_VALUE(inp, KEY_RAW_MAC_SADDR).ptr,
+				     ikey_get_ptr(&inp[KEY_RAW_MAC_SADDR]),
 				     KEY_MAC_SADDR,
-				     GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16);
+				     ikey_get_u16(&inp[KEY_RAW_MAC_ADDRLEN]));
 		if (fret != ULOGD_IRET_OK)
 			return fret;
 	}
 
 	if (pp_is_valid(inp, KEY_RAW_MAC)) {
-		if (GET_VALUE(inp, KEY_RAW_MAC_ADDRLEN).ui16 == ETH_ALEN) {
-			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_ETHER;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-		} else {
-			ret[KEY_MAC_TYPE].u.value.ui16 = ARPHRD_VOID;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
-		}
+		if (ikey_get_u16(&inp[KEY_RAW_MAC_ADDRLEN]) == ETH_ALEN)
+			okey_set_u16(&ret[KEY_MAC_TYPE], ARPHRD_ETHER);
+		else
+			okey_set_u16(&ret[KEY_MAC_TYPE], ARPHRD_VOID);
+
 		return ULOGD_IRET_OK;
 	}
 
 	if (pp_is_valid(inp, KEY_RAW_TYPE)) {
 		/* NFLOG with Linux >= 2.6.27 case */
-		ret[KEY_MAC_TYPE].u.value.ui16 = type =
-			GET_VALUE(inp, KEY_RAW_TYPE).ui16;
-		ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		type = ikey_get_u16(&inp[KEY_RAW_TYPE]);
+		okey_set_u16(&ret[KEY_MAC_TYPE], type);
 	} else {
 		/* ULOG case, treat ethernet encapsulation */
-		if (GET_VALUE(inp, KEY_RAW_MACLEN).ui16 == ETH_HLEN) {
-			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_ETHER;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+		if (ikey_get_u16(&inp[KEY_RAW_MACLEN]) == ETH_HLEN) {
+			type = ARPHRD_ETHER;
+			okey_set_u16(&ret[KEY_MAC_TYPE], type);
 		} else {
-			ret[KEY_MAC_TYPE].u.value.ui16 = type = ARPHRD_VOID;
-			ret[KEY_MAC_TYPE].flags |= ULOGD_RETF_VALID;
+			type = ARPHRD_VOID;
+			okey_set_u16(&ret[KEY_MAC_TYPE], type);
 		}
 	}
 
@@ -213,10 +218,9 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 		default:
 			/* convert raw header to string */
 			return parse_mac2str(ret,
-					     GET_VALUE(inp, KEY_RAW_MAC).ptr,
-					     KEY_MAC_ADDR,
-					     GET_VALUE(inp,
-						     KEY_RAW_MACLEN).ui16);
+					    ikey_get_ptr(&inp[KEY_RAW_MAC]),
+					    KEY_MAC_ADDR,
+					    ikey_get_u16(&inp[KEY_RAW_MACLEN]));
 	}
 	return ULOGD_IRET_OK;
 }
diff --git a/filter/ulogd_filter_IFINDEX.c b/filter/ulogd_filter_IFINDEX.c
index f7571bd..f56ee0b 100644
--- a/filter/ulogd_filter_IFINDEX.c
+++ b/filter/ulogd_filter_IFINDEX.c
@@ -3,6 +3,7 @@
  * ulogd interpreter plugin for ifindex to ifname conversion
  *
  * (C) 2005 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 
@@ -61,20 +62,25 @@ static int interp_ifindex(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
+	void *ptr;
 
-	ret[0].u.value.ptr = calloc(IFNAMSIZ, sizeof(char)); 
-	nlif_index2name(nlif_inst, inp[0].u.source->u.value.ui32,
-			ret[0].u.value.ptr);
-	if (((char *)ret[0].u.value.ptr)[0] == '*')
-		((char *)(ret[0].u.value.ptr))[0] = 0; 
-	ret[0].flags |= ULOGD_RETF_VALID;
-
-	ret[1].u.value.ptr = calloc(IFNAMSIZ, sizeof(char)); 
-	nlif_index2name(nlif_inst, inp[1].u.source->u.value.ui32,
-			ret[1].u.value.ptr);
-	if (((char *)ret[1].u.value.ptr)[0] == '*')
-		((char *)(ret[1].u.value.ptr))[0] = 0; 
-	ret[1].flags |= ULOGD_RETF_VALID;
+	ptr = calloc(IFNAMSIZ, sizeof(char));
+	if (!ptr)
+		return ULOGD_IRET_ERR;
+
+	nlif_index2name(nlif_inst, ikey_get_u32(&inp[0]), ptr);
+	if (((char *)ptr)[0] == '*')
+		((char *)(ptr))[0] = 0;
+	okey_set_ptr(&ret[0], ptr);
+
+	ptr = calloc(IFNAMSIZ, sizeof(char));
+	if (!ptr)
+		return ULOGD_IRET_ERR;
+
+	nlif_index2name(nlif_inst, ikey_get_u32(&inp[1]), ptr);
+	if (((char *)ptr)[0] == '*')
+		((char *)(ptr))[0] = 0; 
+	okey_set_ptr(&ret[1], ptr);
 
 	return ULOGD_IRET_OK;
 }
diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 2d9fc16..1d2865e 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -137,12 +137,12 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 
 	switch (family) {
 		case AF_INET6:
-			addr = (struct in6_addr *) GET_VALUE(inp, index).ui128;
+			addr = (struct in6_addr *)ikey_get_u128(&inp[index]);
 			break;
 		case AF_INET:
 			/* Convert IPv4 to IPv4 in IPv6 */
 			addr = &ip4_addr;
-			uint32_to_ipv6(GET_VALUE(inp, index).ui32, addr);
+			uint32_to_ipv6(ikey_get_u32(&inp[index]), addr);
 			break;
 		default:
 			/* TODO handle error */
@@ -176,13 +176,12 @@ static int interp_ip2bin(struct ulogd_pluginstance *pi)
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
 	int i;
-	int oob_family = GET_VALUE(inp, KEY_OOB_FAMILY).ui8;
+	int oob_family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
 
 	/* Iter on all addr fields */
 	for(i = START_KEY; i < MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			ret[i-1].u.value.ptr = ip2bin(inp, i, oob_family);
-			ret[i-1].flags |= ULOGD_RETF_VALID;
+			okey_set_ptr(&ret[i-1], ip2bin(inp, i, oob_family));
 		}
 	}
 
diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index a1c1e87..df94c72 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -145,7 +145,7 @@ static struct ulogd_key ip2str_keys[] = {
 static char *ip2str(struct ulogd_key *inp, int index)
 {
 	char tmp[IPADDR_LENGTH];
-	char family = GET_VALUE(inp, KEY_OOB_FAMILY).ui8;
+	char family = ikey_get_u8(&inp[KEY_OOB_FAMILY]);
 	char convfamily = family;
 
 	if (family == AF_BRIDGE) {
@@ -154,7 +154,7 @@ static char *ip2str(struct ulogd_key *inp, int index)
 				  "No protocol inside AF_BRIDGE packet\n");
 			return NULL;
 		}
-		switch (GET_VALUE(inp, KEY_OOB_PROTOCOL).ui16) {
+		switch (ikey_get_u16(&inp[KEY_OOB_PROTOCOL])) {
 		case ETH_P_IPV6:
 			convfamily = AF_INET6;
 			break;
@@ -172,15 +172,15 @@ static char *ip2str(struct ulogd_key *inp, int index)
 	}
 
 	switch (convfamily) {
+		u_int32_t ip;
 	case AF_INET6:
 		inet_ntop(AF_INET6,
-			  GET_VALUE(inp, index).ui128,
+			  ikey_get_u128(&inp[index]),
 			  tmp, sizeof(tmp));
 		break;
 	case AF_INET:
-		inet_ntop(AF_INET,
-			  &GET_VALUE(inp, index).ui32,
-			  tmp, sizeof(tmp));
+		ip = ikey_get_u32(&inp[index]);
+		inet_ntop(AF_INET, &ip, tmp, sizeof(tmp));
 		break;
 	default:
 		/* TODO error handling */
@@ -199,8 +199,7 @@ static int interp_ip2str(struct ulogd_pluginstance *pi)
 	/* Iter on all addr fields */
 	for (i = START_KEY; i <= MAX_KEY; i++) {
 		if (pp_is_valid(inp, i)) {
-			ret[i-START_KEY].u.value.ptr = ip2str(inp, i);
-			ret[i-START_KEY].flags |= ULOGD_RETF_VALID;
+			okey_set_ptr(&ret[i-START_KEY], ip2str(inp, i));
 		}
 	}
 
diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index 98f5dae..1a7c2fd 100644
--- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -72,14 +72,14 @@ static int interp_mark(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *inp = pi->input.keys;
 	if (pp_is_valid(inp, KEY_CT_MARK)) {
-		if ((GET_VALUE(inp, KEY_CT_MARK).ui32 &
+		if ((ikey_get_u32(&inp[KEY_CT_MARK]) &
 			pi->config_kset->ces[MARK_MASK].u.value) !=
 			(u_int32_t) pi->config_kset->ces[MARK_MARK].u.value
 		   ) {
 			return ULOGD_IRET_STOP;
 		}
 	} else if (pp_is_valid(inp, KEY_OOB_MARK)) {
-		if ((GET_VALUE(inp, KEY_OOB_MARK).ui32 &
+		if ((ikey_get_u32(&inp[KEY_OOB_MARK]) &
 			pi->config_kset->ces[MARK_MASK].u.value) !=
 			(u_int32_t) pi->config_kset->ces[MARK_MARK].u.value
 		   ) {
diff --git a/filter/ulogd_filter_PRINTFLOW.c b/filter/ulogd_filter_PRINTFLOW.c
index b78c37b..1de1ba6 100644
--- a/filter/ulogd_filter_PRINTFLOW.c
+++ b/filter/ulogd_filter_PRINTFLOW.c
@@ -37,8 +37,7 @@ static int printflow_interp(struct ulogd_pluginstance *upi)
 	static char buf[4096];
 
 	printflow_print(inp, buf);
-	ret[0].u.value.ptr = buf;
-	ret[0].flags |= ULOGD_RETF_VALID;
+	okey_set_ptr(&ret[0], buf);
 	return ULOGD_IRET_OK;
 }
 
diff --git a/filter/ulogd_filter_PRINTPKT.c b/filter/ulogd_filter_PRINTPKT.c
index 62a3cf7..3313194 100644
--- a/filter/ulogd_filter_PRINTPKT.c
+++ b/filter/ulogd_filter_PRINTPKT.c
@@ -37,8 +37,7 @@ static int printpkt_interp(struct ulogd_pluginstance *upi)
 	static char buf[4096];
 
 	printpkt_print(inp, buf);
-	ret[0].u.value.ptr = buf;
-	ret[0].flags |= ULOGD_RETF_VALID;
+	okey_set_ptr(&ret[0], buf);
 	return ULOGD_IRET_OK;
 }
 
diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 3cbafb6..a6cbf94 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -116,25 +116,22 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 	}
 
 	if (len) {
-		ret[0].u.value.ptr = (char *) malloc(len+1);
-		ret[0].flags |= ULOGD_RETF_VALID;
-		if (!ret[0].u.value.ptr) {
-			ulogd_log(ULOGD_ERROR, "OOM (size=%u)\n", len);
+		char *ptr;
+		ptr = (char *) malloc(len+1);
+		if (!ptr)
 			return ULOGD_IRET_ERR;
-		}
-		strncpy((char *) ret[0].u.value.ptr, (char *)begp, len);
-		*((char *)ret[0].u.value.ptr + len) = '\0';
+		strncpy(ptr, (char *)begp, len);
+		ptr[len] = '\0';
+		okey_set_ptr(&ret[0], ptr);
 	}
 	if (pw_len) {
-		ret[1].u.value.ptr = (char *) malloc(pw_len+1);
-		ret[1].flags |= ULOGD_RETF_VALID;
-		if (!ret[1].u.value.ptr){
-			ulogd_log(ULOGD_ERROR, "OOM (size=%u)\n", pw_len);
+		char *ptr;
+		ptr = (char *) malloc(pw_len+1);
+		if (!ptr)
 			return ULOGD_IRET_ERR;
-		}
-		strncpy((char *)ret[1].u.value.ptr, (char *)pw_begp, pw_len);
-		*((char *)ret[1].u.value.ptr + pw_len) = '\0';
-
+		strncpy(ptr, (char *)pw_begp, pw_len);
+		ptr[pw_len] = '\0';
+		okey_set_ptr(&ret[1], ptr);
 	}
 	return ULOGD_IRET_OK;
 }
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 776111a..3f6d784 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -18,6 +18,7 @@
 #include <stdio.h>
 #include <signal.h>	/* need this because of extension-sighandler */
 #include <sys/types.h>
+#include <string.h>
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
@@ -126,6 +127,64 @@ struct ulogd_keyset {
 	unsigned int type;
 };
 
+static inline void okey_set_b(struct ulogd_key *key, u_int8_t value)
+{
+	key->u.value.b = value;
+	key->flags |= ULOGD_RETF_VALID;
+}
+
+static inline void okey_set_u8(struct ulogd_key *key, u_int8_t value)
+{
+	key->u.value.ui8 = value;
+	key->flags |= ULOGD_RETF_VALID;
+}
+
+static inline void okey_set_u16(struct ulogd_key *key, u_int16_t value)
+{
+	key->u.value.ui16 = value;
+	key->flags |= ULOGD_RETF_VALID;
+}
+
+static inline void okey_set_u32(struct ulogd_key *key, u_int32_t value)
+{
+	key->u.value.ui32 = value;
+	key->flags |= ULOGD_RETF_VALID;
+}
+
+static inline void okey_set_u128(struct ulogd_key *key, const void *value)
+{
+	memcpy(key->u.value.ui128, value, 16);
+	key->flags |= ULOGD_RETF_VALID;
+}
+
+static inline void okey_set_ptr(struct ulogd_key *key, void *value)
+{
+	key->u.value.ptr = value;
+	key->flags |= ULOGD_RETF_VALID;
+}
+
+static inline u_int8_t ikey_get_u8(struct ulogd_key *key)
+{
+	return key->u.source->u.value.ui8;
+}
+
+static inline u_int16_t ikey_get_u16(struct ulogd_key *key)
+{
+	return key->u.source->u.value.ui16;
+}
+
+static inline u_int32_t ikey_get_u32(struct ulogd_key *key)
+{
+	return key->u.source->u.value.ui32;
+}
+
+#define ikey_get_u128 ikey_get_ptr
+
+static inline void *ikey_get_ptr(struct ulogd_key *key)
+{
+	return key->u.source->u.value.ptr;
+}
+
 struct ulogd_pluginstance_stack;
 struct ulogd_pluginstance;
 struct ulogd_plugin {
@@ -221,7 +280,6 @@ void __ulogd_log(int level, char *file, int line, const char *message, ...);
 #define IS_NEEDED(x)	(x.flags & ULOGD_RETF_NEEDED)
 #define SET_NEEDED(x)	(x.flags |= ULOGD_RETF_NEEDED)
 
-#define GET_VALUE(res, x)	(res[x].u.source->u.value)
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
 #define pp_is_valid(res, x)	\
 	(res[x].u.source && (GET_FLAGS(res, x) & ULOGD_RETF_VALID))
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 58bb0e2..a33ec35 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -443,67 +443,39 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 {
 	struct ulogd_key *ret = upi->output.keys;
 
-	ret[NFCT_CT_EVENT].u.value.ui32 = type;
-	ret[NFCT_CT_EVENT].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_OOB_FAMILY].u.value.ui8 = nfct_get_attr_u8(ct, ATTR_L3PROTO);
-	ret[NFCT_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-	/* FIXME */
-	ret[NFCT_OOB_PROTOCOL].u.value.ui8 = 0;
-	ret[NFCT_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[NFCT_CT_EVENT], type);
+	okey_set_u8(&ret[NFCT_OOB_FAMILY], nfct_get_attr_u8(ct, ATTR_L3PROTO));
+	okey_set_u8(&ret[NFCT_OOB_PROTOCOL], 0); /* FIXME */
 
 	switch (nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
 	case AF_INET:
-		ret[NFCT_ORIG_IP_SADDR].u.value.ui32 =
-			nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_SRC);
-		ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_ORIG_IP_DADDR].u.value.ui32 =
-			nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_DST);
-		ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_REPLY_IP_SADDR].u.value.ui32 =
-			nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC);
-		ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_REPLY_IP_DADDR].u.value.ui32 =
-			nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST);
-		ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
+		okey_set_u32(&ret[NFCT_ORIG_IP_SADDR],
+			     nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_SRC));
+		okey_set_u32(&ret[NFCT_ORIG_IP_DADDR],
+			     nfct_get_attr_u32(ct, ATTR_ORIG_IPV4_DST));
+		okey_set_u32(&ret[NFCT_REPLY_IP_SADDR],
+			     nfct_get_attr_u32(ct, ATTR_REPL_IPV4_SRC));
+		okey_set_u32(&ret[NFCT_REPLY_IP_DADDR],
+			     nfct_get_attr_u32(ct, ATTR_REPL_IPV4_DST));
 		break;
 	case AF_INET6:
-		memcpy(ret[NFCT_ORIG_IP_SADDR].u.value.ui128,
-		       nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC),
-		       sizeof(int32_t) * 4);
-		ret[NFCT_ORIG_IP_SADDR].flags |= ULOGD_RETF_VALID;
-
-		memcpy(ret[NFCT_ORIG_IP_DADDR].u.value.ui128,
-		       nfct_get_attr(ct, ATTR_ORIG_IPV6_DST),
-		       sizeof(int32_t) * 4);
-		ret[NFCT_ORIG_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
-		memcpy(ret[NFCT_REPLY_IP_SADDR].u.value.ui128,
-		       nfct_get_attr(ct, ATTR_REPL_IPV6_SRC),
-		       sizeof(int32_t) * 4);
-		ret[NFCT_REPLY_IP_SADDR].flags |= ULOGD_RETF_VALID;
-
-		memcpy(ret[NFCT_REPLY_IP_DADDR].u.value.ui128,
-		       nfct_get_attr(ct, ATTR_REPL_IPV6_DST),
-		       sizeof(int32_t) * 4);
-		ret[NFCT_REPLY_IP_DADDR].flags |= ULOGD_RETF_VALID;
-
+		okey_set_u128(&ret[NFCT_ORIG_IP_SADDR],
+			      nfct_get_attr(ct, ATTR_ORIG_IPV6_SRC));
+		okey_set_u128(&ret[NFCT_ORIG_IP_DADDR],
+			      nfct_get_attr(ct, ATTR_ORIG_IPV6_DST));
+		okey_set_u128(&ret[NFCT_REPLY_IP_SADDR],
+			      nfct_get_attr(ct, ATTR_REPL_IPV6_SRC));
+		okey_set_u128(&ret[NFCT_REPLY_IP_DADDR],
+			      nfct_get_attr(ct, ATTR_REPL_IPV6_DST));
 		break;
 	default:
 		ulogd_log(ULOGD_NOTICE, "Unknown protocol family (%d)\n",
 			  nfct_get_attr_u8(ct, ATTR_L3PROTO));
 	}
-	ret[NFCT_ORIG_IP_PROTOCOL].u.value.ui8 =
-		nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO);
-	ret[NFCT_ORIG_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_REPLY_IP_PROTOCOL].u.value.ui8 =
-		nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO);
-	ret[NFCT_REPLY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[NFCT_ORIG_IP_PROTOCOL],
+		    nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO));
+	okey_set_u8(&ret[NFCT_REPLY_IP_PROTOCOL],
+		    nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO));
 
 	switch (nfct_get_attr_u8(ct, ATTR_ORIG_L4PROTO)) {
 	case IPPROTO_TCP:
@@ -511,22 +483,16 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 	case IPPROTO_UDPLITE:
 	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
-		ret[NFCT_ORIG_L4_SPORT].u.value.ui16 =
-			htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC));
-		ret[NFCT_ORIG_L4_SPORT].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_ORIG_L4_DPORT].u.value.ui16 =
-			htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST));
-		ret[NFCT_ORIG_L4_DPORT].flags |= ULOGD_RETF_VALID;
+		okey_set_u16(&ret[NFCT_ORIG_L4_SPORT],
+			     htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_SRC)));
+		okey_set_u16(&ret[NFCT_ORIG_L4_DPORT],
+			     htons(nfct_get_attr_u16(ct, ATTR_ORIG_PORT_DST)));
 		break;
 	case IPPROTO_ICMP:
-		ret[NFCT_ICMP_CODE].u.value.ui8 =
-			nfct_get_attr_u8(ct, ATTR_ICMP_CODE);
-		ret[NFCT_ICMP_CODE].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_ICMP_TYPE].u.value.ui8 =
-			nfct_get_attr_u8(ct, ATTR_ICMP_TYPE);
-		ret[NFCT_ICMP_TYPE].flags |= ULOGD_RETF_VALID;
+		okey_set_u16(&ret[NFCT_ICMP_CODE],
+			     nfct_get_attr_u8(ct, ATTR_ICMP_CODE));
+		okey_set_u16(&ret[NFCT_ICMP_TYPE],
+			     nfct_get_attr_u8(ct, ATTR_ICMP_TYPE));
 		break;
 	}
 
@@ -536,55 +502,36 @@ static int propagate_ct(struct ulogd_pluginstance *upi,
 	case IPPROTO_UDPLITE:
 	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
-		ret[NFCT_REPLY_L4_SPORT].u.value.ui16 =
-			htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC));
-		ret[NFCT_REPLY_L4_SPORT].flags |= ULOGD_RETF_VALID;
-
-		ret[NFCT_REPLY_L4_DPORT].u.value.ui16 =
-			htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST));
-		ret[NFCT_REPLY_L4_DPORT].flags |= ULOGD_RETF_VALID;
+		okey_set_u16(&ret[NFCT_REPLY_L4_SPORT],
+			     htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_SRC)));
+		okey_set_u16(&ret[NFCT_REPLY_L4_DPORT],
+			     htons(nfct_get_attr_u16(ct, ATTR_REPL_PORT_DST)));
 	}
 
-	ret[NFCT_ORIG_RAW_PKTLEN].u.value.ui32 =
-		nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES);
-	ret[NFCT_ORIG_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_ORIG_RAW_PKTCOUNT].u.value.ui32 =
-		nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS);
-	ret[NFCT_ORIG_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_REPLY_RAW_PKTLEN].u.value.ui32 =
-		nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES);;
-	ret[NFCT_REPLY_RAW_PKTLEN].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[NFCT_ORIG_RAW_PKTLEN],
+		     nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_BYTES));
+	okey_set_u32(&ret[NFCT_ORIG_RAW_PKTCOUNT],
+		     nfct_get_attr_u32(ct, ATTR_ORIG_COUNTER_PACKETS));
+	okey_set_u32(&ret[NFCT_REPLY_RAW_PKTLEN],
+		     nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_BYTES));
+	okey_set_u32(&ret[NFCT_REPLY_RAW_PKTCOUNT],
+		     nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS));
 
-	ret[NFCT_REPLY_RAW_PKTCOUNT].u.value.ui32 =
-		nfct_get_attr_u32(ct, ATTR_REPL_COUNTER_PACKETS);
-	ret[NFCT_REPLY_RAW_PKTCOUNT].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_CT_MARK].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_MARK);
-	ret[NFCT_CT_MARK].flags |= ULOGD_RETF_VALID;
-
-	ret[NFCT_CT_ID].u.value.ui32 = nfct_get_attr_u32(ct, ATTR_ID);
-	ret[NFCT_CT_ID].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[NFCT_CT_MARK], nfct_get_attr_u32(ct, ATTR_MARK));
+	okey_set_u32(&ret[NFCT_CT_ID], nfct_get_attr_u32(ct, ATTR_ID));
 
 	if (ts) {
 		if (ts->time[START].tv_sec) {
-			ret[NFCT_FLOW_START_SEC].u.value.ui32 =
-				ts->time[START].tv_sec;
-			ret[NFCT_FLOW_START_SEC].flags |= ULOGD_RETF_VALID;
-
-			ret[NFCT_FLOW_START_USEC].u.value.ui32 =
-				ts->time[START].tv_usec;
-			ret[NFCT_FLOW_START_USEC].flags |= ULOGD_RETF_VALID;
+			okey_set_u32(&ret[NFCT_FLOW_START_SEC],
+				     ts->time[START].tv_sec);
+			okey_set_u32(&ret[NFCT_FLOW_START_USEC],
+				     ts->time[START].tv_usec);
 		}
 		if (ts->time[STOP].tv_sec) {
-			ret[NFCT_FLOW_END_SEC].u.value.ui32 =
-				ts->time[STOP].tv_sec;
-			ret[NFCT_FLOW_END_SEC].flags |= ULOGD_RETF_VALID;
-
-			ret[NFCT_FLOW_END_USEC].u.value.ui32 =
-				ts->time[STOP].tv_usec;
-			ret[NFCT_FLOW_END_USEC].flags |= ULOGD_RETF_VALID;
+			okey_set_u32(&ret[NFCT_FLOW_END_SEC],
+				     ts->time[STOP].tv_sec);
+			okey_set_u32(&ret[NFCT_FLOW_END_USEC],
+				     ts->time[STOP].tv_usec);
 		}
 	}
 
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 39f915a..5d25eec 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -310,59 +310,43 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	u_int32_t uid;
 	u_int32_t gid;
 
-	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
-	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-
-	ret[NFLOG_KEY_RAW_LABEL].u.value.ui8 =
-			label_ce(upi->config_kset).u.value;
-	ret[NFLOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], 
+		    af_ce(upi->config_kset).u.value);
+	okey_set_u8(&ret[NFLOG_KEY_RAW_LABEL],
+		    label_ce(upi->config_kset).u.value);
 
 	if (ph) {
 		/* FIXME */
-		ret[NFLOG_KEY_OOB_HOOK].u.value.ui8 = ph->hook;
-		ret[NFLOG_KEY_OOB_HOOK].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_OOB_PROTOCOL].u.value.ui16 =
-					ntohs(ph->hw_protocol);
-		ret[NFLOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
+		okey_set_u8(&ret[NFLOG_KEY_OOB_HOOK], ph->hook);
+		okey_set_u16(&ret[NFLOG_KEY_OOB_PROTOCOL],
+			     ntohs(ph->hw_protocol));
 	}
 
 	if (nflog_get_msg_packet_hwhdrlen(ldata)) {
-		ret[NFLOG_KEY_RAW_MAC].u.value.ptr =
-			nflog_get_msg_packet_hwhdr(ldata);
-		ret[NFLOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_MAC_LEN].u.value.ui16 =
-			nflog_get_msg_packet_hwhdrlen(ldata);
-		ret[NFLOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_TYPE].u.value.ui16 =
-			nflog_get_hwtype(ldata);
-		ret[NFLOG_KEY_RAW_TYPE].flags |= ULOGD_RETF_VALID;
+		okey_set_ptr(&ret[NFLOG_KEY_RAW_MAC], 
+			     nflog_get_msg_packet_hwhdr(ldata));
+		okey_set_u16(&ret[NFLOG_KEY_RAW_MAC_LEN],
+			     nflog_get_msg_packet_hwhdrlen(ldata));
+		okey_set_u16(&ret[NFLOG_KEY_RAW_TYPE], nflog_get_hwtype(ldata));
 	}
 
 	if (hw) {
-		ret[NFLOG_KEY_RAW_MAC_SADDR].u.value.ptr = hw->hw_addr;
-		ret[NFLOG_KEY_RAW_MAC_SADDR].flags |= ULOGD_RETF_VALID;
-		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].u.value.ui16 =
-						ntohs(hw->hw_addrlen);
-		ret[NFLOG_KEY_RAW_MAC_ADDRLEN].flags |= ULOGD_RETF_VALID;
+		okey_set_ptr(&ret[NFLOG_KEY_RAW_MAC_SADDR], hw->hw_addr);
+		okey_set_u16(&ret[NFLOG_KEY_RAW_MAC_ADDRLEN], 
+			     ntohs(hw->hw_addrlen));
 	}
 
 	if (payload_len >= 0) {
 		/* include pointer to raw packet */
-		ret[NFLOG_KEY_RAW_PCKT].u.value.ptr = payload;
-		ret[NFLOG_KEY_RAW_PCKT].flags |= ULOGD_RETF_VALID;
-
-		ret[NFLOG_KEY_RAW_PCKTLEN].u.value.ui32 = payload_len;
-		ret[NFLOG_KEY_RAW_PCKTLEN].flags |= ULOGD_RETF_VALID;
+		okey_set_ptr(&ret[NFLOG_KEY_RAW_PCKT], payload);
+		okey_set_u32(&ret[NFLOG_KEY_RAW_PCKTLEN], payload_len);
 	}
 
 	/* number of packets */
-	ret[NFLOG_KEY_RAW_PCKTCOUNT].u.value.ui32 = 1;
-	ret[NFLOG_KEY_RAW_PCKTCOUNT].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[NFLOG_KEY_RAW_PCKTCOUNT], 1);
 
-	if (prefix) {
-		ret[NFLOG_KEY_OOB_PREFIX].u.value.ptr = prefix;
-		ret[NFLOG_KEY_OOB_PREFIX].flags |= ULOGD_RETF_VALID;
-	}
+	if (prefix)
+		okey_set_ptr(&ret[NFLOG_KEY_OOB_PREFIX], prefix);
 
 	/* god knows why timestamp_usec contains crap if timestamp_sec
 	 * == 0 if (pkt->timestamp_sec || pkt->timestamp_usec) { */
@@ -370,41 +354,26 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 		gettimeofday(&ts, NULL);
 
 	/* FIXME: convert endianness */
-	ret[NFLOG_KEY_OOB_TIME_SEC].u.value.ui32 = ts.tv_sec & 0xffffffff;
-	ret[NFLOG_KEY_OOB_TIME_SEC].flags |= ULOGD_RETF_VALID;
-	ret[NFLOG_KEY_OOB_TIME_USEC].u.value.ui32 = ts.tv_usec & 0xffffffff;
-	ret[NFLOG_KEY_OOB_TIME_USEC].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[NFLOG_KEY_OOB_TIME_SEC], ts.tv_sec & 0xffffffff);
+	okey_set_u32(&ret[NFLOG_KEY_OOB_TIME_USEC], ts.tv_usec & 0xffffffff);
 
-	ret[NFLOG_KEY_OOB_MARK].u.value.ui32 = mark;
-	ret[NFLOG_KEY_OOB_MARK].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[NFLOG_KEY_OOB_MARK], mark);
 
-	if (indev > 0) {
-		ret[NFLOG_KEY_OOB_IFINDEX_IN].u.value.ui32 = indev;
-		ret[NFLOG_KEY_OOB_IFINDEX_IN].flags |= ULOGD_RETF_VALID;
-	}
+	if (indev > 0)
+		okey_set_u32(&ret[NFLOG_KEY_OOB_IFINDEX_IN], indev);
 
-	if (outdev > 0) {
-		ret[NFLOG_KEY_OOB_IFINDEX_OUT].u.value.ui32 = outdev;
-		ret[NFLOG_KEY_OOB_IFINDEX_OUT].flags |= ULOGD_RETF_VALID;
-	}
+	if (outdev > 0)
+		okey_set_u32(&ret[NFLOG_KEY_OOB_IFINDEX_OUT], outdev);
 
-	if (nflog_get_uid(ldata, &uid) == 0) {
-		ret[NFLOG_KEY_OOB_UID].u.value.ui32 = uid;
-		ret[NFLOG_KEY_OOB_UID].flags |= ULOGD_RETF_VALID;
-	}
-	if (nflog_get_gid(ldata, &gid) == 0) {
-		ret[NFLOG_KEY_OOB_GID].u.value.ui32 = gid;
-		ret[NFLOG_KEY_OOB_GID].flags |= ULOGD_RETF_VALID;
-	}
+	if (nflog_get_uid(ldata, &uid) == 0)
+		okey_set_u32(&ret[NFLOG_KEY_OOB_UID], uid);
+	if (nflog_get_gid(ldata, &gid) == 0)
+		okey_set_u32(&ret[NFLOG_KEY_OOB_GID], gid);
+	if (nflog_get_seq(ldata, &seq) == 0)
+		okey_set_u32(&ret[NFLOG_KEY_OOB_SEQ_LOCAL], seq);
+	if (nflog_get_seq_global(ldata, &seq) == 0)
+		okey_set_u32(&ret[NFLOG_KEY_OOB_SEQ_GLOBAL], seq);
 
-	if (nflog_get_seq(ldata, &seq) == 0) {
-		ret[NFLOG_KEY_OOB_SEQ_LOCAL].u.value.ui32 = seq;
-		ret[NFLOG_KEY_OOB_SEQ_LOCAL].flags |= ULOGD_RETF_VALID;
-	}
-	if (nflog_get_seq_global(ldata, &seq) == 0) {
-		ret[NFLOG_KEY_OOB_SEQ_GLOBAL].u.value.ui32 = seq;
-		ret[NFLOG_KEY_OOB_SEQ_GLOBAL].flags |= ULOGD_RETF_VALID;
-	}
 	ulogd_propagate_results(upi);
 	return 0;
 }
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 3fdb42e..00975de 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -190,54 +190,39 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 	struct ulogd_key *ret = ip->output.keys;
 
 	if (pkt->mac_len) {
-		ret[ULOG_KEY_RAW_MAC].u.value.ptr = pkt->mac;
-		ret[ULOG_KEY_RAW_MAC].flags |= ULOGD_RETF_VALID;
-		ret[ULOG_KEY_RAW_MAC_LEN].u.value.ui16 = pkt->mac_len;
-		ret[ULOG_KEY_RAW_MAC_LEN].flags |= ULOGD_RETF_VALID;
+		okey_set_ptr(&ret[ULOG_KEY_RAW_MAC], pkt->mac);
+		okey_set_u16(&ret[ULOG_KEY_RAW_MAC_LEN], pkt->mac_len);
 	}
 
-	ret[ULOG_KEY_RAW_LABEL].u.value.ui8 = ip->config_kset->ces[3].u.value;
-	ret[ULOG_KEY_RAW_LABEL].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[ULOG_KEY_RAW_LABEL], ip->config_kset->ces[3].u.value);
 
 	/* include pointer to raw ipv4 packet */
-	ret[ULOG_KEY_RAW_PCKT].u.value.ptr = pkt->payload;
-	ret[ULOG_KEY_RAW_PCKT].flags |= ULOGD_RETF_VALID;
-	ret[ULOG_KEY_RAW_PCKTLEN].u.value.ui32 = pkt->data_len;
-	ret[ULOG_KEY_RAW_PCKTLEN].flags |= ULOGD_RETF_VALID;
-	ret[ULOG_KEY_RAW_PCKTCOUNT].u.value.ui32 = 1;
-	ret[ULOG_KEY_RAW_PCKTCOUNT].flags |= ULOGD_RETF_VALID;
+	okey_set_ptr(&ret[ULOG_KEY_RAW_PCKT], pkt->payload);
+	okey_set_u32(&ret[ULOG_KEY_RAW_PCKTLEN], pkt->data_len);
+	okey_set_u32(&ret[ULOG_KEY_RAW_PCKTCOUNT], 1);
 
-	ret[ULOG_KEY_OOB_PREFIX].u.value.ptr = pkt->prefix;
-	ret[ULOG_KEY_OOB_PREFIX].flags |= ULOGD_RETF_VALID;
+	okey_set_ptr(&ret[ULOG_KEY_OOB_PREFIX], pkt->prefix);
 
 	/* god knows why timestamp_usec contains crap if timestamp_sec == 0
 	 * if (pkt->timestamp_sec || pkt->timestamp_usec) { */
 	if (pkt->timestamp_sec) {
-		ret[ULOG_KEY_OOB_TIME_SEC].u.value.ui32 = pkt->timestamp_sec;
-		ret[ULOG_KEY_OOB_TIME_SEC].flags |= ULOGD_RETF_VALID;
-		ret[ULOG_KEY_OOB_TIME_USEC].u.value.ui32 = pkt->timestamp_usec;
-		ret[ULOG_KEY_OOB_TIME_USEC].flags |= ULOGD_RETF_VALID;
+		okey_set_u32(&ret[ULOG_KEY_OOB_TIME_SEC], pkt->timestamp_sec);
+		okey_set_u32(&ret[ULOG_KEY_OOB_TIME_USEC], pkt->timestamp_usec);
 	} else {
 		ret[ULOG_KEY_OOB_TIME_SEC].flags &= ~ULOGD_RETF_VALID;
 		ret[ULOG_KEY_OOB_TIME_USEC].flags &= ~ULOGD_RETF_VALID;
 	}
 
-	ret[ULOG_KEY_OOB_MARK].u.value.ui32 = pkt->mark;
-	ret[ULOG_KEY_OOB_MARK].flags |= ULOGD_RETF_VALID;
-	ret[ULOG_KEY_OOB_IN].u.value.ptr = pkt->indev_name;
-	ret[ULOG_KEY_OOB_IN].flags |= ULOGD_RETF_VALID;
-	ret[ULOG_KEY_OOB_OUT].u.value.ptr = pkt->outdev_name;
-	ret[ULOG_KEY_OOB_OUT].flags |= ULOGD_RETF_VALID;
+	okey_set_u32(&ret[ULOG_KEY_OOB_MARK], pkt->mark);
+	okey_set_ptr(&ret[ULOG_KEY_OOB_IN], pkt->indev_name);
+	okey_set_ptr(&ret[ULOG_KEY_OOB_OUT], pkt->outdev_name);
 
-	ret[ULOG_KEY_OOB_HOOK].u.value.ui8 = pkt->hook;
-	ret[ULOG_KEY_OOB_HOOK].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[ULOG_KEY_OOB_HOOK], pkt->hook);
 
 	/* ULOG is IPv4 only */
-	ret[ULOG_KEY_OOB_FAMILY].u.value.ui8 = AF_INET;
-	ret[ULOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
+	okey_set_u8(&ret[ULOG_KEY_OOB_FAMILY], AF_INET);
 	/* Undef in ULOG but necessary */
-	ret[ULOG_KEY_OOB_PROTOCOL].u.value.ui16 = 0;
-	ret[ULOG_KEY_OOB_PROTOCOL].flags |= ULOGD_RETF_VALID;
+	okey_set_u16(&ret[ULOG_KEY_OOB_PROTOCOL], 0);
 
 	ulogd_propagate_results(ip);
 	return 0;
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index ce4393c..09120a1 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -126,7 +126,6 @@ static struct ulogd_key pcap_keys[INTR_IDS] = {
 	{ .name = "oob.time.usec" },
 };
 
-#define GET_VALUE(res, x)	(res[x].u.source->u.value)
 #define GET_FLAGS(res, x)	(res[x].u.source->flags)
 
 static int interp_pcap(struct ulogd_pluginstance *upi)
@@ -135,13 +134,13 @@ static int interp_pcap(struct ulogd_pluginstance *upi)
 	struct ulogd_key *res = upi->input.keys;
 	struct pcap_sf_pkthdr pchdr;
 
-	pchdr.caplen = GET_VALUE(res, 2).ui32;
-	pchdr.len = GET_VALUE(res, 2).ui32;
+	pchdr.caplen = ikey_get_u32(&res[2]);
+	pchdr.len = ikey_get_u32(&res[2]);
 
 	if (GET_FLAGS(res, 3) & ULOGD_RETF_VALID
 	    && GET_FLAGS(res, 4) & ULOGD_RETF_VALID) {
-		pchdr.ts.tv_sec = GET_VALUE(res, 3).ui32;
-		pchdr.ts.tv_usec = GET_VALUE(res, 4).ui32;
+		pchdr.ts.tv_sec = ikey_get_u32(&res[3]);
+		pchdr.ts.tv_usec = ikey_get_u32(&res[4]);
 	} else {
 		/* use current system time */
 		struct timeval tv;
@@ -156,7 +155,7 @@ static int interp_pcap(struct ulogd_pluginstance *upi)
 			  strerror(errno));
 		return ULOGD_IRET_ERR;
 	}
-	if (fwrite(GET_VALUE(res, 0).ptr, pchdr.caplen, 1, pi->of) != 1) {
+	if (fwrite(ikey_get_ptr(&res[0]), pchdr.caplen, 1, pi->of) != 1) {
 		ulogd_log(ULOGD_ERROR, "Error during write: %s\n",
 			  strerror(errno));
 		return ULOGD_IRET_ERR;
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 0ab2be4..f5296e8 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -125,28 +125,28 @@ nacct_interp(struct ulogd_pluginstance *pi)
 
 	/* try to be as close to nacct as possible.  Instead of nacct's
 	   'timestamp' value use 'flow.end.sec' */
-	if (GET_VALUE(inp, KEY_IP_PROTO).ui8 == IPPROTO_ICMP) {
+	if (ikey_get_u8(&inp[KEY_IP_PROTO]) == IPPROTO_ICMP) {
 		snprintf(buf, sizeof(buf),
 				 "%u\t%u\t%s\t%u\t%s\t%u\t%u\t%u",
-				 GET_VALUE(inp, KEY_FLOW_END).ui32,
-				 GET_VALUE(inp, KEY_IP_PROTO).ui8,
-				 (char *) GET_VALUE(inp, KEY_IP_SADDR).ptr,
-				 GET_VALUE(inp, KEY_ICMP_TYPE).ui8,
-				 (char *) GET_VALUE(inp, KEY_IP_DADDR).ptr,
-				 GET_VALUE(inp, KEY_ICMP_CODE).ui8,
-				 GET_VALUE(inp, KEY_RAW_PKTCNT).ui32,
-				 GET_VALUE(inp, KEY_RAW_PKTLEN).ui32);
+				 ikey_get_u32(&inp[KEY_FLOW_END]),
+				 ikey_get_u8(&inp[KEY_IP_PROTO]),
+				 (char *) ikey_get_ptr(&inp[KEY_IP_SADDR]),
+				 ikey_get_u8(&inp[KEY_ICMP_TYPE]),
+				 (char *) ikey_get_ptr(&inp[KEY_IP_DADDR]),
+				 ikey_get_u8(&inp[KEY_ICMP_CODE]),
+				 ikey_get_u32(&inp[KEY_RAW_PKTCNT]),
+				 ikey_get_u32(&inp[KEY_RAW_PKTLEN]));
 	} else {
 		snprintf(buf, sizeof(buf),
 				 "%u\t%u\t%s\t%u\t%s\t%u\t%u\t%u",
-				 GET_VALUE(inp, KEY_FLOW_END).ui32,
-				 GET_VALUE(inp, KEY_IP_PROTO).ui8,
-				 (char *) GET_VALUE(inp, KEY_IP_SADDR).ptr,
-				 GET_VALUE(inp, KEY_L4_SPORT).ui16,
-				 (char *) GET_VALUE(inp, KEY_IP_DADDR).ptr,
-				 GET_VALUE(inp, KEY_L4_DPORT).ui16,
-				 GET_VALUE(inp, KEY_RAW_PKTCNT).ui32,
-				 GET_VALUE(inp, KEY_RAW_PKTLEN).ui32);
+				 ikey_get_u32(&inp[KEY_FLOW_END]),
+				 ikey_get_u8(&inp[KEY_IP_PROTO]),
+				 (char *) ikey_get_ptr(&inp[KEY_IP_SADDR]),
+				 ikey_get_u16(&inp[KEY_L4_SPORT]),
+				 (char *) ikey_get_ptr(&inp[KEY_IP_DADDR]),
+				 ikey_get_u16(&inp[KEY_L4_DPORT]),
+				 ikey_get_u32(&inp[KEY_RAW_PKTCNT]),
+				 ikey_get_u32(&inp[KEY_RAW_PKTLEN]));
 	}
 
 	fprintf(priv->of, "%s\n", buf);
diff --git a/util/printflow.c b/util/printflow.c
index bb3c2c4..7743a6a 100644
--- a/util/printflow.c
+++ b/util/printflow.c
@@ -139,14 +139,14 @@ int printflow_keys_num = sizeof(printflow_keys)/sizeof(*printflow_keys);
 
 #define pp_print(buf_cur, label, res, x, type) \
 	if (pp_is_valid(res, x)) \
-		buf_cur += sprintf(buf_cur, label"=%u ", GET_VALUE(res, x).type);
+		buf_cur += sprintf(buf_cur, label"=%u ", ikey_get_##type(&res[x]));
 
 int printflow_print(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
 
 	if (pp_is_valid(res, PRINTFLOW_EVENT_TYPE)) {
-		switch (GET_VALUE(res, PRINTFLOW_EVENT_TYPE).ui32) {
+		switch (ikey_get_u32(&res[PRINTFLOW_EVENT_TYPE])) {
 			case 1:
 				buf_cur += sprintf(buf_cur, "[NEW] ");
 				break;
@@ -164,33 +164,33 @@ int printflow_print(struct ulogd_key *res, char *buf)
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_SADDR))
 		buf_cur += sprintf(buf_cur,
 				   "SRC=%s ", 
-				   (char *) GET_VALUE(res, PRINTFLOW_ORIG_IP_SADDR).ptr);
+				   (char *) ikey_get_ptr(&res[PRINTFLOW_ORIG_IP_SADDR]));
 
 	if (pp_is_valid(res, PRINTFLOW_ORIG_IP_DADDR))
 		buf_cur += sprintf(buf_cur,
 				   "DST=%s ",
-				   (char *) GET_VALUE(res, PRINTFLOW_ORIG_IP_DADDR).ptr);
+				   (char *) ikey_get_ptr(&res[PRINTFLOW_ORIG_IP_DADDR]));
 
 	if (!pp_is_valid(res, PRINTFLOW_ORIG_IP_PROTOCOL))
 		goto orig_out;
 
-	switch (GET_VALUE(res, PRINTFLOW_ORIG_IP_PROTOCOL).ui8) {
+	switch (ikey_get_u8(&res[PRINTFLOW_ORIG_IP_PROTOCOL])) {
 	case IPPROTO_TCP:
 		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
-		pp_print(buf_cur, "SPT", res, PRINTFLOW_ORIG_L4_SPORT, ui16);
-		pp_print(buf_cur, "DPT", res, PRINTFLOW_ORIG_L4_DPORT, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_ORIG_L4_SPORT, u16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_ORIG_L4_DPORT, u16);
 		break;
 
 	case IPPROTO_UDP:
 		buf_cur += sprintf(buf_cur, "PROTO=UDP ");
-		pp_print(buf_cur, "SPT", res, PRINTFLOW_ORIG_L4_SPORT, ui16);
-		pp_print(buf_cur, "DPT", res, PRINTFLOW_ORIG_L4_DPORT, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_ORIG_L4_SPORT, u16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_ORIG_L4_DPORT, u16);
 		break;
 
 	case IPPROTO_ICMP:
 		buf_cur += sprintf(buf_cur, "PROTO=ICMP ");
-		pp_print(buf_cur, "TYPE", res, PRINTFLOW_ICMP_CODE, ui8);
-		pp_print(buf_cur, "CODE", res, PRINTFLOW_ICMP_TYPE, ui8);
+		pp_print(buf_cur, "TYPE", res, PRINTFLOW_ICMP_CODE, u8);
+		pp_print(buf_cur, "CODE", res, PRINTFLOW_ICMP_TYPE, u8);
 		break;
 
 	case IPPROTO_ESP:
@@ -202,46 +202,46 @@ int printflow_print(struct ulogd_key *res, char *buf)
 		break;
 
 	default:
-		pp_print(buf_cur, "PROTO", res, PRINTFLOW_ORIG_IP_PROTOCOL, ui8);
+		pp_print(buf_cur, "PROTO", res, PRINTFLOW_ORIG_IP_PROTOCOL, u8);
 		break;
 	}
 
 orig_out:
-	pp_print(buf_cur, "PKTS", res, PRINTFLOW_ORIG_RAW_PKTCOUNT, ui32);
-	pp_print(buf_cur, "BYTES", res, PRINTFLOW_ORIG_RAW_PKTLEN, ui32);
+	pp_print(buf_cur, "PKTS", res, PRINTFLOW_ORIG_RAW_PKTCOUNT, u32);
+	pp_print(buf_cur, "BYTES", res, PRINTFLOW_ORIG_RAW_PKTLEN, u32);
 
 	buf_cur += sprintf(buf_cur, ", REPLY: ");
 
 	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_SADDR))
 		buf_cur += sprintf(buf_cur,
 				   "SRC=%s ",
-				   (char *) GET_VALUE(res,PRINTFLOW_REPLY_IP_SADDR).ptr);
+				   (char *) ikey_get_ptr(&res[PRINTFLOW_REPLY_IP_SADDR]));
 
 	if (pp_is_valid(res, PRINTFLOW_REPLY_IP_DADDR))
 		buf_cur += sprintf(buf_cur,
 				   "DST=%s ",
-				   (char *) GET_VALUE(res,PRINTFLOW_REPLY_IP_DADDR).ptr);
+				   (char *) ikey_get_ptr(&res[PRINTFLOW_REPLY_IP_DADDR]));
 
 	if (!pp_is_valid(res, PRINTFLOW_REPLY_IP_PROTOCOL))
 		goto reply_out;
 
-	switch (GET_VALUE(res, PRINTFLOW_REPLY_IP_PROTOCOL).ui8) {
+	switch (ikey_get_u8(&res[PRINTFLOW_REPLY_IP_PROTOCOL])) {
 	case IPPROTO_TCP:
 		buf_cur += sprintf(buf_cur, "PROTO=TCP ");
-		pp_print(buf_cur, "SPT", res, PRINTFLOW_REPLY_L4_SPORT, ui16);
-		pp_print(buf_cur, "DPT", res, PRINTFLOW_REPLY_L4_DPORT, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_REPLY_L4_SPORT, u16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_REPLY_L4_DPORT, u16);
 		break;
 
 	case IPPROTO_UDP:
 		buf_cur += sprintf(buf_cur, "PROTO=UDP ");
-		pp_print(buf_cur, "SPT", res, PRINTFLOW_REPLY_L4_SPORT, ui16);
-		pp_print(buf_cur, "DPT", res, PRINTFLOW_REPLY_L4_DPORT, ui16);
+		pp_print(buf_cur, "SPT", res, PRINTFLOW_REPLY_L4_SPORT, u16);
+		pp_print(buf_cur, "DPT", res, PRINTFLOW_REPLY_L4_DPORT, u16);
 		break;
 
 	case IPPROTO_ICMP:
 		buf_cur += sprintf(buf_cur, "PROTO=ICMP ");
-		pp_print(buf_cur, "TYPE", res, PRINTFLOW_ICMP_CODE, ui8);
-		pp_print(buf_cur, "CODE", res, PRINTFLOW_ICMP_TYPE, ui8);
+		pp_print(buf_cur, "TYPE", res, PRINTFLOW_ICMP_CODE, u8);
+		pp_print(buf_cur, "CODE", res, PRINTFLOW_ICMP_TYPE, u8);
 		break;
 
 	case IPPROTO_ESP:
@@ -253,13 +253,13 @@ orig_out:
 		break;
 
 	default:
-		pp_print(buf_cur, "PROTO", res, PRINTFLOW_REPLY_IP_PROTOCOL, ui8);
+		pp_print(buf_cur, "PROTO", res, PRINTFLOW_REPLY_IP_PROTOCOL, u8);
 		break;
 	}
 
 reply_out:
-	pp_print(buf_cur, "PKTS", res, PRINTFLOW_REPLY_RAW_PKTCOUNT, ui32);
-	pp_print(buf_cur, "BYTES", res, PRINTFLOW_REPLY_RAW_PKTLEN, ui32);
+	pp_print(buf_cur, "PKTS", res, PRINTFLOW_REPLY_RAW_PKTCOUNT, u32);
+	pp_print(buf_cur, "BYTES", res, PRINTFLOW_REPLY_RAW_PKTLEN, u32);
 
 	strcat(buf_cur, "\n");
 	return 0;
diff --git a/util/printpkt.c b/util/printpkt.c
index 29c2ea4..2292377 100644
--- a/util/printpkt.c
+++ b/util/printpkt.c
@@ -119,38 +119,38 @@ static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
 		}
 
 		buf_cur += sprintf(buf_cur, "SPT=%u DPT=%u ",
-				   GET_VALUE(res, KEY_TCP_SPORT).ui16,
-				   GET_VALUE(res, KEY_TCP_DPORT).ui16);
+				   ikey_get_u16(&res[KEY_TCP_SPORT]),
+				   ikey_get_u16(&res[KEY_TCP_DPORT]));
 		/* FIXME: config */
-		buf_cur += sprintf(buf_cur, "SEQ=%u ACK=%u ", 
-				   GET_VALUE(res, KEY_TCP_SEQ).ui32,
-				   GET_VALUE(res, KEY_TCP_ACKSEQ).ui32);
+		buf_cur += sprintf(buf_cur, "SEQ=%u ACK=%u ",
+				   ikey_get_u32(&res[KEY_TCP_SEQ]),
+				   ikey_get_u32(&res[KEY_TCP_ACKSEQ]));
 
 		buf_cur += sprintf(buf_cur, "WINDOW=%u ",
-				   GET_VALUE(res, KEY_TCP_WINDOW).ui16);
+				   ikey_get_u16(&res[KEY_TCP_WINDOW]));
 
 //		buf_cur += sprintf(buf_cur, "RES=0x%02x ", 
 		
-		if (GET_VALUE(res, KEY_TCP_URG).b)
+		if (ikey_get_u8(&res[KEY_TCP_URG]))
 			buf_cur += sprintf(buf_cur, "URG ");
 
-		if (GET_VALUE(res, KEY_TCP_ACK).b)
+		if (ikey_get_u8(&res[KEY_TCP_ACK]))
 			buf_cur += sprintf(buf_cur, "ACK ");
 
-		if (GET_VALUE(res, KEY_TCP_PSH).b)
+		if (ikey_get_u8(&res[KEY_TCP_PSH]))
 			buf_cur += sprintf(buf_cur, "PSH ");
 
-		if (GET_VALUE(res, KEY_TCP_RST).b)
+		if (ikey_get_u8(&res[KEY_TCP_RST]))
 			buf_cur += sprintf(buf_cur, "RST ");
 
-		if (GET_VALUE(res, KEY_TCP_SYN).b)
+		if (ikey_get_u8(&res[KEY_TCP_SYN]))
 			buf_cur += sprintf(buf_cur, "SYN ");
 
-		if (GET_VALUE(res, KEY_TCP_FIN).b)
+		if (ikey_get_u8(&res[KEY_TCP_FIN]))
 			buf_cur += sprintf(buf_cur, "FIN ");
 
 		buf_cur += sprintf(buf_cur, "URGP=%u ",
-				   GET_VALUE(res, KEY_TCP_URGP).ui16);
+				   ikey_get_u16(&res[KEY_TCP_URGP]));
 
 		break;
 
@@ -163,14 +163,14 @@ static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
 		}
 
 		buf_cur += sprintf(buf_cur, "SPT=%u DPT=%u LEN=%u ", 
-				   GET_VALUE(res, KEY_UDP_SPORT).ui16,
-				   GET_VALUE(res, KEY_UDP_DPORT).ui16, 
-				   GET_VALUE(res, KEY_UDP_LEN).ui16);
+				   ikey_get_u16(&res[KEY_UDP_SPORT]),
+				   ikey_get_u16(&res[KEY_UDP_DPORT]), 
+				   ikey_get_u16(&res[KEY_UDP_LEN]));
 		break;
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 		buf_cur += sprintf(buf_cur, "PROTO=%s ",
-				   GET_VALUE(res, KEY_IP_PROTOCOL).ui8 == IPPROTO_ESP ? "ESP" : "AH");
+				   ikey_get_u8(&res[KEY_IP_PROTOCOL]) == IPPROTO_ESP ? "ESP" : "AH");
 
 		if (!pp_is_valid(res, KEY_AHESP_SPI)) {
 			buf_cur += sprintf(buf_cur, "INCOMPLETE");
@@ -178,7 +178,7 @@ static int printpkt_proto(struct ulogd_key *res, char *buf, int protocol)
 		}
 
 		buf_cur += sprintf(buf_cur, "SPI=0x%x ",
-				   GET_VALUE(res, KEY_AHESP_SPI).ui32);
+				   ikey_get_u32(&res[KEY_AHESP_SPI]));
 		break;
 	}
 
@@ -189,43 +189,44 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
 	char tmp[INET_ADDRSTRLEN];
+	u_int32_t paddr;
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   (char *) GET_VALUE(res, KEY_IP_SADDR).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_IP_SADDR]));
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   (char *) GET_VALUE(res, KEY_IP_DADDR).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_IP_DADDR]));
 
 	/* FIXME: add pp_is_valid calls to remainder of file */
 	buf_cur += sprintf(buf_cur,"LEN=%u TOS=%02X PREC=0x%02X TTL=%u ID=%u ", 
-			   GET_VALUE(res, KEY_IP_TOTLEN).ui16,
-			   GET_VALUE(res, KEY_IP_TOS).ui8 & IPTOS_TOS_MASK, 
-			   GET_VALUE(res, KEY_IP_TOS).ui8 & IPTOS_PREC_MASK,
-			   GET_VALUE(res, KEY_IP_TTL).ui8,
-			   GET_VALUE(res, KEY_IP_ID).ui16);
+			   ikey_get_u16(&res[KEY_IP_TOTLEN]),
+			   ikey_get_u8(&res[KEY_IP_TOS]) & IPTOS_TOS_MASK, 
+			   ikey_get_u8(&res[KEY_IP_TOS]) & IPTOS_PREC_MASK,
+			   ikey_get_u8(&res[KEY_IP_TTL]),
+			   ikey_get_u16(&res[KEY_IP_ID]));
 
-	if (GET_VALUE(res, KEY_IP_FRAGOFF).ui16 & IP_RF) 
+	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_RF) 
 		buf_cur += sprintf(buf_cur, "CE ");
 
-	if (GET_VALUE(res, KEY_IP_FRAGOFF).ui16 & IP_DF)
+	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_DF)
 		buf_cur += sprintf(buf_cur, "DF ");
 
-	if (GET_VALUE(res, KEY_IP_FRAGOFF).ui16 & IP_MF)
+	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_MF)
 		buf_cur += sprintf(buf_cur, "MF ");
 
-	if (GET_VALUE(res, KEY_IP_FRAGOFF).ui16 & IP_OFFMASK)
+	if (ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_OFFMASK)
 		buf_cur += sprintf(buf_cur, "FRAG:%u ", 
-				   GET_VALUE(res, KEY_IP_FRAGOFF).ui16 & IP_OFFMASK);
+				   ikey_get_u16(&res[KEY_IP_FRAGOFF]) & IP_OFFMASK);
 
-	switch (GET_VALUE(res, KEY_IP_PROTOCOL).ui8) {
+	switch (ikey_get_u8(&res[KEY_IP_PROTOCOL])) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 		buf_cur += printpkt_proto(res, buf_cur,
-					  GET_VALUE(res, KEY_IP_PROTOCOL).ui8);
+					  ikey_get_u8(&res[KEY_IP_PROTOCOL]));
 		break;
 
 	case IPPROTO_ICMP:
@@ -237,36 +238,37 @@ static int printpkt_ipv4(struct ulogd_key *res, char *buf)
 		}
 
 		buf_cur += sprintf(buf_cur, "TYPE=%u CODE=%u ",
-				   GET_VALUE(res, KEY_ICMP_TYPE).ui8,
-				   GET_VALUE(res, KEY_ICMP_CODE).ui8);
+				   ikey_get_u8(&res[KEY_ICMP_TYPE]),
+				   ikey_get_u8(&res[KEY_ICMP_CODE]));
 
-		switch (GET_VALUE(res, KEY_ICMP_TYPE).ui8) {
+		switch (ikey_get_u8(&res[KEY_ICMP_CODE])) {
 		case ICMP_ECHO:
 		case ICMP_ECHOREPLY:
 			buf_cur += sprintf(buf_cur, "ID=%u SEQ=%u ", 
-					   GET_VALUE(res, KEY_ICMP_ECHOID).ui16,
-					   GET_VALUE(res, KEY_ICMP_ECHOSEQ).ui16);
+					   ikey_get_u16(&res[KEY_ICMP_ECHOID]),
+					   ikey_get_u16(&res[KEY_ICMP_ECHOSEQ]));
 			break;
 		case ICMP_PARAMETERPROB:
 			buf_cur += sprintf(buf_cur, "PARAMETER=%u ",
-					   GET_VALUE(res, KEY_ICMP_GATEWAY).ui32 >> 24);
+					   ikey_get_u32(&res[KEY_ICMP_GATEWAY]) >> 24);
 			break;
 		case ICMP_REDIRECT:
+			paddr = ikey_get_u32(&res[KEY_ICMP_GATEWAY]),
 			buf_cur += sprintf(buf_cur, "GATEWAY=%s ",
 					   inet_ntop(AF_INET,
-					   	     &GET_VALUE(res, KEY_ICMP_GATEWAY).ui32,
+						     &paddr,
 						     tmp, sizeof(tmp)));
 			break;
 		case ICMP_DEST_UNREACH:
-			if (GET_VALUE(res, KEY_ICMP_CODE).ui8 == ICMP_FRAG_NEEDED)
+			if (ikey_get_u8(&res[KEY_ICMP_CODE]) == ICMP_FRAG_NEEDED)
 				buf_cur += sprintf(buf_cur, "MTU=%u ", 
-						   GET_VALUE(res, KEY_ICMP_FRAGMTU).ui16);
+						   ikey_get_u16(&res[KEY_ICMP_FRAGMTU]));
 			break;
 		}
 		break;
 	default:
 		buf_cur += sprintf(buf_cur, "PROTO=%u ",
-				   GET_VALUE(res, KEY_IP_PROTOCOL).ui8);
+				   ikey_get_u8(&res[KEY_IP_PROTOCOL]));
 	}
 
 	return buf_cur - buf;
@@ -278,41 +280,41 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_IP_SADDR))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   (char *) GET_VALUE(res, KEY_IP_SADDR).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_IP_SADDR]));
 
 	if (pp_is_valid(res, KEY_IP_DADDR))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   (char *) GET_VALUE(res, KEY_IP_DADDR).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_IP_DADDR]));
 
 	if (pp_is_valid(res, KEY_IP6_PAYLOAD_LEN))
 		buf_cur += sprintf(buf_cur, "LEN=%Zu ",
-				   GET_VALUE(res, KEY_IP6_PAYLOAD_LEN).ui16 +
+				   ikey_get_u16(&res[KEY_IP6_PAYLOAD_LEN]) +
 				   sizeof(struct ip6_hdr));
 
 	if (pp_is_valid(res, KEY_IP6_PRIORITY))
 		buf_cur += sprintf(buf_cur, "TC=%u ",
-				   GET_VALUE(res, KEY_IP6_PRIORITY).ui8);
+				   ikey_get_u8(&res[KEY_IP6_PRIORITY]));
 
 	if (pp_is_valid(res, KEY_IP6_HOPLIMIT))
 		buf_cur += sprintf(buf_cur, "HOPLIMIT=%u ",
-				   GET_VALUE(res, KEY_IP6_HOPLIMIT).ui8);
+				   ikey_get_u8(&res[KEY_IP6_HOPLIMIT]));
 	
 	if (pp_is_valid(res, KEY_IP6_FLOWLABEL))
 		buf_cur += sprintf(buf_cur, "FLOWLBL=%u ",
-				   GET_VALUE(res, KEY_IP6_FLOWLABEL).ui32);
+				   ikey_get_u32(&res[KEY_IP6_FLOWLABEL]));
 
 	if (pp_is_valid(res, KEY_IP6_FRAG_OFF) && pp_is_valid(res, KEY_IP6_FRAG_ID))
 		buf_cur += sprintf(buf_cur, "FRAG: %u ID: %08x ",
-				   GET_VALUE(res, KEY_IP6_FRAG_OFF).ui16,
-				   GET_VALUE(res, KEY_IP6_FRAG_ID).ui32);
+				   ikey_get_u16(&res[KEY_IP6_FRAG_OFF]),
+				   ikey_get_u32(&res[KEY_IP6_FRAG_ID]));
 
-	switch (GET_VALUE(res, KEY_IP6_NEXTHDR).ui8) {
+	switch (ikey_get_u8(&res[KEY_IP6_NEXTHDR])) {
 	case IPPROTO_TCP:
 	case IPPROTO_UDP:
 	case IPPROTO_ESP:
 	case IPPROTO_AH:
 		buf_cur += printpkt_proto(res, buf_cur,
-					  GET_VALUE(res, KEY_IP6_NEXTHDR).ui8);
+					  ikey_get_u8(&res[KEY_IP6_NEXTHDR]));
 		break;
 	case IPPROTO_ICMPV6:
 		buf_cur += sprintf(buf_cur, "PROTO=ICMPv6 ");
@@ -329,15 +331,15 @@ static int printpkt_ipv6(struct ulogd_key *res, char *buf)
 		}
 
 		buf_cur += sprintf(buf_cur, "TYPE=%u CODE=%u ",
-				   GET_VALUE(res, KEY_ICMPV6_TYPE).ui8,
-				   GET_VALUE(res, KEY_ICMPV6_CODE).ui8);
+				   ikey_get_u8(&res[KEY_ICMPV6_TYPE]),
+				   ikey_get_u8(&res[KEY_ICMPV6_CODE]));
 
-		switch (GET_VALUE(res, KEY_ICMPV6_TYPE).ui8) {
+		switch (ikey_get_u8(&res[KEY_ICMPV6_TYPE])) {
 		case ICMP6_ECHO_REQUEST:
 		case ICMP6_ECHO_REPLY:
 			buf_cur += sprintf(buf_cur, "ID=%u SEQ=%u ", 
-					   GET_VALUE(res, KEY_ICMPV6_ECHOID).ui16,
-					   GET_VALUE(res, KEY_ICMPV6_ECHOSEQ).ui16);
+					   ikey_get_u16(&res[KEY_ICMPV6_ECHOID]),
+					   ikey_get_u16(&res[KEY_ICMPV6_ECHOSEQ]));
 			break;
 		}
 		break;
@@ -354,16 +356,16 @@ int printpkt_arp(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_ARP_SPA))
 		buf_cur += sprintf(buf_cur, "SRC=%s ",
-				   (char *) GET_VALUE(res, KEY_ARP_SPA).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_ARP_SPA]));
 
 	if (pp_is_valid(res, KEY_ARP_TPA))
 		buf_cur += sprintf(buf_cur, "DST=%s ",
-				   (char *) GET_VALUE(res, KEY_ARP_TPA).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_ARP_TPA]));
 
 	buf_cur += sprintf(buf_cur, "PROTO=ARP ");
 
 	if (pp_is_valid(res, KEY_ARP_OPCODE)) {
-		code = GET_VALUE(res, KEY_ARP_OPCODE).ui16;
+		code = ikey_get_u16(&res[KEY_ARP_OPCODE]);
 		switch (code) {
 		case ARPOP_REQUEST:
 			buf_cur += sprintf(buf_cur, "REQUEST ");
@@ -379,7 +381,7 @@ int printpkt_arp(struct ulogd_key *res, char *buf)
 		}
 
 		if (pp_is_valid(res, KEY_ARP_SHA) && (code == ARPOP_REPLY)) {
-			mac = GET_VALUE(res, KEY_ARP_SHA).ptr;
+			mac = ikey_get_ptr(&res[KEY_ARP_SHA]);
 			buf_cur += sprintf(buf_cur, "REPLY_MAC="
 					   "%02x:%02x:%02x:%02x:%02x:%02x ",
 					   mac[0], mac[1], mac[2],
@@ -395,7 +397,7 @@ int printpkt_bridge(struct ulogd_key *res, char *buf)
 {
 	char *buf_cur = buf;
 
-	switch (GET_VALUE(res, KEY_OOB_PROTOCOL).ui16) {
+	switch (ikey_get_u16(&res[KEY_OOB_PROTOCOL])) {
 	case ETH_P_IP:
 		buf_cur += printpkt_ipv4(res, buf_cur);
 		break;
@@ -407,7 +409,7 @@ int printpkt_bridge(struct ulogd_key *res, char *buf)
 		break;
 	default:
 		buf_cur += sprintf(buf_cur, "PROTO=%u ",
-			   GET_VALUE(res, KEY_OOB_PROTOCOL).ui16);
+				   ikey_get_u16(&res[KEY_OOB_PROTOCOL]));
 	}
 
 	return buf_cur - buf;
@@ -419,17 +421,17 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_OOB_PREFIX))
 		buf_cur += sprintf(buf_cur, "%s ",
-				   (char *) GET_VALUE(res, KEY_OOB_PREFIX).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_OOB_PREFIX]));
 
 	if (pp_is_valid(res, KEY_OOB_IN) && pp_is_valid(res, KEY_OOB_OUT))
 		buf_cur += sprintf(buf_cur, "IN=%s OUT=%s ", 
-				   (char *) GET_VALUE(res, KEY_OOB_IN).ptr, 
-				   (char *) GET_VALUE(res, KEY_OOB_OUT).ptr);
+				   (char *) ikey_get_ptr(&res[KEY_OOB_IN]), 
+				   (char *) ikey_get_ptr(&res[KEY_OOB_OUT]));
 
 	/* FIXME: configurable */
 	if (pp_is_valid(res, KEY_RAW_MAC)) {
-		unsigned char *mac = (unsigned char *) GET_VALUE(res, KEY_RAW_MAC).ptr;
-		int i, len = GET_VALUE(res, KEY_RAW_MACLEN).ui16;
+		unsigned char *mac = (unsigned char *) ikey_get_ptr(&res[KEY_RAW_MAC]);
+		int i, len = ikey_get_u16(&res[KEY_RAW_MACLEN]);
 
 		buf_cur += sprintf(buf_cur, "MAC=");
 		for (i = 0; i < len; i++)
@@ -438,7 +440,7 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 	} else
 		buf_cur += sprintf(buf_cur, "MAC= ");
 
-	switch (GET_VALUE(res, KEY_OOB_FAMILY).ui8) {
+	switch (ikey_get_u8(&res[KEY_OOB_FAMILY])) {
 	case AF_INET:
 		buf_cur += printpkt_ipv4(res, buf_cur);
 		break;
@@ -452,13 +454,13 @@ int printpkt_print(struct ulogd_key *res, char *buf)
 
 	if (pp_is_valid(res, KEY_OOB_UID))
 		buf_cur += sprintf(buf_cur, "UID=%u ",
-				   GET_VALUE(res, KEY_OOB_UID).ui32);
+				   ikey_get_u32(&res[KEY_OOB_UID]));
 	if (pp_is_valid(res, KEY_OOB_GID))
 		buf_cur += sprintf(buf_cur, "GID=%u ",
-				   GET_VALUE(res, KEY_OOB_GID).ui32);
+				   ikey_get_u32(&res[KEY_OOB_GID]));
 	if (pp_is_valid(res, KEY_OOB_MARK))
 		buf_cur += sprintf(buf_cur, "MARK=%x ",
-				   GET_VALUE(res, KEY_OOB_MARK).ui32);
+				   ikey_get_u32(&res[KEY_OOB_MARK]));
 
 	strcat(buf_cur, "\n");
 
-- 
1.5.6.3

