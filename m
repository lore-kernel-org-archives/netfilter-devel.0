From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH]: invaild TCP/UDP matching when ipv6 extension header
 exists
Date: Sat, 31 Jan 2004 15:56:23 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401310656.PAA07746@toshiba.co.jp>
References: <200401310649.PAA00050@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Sat_Jan_31_15:56:23_2004_266)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200401310649.PAA00050@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Sat_Jan_31_15:56:23_2004_266)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Sorry, I forgot to send the patch.

From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Sat, 31 Jan 2004 15:49:32 +0900 (JST)

> 
> Hi,
> 
> tcp_match() and udp_match() in ip6tables.c assume that previous header
> of TCP/UDP header is IPv6 Header. So, for example, 1st of fragmented UDP
> packet, AHed packets can't correctly match the rules which use
> "--sport" and so on.
> 
> This patch use ipv6_skip_exthdr() . But this function has the bug which
> access invalid memory area when found Fragment Header.
> So this patch includes the change for that, too.
> 
> Regards,

----Next_Part(Sat_Jan_31_15:56:23_2004_266)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="tcp_udp_match.patch"

diff -Nur linux-2.6.1/net/ipv6/exthdrs.c linux-2.6.1-fixed/net/ipv6/exthdrs.c
--- linux-2.6.1/net/ipv6/exthdrs.c	2004-01-09 15:59:06.000000000 +0900
+++ linux-2.6.1-fixed/net/ipv6/exthdrs.c	2004-01-31 01:27:38.000000000 +0900
@@ -738,8 +738,16 @@
 		if (skb_copy_bits(skb, start, &hdr, sizeof(hdr)))
 			BUG();
 		if (nexthdr == NEXTHDR_FRAGMENT) {
-			struct frag_hdr *fhdr = (struct frag_hdr *) &hdr;
-			if (ntohs(fhdr->frag_off) & ~0x7)
+			unsigned short frag_off;
+			if (skb_copy_bits(skb,
+					  start+offsetof(struct frag_hdr,
+							 frag_off),
+					  &frag_off,
+					  sizeof(frag_off))) {
+				return -1;
+			}
+
+			if (ntohs(frag_off) & ~0x7)
 				break;
 			hdrlen = 8;
 		} else if (nexthdr == NEXTHDR_AUTH)
diff -Nur linux-2.6.1/net/ipv6/ipv6_syms.c linux-2.6.1-fixed/net/ipv6/ipv6_syms.c
--- linux-2.6.1/net/ipv6/ipv6_syms.c	2004-01-09 15:59:47.000000000 +0900
+++ linux-2.6.1-fixed/net/ipv6/ipv6_syms.c	2004-01-31 01:41:41.000000000 +0900
@@ -46,3 +46,4 @@
 EXPORT_SYMBOL(ip6_flush_pending_frames);
 EXPORT_SYMBOL(ip6_push_pending_frames);
 EXPORT_SYMBOL(ipv6_push_nfrag_opts);
+EXPORT_SYMBOL(ipv6_skip_exthdr);
diff -Nur linux-2.6.1/net/ipv6/netfilter/ip6_tables.c linux-2.6.1-fixed/net/ipv6/netfilter/ip6_tables.c
--- linux-2.6.1/net/ipv6/netfilter/ip6_tables.c	2004-01-09 16:00:02.000000000 +0900
+++ linux-2.6.1-fixed/net/ipv6/netfilter/ip6_tables.c	2004-01-31 01:27:56.000000000 +0900
@@ -1531,22 +1531,24 @@
 
 static int
 tcp_find_option(u_int8_t option,
-		const struct tcphdr *tcp,
-		u_int16_t datalen,
+		const struct sk_buff *skb,
+		unsigned int optoff,
+		unsigned int optlen,
 		int invert,
 		int *hotdrop)
 {
-	unsigned int i = sizeof(struct tcphdr);
-	const u_int8_t *opt = (u_int8_t *)tcp;
+	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
+	char opt[60 - sizeof(struct tcphdr)];
+	unsigned int i;
 
 	duprintf("tcp_match: finding option\n");
 	/* If we don't have the whole header, drop packet. */
-	if (tcp->doff * 4 > datalen) {
+	if (skb_copy_bits(skb, optoff, opt, optlen) < 0) {
 		*hotdrop = 1;
 		return 0;
 	}
 
-	while (i < tcp->doff * 4) {
+	for (i = 0; i < optlen; ) {
 		if (opt[i] == option) return !invert;
 		if (opt[i] < 2) i++;
 		else i += opt[i+1]?:1;
@@ -1565,21 +1567,34 @@
 	  u_int16_t datalen,
 	  int *hotdrop)
 {
-	const struct tcphdr *tcp = hdr;
+	struct tcphdr tcph;
 	const struct ip6t_tcp *tcpinfo = matchinfo;
+	int tcpoff;
+	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 
-	/* To quote Alan:
+	if (offset) {
+		/* To quote Alan:
 
-	   Don't allow a fragment of TCP 8 bytes in. Nobody normal
-	   causes this. Its a cracker trying to break in by doing a
-	   flag overwrite to pass the direction checks.
-	*/
+		   Don't allow a fragment of TCP 8 bytes in. Nobody normal
+		   causes this. Its a cracker trying to break in by doing a
+		   flag overwrite to pass the direction checks.
+		*/
+		if (offset == 1) {
+			duprintf("Dropping evil TCP offset=1 frag.\n");
+			*hotdrop = 1;
+		}
+		/* Must not be a fragment. */
+		return 0;
+	}
 
-	if (offset == 1) {
-		duprintf("Dropping evil TCP offset=1 frag.\n");
-		*hotdrop = 1;
+	tcpoff = (u8*)(skb->nh.ipv6h+1) - skb->data;
+	tcpoff = ipv6_skip_exthdr(skb, tcpoff, &nexthdr, skb->len - tcpoff);
+	if (tcpoff < 0 || tcpoff > skb->len || nexthdr != IPPROTO_TCP)
 		return 0;
-	} else if (offset == 0 && datalen < sizeof(struct tcphdr)) {
+
+#define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
+
+	if (skb_copy_bits(skb, tcpoff, &tcph, sizeof(tcph)) < 0) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
@@ -1587,27 +1602,26 @@
 		return 0;
 	}
 
-	/* FIXME: Try tcp doff >> packet len against various stacks --RR */
-
-#define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
-
-	/* Must not be a fragment. */
-	return !offset
-		&& port_match(tcpinfo->spts[0], tcpinfo->spts[1],
-			      ntohs(tcp->source),
-			      !!(tcpinfo->invflags & IP6T_TCP_INV_SRCPT))
-		&& port_match(tcpinfo->dpts[0], tcpinfo->dpts[1],
-			      ntohs(tcp->dest),
-			      !!(tcpinfo->invflags & IP6T_TCP_INV_DSTPT))
-		&& FWINVTCP((((unsigned char *)tcp)[13]
-			     & tcpinfo->flg_mask)
-			    == tcpinfo->flg_cmp,
-			    IP6T_TCP_INV_FLAGS)
-		&& (!tcpinfo->option
-		    || tcp_find_option(tcpinfo->option, tcp, datalen,
-				       tcpinfo->invflags
-				       & IP6T_TCP_INV_OPTION,
-				       hotdrop));
+	if (!port_match(tcpinfo->spts[0], tcpinfo->spts[1],
+			ntohs(tcph.source),
+			!!(tcpinfo->invflags & IP6T_TCP_INV_SRCPT)))
+		return 0;
+	if (!port_match(tcpinfo->dpts[0], tcpinfo->dpts[1],
+			ntohs(tcph.dest),
+			!!(tcpinfo->invflags & IP6T_TCP_INV_DSTPT)))
+		return 0;
+	if (!FWINVTCP((((unsigned char *)&tcph)[13] & tcpinfo->flg_mask)
+		      == tcpinfo->flg_cmp,
+		      IP6T_TCP_INV_FLAGS))
+		return 0;
+	if (tcpinfo->option &&
+	    !tcp_find_option(tcpinfo->option, skb,
+			     tcpoff + sizeof(tcph),
+			     tcph.doff*4 - sizeof(tcph),
+			     tcpinfo->invflags & IP6T_TCP_INV_OPTION,
+			     hotdrop))
+		return 0;
+	return 1;
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -1637,10 +1651,21 @@
 	  u_int16_t datalen,
 	  int *hotdrop)
 {
-	const struct udphdr *udp = hdr;
+	struct udphdr udph;
 	const struct ip6t_udp *udpinfo = matchinfo;
+	int udpoff;
+	u8 nexthdr = skb->nh.ipv6h->nexthdr;
+
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	udpoff = (u8*)(skb->nh.ipv6h+1) - skb->data;
+	udpoff = ipv6_skip_exthdr(skb, udpoff, &nexthdr, skb->len - udpoff);
+	if (udpoff < 0 || udpoff > skb->len || nexthdr != IPPROTO_UDP)
+		return 0;
 
-	if (offset == 0 && datalen < sizeof(struct udphdr)) {
+	if (skb_copy_bits(skb, udpoff, &udph, sizeof(udph)) < 0) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
@@ -1648,13 +1673,11 @@
 		return 0;
 	}
 
-	/* Must not be a fragment. */
-	return !offset
-		&& port_match(udpinfo->spts[0], udpinfo->spts[1],
-			      ntohs(udp->source),
-			      !!(udpinfo->invflags & IP6T_UDP_INV_SRCPT))
+	return port_match(udpinfo->spts[0], udpinfo->spts[1],
+			  ntohs(udph.source),
+			  !!(udpinfo->invflags & IP6T_UDP_INV_SRCPT))
 		&& port_match(udpinfo->dpts[0], udpinfo->dpts[1],
-			      ntohs(udp->dest),
+			      ntohs(udph.dest),
 			      !!(udpinfo->invflags & IP6T_UDP_INV_DSTPT));
 }
 

----Next_Part(Sat_Jan_31_15:56:23_2004_266)----
