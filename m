From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Thu, 24 Jun 2004 13:04:29 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406240404.NAA01264@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
 boundary="--Next_Part(Thu_Jun_24_13:04:29_2004_682)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kisza@securityaudit.hu, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Jun_24_13:04:29_2004_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, folks,

In the current kernel, skb is linearized by skb_linearize() in ip6_tables.c.
I suggest removing this, and this patch is the 1st step to do it.

To remove skb_linearize(), this patch changes the API of match() like
ip_tables.h

	int (*match)(const struct sk_buff *skb,
		     const struct net_device *in,
		     const struct net_device *out,
		     const void *matchinfo,
		     int offset,
		     unsigned int protoff,
		     int *hotdrop);

"protoff" is the offset of transport protocol header from skb->data.
match modules can get the transport protocol header without skipping IPv6
extension headers.

This patch also changes

	- ip6_packet_match(), tcp_match(), udp_match(), icmp_match() in
	  ip6_tables.c are changed to follow the above API.

	- In all match module, the only arguments of match() are changed.

This patch doesn't remove skb_linearize() yet since more changes are needed
to every match modules. After all modules are changed, we'll be able to just
remove skb_linearize().

Moreover, I optimize and ip6_packet_match() in this patch. In this current
kernel, IPv6 extension headers are skipped many times since ip6t_do_table()
calls ip6_packet_match() per filtering rule.

This patch changes this behavior so that IPv6 extension headers are skipped
at once in ip6t_do_table() unless IP6T_CONTINUE is returned from target.

I know that this optimization is not related with removing skb_linearize().
But I don't want to change ip6_packet_match() many time.

If no objections and no bugs, I want this patch to be applied to mainline
kernel.

comments ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>



----Next_Part(Thu_Jun_24_13:04:29_2004_682)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ip6tables.patch"

diff -Nur linux-2.6.7/include/linux/netfilter_ipv6/ip6_tables.h linux-2.6.7-ip6tables/include/linux/netfilter_ipv6/ip6_tables.h
--- linux-2.6.7/include/linux/netfilter_ipv6/ip6_tables.h	2004-06-16 14:20:04.000000000 +0900
+++ linux-2.6.7-ip6tables/include/linux/netfilter_ipv6/ip6_tables.h	2004-06-23 23:45:43.000000000 +0900
@@ -361,8 +361,7 @@
 		     const struct net_device *out,
 		     const void *matchinfo,
 		     int offset,
-		     const void *hdr,
-		     u_int16_t datalen,
+		     unsigned int protoff,
 		     int *hotdrop);
 
 	/* Called when user tries to insert an entry of this type. */
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6_tables.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6_tables.c
--- linux-2.6.7/net/ipv6/netfilter/ip6_tables.c	2004-06-16 14:19:53.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6_tables.c	2004-06-24 00:00:18.542088784 +0900
@@ -157,14 +157,16 @@
 /* Returns whether matches rule or not. */
 static inline int
 ip6_packet_match(const struct sk_buff *skb,
-		 const struct ipv6hdr *ipv6,
 		 const char *indev,
 		 const char *outdev,
 		 const struct ip6t_ip6 *ip6info,
-		 int isfrag)
+		 u8 *proto,
+		 unsigned int *protoff,
+		 int *isfrag)
 {
 	size_t i;
 	unsigned long ret;
+	const struct ipv6hdr *ipv6 = skb->nh.ipv6h;
 
 #define FWINV(bool,invflg) ((bool) ^ !!(ip6info->invflags & invflg))
 
@@ -215,9 +217,13 @@
 	/* look for the desired protocol header */
 	if((ip6info->flags & IP6T_F_PROTO)) {
 		u_int8_t currenthdr = ipv6->nexthdr;
-		struct ipv6_opt_hdr *hdrptr;
-		u_int16_t ptr;		/* Header offset in skb */
+		struct ipv6_opt_hdr hdr;
+		unsigned int ptr;	/* Header offset in skb */
 		u_int16_t hdrlen;	/* Header */
+		u_int16_t fragoff = 0;
+
+		if (*protoff != 0)
+			goto skip;
 
 		ptr = IPV6_HDR_LEN;
 
@@ -233,31 +239,47 @@
 				(currenthdr == IPPROTO_ESP))
 				return 0;
 
-	                hdrptr = (struct ipv6_opt_hdr *)(skb->data + ptr);
+			if (skb_copy_bits(skb, ptr, &hdr, sizeof(hdr)))
+				BUG();
+
 
 			/* Size calculation */
-	                if (currenthdr == IPPROTO_FRAGMENT) {
+			if (currenthdr == IPPROTO_FRAGMENT) {
+				if (skb_copy_bits(skb,
+						  ptr+offsetof(struct frag_hdr,
+							       frag_off),
+						  &fragoff, sizeof(fragoff)))
+					return 0;
+
+				fragoff = ntohs(fragoff) & ~0x7;
 	                        hdrlen = 8;
 	                } else if (currenthdr == IPPROTO_AH)
-	                        hdrlen = (hdrptr->hdrlen+2)<<2;
+	                        hdrlen = (hdr.hdrlen+2)<<2;
 	                else
-	                        hdrlen = ipv6_optlen(hdrptr);
+	                        hdrlen = ipv6_optlen(&hdr);
 
-			currenthdr = hdrptr->nexthdr;
+			currenthdr = hdr.nexthdr;
 	                ptr += hdrlen;
 			/* ptr is too large */
 	                if ( ptr > skb->len ) 
 				return 0;
+			if (fragoff)
+				break;
 		}
 
+		*proto = currenthdr;
+		*protoff = ptr;
+		*isfrag = fragoff;
+skip:
+
 		/* currenthdr contains the protocol header */
 
 		dprintf("Packet protocol %hi ?= %s%hi.\n",
-				currenthdr, 
+				*proto, 
 				ip6info->invflags & IP6T_INV_PROTO ? "!":"",
 				ip6info->proto);
 
-		if (ip6info->proto == currenthdr) {
+		if (ip6info->proto == *proto) {
 			if(ip6info->invflags & IP6T_INV_PROTO) {
 				return 0;
 			}
@@ -309,13 +331,12 @@
 	     const struct net_device *in,
 	     const struct net_device *out,
 	     int offset,
-	     const void *hdr,
-	     u_int16_t datalen,
+	     unsigned int protoff,
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
 	if (!m->u.kernel.match->match(skb, in, out, m->data,
-				      offset, hdr, datalen, hotdrop))
+				      offset, protoff, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -337,10 +358,9 @@
 	      void *userdata)
 {
 	static const char nulldevname[IFNAMSIZ];
-	u_int16_t offset = 0;
-	struct ipv6hdr *ipv6;
-	void *protohdr;
-	u_int16_t datalen;
+	int offset = 0;
+	unsigned int protoff = 0;
+	u8 proto = 0;
 	int hotdrop = 0;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
@@ -353,9 +373,6 @@
 		return NF_DROP;
 
 	/* Initialization */
-	ipv6 = (*pskb)->nh.ipv6h;
-	protohdr = (u_int32_t *)((char *)ipv6 + IPV6_HDR_LEN);
-	datalen = (*pskb)->len - IPV6_HDR_LEN;
 	indev = in ? in->name : nulldevname;
 	outdev = out ? out->name : nulldevname;
 
@@ -392,17 +409,19 @@
 		IP_NF_ASSERT(e);
 		IP_NF_ASSERT(back);
 		(*pskb)->nfcache |= e->nfcache;
-		if (ip6_packet_match(*pskb, ipv6, indev, outdev, 
-			&e->ipv6, offset)) {
+		if (ip6_packet_match(*pskb, indev, outdev, 
+			&e->ipv6, &proto, &protoff, &offset)) {
 			struct ip6t_entry_target *t;
 
 			if (IP6T_MATCH_ITERATE(e, do_match,
 					       *pskb, in, out,
-					       offset, protohdr,
-					       datalen, &hotdrop) != 0)
+					       offset, protoff, &hotdrop) != 0)
 				goto no_match;
 
-			ADD_COUNTER(e->counters, ntohs(ipv6->payload_len) + IPV6_HDR_LEN, 1);
+			ADD_COUNTER(e->counters,
+				    ntohs((*pskb)->nh.ipv6h->payload_len)
+					  + IPV6_HDR_LEN,
+				    1);
 
 			t = ip6t_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
@@ -459,9 +478,9 @@
 					= 0x57acc001;
 #endif
 				/* Target might have changed stuff. */
-				ipv6 = (*pskb)->nh.ipv6h;
-				protohdr = (u_int32_t *)((void *)ipv6 + IPV6_HDR_LEN);
-				datalen = (*pskb)->len - IPV6_HDR_LEN;
+				offset = 0;
+				proto = 0;
+				protoff = 0;
 
 				if (verdict == IP6T_CONTINUE)
 					e = (void *)e + e->next_offset;
@@ -1534,23 +1553,25 @@
 
 static int
 tcp_find_option(u_int8_t option,
-		const struct tcphdr *tcp,
-		u_int16_t datalen,
+		const struct sk_buff *skb,
+		unsigned int tcpoff,
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
-	if (tcp->doff * 4 < sizeof(struct tcphdr) ||
-	    tcp->doff * 4 > datalen) {
+	if (skb_copy_bits(skb, tcpoff + sizeof(struct tcphdr),
+			  opt, optlen) < 0) {
 		*hotdrop = 1;
 		return 0;
 	}
 
-	while (i < tcp->doff * 4) {
+	for (i = 0; i < optlen; ) {
 		if (opt[i] == option) return !invert;
 		if (opt[i] < 2) i++;
 		else i += opt[i+1]?:1;
@@ -1565,27 +1586,30 @@
 	  const struct net_device *out,
 	  const void *matchinfo,
 	  int offset,
-	  const void *hdr,
-	  u_int16_t datalen,
+	  unsigned int protoff,
 	  int *hotdrop)
 {
-	const struct tcphdr *tcp;
+	struct tcphdr tcph;
 	const struct ip6t_tcp *tcpinfo = matchinfo;
-	int tcpoff;
-	u8 nexthdr = skb->nh.ipv6h->nexthdr;
-
-	/* To quote Alan:
 
-	   Don't allow a fragment of TCP 8 bytes in. Nobody normal
-	   causes this. Its a cracker trying to break in by doing a
-	   flag overwrite to pass the direction checks.
-	*/
+	if (offset) {
+		/* To quote Alan:
 
-	if (offset == 1) {
-		duprintf("Dropping evil TCP offset=1 frag.\n");
-		*hotdrop = 1;
+		   Don't allow a fragment of TCP 8 bytes in. Nobody normal
+		   causes this. Its a cracker trying to break in by doing a
+		   flag overwrite to pass the direction checks.
+		*/
+		if (offset == 1) {
+			duprintf("Dropping evil TCP offset=1 frag.\n");
+			*hotdrop = 1;
+		}
+		/* Must not be a fragment. */
 		return 0;
-	} else if (offset == 0 && datalen < sizeof(struct tcphdr)) {
+	}
+
+#define FWINVTCP(bool,invflg) ((bool) ^ !!(tcpinfo->invflags & invflg))
+
+	if (skb_copy_bits(skb, protoff, &tcph, sizeof(tcph)) < 0) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
@@ -1593,45 +1617,30 @@
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
+	if (tcpinfo->option) {
+		if (tcph.doff * 4 < sizeof(tcph)) {
+			*hotdrop = 1;
+			return 0;
+		}
+		if (!tcp_find_option(tcpinfo->option, skb, protoff,
+				     tcph.doff*4 - sizeof(tcph),
+				     tcpinfo->invflags & IP6T_TCP_INV_OPTION,
+				     hotdrop))
+			return 0;
 	}
-
-	tcp = (struct tcphdr *)(skb->data + tcpoff);
-
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
+	return 1;
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -1657,16 +1666,17 @@
 	  const struct net_device *out,
 	  const void *matchinfo,
 	  int offset,
-	  const void *hdr,
-	  u_int16_t datalen,
+	  unsigned int protoff,
 	  int *hotdrop)
 {
-	const struct udphdr *udp;
+	struct udphdr udph;
 	const struct ip6t_udp *udpinfo = matchinfo;
-	int udpoff;
-	u8 nexthdr = skb->nh.ipv6h->nexthdr;
 
-	if (offset == 0 && datalen < sizeof(struct udphdr)) {
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	if (skb_copy_bits(skb, protoff, &udph, sizeof(udph)) < 0) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil UDP tinygram.\n");
@@ -1674,30 +1684,11 @@
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
 
@@ -1747,14 +1738,17 @@
 	   const struct net_device *out,
 	   const void *matchinfo,
 	   int offset,
-	   const void *hdr,
-	   u_int16_t datalen,
+	   unsigned int protoff,
 	   int *hotdrop)
 {
-	const struct icmp6hdr *icmp = hdr;
+	struct icmp6hdr icmp;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
-	if (offset == 0 && datalen < 2) {
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	if (skb_copy_bits(skb, protoff, &icmp, sizeof(icmp)) < 0) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 		duprintf("Dropping evil ICMP tinygram.\n");
@@ -1762,13 +1756,11 @@
 		return 0;
 	}
 
-	/* Must not be a fragment. */
-	return !offset
-		&& icmp6_type_code_match(icmpinfo->type,
-					icmpinfo->code[0],
-					icmpinfo->code[1],
-					icmp->icmp6_type, icmp->icmp6_code,
-					!!(icmpinfo->invflags&IP6T_ICMP_INV));
+	return icmp6_type_code_match(icmpinfo->type,
+				     icmpinfo->code[0],
+				     icmpinfo->code[1],
+				     icmp.icmp6_type, icmp.icmp6_code,
+				     !!(icmpinfo->invflags&IP6T_ICMP_INV));
 }
 
 /* Called when user tries to insert an entry of this type. */
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_ah.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_ah.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_ah.c	2004-06-16 14:18:58.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_ah.c	2004-06-23 23:45:43.000000000 +0900
@@ -45,8 +45,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ip_auth_hdr *ah = NULL;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_dst.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_dst.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_dst.c	2004-06-16 14:18:56.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_dst.c	2004-06-23 23:45:43.000000000 +0900
@@ -60,8 +60,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ipv6_opt_hdr *optsh = NULL;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_esp.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_esp.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_esp.c	2004-06-16 14:19:36.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_esp.c	2004-06-23 23:45:43.000000000 +0900
@@ -45,8 +45,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	struct ip_esp_hdr *esp = NULL;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_eui64.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_eui64.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_eui64.c	2004-06-16 14:18:52.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_eui64.c	2004-06-23 23:45:43.000000000 +0900
@@ -24,8 +24,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_frag.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_frag.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_frag.c	2004-06-16 14:19:01.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_frag.c	2004-06-23 23:45:43.000000000 +0900
@@ -70,8 +70,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct fraghdr *frag = NULL;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_hbh.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_hbh.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_hbh.c	2004-06-16 14:19:52.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_hbh.c	2004-06-23 23:45:43.000000000 +0900
@@ -59,8 +59,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ipv6_opt_hdr *optsh = NULL;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_hl.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_hl.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_hl.c	2004-06-16 14:19:42.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_hl.c	2004-06-23 23:45:43.000000000 +0900
@@ -20,7 +20,7 @@
 
 static int match(const struct sk_buff *skb, const struct net_device *in,
 		 const struct net_device *out, const void *matchinfo,
-		 int offset, const void *hdr, u_int16_t datalen,
+		 int offset, unsigned int protoff,
 		 int *hotdrop)
 {
 	const struct ip6t_hl_info *info = matchinfo;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_ipv6header.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_ipv6header.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_ipv6header.c	2004-06-16 14:20:26.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_ipv6header.c	2004-06-23 23:45:43.000000000 +0900
@@ -31,8 +31,7 @@
 		 const struct net_device *out,
 		 const void *matchinfo,
 		 int offset,
-		 const void *protohdr,
-		 u_int16_t datalen,
+		 unsigned int protoff,
 		 int *hotdrop)
 {
 	const struct ip6t_ipv6header_info *info = matchinfo;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_length.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_length.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_length.c	2004-06-16 14:20:16.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_length.c	2004-06-23 23:45:43.000000000 +0900
@@ -23,8 +23,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ip6t_length_info *info = matchinfo;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_limit.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_limit.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_limit.c	2004-06-16 14:19:02.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_limit.c	2004-06-23 23:45:43.000000000 +0900
@@ -57,8 +57,7 @@
 		const struct net_device *out,
 		const void *matchinfo,
 		int offset,
-		const void *hdr,
-		u_int16_t datalen,
+		unsigned int protoff,
 		int *hotdrop)
 {
 	struct ip6t_rateinfo *r = ((struct ip6t_rateinfo *)matchinfo)->master;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_mac.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_mac.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_mac.c	2004-06-16 14:20:03.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_mac.c	2004-06-23 23:45:43.000000000 +0900
@@ -25,8 +25,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
     const struct ip6t_mac_info *info = matchinfo;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_mark.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_mark.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_mark.c	2004-06-16 14:20:26.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_mark.c	2004-06-23 23:45:43.000000000 +0900
@@ -24,8 +24,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ip6t_mark_info *info = matchinfo;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_multiport.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_multiport.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_multiport.c	2004-06-16 14:20:26.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_multiport.c	2004-06-23 23:45:43.000000000 +0900
@@ -53,15 +53,14 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
-	const struct udphdr *udp = hdr;
+	const struct udphdr *udp = (const struct udphdr *)(skb->data + protoff);
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
 	/* Must be big enough to read ports. */
-	if (offset == 0 && datalen < sizeof(struct udphdr)) {
+	if (offset == 0 && skb->len - protoff < sizeof(struct udphdr)) {
 		/* We've been asked to examine this packet, and we
 		   can't.  Hence, no choice but to drop. */
 			duprintf("ip6t_multiport:"
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_owner.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_owner.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_owner.c	2004-06-16 14:19:52.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_owner.c	2004-06-23 23:45:43.000000000 +0900
@@ -92,8 +92,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	const struct ip6t_owner_info *info = matchinfo;
diff -Nur linux-2.6.7/net/ipv6/netfilter/ip6t_rt.c linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_rt.c
--- linux-2.6.7/net/ipv6/netfilter/ip6t_rt.c	2004-06-16 14:19:02.000000000 +0900
+++ linux-2.6.7-ip6tables/net/ipv6/netfilter/ip6t_rt.c	2004-06-23 23:45:43.000000000 +0900
@@ -47,8 +47,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *protohdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
        struct ipv6_rt_hdr *route = NULL;

----Next_Part(Thu_Jun_24_13:04:29_2004_682)----
