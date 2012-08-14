From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] bridge: fix rcu dereference outside of rcu_read_lock
Date: Tue, 14 Aug 2012 08:19:33 -0700
Message-ID: <20120814081933.30f3e868@nehalam.linuxnetplumber.net>
References: <1344898062-23633-1-git-send-email-yefremov.denis@gmail.com>
	<1344931732-1858-1-git-send-email-yefremov.denis@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>, pablo@netfilter.org,
	kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, ldv-project@ispras.ru
To: Denis Efremov <yefremov.denis@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1344931732-1858-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alternative solution for problem found by Linux Driver Verification
project (linuxtesting.org).

As it noted in the comment before the br_handle_frame_finish
function, this function should be called under rcu_read_lock.

The problem callgraph:
br_dev_xmit -> br_nf_pre_routing_finish_bridge_slow ->
 -> br_handle_frame_finish -> br_port_get_rcu -> rcu_dereference

And in this case there is no read-lock section.

Reported-by: Denis Efremov <yefremov.denis@gmail.com>
Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
---
 net/bridge/br_device.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 3334845..8a3b50f 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -31,9 +31,11 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct net_bridge_mdb_entry *mdst;
 	struct br_cpu_netstats *brstats = this_cpu_ptr(br->stats);
 
+	rcu_read_lock();
 #ifdef CONFIG_BRIDGE_NETFILTER
 	if (skb->nf_bridge && (skb->nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
 		br_nf_pre_routing_finish_bridge_slow(skb);
+		rcu_read_unlock();
 		return NETDEV_TX_OK;
 	}
 #endif
@@ -48,7 +50,6 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	skb_reset_mac_header(skb);
 	skb_pull(skb, ETH_HLEN);
 
-	rcu_read_lock();
 	if (is_broadcast_ether_addr(dest))
 		br_flood_deliver(br, skb);
 	else if (is_multicast_ether_addr(dest)) {
-- 
1.7.10.4
