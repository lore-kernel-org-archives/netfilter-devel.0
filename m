From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/18] openvswitch: Update the CT state key only after nf_conntrack_in().
Date: Tue, 15 Mar 2016 02:27:57 +0100
Message-ID: <1458005282-24665-14-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jarno Rajahalme <jarno@ovn.org>

Only a successful nf_conntrack_in() call can effect a connection state
change, so it suffices to update the key only after the
nf_conntrack_in() returns.

This change is needed for the later NAT patches.

Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
Acked-by: Joe Stringer <joe@ovn.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/openvswitch/conntrack.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 2c2bf07..a487bb3 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -382,7 +382,8 @@ static bool skb_nfct_cached(const struct net *net, const struct sk_buff *skb,
 }
 
 /* Pass 'skb' through conntrack in 'net', using zone configured in 'info', if
- * not done already.  Update key with new CT state.
+ * not done already.  Update key with new CT state after passing the packet
+ * through conntrack.
  * Note that if the packet is deemed invalid by conntrack, skb->nfct will be
  * set to NULL and 0 will be returned.
  */
@@ -411,14 +412,14 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 				    skb) != NF_ACCEPT)
 			return -ENOENT;
 
+		ovs_ct_update_key(skb, info, key, true);
+
 		if (ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
 			WARN_ONCE(1, "helper rejected packet");
 			return -EINVAL;
 		}
 	}
 
-	ovs_ct_update_key(skb, info, key, true);
-
 	return 0;
 }
 
-- 
2.1.4
