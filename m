From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 4/5]: Fix checks in ip6t_multiport.c
Date: Thu, 14 Oct 2004 02:19:04 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416DC5F8.9090009@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000308080203060007030407"
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
--------------000308080203060007030407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch makes ip6t_multiport check for argument
size and fixes a check against the wrong flags.



--------------000308080203060007030407
Content-Type: text/x-patch;
 name="4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="4.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/14 01:04:09+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Fix checks in ip6t_multiport.c
#   
#   The first patch fixes following bugs in ip6t_multiport.c,
#   
#     - missing check the size of the preference data.
#     - IP6T_INV_PROTO should check with not ip->flags but ip->invflags.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_multiport.c
#   2004/10/14 01:03:43+02:00 yasuyuki.kozakai@toshiba.co.jp +4 -1
#   [NETFILTER]: Fix checks in ip6t_multiport.c
#   
#   The first patch fixes following bugs in ip6t_multiport.c,
#   
#     - missing check the size of the preference data.
#     - IP6T_INV_PROTO should check with not ip->flags but ip->invflags.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
--- a/net/ipv6/netfilter/ip6t_multiport.c	2004-10-14 01:37:19 +02:00
+++ b/net/ipv6/netfilter/ip6t_multiport.c	2004-10-14 01:37:19 +02:00
@@ -87,9 +87,12 @@
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

--------------000308080203060007030407--
