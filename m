From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2.4 9/10]: fixes for ip6t_rt
Date: Wed, 01 Dec 2004 17:07:45 +0900 (JST)
Message-ID: <200412010807.iB187kHe000912@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Dec__1_17:07:45_2004_276)--"
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
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Wed_Dec__1_17:07:45_2004_276)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


This patch fixes the following bugs

	- Wrong cast the pointer to extension header.
	- "Segments Left" field in Routing Header isn't treated as 1 octet.

Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Dec__1_17:07:45_2004_276)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="rt.patch"

--- linux-2.4.28-rc1/./net/ipv6/netfilter/ip6t_rt.c	2003-08-25 20:44:44.000000000 +0900
+++ linux-2.4.28-rc1-extfix/./net/ipv6/netfilter/ip6t_rt.c	2004-11-10 00:51:45.000000000 +0900
@@ -78,7 +78,7 @@ match(const struct sk_buff *skb,
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -135,11 +135,11 @@ match(const struct sk_buff *skb,
 
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
@@ -158,7 +158,7 @@ match(const struct sk_buff *skb,
        ret = (route != NULL)
        		&&
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           ntohl(route->segments_left),
+                           route->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
 		&&
 	      	(!(rtinfo->flags & IP6T_RT_LEN) ||

----Next_Part(Wed_Dec__1_17:07:45_2004_276)----
