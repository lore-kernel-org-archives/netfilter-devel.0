From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 15/18]: Backport fixes for ip6t_multiport
Date: Mon, 20 Dec 2004 08:15:29 +0100
Message-ID: <41C67C11.4010006@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050502080100080304060107"
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
--------------050502080100080304060107
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Backport fixes for ip6t_multiport.


--------------050502080100080304060107
Content-Type: text/x-patch;
 name="15.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="15.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:32:41+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Backport fixes for ip6t_multiport
#   
#   This patch fixes following bugs in ip6t_multiport.c,
#   
#     - missing check the size of the preference data.
#     - IP6T_INV_PROTO should check with not ip->flags but ip->invflags.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_multiport.c
#   2004/12/05 23:32:39+01:00 yasuyuki.kozakai@toshiba.co.jp +4 -1
#   [NETFILTER]: Backport fixes for ip6t_multiport
#   
#   This patch fixes following bugs in ip6t_multiport.c,
#   
#     - missing check the size of the preference data.
#     - IP6T_INV_PROTO should check with not ip->flags but ip->invflags.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
--- a/net/ipv6/netfilter/ip6t_multiport.c	2004-12-20 07:01:28 +01:00
+++ b/net/ipv6/netfilter/ip6t_multiport.c	2004-12-20 07:01:28 +01:00
@@ -74,9 +74,12 @@
 {
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
+	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_multiport)))
+		return 0;
+
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->flags & IP6T_INV_PROTO)
+		&& !(ip->invflags & IP6T_INV_PROTO)
 		&& matchsize == IP6T_ALIGN(sizeof(struct ip6t_multiport))
 		&& (multiinfo->flags == IP6T_MULTIPORT_SOURCE
 		    || multiinfo->flags == IP6T_MULTIPORT_DESTINATION

--------------050502080100080304060107--
