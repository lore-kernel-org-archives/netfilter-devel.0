From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/3] ip6tables: cleanup indentation and white spaces
Date: Mon, 16 Jan 2006 18:38:58 +0900 (JST)
Message-ID: <200601160938.k0G9cxox003667@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
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


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit bfedb77896363cc451e6ea0f0a78dd315e38da4b
tree 89d714451434c1e884a3f9661a73dd6df8b780bc
parent 7e0b844bc4504575df41a3a7ca80ad8fb79ea878
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jan 2006 17:07:46 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jan 2006 17:07:46 +0900

 net/ipv6/netfilter/ip6t_dst.c        |  147 ++++++++++++------------
 net/ipv6/netfilter/ip6t_eui64.c      |   64 +++++-----
 net/ipv6/netfilter/ip6t_frag.c       |  153 ++++++++++++-------------
 net/ipv6/netfilter/ip6t_hbh.c        |  147 ++++++++++++------------
 net/ipv6/netfilter/ip6t_ipv6header.c |   79 ++++++-------
 net/ipv6/netfilter/ip6t_owner.c      |   28 ++---
 net/ipv6/netfilter/ip6t_rt.c         |  211 ++++++++++++++++++----------------
 7 files changed, 417 insertions(+), 412 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
index 80fe826..b4c153a 100644
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -36,19 +36,19 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 #endif
 
 /*
- * (Type & 0xC0) >> 6
- * 	0	-> ignorable
- * 	1	-> must drop the packet
- * 	2	-> send ICMP PARM PROB regardless and drop packet
- * 	3	-> Send ICMP if not a multicast address and drop packet
+ *  (Type & 0xC0) >> 6
+ *	0	-> ignorable
+ *	1	-> must drop the packet
+ *	2	-> send ICMP PARM PROB regardless and drop packet
+ *	3	-> Send ICMP if not a multicast address and drop packet
  *  (Type & 0x20) >> 5
- *  	0	-> invariant
- *  	1	-> can change the routing
+ *	0	-> invariant
+ *	1	-> can change the routing
  *  (Type & 0x1F) Type
- *      0	-> Pad1 (only 1 byte!)
- *      1	-> PadN LENGTH info (total length = length + 2)
- *      C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
- *      5	-> RTALERT 2 x x
+ *	0	-> Pad1 (only 1 byte!)
+ *	1	-> PadN LENGTH info (total length = length + 2)
+ *	C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
+ *	5	-> RTALERT 2 x x
  */
 
 static int
@@ -60,16 +60,16 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_opt_hdr _optsh, *oh;
-       const struct ip6t_opts *optinfo = matchinfo;
-       unsigned int temp;
-       unsigned int ptr;
-       unsigned int hdrlen = 0;
-       unsigned int ret = 0;
-       u8 _opttype, *tp = NULL;
-       u8 _optlen, *lp = NULL;
-       unsigned int optlen;
-       
+	struct ipv6_opt_hdr _optsh, *oh;
+	const struct ip6t_opts *optinfo = matchinfo;
+	unsigned int temp;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+	unsigned int ret = 0;
+	u8 _opttype, *tp = NULL;
+	u8 _optlen, *lp = NULL;
+	unsigned int optlen;
+
 #if HOPBYHOP
 	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP, NULL) < 0)
 #else
@@ -77,42 +77,41 @@ match(const struct sk_buff *skb,
 #endif
 		return 0;
 
-       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
-       if (oh == NULL){
-	       *hotdrop = 1;
-       		return 0;
-       }
-
-       hdrlen = ipv6_optlen(oh);
-       if (skb->len - ptr < hdrlen){
-	       /* Packet smaller than it's length field */
-       		return 0;
-       }
-
-       DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
-
-       DEBUGP("len %02X %04X %02X ",
-       		optinfo->hdrlen, hdrlen,
-       		(!(optinfo->flags & IP6T_OPTS_LEN) ||
-                           ((optinfo->hdrlen == hdrlen) ^
-                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
-
-       ret = (oh != NULL)
-       		&&
-	      	(!(optinfo->flags & IP6T_OPTS_LEN) ||
-                           ((optinfo->hdrlen == hdrlen) ^
-                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
-
-       ptr += 2;
-       hdrlen -= 2;
-       if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
-	       return ret;
+	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
+	if (oh == NULL) {
+		*hotdrop = 1;
+		return 0;
+	}
+
+	hdrlen = ipv6_optlen(oh);
+	if (skb->len - ptr < hdrlen) {
+		/* Packet smaller than it's length field */
+		return 0;
+	}
+
+	DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
+
+	DEBUGP("len %02X %04X %02X ",
+	       optinfo->hdrlen, hdrlen,
+	       (!(optinfo->flags & IP6T_OPTS_LEN) ||
+		((optinfo->hdrlen == hdrlen) ^
+		 !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
+
+	ret = (oh != NULL) &&
+	      (!(optinfo->flags & IP6T_OPTS_LEN) ||
+	       ((optinfo->hdrlen == hdrlen) ^
+		!!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
+
+	ptr += 2;
+	hdrlen -= 2;
+	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
+		return ret;
 	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
 		DEBUGP("Not strict - not implemented");
 	} else {
 		DEBUGP("Strict ");
-		DEBUGP("#%d ",optinfo->optsnr);
-		for(temp=0; temp<optinfo->optsnr; temp++){
+		DEBUGP("#%d ", optinfo->optsnr);
+		for (temp = 0; temp < optinfo->optsnr; temp++) {
 			/* type field exists ? */
 			if (hdrlen < 1)
 				break;
@@ -122,10 +121,10 @@ match(const struct sk_buff *skb,
 				break;
 
 			/* Type check */
-			if (*tp != (optinfo->opts[temp] & 0xFF00)>>8){
+			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
 				DEBUGP("Tbad %02X %02X\n",
 				       *tp,
-				       (optinfo->opts[temp] & 0xFF00)>>8);
+				       (optinfo->opts[temp] & 0xFF00) >> 8);
 				return 0;
 			} else {
 				DEBUGP("Tok ");
@@ -169,7 +168,8 @@ match(const struct sk_buff *skb,
 		}
 		if (temp == optinfo->optsnr)
 			return ret;
-		else return 0;
+		else
+			return 0;
 	}
 
 	return 0;
@@ -178,25 +178,24 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const void *info,
-          void *matchinfo,
-          unsigned int matchinfosize,
-          unsigned int hook_mask)
+	   const void *info,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
 {
-       const struct ip6t_opts *optsinfo = matchinfo;
+	const struct ip6t_opts *optsinfo = matchinfo;
 
-       if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_opts))) {
-              DEBUGP("ip6t_opts: matchsize %u != %u\n",
-                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
-              return 0;
-       }
-       if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
-              DEBUGP("ip6t_opts: unknown flags %X\n",
-                      optsinfo->invflags);
-              return 0;
-       }
+	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_opts))) {
+		DEBUGP("ip6t_opts: matchsize %u != %u\n",
+		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
+		return 0;
+	}
+	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
+		DEBUGP("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
+		return 0;
+	}
 
-       return 1;
+	return 1;
 }
 
 static struct ip6t_match opts_match = {
@@ -212,12 +211,12 @@ static struct ip6t_match opts_match = {
 
 static int __init init(void)
 {
-       return ip6t_register_match(&opts_match);
+	return ip6t_register_match(&opts_match);
 }
 
 static void __exit cleanup(void)
 {
-       ip6t_unregister_match(&opts_match);
+	ip6t_unregister_match(&opts_match);
 }
 
 module_init(init);
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index ddf5f57..27396ac 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -27,45 +27,45 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
+	unsigned char eui64[8];
+	int i = 0;
 
-    unsigned char eui64[8];
-    int i=0;
+	if (!(skb->mac.raw >= skb->head &&
+	      (skb->mac.raw + ETH_HLEN) <= skb->data) &&
+	    offset != 0) {
+		*hotdrop = 1;
+		return 0;
+	}
 
-     if ( !(skb->mac.raw >= skb->head
-                && (skb->mac.raw + ETH_HLEN) <= skb->data)
-                && offset != 0) {
-                        *hotdrop = 1;
-                        return 0;
-                }
-    
-    memset(eui64, 0, sizeof(eui64));
-
-    if (eth_hdr(skb)->h_proto == ntohs(ETH_P_IPV6)) {
-      if (skb->nh.ipv6h->version == 0x6) { 
-         memcpy(eui64, eth_hdr(skb)->h_source, 3);
-         memcpy(eui64 + 5, eth_hdr(skb)->h_source + 3, 3);
-	 eui64[3]=0xff;
-	 eui64[4]=0xfe;
-	 eui64[0] |= 0x02;
-
-	 i=0;
-	 while ((skb->nh.ipv6h->saddr.s6_addr[8+i] ==
-			 eui64[i]) && (i<8)) i++;
-
-	 if ( i == 8 )
-	 	return 1;
-      }
-    }
+	memset(eui64, 0, sizeof(eui64));
+
+	if (eth_hdr(skb)->h_proto == ntohs(ETH_P_IPV6)) {
+		if (skb->nh.ipv6h->version == 0x6) {
+			memcpy(eui64, eth_hdr(skb)->h_source, 3);
+			memcpy(eui64 + 5, eth_hdr(skb)->h_source + 3, 3);
+			eui64[3] = 0xff;
+			eui64[4] = 0xfe;
+			eui64[0] |= 0x02;
+
+			i = 0;
+			while ((skb->nh.ipv6h->saddr.s6_addr[8+i] == eui64[i])
+			       && (i < 8))
+				i++;
+
+			if (i == 8)
+				return 1;
+		}
+	}
 
-    return 0;
+	return 0;
 }
 
 static int
 ip6t_eui64_checkentry(const char *tablename,
-		   const void  *ip,
-		   void *matchinfo,
-		   unsigned int matchsize,
-		   unsigned int hook_mask)
+		      const void *ip,
+		      void *matchinfo,
+		      unsigned int matchsize,
+		      unsigned int hook_mask)
 {
 	if (hook_mask
 	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index a9964b9..4c14125 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -31,12 +31,12 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 static inline int
 id_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
 {
-       int r=0;
-       DEBUGP("frag id_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-              min,id,max);
-       r=(id >= min && id <= max) ^ invert;
-       DEBUGP(" result %s\n",r? "PASS" : "FAILED");
-       return r;
+	int r = 0;
+	DEBUGP("frag id_match:%c 0x%x <= 0x%x <= 0x%x", invert ? '!' : ' ',
+	       min, id, max);
+	r = (id >= min && id <= max) ^ invert;
+	DEBUGP(" result %s\n", r ? "PASS" : "FAILED");
+	return r;
 }
 
 static int
@@ -48,92 +48,91 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct frag_hdr _frag, *fh;
-       const struct ip6t_frag *fraginfo = matchinfo;
-       unsigned int ptr;
+	struct frag_hdr _frag, *fh;
+	const struct ip6t_frag *fraginfo = matchinfo;
+	unsigned int ptr;
 
 	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT, NULL) < 0)
 		return 0;
 
 	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
-	if (fh == NULL){
+	if (fh == NULL) {
 		*hotdrop = 1;
 		return 0;
 	}
 
-       DEBUGP("INFO %04X ", fh->frag_off);
-       DEBUGP("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
-       DEBUGP("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
-       DEBUGP("MF %04X ", fh->frag_off & htons(IP6_MF));
-       DEBUGP("ID %u %08X\n", ntohl(fh->identification),
-	      ntohl(fh->identification));
-
-       DEBUGP("IPv6 FRAG id %02X ",
-       		(id_match(fraginfo->ids[0], fraginfo->ids[1],
-                           ntohl(fh->identification),
-                           !!(fraginfo->invflags & IP6T_FRAG_INV_IDS))));
-       DEBUGP("res %02X %02X%04X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_RES), fh->reserved,
-		ntohs(fh->frag_off) & 0x6,
-       		!((fraginfo->flags & IP6T_FRAG_RES)
-			&& (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
-       DEBUGP("first %02X %02X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_FST),
-		ntohs(fh->frag_off) & ~0x7,
-       		!((fraginfo->flags & IP6T_FRAG_FST)
-			&& (ntohs(fh->frag_off) & ~0x7)));
-       DEBUGP("mf %02X %02X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_MF),
-		ntohs(fh->frag_off) & IP6_MF,
-       		!((fraginfo->flags & IP6T_FRAG_MF)
-			&& !((ntohs(fh->frag_off) & IP6_MF))));
-       DEBUGP("last %02X %02X %02X\n", 
-       		(fraginfo->flags & IP6T_FRAG_NMF),
-		ntohs(fh->frag_off) & IP6_MF,
-       		!((fraginfo->flags & IP6T_FRAG_NMF)
-			&& (ntohs(fh->frag_off) & IP6_MF)));
-
-       return (fh != NULL)
-       		&&
-       		(id_match(fraginfo->ids[0], fraginfo->ids[1],
-			  ntohl(fh->identification),
-                           !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)))
-		&&
-		!((fraginfo->flags & IP6T_FRAG_RES)
-			&& (fh->reserved || (ntohs(fh->frag_off) & 0x6)))
-		&&
-		!((fraginfo->flags & IP6T_FRAG_FST)
-			&& (ntohs(fh->frag_off) & ~0x7))
-		&&
-		!((fraginfo->flags & IP6T_FRAG_MF)
-			&& !(ntohs(fh->frag_off) & IP6_MF))
-		&&
-		!((fraginfo->flags & IP6T_FRAG_NMF)
-			&& (ntohs(fh->frag_off) & IP6_MF));
+	DEBUGP("INFO %04X ", fh->frag_off);
+	DEBUGP("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
+	DEBUGP("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
+	DEBUGP("MF %04X ", fh->frag_off & htons(IP6_MF));
+	DEBUGP("ID %u %08X\n", ntohl(fh->identification),
+	       ntohl(fh->identification));
+
+	DEBUGP("IPv6 FRAG id %02X ",
+	       (id_match(fraginfo->ids[0], fraginfo->ids[1],
+			 ntohl(fh->identification),
+			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS))));
+	DEBUGP("res %02X %02X%04X %02X ",
+	       (fraginfo->flags & IP6T_FRAG_RES), fh->reserved,
+	       ntohs(fh->frag_off) & 0x6,
+	       !((fraginfo->flags & IP6T_FRAG_RES)
+		 && (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
+	DEBUGP("first %02X %02X %02X ",
+	       (fraginfo->flags & IP6T_FRAG_FST),
+	       ntohs(fh->frag_off) & ~0x7,
+	       !((fraginfo->flags & IP6T_FRAG_FST)
+		 && (ntohs(fh->frag_off) & ~0x7)));
+	DEBUGP("mf %02X %02X %02X ",
+	       (fraginfo->flags & IP6T_FRAG_MF),
+	       ntohs(fh->frag_off) & IP6_MF,
+	       !((fraginfo->flags & IP6T_FRAG_MF)
+		 && !((ntohs(fh->frag_off) & IP6_MF))));
+	DEBUGP("last %02X %02X %02X\n",
+	       (fraginfo->flags & IP6T_FRAG_NMF),
+	       ntohs(fh->frag_off) & IP6_MF,
+	       !((fraginfo->flags & IP6T_FRAG_NMF)
+		 && (ntohs(fh->frag_off) & IP6_MF)));
+
+	return (fh != NULL)
+	       &&
+	       (id_match(fraginfo->ids[0], fraginfo->ids[1],
+			 ntohl(fh->identification),
+			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)))
+	       &&
+	       !((fraginfo->flags & IP6T_FRAG_RES)
+		 && (fh->reserved || (ntohs(fh->frag_off) & 0x6)))
+	       &&
+	       !((fraginfo->flags & IP6T_FRAG_FST)
+		 && (ntohs(fh->frag_off) & ~0x7))
+	       &&
+	       !((fraginfo->flags & IP6T_FRAG_MF)
+		 && !(ntohs(fh->frag_off) & IP6_MF))
+	       &&
+	       !((fraginfo->flags & IP6T_FRAG_NMF)
+		 && (ntohs(fh->frag_off) & IP6_MF));
 }
 
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const void *ip,
-          void *matchinfo,
-          unsigned int matchinfosize,
-          unsigned int hook_mask)
+	   const void *ip,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
 {
-       const struct ip6t_frag *fraginfo = matchinfo;
+	const struct ip6t_frag *fraginfo = matchinfo;
 
-       if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_frag))) {
-              DEBUGP("ip6t_frag: matchsize %u != %u\n",
-                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_frag)));
-              return 0;
-       }
-       if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
-              DEBUGP("ip6t_frag: unknown flags %X\n",
-                      fraginfo->invflags);
-              return 0;
-       }
+	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_frag))) {
+		DEBUGP("ip6t_frag: matchsize %u != %u\n",
+		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_frag)));
+		return 0;
+	}
+	if (fraginfo->invflags & ~IP6T_FRAG_INV_MASK) {
+		DEBUGP("ip6t_frag: unknown flags %X\n", fraginfo->invflags);
+		return 0;
+	}
 
-       return 1;
+	return 1;
 }
 
 static struct ip6t_match frag_match = {
@@ -145,12 +144,12 @@ static struct ip6t_match frag_match = {
 
 static int __init init(void)
 {
-       return ip6t_register_match(&frag_match);
+	return ip6t_register_match(&frag_match);
 }
 
 static void __exit cleanup(void)
 {
-       ip6t_unregister_match(&frag_match);
+	ip6t_unregister_match(&frag_match);
 }
 
 module_init(init);
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index ed8ded1..37a8474 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -36,19 +36,19 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 #endif
 
 /*
- * (Type & 0xC0) >> 6
- * 	0	-> ignorable
- * 	1	-> must drop the packet
- * 	2	-> send ICMP PARM PROB regardless and drop packet
- * 	3	-> Send ICMP if not a multicast address and drop packet
+ *  (Type & 0xC0) >> 6
+ *	0	-> ignorable
+ *	1	-> must drop the packet
+ *	2	-> send ICMP PARM PROB regardless and drop packet
+ *	3	-> Send ICMP if not a multicast address and drop packet
  *  (Type & 0x20) >> 5
- *  	0	-> invariant
- *  	1	-> can change the routing
+ *	0	-> invariant
+ *	1	-> can change the routing
  *  (Type & 0x1F) Type
- *      0	-> Pad1 (only 1 byte!)
- *      1	-> PadN LENGTH info (total length = length + 2)
- *      C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
- *      5	-> RTALERT 2 x x
+ *	0	-> Pad1 (only 1 byte!)
+ *	1	-> PadN LENGTH info (total length = length + 2)
+ *	C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
+ *	5	-> RTALERT 2 x x
  */
 
 static int
@@ -60,16 +60,16 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_opt_hdr _optsh, *oh;
-       const struct ip6t_opts *optinfo = matchinfo;
-       unsigned int temp;
-       unsigned int ptr;
-       unsigned int hdrlen = 0;
-       unsigned int ret = 0;
-       u8 _opttype, *tp = NULL;
-       u8 _optlen, *lp = NULL;
-       unsigned int optlen;
-       
+	struct ipv6_opt_hdr _optsh, *oh;
+	const struct ip6t_opts *optinfo = matchinfo;
+	unsigned int temp;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+	unsigned int ret = 0;
+	u8 _opttype, *tp = NULL;
+	u8 _optlen, *lp = NULL;
+	unsigned int optlen;
+
 #if HOPBYHOP
 	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP, NULL) < 0)
 #else
@@ -77,42 +77,41 @@ match(const struct sk_buff *skb,
 #endif
 		return 0;
 
-       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
-       if (oh == NULL){
-	       *hotdrop = 1;
-       		return 0;
-       }
-
-       hdrlen = ipv6_optlen(oh);
-       if (skb->len - ptr < hdrlen){
-	       /* Packet smaller than it's length field */
-       		return 0;
-       }
-
-       DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
-
-       DEBUGP("len %02X %04X %02X ",
-       		optinfo->hdrlen, hdrlen,
-       		(!(optinfo->flags & IP6T_OPTS_LEN) ||
-                           ((optinfo->hdrlen == hdrlen) ^
-                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
-
-       ret = (oh != NULL)
-       		&&
-	      	(!(optinfo->flags & IP6T_OPTS_LEN) ||
-                           ((optinfo->hdrlen == hdrlen) ^
-                           !!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
-
-       ptr += 2;
-       hdrlen -= 2;
-       if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
-	       return ret;
+	oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
+	if (oh == NULL) {
+		*hotdrop = 1;
+		return 0;
+	}
+
+	hdrlen = ipv6_optlen(oh);
+	if (skb->len - ptr < hdrlen) {
+		/* Packet smaller than it's length field */
+		return 0;
+	}
+
+	DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
+
+	DEBUGP("len %02X %04X %02X ",
+	       optinfo->hdrlen, hdrlen,
+	       (!(optinfo->flags & IP6T_OPTS_LEN) ||
+		((optinfo->hdrlen == hdrlen) ^
+		 !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
+
+	ret = (oh != NULL) &&
+	      (!(optinfo->flags & IP6T_OPTS_LEN) ||
+	       ((optinfo->hdrlen == hdrlen) ^
+		!!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
+
+	ptr += 2;
+	hdrlen -= 2;
+	if (!(optinfo->flags & IP6T_OPTS_OPTS)) {
+		return ret;
 	} else if (optinfo->flags & IP6T_OPTS_NSTRICT) {
 		DEBUGP("Not strict - not implemented");
 	} else {
 		DEBUGP("Strict ");
-		DEBUGP("#%d ",optinfo->optsnr);
-		for(temp=0; temp<optinfo->optsnr; temp++){
+		DEBUGP("#%d ", optinfo->optsnr);
+		for (temp = 0; temp < optinfo->optsnr; temp++) {
 			/* type field exists ? */
 			if (hdrlen < 1)
 				break;
@@ -122,10 +121,10 @@ match(const struct sk_buff *skb,
 				break;
 
 			/* Type check */
-			if (*tp != (optinfo->opts[temp] & 0xFF00)>>8){
+			if (*tp != (optinfo->opts[temp] & 0xFF00) >> 8) {
 				DEBUGP("Tbad %02X %02X\n",
 				       *tp,
-				       (optinfo->opts[temp] & 0xFF00)>>8);
+				       (optinfo->opts[temp] & 0xFF00) >> 8);
 				return 0;
 			} else {
 				DEBUGP("Tok ");
@@ -169,7 +168,8 @@ match(const struct sk_buff *skb,
 		}
 		if (temp == optinfo->optsnr)
 			return ret;
-		else return 0;
+		else
+			return 0;
 	}
 
 	return 0;
@@ -178,25 +178,24 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const void *entry,
-          void *matchinfo,
-          unsigned int matchinfosize,
-          unsigned int hook_mask)
+	   const void *entry,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
 {
-       const struct ip6t_opts *optsinfo = matchinfo;
+	const struct ip6t_opts *optsinfo = matchinfo;
 
-       if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_opts))) {
-              DEBUGP("ip6t_opts: matchsize %u != %u\n",
-                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
-              return 0;
-       }
-       if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
-              DEBUGP("ip6t_opts: unknown flags %X\n",
-                      optsinfo->invflags);
-              return 0;
-       }
+	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_opts))) {
+		DEBUGP("ip6t_opts: matchsize %u != %u\n",
+		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_opts)));
+		return 0;
+	}
+	if (optsinfo->invflags & ~IP6T_OPTS_INV_MASK) {
+		DEBUGP("ip6t_opts: unknown flags %X\n", optsinfo->invflags);
+		return 0;
+	}
 
-       return 1;
+	return 1;
 }
 
 static struct ip6t_match opts_match = {
@@ -212,12 +211,12 @@ static struct ip6t_match opts_match = {
 
 static int __init init(void)
 {
-       return ip6t_register_match(&opts_match);
+	return ip6t_register_match(&opts_match);
 }
 
 static void __exit cleanup(void)
 {
-       ip6t_unregister_match(&opts_match);
+	ip6t_unregister_match(&opts_match);
 }
 
 module_init(init);
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index fda1cea..83ad6b2 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -50,20 +50,20 @@ ipv6header_match(const struct sk_buff *s
 	len = skb->len - ptr;
 	temp = 0;
 
-        while (ip6t_ext_hdr(nexthdr)) {
+	while (ip6t_ext_hdr(nexthdr)) {
 		struct ipv6_opt_hdr _hdr, *hp;
-        	int hdrlen;
+		int hdrlen;
 
 		/* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
+		if (len < (int)sizeof(struct ipv6_opt_hdr))
+			return 0;
 		/* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
+		if (nexthdr == NEXTHDR_NONE) {
 			temp |= MASK_NONE;
 			break;
 		}
 		/* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
+		if (nexthdr == NEXTHDR_ESP) {
 			temp |= MASK_ESP;
 			break;
 		}
@@ -72,43 +72,43 @@ ipv6header_match(const struct sk_buff *s
 		BUG_ON(hp == NULL);
 
 		/* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
+		if (nexthdr == NEXTHDR_FRAGMENT) {
+			hdrlen = 8;
+		} else if (nexthdr == NEXTHDR_AUTH)
+			hdrlen = (hp->hdrlen + 2) << 2;
+		else
+			hdrlen = ipv6_optlen(hp);
 
 		/* set the flag */
-		switch (nexthdr){
-			case NEXTHDR_HOP:
-				temp |= MASK_HOPOPTS;
-				break;
-			case NEXTHDR_ROUTING:
-				temp |= MASK_ROUTING;
-				break;
-			case NEXTHDR_FRAGMENT:
-				temp |= MASK_FRAGMENT;
-				break;
-			case NEXTHDR_AUTH:
-				temp |= MASK_AH;
-				break;
-			case NEXTHDR_DEST:
-				temp |= MASK_DSTOPTS;
-				break;
-			default:
-				return 0;
-				break;
+		switch (nexthdr) {
+		case NEXTHDR_HOP:
+			temp |= MASK_HOPOPTS;
+			break;
+		case NEXTHDR_ROUTING:
+			temp |= MASK_ROUTING;
+			break;
+		case NEXTHDR_FRAGMENT:
+			temp |= MASK_FRAGMENT;
+			break;
+		case NEXTHDR_AUTH:
+			temp |= MASK_AH;
+			break;
+		case NEXTHDR_DEST:
+			temp |= MASK_DSTOPTS;
+			break;
+		default:
+			return 0;
+			break;
 		}
 
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
+		nexthdr = hp->nexthdr;
+		len -= hdrlen;
+		ptr += hdrlen;
 		if (ptr > skb->len)
 			break;
-        }
+	}
 
-	if ( (nexthdr != NEXTHDR_NONE ) && (nexthdr != NEXTHDR_ESP) )
+	if ((nexthdr != NEXTHDR_NONE) && (nexthdr != NEXTHDR_ESP))
 		temp |= MASK_PROTO;
 
 	if (info->modeflag)
@@ -137,8 +137,8 @@ ipv6header_checkentry(const char *tablen
 		return 0;
 
 	/* invflags is 0 or 0xff in hard mode */
-	if ((!info->modeflag) && info->invflags != 0x00
-			      && info->invflags != 0xFF)
+	if ((!info->modeflag) && info->invflags != 0x00 &&
+	    info->invflags != 0xFF)
 		return 0;
 
 	return 1;
@@ -152,7 +152,7 @@ static struct ip6t_match ip6t_ipv6header
 	.me		= THIS_MODULE,
 };
 
-static int  __init ipv6header_init(void)
+static int __init ipv6header_init(void)
 {
 	return ip6t_register_match(&ip6t_ipv6header_match);
 }
@@ -164,4 +164,3 @@ static void __exit ipv6header_exit(void)
 
 module_init(ipv6header_init);
 module_exit(ipv6header_exit);
-
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
index 5409b37..8c8a4c7 100644
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -36,14 +36,14 @@ match(const struct sk_buff *skb,
 	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
 		return 0;
 
-	if(info->match & IP6T_OWNER_UID) {
-		if((skb->sk->sk_socket->file->f_uid != info->uid) ^
+	if (info->match & IP6T_OWNER_UID) {
+		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
 		    !!(info->invert & IP6T_OWNER_UID))
 			return 0;
 	}
 
-	if(info->match & IP6T_OWNER_GID) {
-		if((skb->sk->sk_socket->file->f_gid != info->gid) ^
+	if (info->match & IP6T_OWNER_GID) {
+		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
 		    !!(info->invert & IP6T_OWNER_GID))
 			return 0;
 	}
@@ -53,23 +53,23 @@ match(const struct sk_buff *skb,
 
 static int
 checkentry(const char *tablename,
-           const void  *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
+	   const void *ip,
+	   void *matchinfo,
+	   unsigned int matchsize,
+	   unsigned int hook_mask)
 {
 	const struct ip6t_owner_info *info = matchinfo;
 
-        if (hook_mask
-            & ~((1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING))) {
-                printk("ip6t_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
-                return 0;
-        }
+	if (hook_mask
+	    & ~((1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING))) {
+		printk("ip6t_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
+		return 0;
+	}
 
 	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_owner_info)))
 		return 0;
 
-	if (info->match & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
+	if (info->match & (IP6T_OWNER_PID | IP6T_OWNER_SID)) {
 		printk("ipt_owner: pid and sid matching "
 		       "not supported anymore\n");
 		return 0;
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 8465b43..8f82476 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -33,12 +33,12 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 static inline int
 segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
 {
-       int r=0;
-       DEBUGP("rt segsleft_match:%c 0x%x <= 0x%x <= 0x%x",invert? '!':' ',
-              min,id,max);
-       r=(id >= min && id <= max) ^ invert;
-       DEBUGP(" result %s\n",r? "PASS" : "FAILED");
-       return r;
+	int r = 0;
+	DEBUGP("rt segsleft_match:%c 0x%x <= 0x%x <= 0x%x",
+	       invert ? '!' : ' ', min, id, max);
+	r = (id >= min && id <= max) ^ invert;
+	DEBUGP(" result %s\n", r ? "PASS" : "FAILED");
+	return r;
 }
 
 static int
@@ -50,87 +50,93 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_rt_hdr _route, *rh;
-       const struct ip6t_rt *rtinfo = matchinfo;
-       unsigned int temp;
-       unsigned int ptr;
-       unsigned int hdrlen = 0;
-       unsigned int ret = 0;
-       struct in6_addr *ap, _addr;
+	struct ipv6_rt_hdr _route, *rh;
+	const struct ip6t_rt *rtinfo = matchinfo;
+	unsigned int temp;
+	unsigned int ptr;
+	unsigned int hdrlen = 0;
+	unsigned int ret = 0;
+	struct in6_addr *ap, _addr;
 
 	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING, NULL) < 0)
 		return 0;
 
-       rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
-       if (rh == NULL){
-	       *hotdrop = 1;
-       		return 0;
-       }
-
-       hdrlen = ipv6_optlen(rh);
-       if (skb->len - ptr < hdrlen){
-	       /* Pcket smaller than its length field */
-       		return 0;
-       }
-
-       DEBUGP("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
-       DEBUGP("TYPE %04X ", rh->type);
-       DEBUGP("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
-
-       DEBUGP("IPv6 RT segsleft %02X ",
-       		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           rh->segments_left,
-                           !!(rtinfo->invflags & IP6T_RT_INV_SGS))));
-       DEBUGP("type %02X %02X %02X ",
-       		rtinfo->rt_type, rh->type, 
-       		(!(rtinfo->flags & IP6T_RT_TYP) ||
-                           ((rtinfo->rt_type == rh->type) ^
-                           !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
-       DEBUGP("len %02X %04X %02X ",
-       		rtinfo->hdrlen, hdrlen,
-       		(!(rtinfo->flags & IP6T_RT_LEN) ||
-                           ((rtinfo->hdrlen == hdrlen) ^
-                           !!(rtinfo->invflags & IP6T_RT_INV_LEN))));
-       DEBUGP("res %02X %02X %02X ", 
-       		(rtinfo->flags & IP6T_RT_RES), ((struct rt0_hdr *)rh)->reserved,
-       		!((rtinfo->flags & IP6T_RT_RES) && (((struct rt0_hdr *)rh)->reserved)));
-
-       ret = (rh != NULL)
-       		&&
-       		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           rh->segments_left,
-                           !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
-		&&
-	      	(!(rtinfo->flags & IP6T_RT_LEN) ||
-                           ((rtinfo->hdrlen == hdrlen) ^
-                           !!(rtinfo->invflags & IP6T_RT_INV_LEN)))
-		&&
-       		(!(rtinfo->flags & IP6T_RT_TYP) ||
-                           ((rtinfo->rt_type == rh->type) ^
-                           !!(rtinfo->invflags & IP6T_RT_INV_TYP)));
+	rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
+	if (rh == NULL) {
+		*hotdrop = 1;
+		return 0;
+	}
+
+	hdrlen = ipv6_optlen(rh);
+	if (skb->len - ptr < hdrlen) {
+		/* Pcket smaller than its length field */
+		return 0;
+	}
+
+	DEBUGP("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
+	DEBUGP("TYPE %04X ", rh->type);
+	DEBUGP("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
+
+	DEBUGP("IPv6 RT segsleft %02X ",
+	       (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+			       rh->segments_left,
+			       !!(rtinfo->invflags & IP6T_RT_INV_SGS))));
+	DEBUGP("type %02X %02X %02X ",
+	       rtinfo->rt_type, rh->type,
+	       (!(rtinfo->flags & IP6T_RT_TYP) ||
+		((rtinfo->rt_type == rh->type) ^
+		 !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
+	DEBUGP("len %02X %04X %02X ",
+	       rtinfo->hdrlen, hdrlen,
+	       (!(rtinfo->flags & IP6T_RT_LEN) ||
+		((rtinfo->hdrlen == hdrlen) ^
+		 !!(rtinfo->invflags & IP6T_RT_INV_LEN))));
+	DEBUGP("res %02X %02X %02X ",
+	       (rtinfo->flags & IP6T_RT_RES),
+	       ((struct rt0_hdr *)rh)->reserved,
+	       !((rtinfo->flags & IP6T_RT_RES) &&
+		 (((struct rt0_hdr *)rh)->reserved)));
+
+	ret = (rh != NULL)
+	      &&
+	      (segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
+			      rh->segments_left,
+			      !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
+	      &&
+	      (!(rtinfo->flags & IP6T_RT_LEN) ||
+	       ((rtinfo->hdrlen == hdrlen) ^
+		!!(rtinfo->invflags & IP6T_RT_INV_LEN)))
+	      &&
+	      (!(rtinfo->flags & IP6T_RT_TYP) ||
+	       ((rtinfo->rt_type == rh->type) ^
+		!!(rtinfo->invflags & IP6T_RT_INV_TYP)));
 
 	if (ret && (rtinfo->flags & IP6T_RT_RES)) {
 		u_int32_t *rp, _reserved;
 		rp = skb_header_pointer(skb,
-					ptr + offsetof(struct rt0_hdr, reserved),
-					sizeof(_reserved), &_reserved);
+					ptr + offsetof(struct rt0_hdr,
+						       reserved),
+					sizeof(_reserved),
+					&_reserved);
 
 		ret = (*rp == 0);
 	}
 
-	DEBUGP("#%d ",rtinfo->addrnr);
-       if ( !(rtinfo->flags & IP6T_RT_FST) ){
-	       return ret;
+	DEBUGP("#%d ", rtinfo->addrnr);
+	if (!(rtinfo->flags & IP6T_RT_FST)) {
+		return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
 		DEBUGP("Not strict ");
-		if ( rtinfo->addrnr > (unsigned int)((hdrlen-8)/16) ){
+		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
 			DEBUGP("There isn't enough space\n");
 			return 0;
 		} else {
 			unsigned int i = 0;
 
-			DEBUGP("#%d ",rtinfo->addrnr);
-			for(temp=0; temp<(unsigned int)((hdrlen-8)/16); temp++){
+			DEBUGP("#%d ", rtinfo->addrnr);
+			for (temp = 0;
+			     temp < (unsigned int)((hdrlen - 8) / 16);
+			     temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
 							+ sizeof(struct rt0_hdr)
@@ -141,24 +147,26 @@ match(const struct sk_buff *skb,
 				BUG_ON(ap == NULL);
 
 				if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
-					DEBUGP("i=%d temp=%d;\n",i,temp);
+					DEBUGP("i=%d temp=%d;\n", i, temp);
 					i++;
 				}
-				if (i==rtinfo->addrnr) break;
+				if (i == rtinfo->addrnr)
+					break;
 			}
 			DEBUGP("i=%d #%d\n", i, rtinfo->addrnr);
 			if (i == rtinfo->addrnr)
 				return ret;
-			else return 0;
+			else
+				return 0;
 		}
 	} else {
 		DEBUGP("Strict ");
-		if ( rtinfo->addrnr > (unsigned int)((hdrlen-8)/16) ){
+		if (rtinfo->addrnr > (unsigned int)((hdrlen - 8) / 16)) {
 			DEBUGP("There isn't enough space\n");
 			return 0;
 		} else {
-			DEBUGP("#%d ",rtinfo->addrnr);
-			for(temp=0; temp<rtinfo->addrnr; temp++){
+			DEBUGP("#%d ", rtinfo->addrnr);
+			for (temp = 0; temp < rtinfo->addrnr; temp++) {
 				ap = skb_header_pointer(skb,
 							ptr
 							+ sizeof(struct rt0_hdr)
@@ -171,9 +179,11 @@ match(const struct sk_buff *skb,
 					break;
 			}
 			DEBUGP("temp=%d #%d\n", temp, rtinfo->addrnr);
-			if ((temp == rtinfo->addrnr) && (temp == (unsigned int)((hdrlen-8)/16)))
+			if ((temp == rtinfo->addrnr) &&
+			    (temp == (unsigned int)((hdrlen - 8) / 16)))
 				return ret;
-			else return 0;
+			else
+				return 0;
 		}
 	}
 
@@ -183,32 +193,31 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const void *entry,
-          void *matchinfo,
-          unsigned int matchinfosize,
-          unsigned int hook_mask)
+	   const void *entry,
+	   void *matchinfo,
+	   unsigned int matchinfosize,
+	   unsigned int hook_mask)
 {
-       const struct ip6t_rt *rtinfo = matchinfo;
+	const struct ip6t_rt *rtinfo = matchinfo;
 
-       if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_rt))) {
-              DEBUGP("ip6t_rt: matchsize %u != %u\n",
-                      matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_rt)));
-              return 0;
-       }
-       if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
-              DEBUGP("ip6t_rt: unknown flags %X\n",
-                      rtinfo->invflags);
-              return 0;
-       }
-       if ( (rtinfo->flags & (IP6T_RT_RES|IP6T_RT_FST_MASK)) && 
-		       (!(rtinfo->flags & IP6T_RT_TYP) || 
-		       (rtinfo->rt_type != 0) || 
-		       (rtinfo->invflags & IP6T_RT_INV_TYP)) ) {
-	      DEBUGP("`--rt-type 0' required before `--rt-0-*'");
-              return 0;
-       }
+	if (matchinfosize != IP6T_ALIGN(sizeof(struct ip6t_rt))) {
+		DEBUGP("ip6t_rt: matchsize %u != %u\n",
+		       matchinfosize, IP6T_ALIGN(sizeof(struct ip6t_rt)));
+		return 0;
+	}
+	if (rtinfo->invflags & ~IP6T_RT_INV_MASK) {
+		DEBUGP("ip6t_rt: unknown flags %X\n", rtinfo->invflags);
+		return 0;
+	}
+	if ((rtinfo->flags & (IP6T_RT_RES | IP6T_RT_FST_MASK)) &&
+	    (!(rtinfo->flags & IP6T_RT_TYP) ||
+	     (rtinfo->rt_type != 0) ||
+	     (rtinfo->invflags & IP6T_RT_INV_TYP))) {
+		DEBUGP("`--rt-type 0' required before `--rt-0-*'");
+		return 0;
+	}
 
-       return 1;
+	return 1;
 }
 
 static struct ip6t_match rt_match = {
@@ -220,12 +229,12 @@ static struct ip6t_match rt_match = {
 
 static int __init init(void)
 {
-       return ip6t_register_match(&rt_match);
+	return ip6t_register_match(&rt_match);
 }
 
 static void __exit cleanup(void)
 {
-       ip6t_unregister_match(&rt_match);
+	ip6t_unregister_match(&rt_match);
 }
 
 module_init(init);
