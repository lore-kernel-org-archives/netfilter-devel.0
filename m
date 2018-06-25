From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] openvswitch: use nf_ct_get_tuplepr, invert_tuplepr
Date: Mon, 25 Jun 2018 17:55:32 +0200
Message-ID: <20180625155532.20577-1-fw@strlen.de>
Cc: <netdev@vger.kernel.org>, pshelar@ovn.org, dev@openvswitch.org,
        Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These versions deal with the l3proto/l4proto details internally.
It removes only caller of nf_ct_get_tuple, so make it static.

After this, l3proto->get_l4proto() can be removed in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since v1.

 This is a preparation patch to remove the l3proto indirections.
 Evanutally nf_conntrack_l3proto will be removed.

 ipv4 and ipv6 protocol trackers will be part of nf_conntrack itself.

 include/net/netfilter/nf_conntrack_core.h |  7 -------
 net/netfilter/nf_conntrack_core.c         |  3 +--
 net/openvswitch/conntrack.c               | 17 +++--------------
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 9b5e7634713e..90df45022c51 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -40,13 +40,6 @@ void nf_conntrack_cleanup_start(void);
 void nf_conntrack_init_end(void);
 void nf_conntrack_cleanup_end(void);
 
-bool nf_ct_get_tuple(const struct sk_buff *skb, unsigned int nhoff,
-		     unsigned int dataoff, u_int16_t l3num, u_int8_t protonum,
-		     struct net *net,
-		     struct nf_conntrack_tuple *tuple,
-		     const struct nf_conntrack_l3proto *l3proto,
-		     const struct nf_conntrack_l4proto *l4proto);
-
 bool nf_ct_invert_tuple(struct nf_conntrack_tuple *inverse,
 			const struct nf_conntrack_tuple *orig,
 			const struct nf_conntrack_l3proto *l3proto,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3465da2a98bd..160493f95fed 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -222,7 +222,7 @@ static u32 hash_conntrack(const struct net *net,
 	return scale_hash(hash_conntrack_raw(tuple, net));
 }
 
-bool
+static bool
 nf_ct_get_tuple(const struct sk_buff *skb,
 		unsigned int nhoff,
 		unsigned int dataoff,
@@ -244,7 +244,6 @@ nf_ct_get_tuple(const struct sk_buff *skb,
 
 	return l4proto->pkt_to_tuple(skb, dataoff, net, tuple);
 }
-EXPORT_SYMBOL_GPL(nf_ct_get_tuple);
 
 bool nf_ct_get_tuplepr(const struct sk_buff *skb, unsigned int nhoff,
 		       u_int16_t l3num,
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 284aca2a252d..e05bd3e53f0f 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -607,23 +607,12 @@ static struct nf_conn *
 ovs_ct_find_existing(struct net *net, const struct nf_conntrack_zone *zone,
 		     u8 l3num, struct sk_buff *skb, bool natted)
 {
-	const struct nf_conntrack_l3proto *l3proto;
-	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
-	unsigned int dataoff;
-	u8 protonum;
 
-	l3proto = __nf_ct_l3proto_find(l3num);
-	if (l3proto->get_l4proto(skb, skb_network_offset(skb), &dataoff,
-				 &protonum) <= 0) {
-		pr_debug("ovs_ct_find_existing: Can't get protonum\n");
-		return NULL;
-	}
-	l4proto = __nf_ct_l4proto_find(l3num, protonum);
-	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
-			     protonum, net, &tuple, l3proto, l4proto)) {
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb), l3num,
+			       net, &tuple)) {
 		pr_debug("ovs_ct_find_existing: Can't get tuple\n");
 		return NULL;
 	}
@@ -632,7 +621,7 @@ ovs_ct_find_existing(struct net *net, const struct nf_conntrack_zone *zone,
 	if (natted) {
 		struct nf_conntrack_tuple inverse;
 
-		if (!nf_ct_invert_tuple(&inverse, &tuple, l3proto, l4proto)) {
+		if (!nf_ct_invert_tuplepr(&inverse, &tuple)) {
 			pr_debug("ovs_ct_find_existing: Inversion failed!\n");
 			return NULL;
 		}
-- 
2.16.4
