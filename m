From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 13/19]: Enable ip6t_frag.c to work without
	skb_linearize()
Date: Mon, 25 Oct 2004 02:49:48 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4DAC.3070301@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090600050304040203070106"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090600050304040203070106
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ip6t_frag to skb_header_pointer.



--------------090600050304040203070106
Content-Type: text/x-patch;
 name="13.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="13.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/20 21:36:17+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Enable ip6t_frag.c to work without skb_linearize()
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_frag.c
#   2004/10/20 21:35:34+02:00 yasuyuki.kozakai@toshiba.co.jp +31 -29
#   [NETFILTER]: Enable ip6t_frag.c to work without skb_linearize()
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
--- a/net/ipv6/netfilter/ip6t_frag.c	2004-10-22 03:41:55 +02:00
+++ b/net/ipv6/netfilter/ip6t_frag.c	2004-10-22 03:41:55 +02:00
@@ -48,7 +48,7 @@
       unsigned int protoff,
       int *hotdrop)
 {
-       struct frag_hdr *frag = NULL;
+       struct frag_hdr _frag, *fh = NULL;
        const struct ip6t_frag *fraginfo = matchinfo;
        unsigned int temp;
        int len;
@@ -65,7 +65,7 @@
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_frag header iteration \n");
 
@@ -81,15 +81,16 @@
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
@@ -112,7 +113,7 @@
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -129,57 +130,58 @@
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

--------------090600050304040203070106--
