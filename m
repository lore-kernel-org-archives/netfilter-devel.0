From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/6]: Fix ip6tables ESP matching with "-p all"
Date: Tue, 11 Jan 2005 13:49:54 +0100
Message-ID: <41E3CB72.3020303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070603030309050302060304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------070603030309050302060304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------070603030309050302060304
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 03:44:14+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix ip6tables ESP matching with "-p all"
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/01/11 03:44:07+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix ip6tables ESP matching with "-p all"
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:39:53 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-01-11 13:39:53 +01:00
@@ -234,7 +234,7 @@
 			 * we will change the return 0 to 1*/
 			if ((currenthdr == IPPROTO_NONE) || 
 				(currenthdr == IPPROTO_ESP))
-				return 0;
+				break;
 
 			hp = skb_header_pointer(skb, ptr, sizeof(_hdr), &_hdr);
 			BUG_ON(hp == NULL);

--------------070603030309050302060304--
