From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH v2] bridge: Superfluous skb->nfct check in
	br_nf_dev_queue_xmit
Date: Mon, 28 Apr 2014 17:31:45 +0400
Message-ID: <535E5841.2030802@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>
To: Florian Westphal <fw@strlen.de>, bridge@lists.linux-foundation.org,
	netfilter-devel@vger.kernel.org
Return-path: <bridge-bounces@lists.linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

Currently bridge silently drops defragmented ipv4 packets if nf_conntrack module
is not loaded on the node. However ipv4 fragmentation and defragmentation
does not require enabled connection tracking.

Removing superfluous skb->nfct check allows to re-fragment previously
defragmented packets and give them chance to reach destination side.

v2: removed #if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4) added because
of using of nfct check

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 80e1b0f..d50c154 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -859,12 +859,11 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 	return NF_STOLEN;
 }
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK_IPV4)
 static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 {
 	int ret;
 
-	if (skb->nfct != NULL && skb->protocol == htons(ETH_P_IP) &&
+	if (skb->protocol == htons(ETH_P_IP) &&
 	    skb->len + nf_bridge_mtu_reduction(skb) > skb->dev->mtu &&
 	    !skb_is_gso(skb)) {
 		if (br_parse_ip_options(skb))
@@ -876,12 +875,6 @@ static int br_nf_dev_queue_xmit(struct sk_buff *skb)
 
 	return ret;
 }
-#else
-static int br_nf_dev_queue_xmit(struct sk_buff *skb)
-{
-        return br_dev_queue_push_xmit(skb);
-}
-#endif
 
 /* PF_BRIDGE/POST_ROUTING ********************************************/
 static unsigned int br_nf_post_routing(const struct nf_hook_ops *ops,
-- 
1.7.5.4
