From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/5]: Fix multiple bugs in ip6rt.c
Date: Thu, 14 Oct 2004 02:18:51 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416DC5EB.3060500@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080708040606080709030407"
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
--------------080708040606080709030407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch fixes an invalid cast and wrong use of the
segments_left field in the routing header in ip6rt.c.



--------------080708040606080709030407
Content-Type: text/x-patch;
 name="3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="3.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/14 01:00:37+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix multiple bugs in ip6rt.c
#   
#   The first patch fixes the following bugs
#   
#     - Wrong cast the pointer to extension header.
#     - "Segments Left" field in Routing Header isn't treated as 1 octet.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_rt.c
#   2004/10/14 01:00:09+02:00 yasuyuki.kozakai@toshiba.co.jp +4 -4
#   [NETFILTER]: Fix multiple bugs in ip6rt.c
#   
#   The first patch fixes the following bugs
#   
#     - Wrong cast the pointer to extension header.
#     - "Segments Left" field in Routing Header isn't treated as 1 octet.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c	2004-10-14 01:36:59 +02:00
+++ b/net/ipv6/netfilter/ip6t_rt.c	2004-10-14 01:36:59 +02:00
@@ -85,7 +85,7 @@
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -142,11 +142,11 @@
 
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
@@ -165,7 +165,7 @@
        ret = (route != NULL)
        		&&
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           ntohl(route->segments_left),
+                           route->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
 		&&
 	      	(!(rtinfo->flags & IP6T_RT_LEN) ||

--------------080708040606080709030407--
