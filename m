From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 6/8]: Fix ip6tables ESP matching with "-p all"
Date: Fri, 04 Mar 2005 13:18:52 +0100
Message-ID: <4228522C.60307@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="06.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="06.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/04 00:51:10+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix ip6tables ESP matching with "-p all"
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6_tables.c
#   2005/03/04 00:51:08+01:00 kaber@coreworks.de +1 -1
#   [NETFILTER]: Fix ip6tables ESP matching with "-p all"
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
--- a/net/ipv6/netfilter/ip6_tables.c	2005-03-04 01:52:07 +01:00
+++ b/net/ipv6/netfilter/ip6_tables.c	2005-03-04 01:52:07 +01:00
@@ -226,7 +226,7 @@
 			 * we will change the return 0 to 1*/
 			if ((currenthdr == IPPROTO_NONE) || 
 				(currenthdr == IPPROTO_ESP))
-				return 0;
+				break;
 
 	                hdrptr = (struct ipv6_opt_hdr *)(skb->data + ptr);
 
