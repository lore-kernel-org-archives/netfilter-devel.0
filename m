From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 12/18]: Backport fixes for ip6t_frag
Date: Mon, 20 Dec 2004 08:15:15 +0100
Message-ID: <41C67C03.4090605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040509070209060407010806"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------040509070209060407010806
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Backport fixes for ip6t_frag.


--------------040509070209060407010806
Content-Type: text/x-patch;
 name="12.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="12.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:27:40+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Backport fixes for ip6t_frag
#   
#   This patch fixes following bugs in ip6t_frag.c:
#   
#     - Wrong cast the pointer to extension header.
#     - replaced "struct fraghdr" with "struct frag_hdr".
#     - header length of Fragment Header is statically 8 octets.
#       Then the option "--frag-len" doesn't make sense.
#     - There are endian issues where using frag->info.
#     - Reserved fields are not 2 bit but 8bit + 2 bit. (see RFC2460)
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_frag.c
#   2004/12/05 23:27:38+01:00 yasuyuki.kozakai@toshiba.co.jp +38 -58
#   [NETFILTER]: Backport fixes for ip6t_frag
#   
#   This patch fixes following bugs in ip6t_frag.c:
#   
#     - Wrong cast the pointer to extension header.
#     - replaced "struct fraghdr" with "struct frag_hdr".
#     - header length of Fragment Header is statically 8 octets.
#       Then the option "--frag-len" doesn't make sense.
#     - There are endian issues where using frag->info.
#     - Reserved fields are not 2 bit but 8bit + 2 bit. (see RFC2460)
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
--- a/net/ipv6/netfilter/ip6t_frag.c	2004-12-20 07:01:25 +01:00
+++ b/net/ipv6/netfilter/ip6t_frag.c	2004-12-20 07:01:25 +01:00
@@ -6,8 +6,6 @@
 #include <net/checksum.h>
 #include <net/ipv6.h>
 
-#include <asm/byteorder.h>
-
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_frag.h>
 
@@ -22,28 +20,7 @@
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
+#define IP6_MF	0x0001
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
 static inline int
@@ -67,7 +44,7 @@
       u_int16_t datalen,
       int *hotdrop)
 {
-       struct fraghdr *frag = NULL;
+       struct frag_hdr *frag = NULL;
        const struct ip6t_frag *fraginfo = matchinfo;
        unsigned int temp;
        int len;
@@ -100,7 +77,7 @@
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -143,59 +120,62 @@
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

--------------040509070209060407010806--
