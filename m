From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/4]: Simplify netbios helper
Date: Tue, 13 Sep 2005 09:37:16 +0200
Message-ID: <432681AC.70904@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Simplify netbios helper

Don't parse the packet, the data is already available in the conntrack
structure.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 32be69721bfef1f0ab1c271c60002b06f27bf589
tree f47b2dd306d31343f19a0a63f73cf7e685ed9a4d
parent d53f0d343998b81945723c43046c4f2ee301e45b
author Patrick McHardy <kaber@trash.net> Sat, 10 Sep 2005 01:33:13 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 10 Sep 2005 01:33:13 +0200

 net/ipv4/netfilter/ip_conntrack_netbios_ns.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
--- a/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
+++ b/net/ipv4/netfilter/ip_conntrack_netbios_ns.c
@@ -23,7 +23,6 @@
 #include <linux/inetdevice.h>
 #include <linux/in.h>
 #include <linux/ip.h>
-#include <linux/udp.h>
 #include <net/route.h>
 
 #include <linux/netfilter.h>
@@ -31,6 +30,8 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 
+#define NMBD_PORT	137
+
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_DESCRIPTION("NetBIOS name service broadcast connection tracking helper");
 MODULE_LICENSE("GPL");
@@ -44,7 +45,6 @@ static int help(struct sk_buff **pskb,
 {
 	struct ip_conntrack_expect *exp;
 	struct iphdr *iph = (*pskb)->nh.iph;
-	struct udphdr _uh, *uh;
 	struct rtable *rt = (struct rtable *)(*pskb)->dst;
 	struct in_device *in_dev;
 	u_int32_t mask = 0;
@@ -72,20 +72,15 @@ static int help(struct sk_buff **pskb,
 	if (mask == 0)
 		goto out;
 
-	uh = skb_header_pointer(*pskb, iph->ihl * 4, sizeof(_uh), &_uh);
-	BUG_ON(uh == NULL);
-
 	exp = ip_conntrack_expect_alloc(ct);
 	if (exp == NULL)
 		goto out;
-	memset(&exp->tuple, 0, sizeof(exp->tuple));
-	exp->tuple.src.ip         = iph->daddr & mask;
-	exp->tuple.dst.ip         = iph->saddr;
-	exp->tuple.dst.u.udp.port = uh->source;
-	exp->tuple.dst.protonum   = IPPROTO_UDP;
 
-	memset(&exp->mask, 0, sizeof(exp->mask));
+	exp->tuple                = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	exp->tuple.src.u.udp.port = ntohs(NMBD_PORT);
+
 	exp->mask.src.ip          = mask;
+	exp->mask.src.u.udp.port  = 0xFFFF;
 	exp->mask.dst.ip          = 0xFFFFFFFF;
 	exp->mask.dst.u.udp.port  = 0xFFFF;
 	exp->mask.dst.protonum    = 0xFF;
@@ -107,7 +102,7 @@ static struct ip_conntrack_helper helper
 		.src = {
 			.u = {
 				.udp = {
-					.port	= __constant_htons(137),
+					.port	= __constant_htons(NMBD_PORT),
 				}
 			}
 		},
