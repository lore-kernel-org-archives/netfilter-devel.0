From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] bug fixes and introducing skb_header_pointer() to
 ip6t_frag.c
Date: Thu, 07 Oct 2004 13:56:53 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410070456.i974usIv027450@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Oct__7_13:56:53_2004_867)--"
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

----Next_Part(Thu_Oct__7_13:56:53_2004_867)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

The first patch fixes following bugs in ip6t_frag.c,

	- Wrong cast the pointer to extension header.
	- header length of Fragment Header is statically 8 octets.
	  Then the option "--frag-len" doesn't make sense.
	- There are endian issues where using frag->info.
	- Reserved fields are not 2 bit but 8bit + 2 bit. (see RFC2460)

And the second patch enables ip6t_frag.c to work without skb_linearize().

Before trying these patches, don't forget to apply the patch which prepare
to removing skb_linearize().

https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017028.html

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Oct__7_13:56:53_2004_867)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="frag-fix.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_frag.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_frag.c	2004-10-07 13:05:06.895777112 +0900
@@ -14,8 +14,6 @@
 #include <net/checksum.h>
 #include <net/ipv6.h>
 
-#include <asm/byteorder.h>
-
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_frag.h>
 
@@ -29,29 +27,6 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@s
 #define DEBUGP(format, args...)
 #endif
 
-#if 0
-#if     BYTE_ORDER == BIG_ENDIAN
-#define IP6F_OFF_MASK       0xfff8  /* mask out offset from _offlg */
-#define IP6F_RESERVED_MASK  0x0006  /* reserved bits in ip6f_offlg */
-#define IP6F_MORE_FRAG      0x0001  /* more-fragments flag */
-#else   /* BYTE_ORDER == LITTLE_ENDIAN */
-#define IP6F_OFF_MASK       0xf8ff  /* mask out offset from _offlg */
-#define IP6F_RESERVED_MASK  0x0600  /* reserved bits in ip6f_offlg */
-#define IP6F_MORE_FRAG      0x0100  /* more-fragments flag */
-#endif
-#endif
-
-#define IP6F_OFF_MASK       0xf8ff  /* mask out offset from _offlg */
-#define IP6F_RESERVED_MASK  0x0600  /* reserved bits in ip6f_offlg */
-#define IP6F_MORE_FRAG      0x0100  /* more-fragments flag */
-
-struct fraghdr {
-       __u8    nexthdr;
-       __u8    hdrlen;
-       __u16   info;
-       __u32   id;
-};
-
 /* Returns 1 if the id is matched by the range, 0 otherwise */
 static inline int
 id_match(u_int32_t min, u_int32_t max, u_int32_t id, int invert)
@@ -73,7 +48,7 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct fraghdr *frag = NULL;
+       struct frag_hdr *frag = NULL;
        const struct ip6t_frag *fraginfo = matchinfo;
        unsigned int temp;
        int len;
@@ -106,7 +81,7 @@ match(const struct sk_buff *skb,
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -149,59 +124,62 @@ match(const struct sk_buff *skb,
        /* FRAG header not found */
        if ( temp != MASK_FRAGMENT ) return 0;
 
-       if (len < (int)sizeof(struct fraghdr)){
+       if (len < sizeof(struct frag_hdr)){
 	       *hotdrop = 1;
        		return 0;
        }
 
-       frag = (struct fraghdr *) (skb->data + ptr);
+       frag = (struct frag_hdr *) (skb->data + ptr);
 
-       DEBUGP("IPv6 FRAG LEN %u %u ", hdrlen, frag->hdrlen);
-       DEBUGP("INFO %04X ", frag->info);
-       DEBUGP("OFFSET %04X ", frag->info & IP6F_OFF_MASK);
-       DEBUGP("RES %04X ", frag->info & IP6F_RESERVED_MASK);
-       DEBUGP("MF %04X ", frag->info & IP6F_MORE_FRAG);
-       DEBUGP("ID %u %08X\n", ntohl(frag->id), ntohl(frag->id));
+       DEBUGP("INFO %04X ", frag->frag_off);
+       DEBUGP("OFFSET %04X ", ntohs(frag->frag_off) & ~0x7);
+       DEBUGP("RES %02X %04X", frag->reserved, ntohs(frag->frag_off) & 0x6);
+       DEBUGP("MF %04X ", frag->frag_off & htons(IP6_MF));
+       DEBUGP("ID %u %08X\n", ntohl(frag->identification),
+	      ntohl(frag->identification));
 
        DEBUGP("IPv6 FRAG id %02X ",
        		(id_match(fraginfo->ids[0], fraginfo->ids[1],
-                           ntohl(frag->id),
+                           ntohl(frag->identification),
                            !!(fraginfo->invflags & IP6T_FRAG_INV_IDS))));
-       DEBUGP("len %02X %04X %02X ",
-       		fraginfo->hdrlen, hdrlen,
-       		(!fraginfo->hdrlen ||
-                           (fraginfo->hdrlen == hdrlen) ^
-                           !!(fraginfo->invflags & IP6T_FRAG_INV_LEN)));
-       DEBUGP("res %02X %02X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_RES), frag->info & IP6F_RESERVED_MASK,
-       		!((fraginfo->flags & IP6T_FRAG_RES) && (frag->info & IP6F_RESERVED_MASK)));
+       DEBUGP("res %02X %02X%04X %02X ", 
+       		(fraginfo->flags & IP6T_FRAG_RES), frag->reserved,
+		ntohs(frag->frag_off) & 0x6,
+       		!((fraginfo->flags & IP6T_FRAG_RES)
+			&& (frag->reserved || (ntohs(frag->frag_off) & 0x6))));
        DEBUGP("first %02X %02X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_FST), frag->info & IP6F_OFF_MASK,
-       		!((fraginfo->flags & IP6T_FRAG_FST) && (frag->info & IP6F_OFF_MASK)));
+       		(fraginfo->flags & IP6T_FRAG_FST),
+		ntohs(frag->frag_off) & ~0x7,
+       		!((fraginfo->flags & IP6T_FRAG_FST)
+			&& (ntohs(frag->frag_off) & ~0x7)));
        DEBUGP("mf %02X %02X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_MF), frag->info & IP6F_MORE_FRAG,
-       		!((fraginfo->flags & IP6T_FRAG_MF) && !((frag->info & IP6F_MORE_FRAG))));
+       		(fraginfo->flags & IP6T_FRAG_MF),
+		ntohs(frag->frag_off) & IP6_MF,
+       		!((fraginfo->flags & IP6T_FRAG_MF)
+			&& !((ntohs(frag->frag_off) & IP6_MF))));
        DEBUGP("last %02X %02X %02X\n", 
-       		(fraginfo->flags & IP6T_FRAG_NMF), frag->info & IP6F_MORE_FRAG,
-       		!((fraginfo->flags & IP6T_FRAG_NMF) && (frag->info & IP6F_MORE_FRAG)));
+       		(fraginfo->flags & IP6T_FRAG_NMF),
+		ntohs(frag->frag_off) & IP6_MF,
+       		!((fraginfo->flags & IP6T_FRAG_NMF)
+			&& (ntohs(frag->frag_off) & IP6_MF)));
 
        return (frag != NULL)
        		&&
        		(id_match(fraginfo->ids[0], fraginfo->ids[1],
-                           ntohl(frag->id),
+			  ntohl(frag->identification),
                            !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)))
 		&&
-	      	(!fraginfo->hdrlen ||
-                           (fraginfo->hdrlen == hdrlen) ^
-                           !!(fraginfo->invflags & IP6T_FRAG_INV_LEN))
-		&&
-		!((fraginfo->flags & IP6T_FRAG_RES) && (frag->info & IP6F_RESERVED_MASK))
+		!((fraginfo->flags & IP6T_FRAG_RES)
+			&& (frag->reserved || (ntohs(frag->frag_off) & 0x6)))
 		&&
-		!((fraginfo->flags & IP6T_FRAG_FST) && (frag->info & IP6F_OFF_MASK))
+		!((fraginfo->flags & IP6T_FRAG_FST)
+			&& (ntohs(frag->frag_off) & ~0x7))
 		&&
-		!((fraginfo->flags & IP6T_FRAG_MF) && !((frag->info & IP6F_MORE_FRAG)))
+		!((fraginfo->flags & IP6T_FRAG_MF)
+			&& !(ntohs(frag->frag_off) & IP6_MF))
 		&&
-		!((fraginfo->flags & IP6T_FRAG_NMF) && (frag->info & IP6F_MORE_FRAG));
+		!((fraginfo->flags & IP6T_FRAG_NMF)
+			&& (ntohs(frag->frag_off) & IP6_MF));
 }
 
 /* Called when user tries to insert an entry of this type. */

----Next_Part(Thu_Oct__7_13:56:53_2004_867)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="frag-nolin.patch"

--- linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_frag.c	2004-10-07 13:05:06.895777112 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_frag.c	2004-10-07 10:41:40.280181560 +0900
@@ -48,7 +48,7 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct frag_hdr *frag = NULL;
+       struct frag_hdr _frag, *fh = NULL;
        const struct ip6t_frag *fraginfo = matchinfo;
        unsigned int temp;
        int len;
@@ -65,7 +65,7 @@ match(const struct sk_buff *skb,
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_frag header iteration \n");
 
@@ -81,15 +81,16 @@ match(const struct sk_buff *skb,
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
+	      hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
+	      BUG_ON(hp == NULL);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
                         hdrlen = 8;
                 } else if (nexthdr == NEXTHDR_AUTH)
-                        hdrlen = (hdr->hdrlen+2)<<2;
+                        hdrlen = (hp->hdrlen+2)<<2;
                 else
-                        hdrlen = ipv6_optlen(hdr);
+                        hdrlen = ipv6_optlen(hp);
 
               /* FRAG -> evaluate */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -112,7 +113,7 @@ match(const struct sk_buff *skb,
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -129,57 +130,58 @@ match(const struct sk_buff *skb,
        		return 0;
        }
 
-       frag = (struct frag_hdr *) (skb->data + ptr);
+       fh = skb_header_pointer(skb, ptr, sizeof(_frag), &_frag);
+       BUG_ON(fh == NULL);
 
-       DEBUGP("INFO %04X ", frag->frag_off);
-       DEBUGP("OFFSET %04X ", ntohs(frag->frag_off) & ~0x7);
-       DEBUGP("RES %02X %04X", frag->reserved, ntohs(frag->frag_off) & 0x6);
-       DEBUGP("MF %04X ", frag->frag_off & htons(IP6_MF));
-       DEBUGP("ID %u %08X\n", ntohl(frag->identification),
-	      ntohl(frag->identification));
+       DEBUGP("INFO %04X ", fh->frag_off);
+       DEBUGP("OFFSET %04X ", ntohs(fh->frag_off) & ~0x7);
+       DEBUGP("RES %02X %04X", fh->reserved, ntohs(fh->frag_off) & 0x6);
+       DEBUGP("MF %04X ", fh->frag_off & htons(IP6_MF));
+       DEBUGP("ID %u %08X\n", ntohl(fh->identification),
+	      ntohl(fh->identification));
 
        DEBUGP("IPv6 FRAG id %02X ",
        		(id_match(fraginfo->ids[0], fraginfo->ids[1],
-                           ntohl(frag->identification),
+                           ntohl(fh->identification),
                            !!(fraginfo->invflags & IP6T_FRAG_INV_IDS))));
        DEBUGP("res %02X %02X%04X %02X ", 
-       		(fraginfo->flags & IP6T_FRAG_RES), frag->reserved,
-		ntohs(frag->frag_off) & 0x6,
+       		(fraginfo->flags & IP6T_FRAG_RES), fh->reserved,
+		ntohs(fh->frag_off) & 0x6,
        		!((fraginfo->flags & IP6T_FRAG_RES)
-			&& (frag->reserved || (ntohs(frag->frag_off) & 0x6))));
+			&& (fh->reserved || (ntohs(fh->frag_off) & 0x06))));
        DEBUGP("first %02X %02X %02X ", 
        		(fraginfo->flags & IP6T_FRAG_FST),
-		ntohs(frag->frag_off) & ~0x7,
+		ntohs(fh->frag_off) & ~0x7,
        		!((fraginfo->flags & IP6T_FRAG_FST)
-			&& (ntohs(frag->frag_off) & ~0x7)));
+			&& (ntohs(fh->frag_off) & ~0x7)));
        DEBUGP("mf %02X %02X %02X ", 
        		(fraginfo->flags & IP6T_FRAG_MF),
-		ntohs(frag->frag_off) & IP6_MF,
+		ntohs(fh->frag_off) & IP6_MF,
        		!((fraginfo->flags & IP6T_FRAG_MF)
-			&& !((ntohs(frag->frag_off) & IP6_MF))));
+			&& !((ntohs(fh->frag_off) & IP6_MF))));
        DEBUGP("last %02X %02X %02X\n", 
        		(fraginfo->flags & IP6T_FRAG_NMF),
-		ntohs(frag->frag_off) & IP6_MF,
+		ntohs(fh->frag_off) & IP6_MF,
        		!((fraginfo->flags & IP6T_FRAG_NMF)
-			&& (ntohs(frag->frag_off) & IP6_MF)));
+			&& (ntohs(fh->frag_off) & IP6_MF)));
 
-       return (frag != NULL)
+       return (fh != NULL)
        		&&
        		(id_match(fraginfo->ids[0], fraginfo->ids[1],
-			  ntohl(frag->identification),
+			  ntohl(fh->identification),
                            !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)))
 		&&
 		!((fraginfo->flags & IP6T_FRAG_RES)
-			&& (frag->reserved || (ntohs(frag->frag_off) & 0x6)))
+			&& (fh->reserved || (ntohs(fh->frag_off) & 0x6)))
 		&&
 		!((fraginfo->flags & IP6T_FRAG_FST)
-			&& (ntohs(frag->frag_off) & ~0x7))
+			&& (ntohs(fh->frag_off) & ~0x7))
 		&&
 		!((fraginfo->flags & IP6T_FRAG_MF)
-			&& !(ntohs(frag->frag_off) & IP6_MF))
+			&& !(ntohs(fh->frag_off) & IP6_MF))
 		&&
 		!((fraginfo->flags & IP6T_FRAG_NMF)
-			&& (ntohs(frag->frag_off) & IP6_MF));
+			&& (ntohs(fh->frag_off) & IP6_MF));
 }
 
 /* Called when user tries to insert an entry of this type. */

----Next_Part(Thu_Oct__7_13:56:53_2004_867)----
