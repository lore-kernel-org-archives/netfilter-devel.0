From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 9/19]: Convert ip6t_physdev match function to new
 argument order
Date: Mon, 25 Oct 2004 02:49:26 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4D96.9090207@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010600030300090502090305"
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
--------------010600030300090502090305
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ip6t_physdev to new match-function argument order.



--------------010600030300090502090305
Content-Type: text/x-patch;
 name="09.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="09.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/19 15:49:43+02:00 kaber@coreworks.de 
#   [NETFILTER]: Convert ip6t_physdev match function to new argument order
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_physdev.c
#   2004/10/19 15:49:12+02:00 kaber@coreworks.de +1 -2
#   [NETFILTER]: Convert ip6t_physdev match function to new argument order
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_physdev.c b/net/ipv6/netfilter/ip6t_physdev.c
--- a/net/ipv6/netfilter/ip6t_physdev.c	2004-10-22 03:39:17 +02:00
+++ b/net/ipv6/netfilter/ip6t_physdev.c	2004-10-22 03:39:17 +02:00
@@ -26,8 +26,7 @@
       const struct net_device *out,
       const void *matchinfo,
       int offset,
-      const void *hdr,
-      u_int16_t datalen,
+      unsigned int protoff,
       int *hotdrop)
 {
 	int i;

--------------010600030300090502090305--
