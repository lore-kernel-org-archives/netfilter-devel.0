From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: nf_conntrack_ipv4: fix "Frag of proto ..."
	messages
Date: Mon, 10 Sep 2007 00:20:39 +0200 (MEST)
Message-ID: <20070909221738.25157.79830.sendpatchset@localhost.localdomain>
References: <20070909221736.25157.46398.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070909221736.25157.46398.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ipv4: fix "Frag of proto ..." messages

Since we're now using a generic tuple decoding function in ICMP
connection tracking, ipv4_get_l4proto() might get called with a
fragmented packet from within an ICMP error. Remove the error
message we used to print when this happens.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0fb0ffa355d0db63cf6f9dda9958c91e4bc7c859
tree 72c9853b112c17840ae9437e23888257dd3236ac
parent b21010ed6498391c0f359f2a89c907533fe07fec
author Patrick McHardy <kaber@trash.net> Mon, 10 Sep 2007 00:13:16 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 10 Sep 2007 00:13:16 +0200

 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index d9b5177..53cb177 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -87,14 +87,10 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	if (iph == NULL)
 		return -NF_DROP;
 
-	/* Never happen */
-	if (iph->frag_off & htons(IP_OFFSET)) {
-		if (net_ratelimit()) {
-			printk(KERN_ERR "ipv4_get_l4proto: Frag of proto %u\n",
-			iph->protocol);
-		}
+	/* Conntrack defragments packets, we might still see fragments
+	 * inside ICMP packets though. */
+	if (iph->frag_off & htons(IP_OFFSET))
 		return -NF_DROP;
-	}
 
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
