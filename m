From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 11/19]: Enable ip6t_rt.c to work without skb_linearize()
Date: Mon, 25 Oct 2004 02:49:41 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4DA5.2030609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020407070406020807070308"
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
--------------020407070406020807070308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ip6t_rt to skb_header_pointer.



--------------020407070406020807070308
Content-Type: text/x-patch;
 name="11.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="11.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/20 21:27:38+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Enable ip6t_rt.c to work without skb_linearize()
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
# 
# net/ipv6/netfilter/ip6t_rt.c
#   2004/10/20 21:26:53+02:00 yasuyuki.kozakai@toshiba.co.jp +59 -62
#   [NETFILTER]: Enable ip6t_rt.c to work without skb_linearize()
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c	2004-10-22 03:41:16 +02:00
+++ b/net/ipv6/netfilter/ip6t_rt.c	2004-10-22 03:41:16 +02:00
@@ -50,7 +50,7 @@
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_rt_hdr *route = NULL;
+       struct ipv6_rt_hdr _route, *rh = NULL;
        const struct ip6t_rt *rtinfo = matchinfo;
        unsigned int temp;
        unsigned int len;
@@ -58,6 +58,7 @@
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
+       struct in6_addr *ap, _addr;
 
        /* type of the 1st exthdr */
        nexthdr = skb->nh.ipv6h->nexthdr;
@@ -68,7 +69,7 @@
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_rt header iteration \n");
 
@@ -84,15 +85,16 @@
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
 
               /* ROUTING -> evaluate */
                 if (nexthdr == NEXTHDR_ROUTING) {
@@ -115,7 +117,7 @@
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -137,20 +139,21 @@
        		return 0;
        }
 
-       route = (struct ipv6_rt_hdr *) (skb->data + ptr);
+       rh = skb_header_pointer(skb, ptr, sizeof(_route), &_route);
+       BUG_ON(rh == NULL);
 
-       DEBUGP("IPv6 RT LEN %u %u ", hdrlen, route->hdrlen);
-       DEBUGP("TYPE %04X ", route->type);
-       DEBUGP("SGS_LEFT %u %02X\n", route->segments_left, route->segments_left);
+       DEBUGP("IPv6 RT LEN %u %u ", hdrlen, rh->hdrlen);
+       DEBUGP("TYPE %04X ", rh->type);
+       DEBUGP("SGS_LEFT %u %02X\n", rh->segments_left, rh->segments_left);
 
        DEBUGP("IPv6 RT segsleft %02X ",
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           route->segments_left,
+                           rh->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS))));
        DEBUGP("type %02X %02X %02X ",
-       		rtinfo->rt_type, route->type, 
+       		rtinfo->rt_type, rh->type, 
        		(!(rtinfo->flags & IP6T_RT_TYP) ||
-                           ((rtinfo->rt_type == route->type) ^
+                           ((rtinfo->rt_type == rh->type) ^
                            !!(rtinfo->invflags & IP6T_RT_INV_TYP))));
        DEBUGP("len %02X %04X %02X ",
        		rtinfo->hdrlen, hdrlen,
@@ -158,13 +161,13 @@
                            ((rtinfo->hdrlen == hdrlen) ^
                            !!(rtinfo->invflags & IP6T_RT_INV_LEN))));
        DEBUGP("res %02X %02X %02X ", 
-       		(rtinfo->flags & IP6T_RT_RES), ((struct rt0_hdr *)route)->bitmap,
-       		!((rtinfo->flags & IP6T_RT_RES) && (((struct rt0_hdr *)route)->bitmap)));
+       		(rtinfo->flags & IP6T_RT_RES), ((struct rt0_hdr *)rh)->bitmap,
+       		!((rtinfo->flags & IP6T_RT_RES) && (((struct rt0_hdr *)rh)->bitmap)));
 
-       ret = (route != NULL)
+       ret = (rh != NULL)
        		&&
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           route->segments_left,
+                           rh->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
 		&&
 	      	(!(rtinfo->flags & IP6T_RT_LEN) ||
@@ -172,13 +175,19 @@
                            !!(rtinfo->invflags & IP6T_RT_INV_LEN)))
 		&&
        		(!(rtinfo->flags & IP6T_RT_TYP) ||
-                           ((rtinfo->rt_type == route->type) ^
-                           !!(rtinfo->invflags & IP6T_RT_INV_TYP)))
-		&&
-       		!((rtinfo->flags & IP6T_RT_RES) && (((struct rt0_hdr *)route)->bitmap));
+                           ((rtinfo->rt_type == rh->type) ^
+                           !!(rtinfo->invflags & IP6T_RT_INV_TYP)));
+
+	if (ret && (rtinfo->flags & IP6T_RT_RES)) {
+		u_int32_t *bp, _bitmap;
+		bp = skb_header_pointer(skb,
+					ptr + offsetof(struct rt0_hdr, bitmap),
+					sizeof(_bitmap), &_bitmap);
+
+		ret = (*bp == 0);
+	}
 
 	DEBUGP("#%d ",rtinfo->addrnr);
-       temp = len = ptr = 0;
        if ( !(rtinfo->flags & IP6T_RT_FST) ){
 	       return ret;
 	} else if (rtinfo->flags & IP6T_RT_FST_NSTRICT) {
@@ -187,32 +196,27 @@
 			DEBUGP("There isn't enough space\n");
 			return 0;
 		} else {
+			unsigned int i = 0;
+
 			DEBUGP("#%d ",rtinfo->addrnr);
-			ptr = 0;
 			for(temp=0; temp<(unsigned int)((hdrlen-8)/16); temp++){
-				len = 0;
-				while ((u8)(((struct rt0_hdr *)route)->
-						addr[temp].s6_addr[len]) ==
-					(u8)(rtinfo->addrs[ptr].s6_addr[len])){
-					DEBUGP("%02X?%02X ",
-		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
-					(u8)(rtinfo->addrs[ptr].s6_addr[len]));
-					len++;
-					if ( len == 16 ) break;
+				ap = skb_header_pointer(skb,
+							ptr
+							+ sizeof(struct rt0_hdr)
+							+ temp * sizeof(_addr),
+							sizeof(_addr),
+							&_addr);
+
+				BUG_ON(ap == NULL);
+
+				if (!ipv6_addr_cmp(ap, &rtinfo->addrs[i])) {
+					DEBUGP("i=%d temp=%d;\n",i,temp);
+					i++;
 				}
-				if (len==16) {
-					DEBUGP("ptr=%d temp=%d;\n",ptr,temp);
-					ptr++;
-				} else {
-					DEBUGP("%02X?%02X ",
-		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
-					(u8)(rtinfo->addrs[ptr].s6_addr[len]));
-					DEBUGP("!ptr=%d temp=%d;\n",ptr,temp);
-				}
-				if (ptr==rtinfo->addrnr) break;
+				if (i==rtinfo->addrnr) break;
 			}
-			DEBUGP("ptr=%d len=%d #%d\n",ptr,len, rtinfo->addrnr);
-			if ( (len == 16) && (ptr == rtinfo->addrnr))
+			DEBUGP("i=%d #%d\n", i, rtinfo->addrnr);
+			if (i == rtinfo->addrnr)
 				return ret;
 			else return 0;
 		}
@@ -224,26 +228,19 @@
 		} else {
 			DEBUGP("#%d ",rtinfo->addrnr);
 			for(temp=0; temp<rtinfo->addrnr; temp++){
-				len = 0;
-				while ((u8)(((struct rt0_hdr *)route)->
-						addr[temp].s6_addr[len]) ==
-					(u8)(rtinfo->addrs[temp].s6_addr[len])){
-					DEBUGP("%02X?%02X ",
-		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
-					(u8)(rtinfo->addrs[temp].s6_addr[len]));
-					len++;
-					if ( len == 16 ) break;
-				}
-				if (len!=16) {
-					DEBUGP("%02X?%02X ",
-		(u8)(((struct rt0_hdr *)route)->addr[temp].s6_addr[len]),
-					(u8)(rtinfo->addrs[temp].s6_addr[len]));
-					DEBUGP("!len=%d temp=%d;\n",len,temp);
+				ap = skb_header_pointer(skb,
+							ptr
+							+ sizeof(struct rt0_hdr)
+							+ temp * sizeof(_addr),
+							sizeof(_addr),
+							&_addr);
+				BUG_ON(ap == NULL);
+
+				if (ipv6_addr_cmp(ap, &rtinfo->addrs[temp]))
 					break;
-				}
 			}
-			DEBUGP("temp=%d len=%d #%d\n",temp,len,rtinfo->addrnr);
-			if ( (len == 16) && (temp == rtinfo->addrnr) && (temp == (unsigned int)((hdrlen-8)/16)))
+			DEBUGP("temp=%d #%d\n", temp, rtinfo->addrnr);
+			if ((temp == rtinfo->addrnr) && (temp == (unsigned int)((hdrlen-8)/16)))
 				return ret;
 			else return 0;
 		}

--------------020407070406020807070308--
