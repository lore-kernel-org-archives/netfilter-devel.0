From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] introduce ipv6_find_hdr to unify similar loops in IPv6
 matches
Date: Thu, 15 Sep 2005 01:15:08 +0900 (JST)
Message-ID: <200509141615.j8EGF9D2005786@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep_15_01_15_08_2005_359)--"
Content-Transfer-Encoding: 7bit
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

----Next_Part(Thu_Sep_15_01_15_08_2005_359)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

Some IPv6 matches have very similar loops to find IPv6 extension header
and we can unify them. This patch introduces ipv6_find_hdr() to do it.
I just checked that it can find the target headers in the packet which has
dst,hbh,rt,frag,ah,esp headers.

Please consider applying this.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Thu_Sep_15_01_15_08_2005_359)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="find-ext.patch"

[NETFILTER] introduce ipv6_find_hdr to unify similar loops in IPv6 matches

Some IPv6 matches have very similar loops to find IPv6 extension header.
This patch replaces them with ipv6_find_hdr() which finds specified IPv6
extension header.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit e7bd81b5ae330488f66fe74ca304a47e429c2bf1
tree fd1cdc401423f223d2afc3f0a292ed9610cacd9c
parent 033d974405276c22609c45d50167dd11df20aa82
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 15 Sep 2005 00:29:07 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 15 Sep 2005 00:29:07 +0900

 include/linux/netfilter_ipv6/ip6_tables.h |    3 +
 net/ipv6/netfilter/ip6_tables.c           |   52 +++++++++++++++++
 net/ipv6/netfilter/ip6t_ah.c              |   81 ++-------------------------
 net/ipv6/netfilter/ip6t_dst.c             |   88 ++---------------------------
 net/ipv6/netfilter/ip6t_esp.c             |   73 +-----------------------
 net/ipv6/netfilter/ip6t_frag.c            |   88 +++--------------------------
 net/ipv6/netfilter/ip6t_hbh.c             |   88 ++---------------------------
 net/ipv6/netfilter/ip6t_rt.c              |   83 ++-------------------------
 8 files changed, 93 insertions(+), 463 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -455,6 +455,9 @@ extern unsigned int ip6t_do_table(struct
 
 /* Check for an extension */
 extern int ip6t_ext_hdr(u8 nexthdr);
+/* find specified header and get offset to it */
+extern int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
+			 u8 target);
 
 #define IP6T_ALIGN(s) (((s) + (__alignof__(struct ip6t_entry)-1)) & ~(__alignof__(struct ip6t_entry)-1))
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1955,6 +1955,57 @@ static void __exit fini(void)
 #endif
 }
 
+/*
+ * find specified header up to transport protocol header.
+ * If found target header, the offset to the header is set to *offset
+ * and return 0. otherwise, return -1.
+ *
+ * Notes: - non-1st Fragment Header isn't skipped.
+ *	  - ESP header isn't skipped.
+ *	  - The target header may be trancated.
+ */
+int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset, u8 target)
+{
+	unsigned int start = (u8*)(skb->nh.ipv6h + 1) - skb->data;
+	u8 nexthdr = skb->nh.ipv6h->nexthdr;
+	unsigned int len = skb->len - start;
+
+	while (nexthdr != target) {
+		struct ipv6_opt_hdr _hdr, *hp;
+		unsigned int hdrlen;
+
+		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE)
+			return -1;
+		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
+		if (hp == NULL)
+			return -1;
+		if (nexthdr == NEXTHDR_FRAGMENT) {
+			unsigned short _frag_off, *fp;
+			fp = skb_header_pointer(skb,
+						start+offsetof(struct frag_hdr,
+							       frag_off),
+						sizeof(_frag_off),
+						&_frag_off);
+			if (fp == NULL)
+				return -1;
+
+			if (ntohs(*fp) & ~0x7)
+				return -1;
+			hdrlen = 8;
+		} else if (nexthdr == NEXTHDR_AUTH)
+			hdrlen = (hp->hdrlen + 2) << 2; 
+		else
+			hdrlen = ipv6_optlen(hp); 
+
+		nexthdr = hp->nexthdr;
+		len -= hdrlen;
+		start += hdrlen;
+	}
+
+	*offset = start;
+	return 0;
+}
+
 EXPORT_SYMBOL(ip6t_register_table);
 EXPORT_SYMBOL(ip6t_unregister_table);
 EXPORT_SYMBOL(ip6t_do_table);
@@ -1963,6 +2014,7 @@ EXPORT_SYMBOL(ip6t_unregister_match);
 EXPORT_SYMBOL(ip6t_register_target);
 EXPORT_SYMBOL(ip6t_unregister_target);
 EXPORT_SYMBOL(ip6t_ext_hdr);
+EXPORT_SYMBOL(ipv6_find_hdr);
 
 module_init(init);
 module_exit(fini);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -48,92 +48,21 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-	struct ip_auth_hdr *ah = NULL, _ah;
+	struct ip_auth_hdr *ah, _ah;
 	const struct ip6t_ah *ahinfo = matchinfo;
-	unsigned int temp;
-	int len;
-	u8 nexthdr;
 	unsigned int ptr;
 	unsigned int hdrlen = 0;
 
-	/*DEBUGP("IPv6 AH entered\n");*/
-	/* if (opt->auth == 0) return 0;
-	* It does not filled on output */
-
-	/* type of the 1st exthdr */
-	nexthdr = skb->nh.ipv6h->nexthdr;
-	/* pointer to the 1st exthdr */
-	ptr = sizeof(struct ipv6hdr);
-	/* available length */
-	len = skb->len - ptr;
-	temp = 0;
-
-	while (ip6t_ext_hdr(nexthdr)) {
-		struct ipv6_opt_hdr _hdr, *hp;
-
-		DEBUGP("ipv6_ah header iteration \n");
-
-		/* Is there enough space for the next ext header? */
-		if (len < sizeof(struct ipv6_opt_hdr))
-			return 0;
-		/* No more exthdr -> evaluate */
-		if (nexthdr == NEXTHDR_NONE)
-			break;
-		/* ESP -> evaluate */
-		if (nexthdr == NEXTHDR_ESP)
-			break;
-
-		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-		BUG_ON(hp == NULL);
-
-		/* Calculate the header length */
-		if (nexthdr == NEXTHDR_FRAGMENT)
-			hdrlen = 8;
-		else if (nexthdr == NEXTHDR_AUTH)
-			hdrlen = (hp->hdrlen+2)<<2;
-		else
-			hdrlen = ipv6_optlen(hp);
-
-		/* AH -> evaluate */
-		if (nexthdr == NEXTHDR_AUTH) {
-			temp |= MASK_AH;
-			break;
-		}
-
-		
-		/* set the flag */
-		switch (nexthdr) {
-		case NEXTHDR_HOP:
-		case NEXTHDR_ROUTING:
-		case NEXTHDR_FRAGMENT:
-		case NEXTHDR_AUTH:
-		case NEXTHDR_DEST:
-			break;
-		default:
-			DEBUGP("ipv6_ah match: unknown nextheader %u\n",nexthdr);
-			return 0;
-		}
-
-		nexthdr = hp->nexthdr;
-		len -= hdrlen;
-		ptr += hdrlen;
-		if (ptr > skb->len) {
-			DEBUGP("ipv6_ah: new pointer too large! \n");
-			break;
-		}
-	}
-
-	/* AH header not found */
-	if (temp != MASK_AH)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_AUTH) < 0)
 		return 0;
 
-	if (len < sizeof(struct ip_auth_hdr)){
+	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
+	if (ah == NULL) {
 		*hotdrop = 1;
 		return 0;
 	}
 
-	ah = skb_header_pointer(skb, ptr, sizeof(_ah), &_ah);
-	BUG_ON(ah == NULL);
+	hdrlen = (ah->hdrlen + 2) << 2;
 
 	DEBUGP("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
 	DEBUGP("RES %04X ", ah->reserved);
diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -63,8 +63,6 @@ match(const struct sk_buff *skb,
        struct ipv6_opt_hdr _optsh, *oh;
        const struct ip6t_opts *optinfo = matchinfo;
        unsigned int temp;
-       unsigned int len;
-       u8 nexthdr;
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
@@ -72,97 +70,25 @@ match(const struct sk_buff *skb,
        u8 _optlen, *lp = NULL;
        unsigned int optlen;
        
-       /* type of the 1st exthdr */
-       nexthdr = skb->nh.ipv6h->nexthdr;
-       /* pointer to the 1st exthdr */
-       ptr = sizeof(struct ipv6hdr);
-       /* available length */
-       len = skb->len - ptr;
-       temp = 0;
-
-        while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr _hdr, *hp;
-
-              DEBUGP("ipv6_opts header iteration \n");
-
-              /* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
-              /* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
-                     break;
-              }
-              /* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
-                     break;
-              }
-
-	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-	      BUG_ON(hp == NULL);
-
-              /* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
-
-              /* OPTS -> evaluate */
 #if HOPBYHOP
-                if (nexthdr == NEXTHDR_HOP) {
-                     temp |= MASK_HOPOPTS;
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP) < 0)
 #else
-                if (nexthdr == NEXTHDR_DEST) {
-                     temp |= MASK_DSTOPTS;
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_DEST) < 0)
 #endif
-                     break;
-              }
-
-
-              /* set the flag */
-              switch (nexthdr){
-                     case NEXTHDR_HOP:
-                     case NEXTHDR_ROUTING:
-                     case NEXTHDR_FRAGMENT:
-                     case NEXTHDR_AUTH:
-                     case NEXTHDR_DEST:
-                            break;
-                     default:
-                            DEBUGP("ipv6_opts match: unknown nextheader %u\n",nexthdr);
-                            return 0;
-                            break;
-              }
-
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
-		if ( ptr > skb->len ) {
-			DEBUGP("ipv6_opts: new pointer is too large! \n");
-			break;
-		}
-        }
+		return 0;
 
-       /* OPTIONS header not found */
-#if HOPBYHOP
-       if ( temp != MASK_HOPOPTS ) return 0;
-#else
-       if ( temp != MASK_DSTOPTS ) return 0;
-#endif
-
-       if (len < (int)sizeof(struct ipv6_opt_hdr)){
+       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
+       if (oh == NULL){
 	       *hotdrop = 1;
        		return 0;
        }
 
-       if (len < hdrlen){
+       hdrlen = ipv6_optlen(oh);
+       if (skb->len - ptr < hdrlen){
 	       /* Packet smaller than it's length field */
        		return 0;
        }
 
-       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
-       BUG_ON(oh == NULL);
-
        DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
 
        DEBUGP("len %02X %04X %02X ",
diff --git a/net/ipv6/netfilter/ip6t_esp.c b/net/ipv6/netfilter/ip6t_esp.c
--- a/net/ipv6/netfilter/ip6t_esp.c
+++ b/net/ipv6/netfilter/ip6t_esp.c
@@ -48,87 +48,22 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-	struct ip_esp_hdr _esp, *eh = NULL;
+	struct ip_esp_hdr _esp, *eh;
 	const struct ip6t_esp *espinfo = matchinfo;
-	unsigned int temp;
-	int len;
-	u8 nexthdr;
 	unsigned int ptr;
 
 	/* Make sure this isn't an evil packet */
 	/*DEBUGP("ipv6_esp entered \n");*/
 
-	/* type of the 1st exthdr */
-	nexthdr = skb->nh.ipv6h->nexthdr;
-	/* pointer to the 1st exthdr */
-	ptr = sizeof(struct ipv6hdr);
-	/* available length */
-	len = skb->len - ptr;
-	temp = 0;
-
-	while (ip6t_ext_hdr(nexthdr)) {
-		struct ipv6_opt_hdr _hdr, *hp;
-		int hdrlen;
-
-		DEBUGP("ipv6_esp header iteration \n");
-
-		/* Is there enough space for the next ext header? */
-		if (len < sizeof(struct ipv6_opt_hdr))
-			return 0;
-		/* No more exthdr -> evaluate */
-		if (nexthdr == NEXTHDR_NONE)
-			break;
-		/* ESP -> evaluate */
-		if (nexthdr == NEXTHDR_ESP) {
-			temp |= MASK_ESP;
-			break;
-		}
-
-		hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-		BUG_ON(hp == NULL);
-
-		/* Calculate the header length */
-		if (nexthdr == NEXTHDR_FRAGMENT)
-			hdrlen = 8;
-		else if (nexthdr == NEXTHDR_AUTH)
-			hdrlen = (hp->hdrlen+2)<<2;
-		else
-			hdrlen = ipv6_optlen(hp);
-
-		/* set the flag */
-		switch (nexthdr) {
-		case NEXTHDR_HOP:
-		case NEXTHDR_ROUTING:
-		case NEXTHDR_FRAGMENT:
-		case NEXTHDR_AUTH:
-		case NEXTHDR_DEST:
-			break;
-		default:
-			DEBUGP("ipv6_esp match: unknown nextheader %u\n",nexthdr);
-			return 0;
-		}
-
-		nexthdr = hp->nexthdr;
-		len -= hdrlen;
-		ptr += hdrlen;
-		if (ptr > skb->len) {
-			DEBUGP("ipv6_esp: new pointer too large! \n");
-			break;
-		}
-	}
-
-	/* ESP header not found */
-	if (temp != MASK_ESP)
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ESP) < 0)
 		return 0;
 
-	if (len < sizeof(struct ip_esp_hdr)) {
+	eh = skb_header_pointer(skb, ptr, sizeof(_esp), &_esp);
+	if (eh == NULL) {
 		*hotdrop = 1;
 		return 0;
 	}
 
-	eh = skb_header_pointer(skb, ptr, sizeof(_esp), &_esp);
-	BUG_ON(eh == NULL);
-
 	DEBUGP("IPv6 ESP SPI %u %08X\n", ntohl(eh->spi), ntohl(eh->spi));
 
 	return (eh != NULL)
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -48,90 +48,18 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct frag_hdr _frag, *fh = NULL;
+       struct frag_hdr _frag, *fh;
        const struct ip6t_frag *fraginfo = matchinfo;
-       unsigned int temp;
-       int len;
-       u8 nexthdr;
        unsigned int ptr;
-       unsigned int hdrlen = 0;
 
-       /* type of the 1st exthdr */
-       nexthdr = skb->nh.ipv6h->nexthdr;
-       /* pointer to the 1st exthdr */
-       ptr = sizeof(struct ipv6hdr);
-       /* available length */
-       len = skb->len - ptr;
-       temp = 0;
-
-        while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr _hdr, *hp;
-
-              DEBUGP("ipv6_frag header iteration \n");
-
-              /* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
-              /* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
-                     break;
-              }
-              /* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
-                     break;
-              }
-
-	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-	      BUG_ON(hp == NULL);
-
-              /* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
-
-              /* FRAG -> evaluate */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                     temp |= MASK_FRAGMENT;
-                     break;
-              }
-
-
-              /* set the flag */
-              switch (nexthdr){
-                     case NEXTHDR_HOP:
-                     case NEXTHDR_ROUTING:
-                     case NEXTHDR_FRAGMENT:
-                     case NEXTHDR_AUTH:
-                     case NEXTHDR_DEST:
-                            break;
-                     default:
-                            DEBUGP("ipv6_frag match: unknown nextheader %u\n",nexthdr);
-                            return 0;
-                            break;
-              }
-
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
-		if ( ptr > skb->len ) {
-			DEBUGP("ipv6_frag: new pointer too large! \n");
-			break;
-		}
-        }
-
-       /* FRAG header not found */
-       if ( temp != MASK_FRAGMENT ) return 0;
-
-       if (len < sizeof(struct frag_hdr)){
-	       *hotdrop = 1;
-       		return 0;
-       }
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_FRAGMENT) < 0)
+		return 0;
 
-       fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
-       BUG_ON(fh == NULL);
+	fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
+	if (fh == NULL){
+		*hotdrop = 1;
+		return 0;
+	}
 
        DEBUGP("INFO %04X ", fh->frag_off);
        DEBUGP("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -63,8 +63,6 @@ match(const struct sk_buff *skb,
        struct ipv6_opt_hdr _optsh, *oh;
        const struct ip6t_opts *optinfo = matchinfo;
        unsigned int temp;
-       unsigned int len;
-       u8 nexthdr;
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
@@ -72,97 +70,25 @@ match(const struct sk_buff *skb,
        u8 _optlen, *lp = NULL;
        unsigned int optlen;
        
-       /* type of the 1st exthdr */
-       nexthdr = skb->nh.ipv6h->nexthdr;
-       /* pointer to the 1st exthdr */
-       ptr = sizeof(struct ipv6hdr);
-       /* available length */
-       len = skb->len - ptr;
-       temp = 0;
-
-        while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr _hdr, *hp;
-
-              DEBUGP("ipv6_opts header iteration \n");
-
-              /* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
-              /* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
-                     break;
-              }
-              /* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
-                     break;
-              }
-
-	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-	      BUG_ON(hp == NULL);
-
-              /* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
-
-              /* OPTS -> evaluate */
 #if HOPBYHOP
-                if (nexthdr == NEXTHDR_HOP) {
-                     temp |= MASK_HOPOPTS;
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_HOP) < 0)
 #else
-                if (nexthdr == NEXTHDR_DEST) {
-                     temp |= MASK_DSTOPTS;
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_DEST) < 0)
 #endif
-                     break;
-              }
-
-
-              /* set the flag */
-              switch (nexthdr){
-                     case NEXTHDR_HOP:
-                     case NEXTHDR_ROUTING:
-                     case NEXTHDR_FRAGMENT:
-                     case NEXTHDR_AUTH:
-                     case NEXTHDR_DEST:
-                            break;
-                     default:
-                            DEBUGP("ipv6_opts match: unknown nextheader %u\n",nexthdr);
-                            return 0;
-                            break;
-              }
-
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
-		if ( ptr > skb->len ) {
-			DEBUGP("ipv6_opts: new pointer is too large! \n");
-			break;
-		}
-        }
+		return 0;
 
-       /* OPTIONS header not found */
-#if HOPBYHOP
-       if ( temp != MASK_HOPOPTS ) return 0;
-#else
-       if ( temp != MASK_DSTOPTS ) return 0;
-#endif
-
-       if (len < (int)sizeof(struct ipv6_opt_hdr)){
+       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
+       if (oh == NULL){
 	       *hotdrop = 1;
        		return 0;
        }
 
-       if (len < hdrlen){
+       hdrlen = ipv6_optlen(oh);
+       if (skb->len - ptr < hdrlen){
 	       /* Packet smaller than it's length field */
        		return 0;
        }
 
-       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
-       BUG_ON(oh == NULL);
-
        DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
 
        DEBUGP("len %02X %04X %02X ",
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -50,98 +50,29 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_rt_hdr _route, *rh = NULL;
+       struct ipv6_rt_hdr _route, *rh;
        const struct ip6t_rt *rtinfo = matchinfo;
        unsigned int temp;
-       unsigned int len;
-       u8 nexthdr;
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
        struct in6_addr *ap, _addr;
 
-       /* type of the 1st exthdr */
-       nexthdr = skb->nh.ipv6h->nexthdr;
-       /* pointer to the 1st exthdr */
-       ptr = sizeof(struct ipv6hdr);
-       /* available length */
-       len = skb->len - ptr;
-       temp = 0;
-
-        while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr _hdr, *hp;
-
-              DEBUGP("ipv6_rt header iteration \n");
-
-              /* Is there enough space for the next ext header? */
-                if (len < (int)sizeof(struct ipv6_opt_hdr))
-                        return 0;
-              /* No more exthdr -> evaluate */
-                if (nexthdr == NEXTHDR_NONE) {
-                     break;
-              }
-              /* ESP -> evaluate */
-                if (nexthdr == NEXTHDR_ESP) {
-                     break;
-              }
-
-	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
-	      BUG_ON(hp == NULL);
-
-              /* Calculate the header length */
-                if (nexthdr == NEXTHDR_FRAGMENT) {
-                        hdrlen = 8;
-                } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hp->hdrlen+2)<<2;
-                else
-                        hdrlen = ipv6_optlen(hp);
-
-              /* ROUTING -> evaluate */
-                if (nexthdr == NEXTHDR_ROUTING) {
-                     temp |= MASK_ROUTING;
-                     break;
-              }
-
-
-              /* set the flag */
-              switch (nexthdr){
-                     case NEXTHDR_HOP:
-                     case NEXTHDR_ROUTING:
-                     case NEXTHDR_FRAGMENT:
-                     case NEXTHDR_AUTH:
-                     case NEXTHDR_DEST:
-                            break;
-                     default:
-                            DEBUGP("ipv6_rt match: unknown nextheader %u\n",nexthdr);
-                            return 0;
-                            break;
-              }
-
-                nexthdr = hp->nexthdr;
-                len -= hdrlen;
-                ptr += hdrlen;
-		if ( ptr > skb->len ) {
-			DEBUGP("ipv6_rt: new pointer is too large! \n");
-			break;
-		}
-        }
-
-       /* ROUTING header not found */
-       if ( temp != MASK_ROUTING ) return 0;
+	if (ipv6_find_hdr(skb, &ptr, NEXTHDR_ROUTING) < 0)
+		return 0;
 
-       if (len < (int)sizeof(struct ipv6_rt_hdr)){
+       rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
+       if (rh == NULL){
 	       *hotdrop = 1;
        		return 0;
        }
 
-       if (len < hdrlen){
+       hdrlen = ipv6_optlen(rh);
+       if (skb->len - ptr < hdrlen){
 	       /* Pcket smaller than its length field */
        		return 0;
        }
 
-       rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
-       BUG_ON(rh == NULL);
-
        DEBUGP("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
        DEBUGP("TYPE %04X ", rh->type);
        DEBUGP("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);

----Next_Part(Thu_Sep_15_01_15_08_2005_359)----
