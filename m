From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/4] fixes for dst match
Date: Fri, 22 Oct 2004 11:56:51 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410220256.i9M2uqMD003834@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Oct_22_11:56:51_2004_331)--"
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

----Next_Part(Fri_Oct_22_11:56:51_2004_331)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch fixes the following bugs in ip6t_dst.c.

	- ".me = THIS_MODULE," is missing 

	- The cast of the pointer to the next IPv6 extension header is wrong.

	- hdrlen may underflow.

	- (u16)*optdesc causes to alignment problem.

	- The calculation of the offset to next option is wrong. In the case
	  that the type isn't 0, it should be "Opt Data Len" field + 2
	  (see RFC2460).

Signed-off-by Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Fri_Oct_22_11:56:51_2004_331)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dst-fix.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_dst.c	2004-10-10 15:06:05.000000000 +0900
+++ linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_dst.c	2004-10-20 23:57:35.000000000 +0900
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

----Next_Part(Fri_Oct_22_11:56:51_2004_331)----
