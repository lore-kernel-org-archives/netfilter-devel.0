From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4 1/10]: fixes for ip6t_LOG
Date: Wed, 01 Dec 2004 17:04:05 +0900 (JST)
Message-ID: <200412010804.iB1846WK025149@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Dec__1_17:04:05_2004_886)--"
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Wed_Dec__1_17:04:05_2004_886)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes the following bugs in ip6t_LOG.c.

	- No check with skb->len. Then invalid memory access may occur.

	- If packet is fragmented and it's not first fragment, nonexistent
	  extension headers is tried to parse.

	- All headers which aren't TCP/UDP/ICMPv6 are treated as IPv6
	  extension header.

	- The encrypted data after ESP is tried to parse.

	- ntohl() for ID in Fragment header is missing.

	- If doff*4 of TCP header is less than sizeof(struct tcphdr),
	  TCP options are tried to parse.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Dec__1_17:04:05_2004_886)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="LOG.patch"

--- linux-2.4.28-rc1/./net/ipv6/netfilter/ip6t_LOG.c	2004-11-10 00:47:10.000000000 +0900
+++ linux-2.4.28-rc1-extfix/./net/ipv6/netfilter/ip6t_LOG.c	2004-11-10 00:51:45.000000000 +0900
@@ -35,54 +35,40 @@ struct in_device;
 	ntohs((addr).s6_addr16[6]), \
 	ntohs((addr).s6_addr16[7])
 
-struct esphdr {
-	__u32   spi;
-}; /* FIXME evil kludge */
-        
-/* Use lock to serialize, so printks don't overlap */
-static spinlock_t log_lock = SPIN_LOCK_UNLOCKED;
+/* FIXME evil kludge */
 
-/* takes in current header and pointer to the header */
-/* if another header exists, sets hdrptr to the next header
-   and returns the new header value, else returns 0 */
-static u_int8_t ip6_nexthdr(u_int8_t currenthdr, u_int8_t **hdrptr)
-{
-	u_int8_t hdrlen, nexthdr = 0;
+struct ahhdr {
+	__u8  nexthdr;
+	__u8  hdrlen;
+	__u16 reserved;
+	__u32 spi;
+	__u32 seq_no;
+};
 
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
+struct esphdr {
+	__u32 spi;
+	__u32 seq_no;
+};
 
-}
+/* Use lock to serialize, so printks don't overlap */
+static spinlock_t log_lock = SPIN_LOCK_UNLOCKED;
 
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
+	struct ipv6hdr *ipv6h;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+
+	if (skb->len - ip6hoff < sizeof(*ipv6h)) {
+		printk("TRUNCATED");
+		return;
+	}
+	ipv6h = (struct ipv6hdr *)(skb->data + ip6hoff);
 
 	/* Max length: 88 "SRC=0000.0000.0000.0000.0000.0000.0000.0000 DST=0000.0000.0000.0000.0000.0000.0000.0000" */
 	printk("SRC=%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x ", NIP6(ipv6h->saddr));
@@ -96,60 +82,131 @@ static void dump_packet(const struct ip6
 	       (ntohl(*(u_int32_t *)ipv6h) & 0x000fffff));
 
 	fragment = 0;
-	hdrptr = (u_int8_t *)(ipv6h + 1);
-	while (currenthdr) {
-		if ((currenthdr == IPPROTO_TCP) ||
-		    (currenthdr == IPPROTO_UDP) ||
-		    (currenthdr == IPPROTO_ICMPV6))
-			break;
+	ptr = ip6hoff + sizeof(struct ipv6hdr);
+	currenthdr = ipv6h->nexthdr;
+	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
+		struct ipv6_opt_hdr *hdr;
+
+		if (skb->len - ptr < sizeof(*hdr)) {
+			printk("TRUNCATED");
+			return;
+		}
+		hdr = (struct ipv6_opt_hdr *)(skb->data + ptr);
+
 		/* Max length: 48 "OPT (...) " */
-		printk("OPT ( ");
+		if (info->logflags & IP6T_LOG_IPOPT)
+			printk("OPT ( ");
+
 		switch (currenthdr) {
 		case IPPROTO_FRAGMENT: {
-			struct frag_hdr *fhdr = (struct frag_hdr *)hdrptr;
+			struct frag_hdr *fhdr;
 
-			/* Max length: 11 "FRAG:65535 " */
-			printk("FRAG:%u ", ntohs(fhdr->frag_off) & 0xFFF8);
+			printk("FRAG:");
+			if (skb->len - ptr < sizeof(*fhdr)) {
+				printk("TRUNCATED ");
+				return;
+			}
+			fhdr = (struct frag_hdr *)(skb->data + ptr);
+
+			/* Max length: 6 "65535 " */
+			printk("%u ", ntohs(fhdr->frag_off) & 0xFFF8);
 
 			/* Max length: 11 "INCOMPLETE " */
 			if (fhdr->frag_off & htons(0x0001))
 				printk("INCOMPLETE ");
 
-			printk("ID:%08x ", fhdr->identification);
+			printk("ID:%08x ", ntohl(fhdr->identification));
 
 			if (ntohs(fhdr->frag_off) & 0xFFF8)
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
+			hdrlen = ipv6_optlen(hdr);
 			break;
 		/* Max Length */
 		case IPPROTO_AH:
+			if (info->logflags & IP6T_LOG_IPOPT) {
+				struct ahhdr *ah;
+
+				/* Max length: 3 "AH " */
+				printk("AH ");
+
+				if (fragment) {
+					printk(")");
+					return;
+				}
+
+				if (skb->len - ptr < sizeof(*ah)) {
+					/*
+					 * Max length: 26 "INCOMPLETE [65535 	
+					 *  bytes] )"
+					 */
+					printk("INCOMPLETE [%u bytes] )",
+					       skb->len - ptr);
+					return;
+				}
+				ah = (struct ahhdr *)(skb->data + ptr);
+
+				/* Length: 15 "SPI=0xF1234567 */
+				printk("SPI=0x%x ", ntohl(ah->spi));
+
+			}
+
+			hdrlen = (hdr->hdrlen+2)<<2;
+			break;
 		case IPPROTO_ESP:
 			if (info->logflags & IP6T_LOG_IPOPT) {
-				struct esphdr *esph = (struct esphdr *)hdrptr;
-				int esp = (currenthdr == IPPROTO_ESP);
+				struct esphdr *esph;
 
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
+				if (skb->len - ptr < sizeof(*esph)) {
+					printk("INCOMPLETE [%u bytes] )",
+					       skb->len - ptr);
+					return;
+				}
+				esph = (struct esphdr *)(skb->data + ptr);
+
+				/* Length: 16 "SPI=0xF1234567 )" */
+				printk("SPI=0x%x )", ntohl(esph->spi) );
 
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
+		currenthdr = hdr->nexthdr;
+		ptr += hdrlen;
 	}
 
 	switch (currenthdr) {
 	case IPPROTO_TCP: {
-		struct tcphdr *tcph = (struct tcphdr *)hdrptr;
+		struct tcphdr *tcph;
 
 		/* Max length: 10 "PROTO=TCP " */
 		printk("PROTO=TCP ");
@@ -157,6 +214,13 @@ static void dump_packet(const struct ip6
 		if (fragment)
 			break;
 
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (skb->len - ptr < sizeof(*tcph)) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+		tcph = (struct tcphdr *)(skb->data + ptr);
+
 		/* Max length: 20 "SPT=65535 DPT=65535 " */
 		printk("SPT=%u DPT=%u ",
 		       ntohs(tcph->source), ntohs(tcph->dest));
@@ -166,7 +230,7 @@ static void dump_packet(const struct ip6
 			       ntohl(tcph->seq), ntohl(tcph->ack_seq));
 		/* Max length: 13 "WINDOW=65535 " */
 		printk("WINDOW=%u ", ntohs(tcph->window));
-		/* Max length: 9 "RES=0x3F " */
+		/* Max length: 9 "RES=0x3C " */
 		printk("RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(tcph) & TCP_RESERVED_BITS) >> 22));
 		/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
 		if (tcph->cwr)
@@ -189,19 +253,29 @@ static void dump_packet(const struct ip6
 		printk("URGP=%u ", ntohs(tcph->urg_ptr));
 
 		if ((info->logflags & IP6T_LOG_TCPOPT)
-		    && tcph->doff * 4 != sizeof(struct tcphdr)) {
+		    && tcph->doff * 4 > sizeof(struct tcphdr)) {
+			u_int8_t *op;
 			unsigned int i;
+			unsigned int optsize = tcph->doff * 4
+					       - sizeof(struct tcphdr);
+
+			if (skb->len - ptr - sizeof(struct tcphdr) < optsize) {
+				printk("OPT (TRUNCATED)");
+				return;
+			}
+			op = (u_int8_t *)(skb->data + ptr
+					  + sizeof(struct tcphdr));
 
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
+		struct udphdr *udph;
 
 		/* Max length: 10 "PROTO=UDP " */
 		printk("PROTO=UDP ");
@@ -209,6 +283,13 @@ static void dump_packet(const struct ip6
 		if (fragment)
 			break;
 
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (skb->len - ptr < sizeof(*udph)) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+		udph = (struct udphdr *)(skb->data + ptr);
+
 		/* Max length: 20 "SPT=65535 DPT=65535 " */
 		printk("SPT=%u DPT=%u LEN=%u ",
 		       ntohs(udph->source), ntohs(udph->dest),
@@ -216,7 +297,7 @@ static void dump_packet(const struct ip6
 		break;
 	}
 	case IPPROTO_ICMPV6: {
-		struct icmp6hdr *icmp6h = (struct icmp6hdr *)hdrptr;
+		struct icmp6hdr *icmp6h;
 
 		/* Max length: 13 "PROTO=ICMPv6 " */
 		printk("PROTO=ICMPv6 ");
@@ -224,6 +305,13 @@ static void dump_packet(const struct ip6
 		if (fragment)
 			break;
 
+		/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+		if (skb->len - ptr < sizeof(*icmp6h)) {
+			printk("INCOMPLETE [%u bytes] ", skb->len - ptr);
+			return;
+		}
+		icmp6h = (struct icmp6hdr *)(skb->data + ptr);
+
 		/* Max length: 18 "TYPE=255 CODE=255 " */
 		printk("TYPE=%u CODE=%u ", icmp6h->icmp6_type, icmp6h->icmp6_code);
 
@@ -250,7 +338,8 @@ static void dump_packet(const struct ip6
 			/* Max length: 3+maxlen */
 			if (recurse) {
 				printk("[");
-				dump_packet(info, (struct ipv6hdr *)(icmp6h + 1), 0);
+				dump_packet(info, skb, ptr + sizeof(*icmp6h),
+					    0);
 				printk("] ");
 			}
 
@@ -260,7 +349,7 @@ static void dump_packet(const struct ip6
 		}
 		break;
 	}
-	/* Max length: 10 "PROTO 255 " */
+	/* Max length: 10 "PROTO=255 " */
 	default:
 		printk("PROTO=%u ", currenthdr);
 	}
@@ -326,7 +415,8 @@ ip6t_log_target(struct sk_buff **pskb,
 			printk(" ");
 	}
 
-	dump_packet(loginfo, ipv6h, 1);
+	dump_packet(loginfo, (*pskb), (u8*)(*pskb)->nh.ipv6h - (*pskb)->data,
+		    1);
 	printk("\n");
 	spin_unlock_bh(&log_lock);
 

----Next_Part(Wed_Dec__1_17:04:05_2004_886)----
