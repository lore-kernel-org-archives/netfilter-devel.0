From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/39]: ipt_TCPMSS: remove impossible condition
Date: Wed, 20 Sep 2006 10:23:57 +0200 (MEST)
Message-ID: <20060920082449.14636.26271.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_TCPMSS: remove impossible condition

Every skb must have a dst_entry at this point.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a33f866d48a8ce0f83293a6ee1dbfd4a5345499f
tree de65c4992e63b67d2dd968c26000ea6ee36085a6
parent feaf79fd9c26309b0bffa69e7b4f835fc8f30179
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:04 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:28:04 +0200

 net/ipv4/netfilter/ipt_TCPMSS.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_TCPMSS.c b/net/ipv4/netfilter/ipt_TCPMSS.c
index bfc8d9c..b2d3c4f 100644
--- a/net/ipv4/netfilter/ipt_TCPMSS.c
+++ b/net/ipv4/netfilter/ipt_TCPMSS.c
@@ -73,13 +73,6 @@ ipt_tcpmss_target(struct sk_buff **pskb,
 	}
 
 	if (tcpmssinfo->mss == IPT_TCPMSS_CLAMP_PMTU) {
-		if (!(*pskb)->dst) {
-			if (net_ratelimit())
-				printk(KERN_ERR "ipt_tcpmss_target: "
-				       "no dst?! can't determine path-MTU\n");
-			return NF_DROP; /* or IPT_CONTINUE ?? */
-		}
-
 		if (dst_mtu((*pskb)->dst) <= sizeof(struct iphdr) +
 					     sizeof(struct tcphdr)) {
 			if (net_ratelimit())
