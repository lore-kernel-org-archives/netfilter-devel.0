From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 16/18]: Backport fixes for ip6t_rt
Date: Mon, 20 Dec 2004 08:15:35 +0100
Message-ID: <41C67C17.8060503@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080205030706050408050604"
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
--------------080205030706050408050604
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Backport fixes for ip6t_rt.


--------------080205030706050408050604
Content-Type: text/x-patch;
 name="16.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="16.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:33:54+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Backport fixes for ip6t_rt
#   
#   This patch fixes the following bugs
#   
#     - Wrong cast the pointer to extension header.
#     - "Segments Left" field in Routing Header isn't treated as 1 octet.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_rt.c
#   2004/12/05 23:33:52+01:00 yasuyuki.kozakai@toshiba.co.jp +4 -4
#   [NETFILTER]: Backport fixes for ip6t_rt
#   
#   This patch fixes the following bugs
#   
#     - Wrong cast the pointer to extension header.
#     - "Segments Left" field in Routing Header isn't treated as 1 octet.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c	2004-12-20 07:01:30 +01:00
+++ b/net/ipv6/netfilter/ip6t_rt.c	2004-12-20 07:01:30 +01:00
@@ -78,7 +78,7 @@
                      break;
               }
 
-              hdr=(struct ipv6_opt_hdr *)skb->data+ptr;
+              hdr=(struct ipv6_opt_hdr *)(skb->data+ptr);
 
               /* Calculate the header length */
                 if (nexthdr == NEXTHDR_FRAGMENT) {
@@ -135,11 +135,11 @@
 
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
@@ -158,7 +158,7 @@
        ret = (route != NULL)
        		&&
        		(segsleft_match(rtinfo->segsleft[0], rtinfo->segsleft[1],
-                           ntohl(route->segments_left),
+                           route->segments_left,
                            !!(rtinfo->invflags & IP6T_RT_INV_SGS)))
 		&&
 	      	(!(rtinfo->flags & IP6T_RT_LEN) ||

--------------080205030706050408050604--
