From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/06]: xt_pkttype: fix mismatches on locally generated
	packets
Date: Tue, 25 Jul 2006 05:26:59 +0200 (MEST)
Message-ID: <20060725032658.25063.92778.sendpatchset@localhost.localdomain>
References: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_pkttype: fix mismatches on locally generated packets

Locally generated broadcast and multicast packets have pkttype set to
PACKET_LOOPBACK instead of PACKET_BROADCAST or PACKET_MULTICAST. This
causes the pkttype match to fail to match packets of either type.

The below patch remedies this by using the daddr as a hint as to
broadcast|multicast. While not pretty, this seems like the only way
to solve the problem short of just noting this as a limitation of the
match.

This resolves netfilter bugzilla #484

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9a713120692b6601fa2abf506862bc40c16459ba
tree 3dbfa7b16367fbe36adcd374b8f62dfde89769fa
parent 91ce3a69f0154c527da6e4a47c8784383981a222
author Phil Oester <kernel@linuxace.com> Tue, 25 Jul 2006 00:05:39 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 00:05:39 +0200

 net/netfilter/xt_pkttype.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index 3ac703b..d2f5320 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -9,6 +9,8 @@ #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/if_ether.h>
 #include <linux/if_packet.h>
+#include <linux/in.h>
+#include <linux/ip.h>
 
 #include <linux/netfilter/xt_pkttype.h>
 #include <linux/netfilter/x_tables.h>
@@ -28,9 +30,17 @@ static int match(const struct sk_buff *s
       unsigned int protoff,
       int *hotdrop)
 {
+	u_int8_t type;
 	const struct xt_pkttype_info *info = matchinfo;
 
-	return (skb->pkt_type == info->pkttype) ^ info->invert;
+	if (skb->pkt_type == PACKET_LOOPBACK)
+		type = (MULTICAST(skb->nh.iph->daddr)
+			? PACKET_MULTICAST
+			: PACKET_BROADCAST);
+	else
+		type = skb->pkt_type;
+
+	return (type == info->pkttype) ^ info->invert;
 }
 
 static struct xt_match pkttype_match = {
