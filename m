From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 11/18]: Backport fixes for ip6t_eui64
Date: Mon, 20 Dec 2004 08:15:11 +0100
Message-ID: <41C67BFF.3060307@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040002010109010704050908"
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
--------------040002010109010704050908
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Backport fixes for ip6t_eui64.


--------------040002010109010704050908
Content-Type: text/x-patch;
 name="11.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="11.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/05 23:19:08+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Backport fixes for ip6t_eui64
#   
#   User cannot insert rule with eui64 match to FORWARD chain.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_eui64.c
#   2004/12/05 23:19:06+01:00 yasuyuki.kozakai@toshiba.co.jp +1 -1
#   [NETFILTER]: Backport fixes for ip6t_eui64
#   
#   User cannot insert rule with eui64 match to FORWARD chain.
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
--- a/net/ipv6/netfilter/ip6t_eui64.c	2004-12-20 07:01:24 +01:00
+++ b/net/ipv6/netfilter/ip6t_eui64.c	2004-12-20 07:01:24 +01:00
@@ -58,7 +58,7 @@
 {
 	if (hook_mask
 	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
-		(1 << NF_IP6_PRE_ROUTING) )) {
+		(1 << NF_IP6_FORWARD))) {
 		printk("ip6t_eui64: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
 		return 0;
 	}

--------------040002010109010704050908--
