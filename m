From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/18] openvswitch: Handle NF_REPEAT in conntrack action.
Date: Tue, 15 Mar 2016 02:27:59 +0100
Message-ID: <1458005282-24665-16-git-send-email-pablo@netfilter.org>
References: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1458005282-24665-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jarno Rajahalme <jarno@ovn.org>

Repeat the nf_conntrack_in() call when it returns NF_REPEAT.  This
avoids dropping a SYN packet re-opening an existing TCP connection.

Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
Acked-by: Joe Stringer <joe@ovn.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/openvswitch/conntrack.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index ae36fe2..85256b3 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -485,6 +485,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 	 */
 	if (!skb_nfct_cached(net, key, info, skb)) {
 		struct nf_conn *tmpl = info->ct;
+		int err;
 
 		/* Associate skb with specified zone. */
 		if (tmpl) {
@@ -495,8 +496,13 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 			skb->nfctinfo = IP_CT_NEW;
 		}
 
-		if (nf_conntrack_in(net, info->family, NF_INET_PRE_ROUTING,
-				    skb) != NF_ACCEPT)
+		/* Repeat if requested, see nf_iterate(). */
+		do {
+			err = nf_conntrack_in(net, info->family,
+					      NF_INET_PRE_ROUTING, skb);
+		} while (err == NF_REPEAT);
+
+		if (err != NF_ACCEPT)
 			return -ENOENT;
 
 		ovs_ct_update_key(skb, info, key, true);
-- 
2.1.4
