From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] bug fixes and introducing skb_header_pointer() to ip6t_rt.c
Date: Thu, 07 Oct 2004 12:34:14 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410070334.i973YF9A027425@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Oct__7_12:34:14_2004_795)--"
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

----Next_Part(Thu_Oct__7_12:34:14_2004_795)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

The first patch fixes the following bugs

	- Wrong cast the pointer to extension header.
	- "Segments Left" field in Routing Header isn't treated as 1 octet.

And the second patch enables ip6t_rt.c to work without skb_linearize().

Please note that the second patch overrides all of changes by the first patch.
I divided into them for just ease to read.

And before trying these patches, don't forget to apply the patch which prepare
to removing skb_linearize().

https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017028.html

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Oct__7_12:34:14_2004_795)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="rt-fix.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_rt.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_rt.c	2004-10-07 11:25:33.231912056 +0900
@@ -84,7 +84,7 @@ match(const struct sk_buff *skb,
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -141,11 +141,11 @@ match(const struct sk_buff *skb,
 
        DEBUGP("IPv6 RT LEN %u %u ", hdrlen, route->hdrlen);
        DEBUGP("TYPE %04X ", route->type);
-       DEBUGP("SGS_LEFT %u %08X\n", ntohl(route->segments_left), ntohl(route->segments_left));
+       DEBUGP("SGS_LEFT %u %02X\n", route->segments_left, route->segments_left);
 
        DEBUGP("IPv6 RT segsleft %02X ",
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           ntohl(route->segments_left),
+                           route->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS))));
        DEBUGP("type %02X %02X %02X ",
        		rtinfo->rt_type, route->type, 
@@ -164,7 +164,7 @@ match(const struct sk_buff *skb,
        ret = (route != NULL)
        		&&
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           ntohl(route->segments_left),
+                           route->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
 		&&
 	      	(!(rtinfo->flags & IP6T_RT_LEN) ||

----Next_Part(Thu_Oct__7_12:34:14_2004_795)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="rt-nolin.patch"

--- linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_rt.c	2004-10-07 11:25:33.231912056 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_rt.c	2004-10-05 22:17:19.000000000 +0900
@@ -50,7 +50,7 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-       struct ipv6_rt_hdr *route = NULL;
+       struct ipv6_rt_hdr _route, *rh = NULL;
        const struct ip6t_rt *rtinfo = matchinfo;
        unsigned int temp;
        unsigned int len;
@@ -58,6 +58,7 @@ match(const struct sk_buff *skb,
        unsigned int ptr;
        unsigned int hdrlen = 0;
        unsigned int ret = 0;
+       struct in6_addr *ap, _addr;
 
        /* type of the 1st exthdr */
        nexthdr = skb->nh.ipv6h->nexthdr;
@@ -68,7 +69,7 @@ match(const struct sk_buff *skb,
        temp = 0;
 
         while (ip6t_ext_hdr(nexthdr)) {
-               struct ipv6_opt_hdr *hdr;
+               struct ipv6_opt_hdr _hdr, *hp;
 
               DEBUGP("ipv6_rt header iteration \n");
 
@@ -84,15 +85,16 @@ match(const struct sk_buff *skb,
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
@@ -115,7 +117,7 @@ match(const struct sk_buff *skb,
                             break;
               }
 
-                nexthdr = hdr->nexthdr;
+                nexthdr = hp->nexthdr;
                 len -= hdrlen;
                 ptr += hdrlen;
 		if ( ptr > skb->len ) {
@@ -137,20 +139,21 @@ match(const struct sk_buff *skb,
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
@@ -158,13 +161,13 @@ match(const struct sk_buff *skb,
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
@@ -172,13 +175,19 @@ match(const struct sk_buff *skb,
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
@@ -187,32 +196,27 @@ match(const struct sk_buff *skb,
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
@@ -224,26 +228,19 @@ match(const struct sk_buff *skb,
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

----Next_Part(Thu_Oct__7_12:34:14_2004_795)----
