From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 15/19]: Fix multiple bugs in dst match
Date: Mon, 25 Oct 2004 02:49:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4DB5.8040108@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070603020207050707080305"
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
--------------070603020207050707080305
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Fix multiple bugs in dst match:

- ".me = THIS_MODULE" is missing
- The cast of the pointer to the next IPv6 extension header is wrong.
- hdrlen may underflow.
- (u16)*optdesc causes to alignment problem.
- The calculation of the offset to next option is wrong. In the case
  that the type isn't 0, it should be "Opt Data Len" field + 2
  (see RFC2460).



--------------070603020207050707080305
Content-Type: text/x-patch;
 name="15.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/25 00:39:13+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix multiple bugs in dst match
#   
#   This patch fixes the following bugs in ip6t_dst.c.
#   
#     - ".me = THIS_MODULE" is missing 
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
#   2004/10/25 00:39:07+02:00 yasuyuki.kozakai@toshiba.co.jp +39 -37
#   [NETFILTER]: Fix multiple bugs in dst match
#   
#   This patch fixes the following bugs in ip6t_dst.c.
#   
#     - ".me = THIS_MODULE" is missing 
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
--- a/net/ipv6/netfilter/ip6t_dst.c	2004-10-25 01:13:48 +02:00
+++ b/net/ipv6/netfilter/ip6t_dst.c	2004-10-25 01:13:48 +02:00
@@ -7,7 +7,6 @@
  * published by the Free Software Foundation.
  */
 
-
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ipv6.h>
@@ -20,8 +19,6 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 
-#define LOW(n)		(n & 0x00FF)
-
 #define HOPBYHOP	0
 
 MODULE_LICENSE("GPL");
@@ -48,8 +45,8 @@
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
@@ -71,7 +68,8 @@
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
-       u_int16_t *optdesc = NULL;
+       u8 *opttype = NULL;
+       unsigned int optlen;
        
        /* type of the 1st exthdr */
        nexthdr = skb->nh.ipv6h->nexthdr;
@@ -98,7 +96,7 @@
                      break;
               }
 
-              hdr=(void *)(skb->data)+ptr;
+	      hdr = (void *)(skb->data + ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -160,7 +158,7 @@
        		return 0;
        }
 
-       optsh=(void *)(skb->data)+ptr;
+       optsh = (void *)(skb->data + ptr);
 
        DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, optsh->hdrlen);
 
@@ -176,7 +174,6 @@
                            ((optinfo->hdrlen == hdrlen) ^
                            !!(optinfo->invflags & IP6T_OPTS_INV_LEN)));
 
-       temp = len = 0;
        ptr += 2;
        hdrlen -= 2;
        if ( !(optinfo->flags & IP6T_OPTS_OPTS) ){
@@ -187,48 +184,52 @@
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
@@ -270,6 +271,7 @@
 #endif
 	.match		= &match,
 	.checkentry	= &checkentry,
+	.me		= THIS_MODULE,
 };
 
 static int __init init(void)

--------------070603020207050707080305--
