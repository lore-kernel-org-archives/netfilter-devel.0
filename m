From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4 10/10]: fixes for ip6tables
Date: Wed, 01 Dec 2004 17:08:40 +0900 (JST)
Message-ID: <200412010808.iB188ePC002210@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Dec__1_17:08:40_2004_195)--"
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

----Next_Part(Wed_Dec__1_17:08:40_2004_195)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes the following bugs.
	- "offset" argument of match functions are always 0.
	- "datalen" argument of match functions includes extension headers.

And I deleted the code skipping extension headers in {tcp,udp}_match().

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Dec__1_17:08:40_2004_195)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ip6_tables.patch"

--- linux-2.4.28-rc1/./net/ipv6/netfilter/ip6_tables.c	2004-08-08 08:26:07.000000000 +0900
+++ linux-2.4.28-rc1-extfix/./net/ipv6/netfilter/ip6_tables.c	2004-11-13 12:38:21.000000000 +0900
@@ -149,14 +149,15 @@ ip6t_ext_hdr(u8 nexthdr)
 /* Returns whether matches rule or not. */
 static inline int
 ip6_packet_match(const struct sk_buff *skb,
-		 const struct ipv6hdr *ipv6,
 		 const char *indev,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
-		 int isfrag)
+		 unsigned int *protoff,
+		 int *fragoff)
 {
 	size_t i;
 	unsigned long ret;
+	const struct ipv6hdr *ipv6 = skb->nh.ipv6h;
 
 #define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
 
@@ -210,6 +211,7 @@ ip6_packet_match(const struct sk_buff *s
 		struct ipv6_opt_hdr *hdrptr;
 		u_int16_t ptr;		/* Header offset in skb */
 		u_int16_t hdrlen;	/* Header */
+		u_int16_t foff = 0;
 
 		ptr = IPV6_HDR_LEN;
 
@@ -229,6 +231,16 @@ ip6_packet_match(const struct sk_buff *s
 
 			/* Size calculation */
 	                if (currenthdr == IPPROTO_FRAGMENT) {
+				unsigned int foff_off;
+
+				foff_off = ptr + offsetof(struct frag_hdr,
+							  frag_off);
+				if (skb->len - foff_off < sizeof(foff))
+					return 0;
+
+				foff = ntohs(*(u_int16_t *)(skb->data
+							    + foff_off))
+				       & ~0x7;
 	                        hdrlen = 8;
 	                } else if (currenthdr == IPPROTO_AH)
 	                        hdrlen = (hdrptr->hdrlen+2)<<2;
@@ -240,8 +252,16 @@ ip6_packet_match(const struct sk_buff *s
 			/* ptr is too large */
 	                if ( ptr > skb->len ) 
 				return 0;
+			if (foff) {
+				if (ip6t_ext_hdr(currenthdr))
+					return 0;
+				break;
+			}
 		}
 
+		*protoff = ptr;
+		*fragoff = foff;
+
 		/* currenthdr contains the protocol header */
 
 		dprintf("Packet protocol %hi ?= %s%hi.\n",
@@ -329,10 +349,8 @@ ip6t_do_table(struct sk_buff **pskb,
 	      void *userdata)
 {
 	static const char nulldevname[IFNAMSIZ] = { 0 };
-	u_int16_t offset = 0;
-	struct ipv6hdr *ipv6;
-	void *protohdr;
-	u_int16_t datalen;
+	int offset = 0;
+	unsigned int protoff = 0;
 	int hotdrop = 0;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
@@ -341,9 +359,6 @@ ip6t_do_table(struct sk_buff **pskb,
 	struct ip6t_entry *e, *back;
 
 	/* Initialization */
-	ipv6 = (*pskb)->nh.ipv6h;
-	protohdr = (u_int32_t *)((char *)ipv6 + IPV6_HDR_LEN);
-	datalen = (*pskb)->len - IPV6_HDR_LEN;
 	indev = in ? in->name : nulldevname;
 	outdev = out ? out->name : nulldevname;
 
@@ -381,17 +396,20 @@ ip6t_do_table(struct sk_buff **pskb,
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		(*pskb)->nfcache |= e->nfcache;
-		if (ip6_packet_match(*pskb, ipv6, indev, outdev, 
-			&e->ipv6, offset)) {
+		if (ip6_packet_match(*pskb, indev, outdev, &e->ipv6,
+				     &protoff, &offset)) {
 			struct ip6t_entry_target *t;
 
 			if (IP6T_MATCH_ITERATE(e, do_match,
 					       *pskb, in, out,
-					       offset, protohdr,
-					       datalen, &hotdrop) != 0)
+					       offset,
+					       (void *)((*pskb)->data
+							+ protoff),
+					       (*pskb)->len - protoff,
+					       &hotdrop) != 0)
 				goto no_match;
 
-			ADD_COUNTER(e->counters, ntohs(ipv6->payload_len) + IPV6_HDR_LEN, 1);
+			ADD_COUNTER(e->counters, ntohs((*pskb)->nh.ipv6h->payload_len) + IPV6_HDR_LEN, 1);
 
 			t = ip6t_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
@@ -447,11 +465,6 @@ ip6t_do_table(struct sk_buff **pskb,
 				((struct ip6t_entry *)table_base)->comefrom
 					= 0x57acc001;
 #endif
-				/* Target might have changed stuff. */
-				ipv6 = (*pskb)->nh.ipv6h;
-				protohdr = (u_int32_t *)((void *)ipv6 + IPV6_HDR_LEN);
-				datalen = (*pskb)->len - IPV6_HDR_LEN;
-
 				if (verdict == IP6T_CONTINUE)
 					e = (void *)e + e->next_offset;
 				else
@@ -1567,10 +1580,8 @@ tcp_match(const struct sk_buff *skb,
 	  u_int16_t datalen,
 	  int *hotdrop)
 {
-	const struct tcphdr *tcp;
+	const struct tcphdr *tcp = hdr;
 	const struct ip6t_tcp *tcpinfo = matchinfo;
-	int tcpoff;
-	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 
 	/* To quote Alan:
 
@@ -1591,24 +1602,6 @@ tcp_match(const struct sk_buff *skb,
 		return 0;
 	}
 
-	tcpoff = (u8*)(skb->nh.ipv6h + 1) - skb->data;
-	tcpoff = ipv6_skip_exthdr(skb, tcpoff, &nexthdr, skb->len - tcpoff);
-	if (tcpoff < 0 || tcpoff > skb->len) {
-		duprintf("tcp_match: cannot skip exthdr. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	} else if (nexthdr == IPPROTO_FRAGMENT)
-		return 0;
-	else if (nexthdr != IPPROTO_TCP ||
-		 skb->len - tcpoff < sizeof(struct tcphdr)) {
-		/* cannot be occured */
-		duprintf("tcp_match: cannot get TCP header. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	tcp = (struct tcphdr *)(skb->data + tcpoff);
-
 	/* FIXME: Try tcp doff >> packet len against various stacks --RR */
 
 #define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
@@ -1659,10 +1652,8 @@ udp_match(const struct sk_buff *skb,
 	  u_int16_t datalen,
 	  int *hotdrop)
 {
-	const struct udphdr *udp;
+	const struct udphdr *udp = hdr;
 	const struct ip6t_udp *udpinfo = matchinfo;
-	int udpoff;
-	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 
 	if (offset == 0 && datalen < sizeof(struct udphdr)) {
 		/* We've been asked to examine this packet, and we
@@ -1672,23 +1663,6 @@ udp_match(const struct sk_buff *skb,
 		return 0;
 	}
 
-	udpoff = (u8*)(skb->nh.ipv6h + 1) - skb->data;
-	udpoff = ipv6_skip_exthdr(skb, udpoff, &nexthdr, skb->len - udpoff);
-	if (udpoff < 0 || udpoff > skb->len) {
-		duprintf("udp_match: cannot skip exthdr. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	} else if (nexthdr == IPPROTO_FRAGMENT)
-		return 0;
-	else if (nexthdr != IPPROTO_UDP ||
-		 skb->len - udpoff < sizeof(struct udphdr)) {
-		duprintf("udp_match: cannot get UDP header. Dropping.\n");
-		*hotdrop = 1;
-		return 0;
-	}
-
-	udp = (struct udphdr *)(skb->data + udpoff);
-
 	/* Must not be a fragment. */
 	return !offset
 		&& port_match(udpinfo->spts[0], udpinfo->spts[1],

----Next_Part(Wed_Dec__1_17:08:40_2004_195)----
