From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: introducing skb_header_pointer() and bug fixes of
 ip6t_LOG.c
Date: Thu, 07 Oct 2004 11:03:53 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410070203.i9723xqf013447@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Oct__7_11:03:53_2004_571)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Oct__7_11:03:53_2004_571)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

This patch enables ip6t_LOG.c to work without skb_linearize().

I changed a large part of this file. At first, ip6_nexthdr() is deleted
to prevent multiple call of skb_header_pointer() at dump_packet() and
ip6_nexthdr().

And the following bugs are fixed. The first bug is fixed by introducing
skb_header_pointer(), then I didn't separate patches.

	- No check with skb->len. Then invalid memory access may occur.

	- If packet is fragmented and it's not first fragment, nonexistent
	  extension headers is tried to parse.

	- All headers which aren't TCP/UDP/ICMPv6 are treated as IPv6
	  extension header.

	- The encrypted data after ESP is tried to parse.

	- ntohl() for ID in Fragment header is missing.

	- If doff*4 of TCP header is less than sizeof(struct tcphdr),
	  TCP options are tried to parse.


Before trying this patch, don't forget to apply the patch which prepare
to removing skb_linearize().

https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017028.html

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Oct__7_11:03:53_2004_571)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="LOG-fix-nolin.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_LOG.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_LOG.c	2004-10-06 08:54:25.000000000 +0900
@@ -40,120 +40,166 @@ struct in_device;
 #define DEBUGP(format, args...)
 #endif
 
-struct esphdr {
-	__u32   spi;
-}; /* FIXME evil kludge */
-        
 /* Use lock to serialize, so printks don't overlap */
 static spinlock_t log_lock = SPIN_LOCK_UNLOCKED;
 
-/* takes in current header and pointer to the header */
-/* if another header exists, sets hdrptr to the next header
-   and returns the new header value, else returns IPPROTO_NONE */
-static u_int8_t ip6_nexthdr(u_int8_t currenthdr, u_int8_t **hdrptr)
-{
-	u_int8_t hdrlen, nexthdr = IPPROTO_NONE;
-
-	switch(currenthdr){
-		case IPPROTO_AH:
-		/* whoever decided to do the length of AUTH for ipv6
-		in 32bit units unlike other headers should be beaten...
-		repeatedly...with a large stick...no, an even LARGER
-		stick...no, you're still not thinking big enough */
-			nexthdr = **hdrptr;
-			hdrlen = (*hdrptr)[1] * 4 + 8;
-			*hdrptr = *hdrptr + hdrlen;
-			break;
-		/*stupid rfc2402 */
-		case IPPROTO_DSTOPTS:
-		case IPPROTO_ROUTING:
-		case IPPROTO_HOPOPTS:
-			nexthdr = **hdrptr;
-			hdrlen = (*hdrptr)[1] * 8 + 8;
-			*hdrptr = *hdrptr + hdrlen;
-			break;
-		case IPPROTO_FRAGMENT:
-			nexthdr = **hdrptr;
-			*hdrptr = *hdrptr + 8;
-			break;
-	}	
-	return nexthdr;
-}
-
 /* One level of recursion won't kill us */
 static void dump_packet(const struct ip6t_log_info *info,
-			struct ipv6hdr *ipv6h, int recurse)
+			const struct sk_buff *skb, unsigned int ip6hoff,
+			int recurse)
 {
-	u_int8_t currenthdr = ipv6h->nexthdr;
-	u_int8_t *hdrptr;
+	u_int8_t currenthdr;
 	int fragment;
+	struct ipv6hdr _ip6h, *ih;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+
+	ih = skb_header_pointer(skb, ip6hoff, sizeof(_ip6h), &_ip6h);
+	if (ih == NULL) {
+		printk("TRUNCATED");
+		return;
+	}
 
 	/* Max length: 88 "SRC=0000.0000.0000.0000.0000.0000.0000.0000 DST=0000.0000.0000.0000.0000.0000.0000.0000" */
-	printk("SRC=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->saddr));
-	printk("DST=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->daddr));
+	printk("SRC=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ih->saddr));
+	printk("DST=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ih->daddr));
 
 	/* Max length: 44 "LEN=65535 TC=255 HOPLIMIT=255 FLOWLBL=FFFFF " */
 	printk("LEN=%Zu TC=%u HOPLIMIT=%u FLOWLBL=%u ",
-	       ntohs(ipv6h->payload_len) + sizeof(struct ipv6hdr),
-	       (ntohl(*(u_int32_t *)ipv6h) & 0x0ff00000) >> 20,
-	       ipv6h->hop_limit,
-	       (ntohl(*(u_int32_t *)ipv6h) & 0x000fffff));
+	       ntohs(ih->payload_len) + sizeof(struct ipv6hdr),
+	       (ntohl(*(u_int32_t *)ih) & 0x0ff00000) >> 20,
+	       ih->hop_limit,
+	       (ntohl(*(u_int32_t *)ih) & 0x000fffff));
 
 	fragment = 0;
-	hdrptr = (u_int8_t *)(ipv6h + 1);
-	while (currenthdr != IPPROTO_NONE) {
-		if ((currenthdr == IPPROTO_TCP) ||
-		    (currenthdr == IPPROTO_UDP) ||
-		    (currenthdr == IPPROTO_ICMPV6))
-			break;
+	ptr = ip6hoff + sizeof(struct ipv6hdr);
+	currenthdr = ih->nexthdr;
+	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+
+		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+		if (hp == NULL) {
+			printk("TRUNCATED");
+			return;
+		}
+
 		/* Max length: 48 "OPT (...) " */
-		printk("OPT ( ");
+		if (info->logflags & IP6T_LOG_IPOPT)
+			printk("OPT ( ");
+
 		switch (currenthdr) {
 		case IPPROTO_FRAGMENT: {
-			struct frag_hdr *fhdr = (struct frag_hdr *)hdrptr;
+			struct frag_hdr _fhdr, *fh;
 
-			/* Max length: 11 "FRAG:65535 " */
-			printk("FRAG:%u ", ntohs(fhdr->frag_off) & 0xFFF8);
+			printk("FRAG:");
+			fh = skb_header_pointer(skb, ptr, sizeof(_fhdr),
+						&_fhdr);
+			if (fh == NULL) {
+				printk("TRUNCATED ");
+				return;
+			}
+
+			/* Max length: 6 "65535 " */
+			printk("%u ", ntohs(fh->frag_off) & 0xFFF8);
 
 			/* Max length: 11 "INCOMPLETE " */
-			if (fhdr->frag_off & htons(0x0001))
+			if (fh->frag_off & htons(0x0001))
 				printk("INCOMPLETE ");
 
-			printk("ID:%08x ", fhdr->identification);
+			printk("ID:%08x ", ntohl(fh->identification));
 
-			if (ntohs(fhdr->frag_off) & 0xFFF8)
+			if (ntohs(fh->frag_off) & 0xFFF8)
 				fragment = 1;
 
+			hdrlen = 8;
+
 			break;
 		}
 		case IPPROTO_DSTOPTS:
 		case IPPROTO_ROUTING:
 		case IPPROTO_HOPOPTS:
+			if (fragment) {
+				if (info->logflags & IP6T_LOG_IPOPT)
+					printk(")");
+				return;
+			}
+			hdrlen = ipv6_optlen(hp);
 			break;
 		/* Max Length */
 		case IPPROTO_AH:
+			if (info->logflags & IP6T_LOG_IPOPT) {
+				struct ip_auth_hdr _ahdr, *ah;
+
+				/* Max length: 3 "AH " */
+				printk("AH ");
+
+				if (fragment) {
+					printk(")");
+					return;
+				}
+
+				ah = skb_header_pointer(skb, ptr, sizeof(_ahdr),
+							&_ahdr);
+				if (ah == NULL) {
+					/*
+					 * Max length: 26 "INCOMPLETE [65535 	
+					 *  bytes] )"
+					 */
+					printk("INCOMPLETE [%u bytes] )",
+					       skb->len - ptr);
+					return;
+				}
+
+				/* Length: 15 "SPI=0xF1234567 */
+				printk("SPI=0x%x ", ntohl(ah->spi));
+
+			}
+
+			hdrlen = (hp->hdrlen+2)<<2;
+			break;
 		case IPPROTO_ESP:
 			if (info->logflags & IP6T_LOG_IPOPT) {
-				struct esphdr *esph = (struct esphdr *)hdrptr;
-				int esp = (currenthdr == IPPROTO_ESP);
+				struct ip_esp_hdr _esph, *eh;
 
 				/* Max length: 4 "ESP " */
-				printk("%s ",esp ? "ESP" : "AH");
+				printk("ESP ");
+
+				if (fragment) {
+					printk(")");
+					return;
+				}
+
+				/*
+				 * Max length: 26 "INCOMPLETE [65535 bytes] )"
+				 */
+				eh = skb_header_pointer(skb, ptr, sizeof(_esph),
+							&_esph);
+				if (eh == NULL) {
+					printk("INCOMPLETE [%u bytes] )",
+					       skb->len - ptr);
+					return;
+				}
+
+				/* Length: 16 "SPI=0xF1234567 )" */
+				printk("SPI=0x%x )", ntohl(eh->spi) );
 
-				/* Length: 15 "SPI=0xF1234567 " */
-				printk("SPI=0x%x ", ntohl(esph->spi) );
-				break;
 			}
+			return;
 		default:
-			break;
+			/* Max length: 20 "Unknown Ext Hdr 255" */
+			printk("Unknown Ext Hdr %u", currenthdr);
+			return;
 		}
-		printk(") ");
-		currenthdr = ip6_nexthdr(currenthdr, &hdrptr);
+		if (info->logflags & IP6T_LOG_IPOPT)
+			printk(") ");
+
+		currenthdr = hp->nexthdr;
+		ptr += hdrlen;
 	}
 
 	switch (currenthdr) {
 	case IPPROTO_TCP: {
-		struct tcphdr *tcph = (struct tcphdr *)hdrptr;
+		struct tcphdr _tcph, *th;
 
 		/* Max length: 10 "PROTO=TCP " */
 		printk("PROTO=TCP ");
@@ -161,51 +207,69 @@ static void dump_packet(const struct ip6
 		if (fragment)
 			break;
 
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		th = skb_header_pointer(skb, ptr, sizeof(_tcph), &_tcph);
+		if (th == NULL) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+
 		/* Max length: 20 "SPT=65535 DPT=65535 " */
 		printk("SPT=%u DPT=%u ",
-		       ntohs(tcph->source), ntohs(tcph->dest));
+		       ntohs(th->source), ntohs(th->dest));
 		/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
 		if (info->logflags & IP6T_LOG_TCPSEQ)
 			printk("SEQ=%u ACK=%u ",
-			       ntohl(tcph->seq), ntohl(tcph->ack_seq));
+			       ntohl(th->seq), ntohl(th->ack_seq));
 		/* Max length: 13 "WINDOW=65535 " */
-		printk("WINDOW=%u ", ntohs(tcph->window));
-		/* Max length: 9 "RES=0x3F " */
-		printk("RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(tcph) & TCP_RESERVED_BITS) >> 22));
+		printk("WINDOW=%u ", ntohs(th->window));
+		/* Max length: 9 "RES=0x3C " */
+		printk("RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(th) & TCP_RESERVED_BITS) >> 22));
 		/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
-		if (tcph->cwr)
+		if (th->cwr)
 			printk("CWR ");
-		if (tcph->ece)
+		if (th->ece)
 			printk("ECE ");
-		if (tcph->urg)
+		if (th->urg)
 			printk("URG ");
-		if (tcph->ack)
+		if (th->ack)
 			printk("ACK ");
-		if (tcph->psh)
+		if (th->psh)
 			printk("PSH ");
-		if (tcph->rst)
+		if (th->rst)
 			printk("RST ");
-		if (tcph->syn)
+		if (th->syn)
 			printk("SYN ");
-		if (tcph->fin)
+		if (th->fin)
 			printk("FIN ");
 		/* Max length: 11 "URGP=65535 " */
-		printk("URGP=%u ", ntohs(tcph->urg_ptr));
+		printk("URGP=%u ", ntohs(th->urg_ptr));
 
 		if ((info->logflags & IP6T_LOG_TCPOPT)
-		    && tcph->doff * 4 != sizeof(struct tcphdr)) {
+		    && th->doff * 4 > sizeof(struct tcphdr)) {
+			u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
 			unsigned int i;
+			unsigned int optsize = th->doff * 4
+					       - sizeof(struct tcphdr);
+
+			op = skb_header_pointer(skb,
+						ptr + sizeof(struct tcphdr),
+						optsize, _opt);
+			if (op == NULL) {
+				printk("OPT (TRUNCATED)");
+				return;
+			}
 
 			/* Max length: 127 "OPT (" 15*4*2chars ") " */
 			printk("OPT (");
-			for (i =sizeof(struct tcphdr); i < tcph->doff * 4; i++)
-				printk("%02X", ((u_int8_t *)tcph)[i]);
+			for (i =0; i < optsize; i++)
+				printk("%02X", op[i]);
 			printk(") ");
 		}
 		break;
 	}
 	case IPPROTO_UDP: {
-		struct udphdr *udph = (struct udphdr *)hdrptr;
+		struct udphdr _udph, *uh;
 
 		/* Max length: 10 "PROTO=UDP " */
 		printk("PROTO=UDP ");
@@ -213,14 +277,21 @@ static void dump_packet(const struct ip6
 		if (fragment)
 			break;
 
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		uh = skb_header_pointer(skb, ptr, sizeof(_udph), &_udph);
+		if (uh == NULL) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+
 		/* Max length: 20 "SPT=65535 DPT=65535 " */
 		printk("SPT=%u DPT=%u LEN=%u ",
-		       ntohs(udph->source), ntohs(udph->dest),
-		       ntohs(udph->len));
+		       ntohs(uh->source), ntohs(uh->dest),
+		       ntohs(uh->len));
 		break;
 	}
 	case IPPROTO_ICMPV6: {
-		struct icmp6hdr *icmp6h = (struct icmp6hdr *)hdrptr;
+		struct icmp6hdr _icmp6h, *ic;
 
 		/* Max length: 13 "PROTO=ICMPv6 " */
 		printk("PROTO=ICMPv6 ");
@@ -228,16 +299,23 @@ static void dump_packet(const struct ip6
 		if (fragment)
 			break;
 
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		ic = skb_header_pointer(skb, ptr, sizeof(_icmp6h), &_icmp6h);
+		if (ic == NULL) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+
 		/* Max length: 18 "TYPE=255 CODE=255 " */
-		printk("TYPE=%u CODE=%u ", icmp6h->icmp6_type, icmp6h->icmp6_code);
+		printk("TYPE=%u CODE=%u ", ic->icmp6_type, ic->icmp6_code);
 
-		switch (icmp6h->icmp6_type) {
+		switch (ic->icmp6_type) {
 		case ICMPV6_ECHO_REQUEST:
 		case ICMPV6_ECHO_REPLY:
 			/* Max length: 19 "ID=65535 SEQ=65535 " */
 			printk("ID=%u SEQ=%u ",
-				ntohs(icmp6h->icmp6_identifier),
-				ntohs(icmp6h->icmp6_sequence));
+				ntohs(ic->icmp6_identifier),
+				ntohs(ic->icmp6_sequence));
 			break;
 		case ICMPV6_MGM_QUERY:
 		case ICMPV6_MGM_REPORT:
@@ -246,7 +324,7 @@ static void dump_packet(const struct ip6
 
 		case ICMPV6_PARAMPROB:
 			/* Max length: 17 "POINTER=ffffffff " */
-			printk("POINTER=%08x ", ntohl(icmp6h->icmp6_pointer));
+			printk("POINTER=%08x ", ntohl(ic->icmp6_pointer));
 			/* Fall through */
 		case ICMPV6_DEST_UNREACH:
 		case ICMPV6_PKT_TOOBIG:
@@ -254,13 +332,14 @@ static void dump_packet(const struct ip6
 			/* Max length: 3+maxlen */
 			if (recurse) {
 				printk("[");
-				dump_packet(info, (struct ipv6hdr *)(icmp6h + 1), 0);
+				dump_packet(info, skb, ptr + sizeof(_icmp6h),
+					    0);
 				printk("] ");
 			}
 
 			/* Max length: 10 "MTU=65535 " */
-			if (icmp6h->icmp6_type == ICMPV6_PKT_TOOBIG)
-				printk("MTU=%u ", ntohl(icmp6h->icmp6_mtu));
+			if (ic->icmp6_type == ICMPV6_PKT_TOOBIG)
+				printk("MTU=%u ", ntohl(ic->icmp6_mtu));
 		}
 		break;
 	}
@@ -328,7 +407,7 @@ ip6t_log_packet(unsigned int hooknum,
 			printk(" ");
 	}
 
-	dump_packet(loginfo, ipv6h, 1);
+	dump_packet(loginfo, skb, (u8*)skb->nh.ipv6h - skb->data, 1);
 	printk("\n");
 	spin_unlock_bh(&log_lock);
 }

----Next_Part(Thu_Oct__7_11:03:53_2004_571)----
