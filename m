From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 9/18]: Backport fixes for ip6t_dst
Date: Mon, 20 Dec 2004 08:15:03 +0100
Message-ID: <41C67BF7.80002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040904090708040906030200"
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
--------------040904090708040906030200
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Backport fixes for ip6t_dst.


--------------040904090708040906030200
Content-Type: text/x-patch;
 name="09.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:13:57+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Backport fixes for ip6t_dst
#   
#   This patch fixes the following bugs in ip6t_dst.c:
#   
#     - The cast of the pointer to the next IPv6 extension header is wrong.
#     - hdrlen may underflow.
#     - (u16)*optdesc causes to alignment problem.
#     - The calculation of the offset to next option is wrong. In the case
#       that the type isn't 0, it should be "Opt Data Len" field + 2
#       (see RFC2460).
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_dst.c
#   2004/12/05 23:13:55+01:00 yasuyuki.kozakai@toshiba.co.jp +38 -36
#   [NETFILTER]: Backport fixes for ip6t_dst
#   
#   This patch fixes the following bugs in ip6t_dst.c:
#   
#     - The cast of the pointer to the next IPv6 extension header is wrong.
#     - hdrlen may underflow.
#     - (u16)*optdesc causes to alignment problem.
#     - The calculation of the offset to next option is wrong. In the case
#       that the type isn't 0, it should be "Opt Data Len" field + 2
#       (see RFC2460).
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
--- a/net/ipv6/netfilter/ip6t_dst.c	2004-12-20 07:01:14 +01:00
+++ b/net/ipv6/netfilter/ip6t_dst.c	2004-12-20 07:01:14 +01:00
@@ -11,8 +11,6 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 
-#define LOW(n)		(n & 0x00FF)
-
 #define HOPBYHOP	0
 
 EXPORT_NO_SYMBOLS;
@@ -40,8 +38,8 @@
  *  	0	-> invariant
  *  	1	-> can change the routing
  *  (Type & 0x1F) Type
- *      0	-> PAD0 (only 1 byte!)
- *      1	-> PAD1 LENGTH info (total length = length + 2)
+ *      0	-> Pad1 (only 1 byte!)
+ *      1	-> PadN LENGTH info (total length = length + 2)
  *      C0 | 2	-> JUMBO 4 x x x x ( xxxx > 64k )
  *      5	-> RTALERT 2 x x
  */
@@ -64,7 +62,8 @@
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
-       u_int16_t *optdesc = NULL;
+       u8 *opttype = NULL;
+       unsigned int optlen;
        
        /* type of the 1st exthdr */
        nexthdr = skb->nh.ipv6h->nexthdr;
@@ -91,7 +90,7 @@
                      break;
               }
 
-              hdr=(void *)(skb->data)+ptr;
+	      hdr = (void *)(skb->data + ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -153,7 +152,7 @@
        		return 0;
        }
 
-       optsh=(void *)(skb->data)+ptr;
+       optsh = (void *)(skb->data + ptr);
 
        DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, optsh->hdrlen);
 
@@ -169,7 +168,6 @@
                            ((optinfo->hdrlen == hdrlen) ^
                            !!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
 
-       temp = len = 0;
        ptr += 2;
        hdrlen -= 2;
        if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
@@ -180,48 +178,52 @@
 		DEBUGP("Strict ");
 		DEBUGP("#%d ",optinfo->optsnr);
 		for(temp=0; temp<optinfo->optsnr; temp++){
-			optdesc = (void *)(skb->data)+ptr;
+			/* type field exists ? */
+			if (ptr > skb->len - 1 || hdrlen < 1)
+				break;
+			opttype = (void *)(skb->data + ptr);
+
 			/* Type check */
-			if ( (unsigned char)*optdesc != 
-				(optinfo->opts[temp] & 0xFF00)>>8 ){
+			if (*opttype != (optinfo->opts[temp] & 0xFF00)>>8){
 				DEBUGP("Tbad %02X %02X\n",
-						(unsigned char)*optdesc,
-						(optinfo->opts[temp] &
-						 0xFF00)>>8);
+				       *opttype,
+				       (optinfo->opts[temp] & 0xFF00)>>8);
 				return 0;
 			} else {
 				DEBUGP("Tok ");
 			}
 			/* Length check */
-			if (((optinfo->opts[temp] & 0x00FF) != 0xFF) &&
-				(unsigned char)*optdesc != 0){
-				if ( ntohs((u16)*optdesc) != 
-						optinfo->opts[temp] ){
-					DEBUGP("Lbad %02X %04X %04X\n",
-							(unsigned char)*optdesc,
-							ntohs((u16)*optdesc),
-							optinfo->opts[temp]);
+			if (*opttype) {
+				u16 spec_len;
+
+				/* length field exists ? */
+				if (ptr > skb->len - 2 || hdrlen < 2)
+					break;
+				optlen = *((u8 *)(skb->data + ptr + 1));
+				spec_len = optinfo->opts[temp] & 0x00FF;
+
+				if (spec_len != 0x00FF && spec_len != optlen) {
+					DEBUGP("Lbad %02X %04X\n", optlen,
+					       spec_len);
 					return 0;
-				} else {
-					DEBUGP("Lok ");
 				}
-			}
-			/* Step to the next */
-			if ((unsigned char)*optdesc == 0){
-				DEBUGP("PAD0 \n");
-				ptr++;
-				hdrlen--;
+				DEBUGP("Lok ");
+				optlen += 2;
 			} else {
-				ptr += LOW(ntohs(*optdesc));
-				hdrlen -= LOW(ntohs(*optdesc));
-				DEBUGP("len%04X \n", 
-					LOW(ntohs(*optdesc)));
+				DEBUGP("Pad1\n");
+				optlen = 1;
 			}
-			if (ptr > skb->len || ( !hdrlen && 
-				(temp != optinfo->optsnr - 1))) {
+
+			/* Step to the next */
+			DEBUGP("len%04X \n", optlen);
+
+			if ((ptr > skb->len - optlen || hdrlen < optlen) &&
+			    (temp < optinfo->optsnr - 1)) {
 				DEBUGP("new pointer is too large! \n");
 				break;
 			}
+			ptr += optlen;
+			hdrlen -= optlen;
 		}
 		if (temp == optinfo->optsnr)
 			return ret;

--------------040904090708040906030200--
