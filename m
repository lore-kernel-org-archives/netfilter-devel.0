From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6] netfilter: bridge: Don't sabotage nf_hook calls from an l3mdev
Date: Tue,  2 Oct 2018 00:37:40 +0200
Message-ID: <20181001223745.29010-2-pablo@netfilter.org>
References: <20181001223745.29010-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181001223745.29010-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

For starters, the bridge netfilter code registers operations that
are invoked any time nh_hook is called. Specifically, ip_sabotage_in
watches for nested calls for NF_INET_PRE_ROUTING when a bridge is in
the stack.

Packet wise, the bridge netfilter hook runs first. br_nf_pre_routing
allocates nf_bridge, sets in_prerouting to 1 and calls NF_HOOK for
NF_INET_PRE_ROUTING. It's finish function, br_nf_pre_routing_finish,
then resets in_prerouting flag to 0 and the packet continues up the
stack. The packet eventually makes it to the VRF driver and it invokes
nf_hook for NF_INET_PRE_ROUTING in case any rules have been added against
the vrf device.

Because of the registered operations the call to nf_hook causes
ip_sabotage_in to be invoked. That function sees the nf_bridge on the
skb and that in_prerouting is not set. Thinking it is an invalid nested
call it steals (drops) the packet.

Update ip_sabotage_in to recognize that the bridge or one of its upper
devices (e.g., vlan) can be enslaved to a VRF (L3 master device) and
allow the packet to go through the nf_hook a second time.

Fixes: 73e20b761acf ("net: vrf: Add support for PREROUTING rules on vrf device")
Reported-by: D'Souza, Nelson <ndsouza@ciena.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 6e0dc6bcd32a..37278dc280eb 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -835,7 +835,8 @@ static unsigned int ip_sabotage_in(void *priv,
 				   struct sk_buff *skb,
 				   const struct nf_hook_state *state)
 {
-	if (skb->nf_bridge && !skb->nf_bridge->in_prerouting) {
+	if (skb->nf_bridge && !skb->nf_bridge->in_prerouting &&
+	    !netif_is_l3_master(skb->dev)) {
 		state->okfn(state->net, state->sk, skb);
 		return NF_STOLEN;
 	}
-- 
2.11.0
