From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/9]: Make eui64 match usuable in FORWARD chain
Date: Mon, 15 Nov 2004 22:44:26 +0100
Message-ID: <4199233A.80206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060508080005030006080207"
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
--------------060508080005030006080207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

eui64 match can used in FORWARD chain.



--------------060508080005030006080207
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/04 03:16:30+01:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Make eui64 match usuable in FORWARD chain
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_eui64.c
#   2004/11/04 03:16:23+01:00 yasuyuki.kozakai@toshiba.co.jp +1 -1
#   [NETFILTER]: Make eui64 match usuable in FORWARD chain
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
--- a/net/ipv6/netfilter/ip6t_eui64.c	2004-11-15 22:06:28 +01:00
+++ b/net/ipv6/netfilter/ip6t_eui64.c	2004-11-15 22:06:28 +01:00
@@ -69,7 +69,7 @@
 {
 	if (hook_mask
 	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN) |
-		(1 << NF_IP6_PRE_ROUTING) )) {
+		(1 << NF_IP6_FORWARD))) {
 		printk("ip6t_eui64: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
 		return 0;
 	}

--------------060508080005030006080207--
