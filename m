From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/4] introducing skb_header_pointer() to dst match
Date: Fri, 22 Oct 2004 11:59:42 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410220259.i9M2xhnZ007641@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Oct_22_11:59:42_2004_791)--"
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Fri_Oct_22_11:59:42_2004_791)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch introduces skb_header_pointer() to ip6t_dst.c

Signed-off-by Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Fri_Oct_22_11:59:42_2004_791)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dst-nolin.patch"

--- linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_dst.c	2004-10-20 23:57:35.000000000 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_dst.c	2004-10-21 01:27:20.940686768 +0900
@@ -60,7 +60,7 @@
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_opt_hdr *optsh = NULL;
+       struct ipv6_opt_hdr _optsh, *oh;
        const struct ip6t_opts *optinfo = matchinfo;
        unsigned int temp;
        unsigned int len;
@@ -68,7 +68,8 @@
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
-       u8 *opttype = NULL;
+       u8 _opttype, *tp = NULL;
+       u8 _optlen, *lp = NULL;
        unsigned int optlen;
        
        /* type of the 1st exthdr */
@@ -80,7 +81,7 @@
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_opts header iteration \n");
 
@@ -96,15 +97,16 @@
                      break;
               }
 
-	      hdr = (void *)(skb->data + ptr);
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
 
               /* OPTS -> evaluate */
 #if HOPBYHOP
@@ -132,7 +134,7 @@
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -158,9 +160,10 @@
        		return 0;
        }
 
-       optsh = (void *)(skb->data + ptr);
+       oh = skb_header_pointer(skb, ptr, sizeof(_optsh), &_optsh);
+       BUG_ON(oh == NULL);
 
-       DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, optsh->hdrlen);
+       DEBUGP("IPv6 OPTS LEN %u %u ", hdrlen, oh->hdrlen);
 
        DEBUGP("len %02X %04X %02X ",
        		optinfo->hdrlen, hdrlen,
@@ -168,7 +171,7 @@
                            ((optinfo->hdrlen == hdrlen) ^
                            !!(optinfo->invflags & IP6T_OPTS_INV_LEN))));
 
-       ret = (optsh != NULL)
+       ret = (oh != NULL)
        		&&
 	      	(!(optinfo->flags & IP6T_OPTS_LEN) ||
                            ((optinfo->hdrlen == hdrlen) ^
@@ -185,36 +188,43 @@
 		DEBUGP("#%d ",optinfo->optsnr);
 		for(temp=0; temp<optinfo->optsnr; temp++){
 			/* type field exists ? */
-			if (ptr > skb->len - 1 || hdrlen < 1)
+			if (hdrlen < 1)
+				break;
+			tp = skb_header_pointer(skb, ptr, sizeof(_opttype),
+						&_opttype);
+			if (tp == NULL)
 				break;
-			opttype = (void *)(skb->data + ptr);
 
 			/* Type check */
-			if (*opttype != (optinfo->opts[temp] & 0xFF00)>>8){
+			if (*tp != (optinfo->opts[temp] & 0xFF00)>>8){
 				DEBUGP("Tbad %02X %02X\n",
-				       *opttype,
+				       *tp,
 				       (optinfo->opts[temp] & 0xFF00)>>8);
 				return 0;
 			} else {
 				DEBUGP("Tok ");
 			}
 			/* Length check */
-			if (*opttype) {
+			if (*tp) {
 				u16 spec_len;
 
 				/* length field exists ? */
-				if (ptr > skb->len - 2 || hdrlen < 2)
+				if (hdrlen < 2)
+					break;
+				lp = skb_header_pointer(skb, ptr + 1,
+							sizeof(_optlen),
+							&_optlen);
+				if (lp == NULL)
 					break;
-				optlen = *((u8 *)(skb->data + ptr + 1));
 				spec_len = optinfo->opts[temp] & 0x00FF;
 
-				if (spec_len != 0x00FF && spec_len != optlen) {
-					DEBUGP("Lbad %02X %04X\n", optlen,
+				if (spec_len != 0x00FF && spec_len != *lp) {
+					DEBUGP("Lbad %02X %04X\n", *lp,
 					       spec_len);
 					return 0;
 				}
 				DEBUGP("Lok ");
-				optlen += 2;
+				optlen = *lp + 2;
 			} else {
 				DEBUGP("Pad1\n");
 				optlen = 1;

----Next_Part(Fri_Oct_22_11:59:42_2004_791)----
