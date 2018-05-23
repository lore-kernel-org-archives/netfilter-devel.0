From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/18] netfilter: nfnetlink_queue: resolve clash for unconfirmed conntracks
Date: Wed, 23 May 2018 20:42:53 +0200
Message-ID: <20180523184254.22599-18-pablo@netfilter.org>
References: <20180523184254.22599-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

In nfqueue, two consecutive skbuffs may race to create the conntrack
entry. Hence, the one that loses the race gets dropped due to clash in
the insertion into the hashes from the nf_conntrack_confirm() path.

This patch adds a new nf_conntrack_update() function which searches for
possible clashes and resolve them. NAT mangling for the packet losing
race is corrected by using the conntrack information that won race.

In order to avoid direct module dependencies with conntrack and NAT, the
nf_ct_hook and nf_nat_hook structures are used for this purpose.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         |  5 +++
 net/netfilter/nf_conntrack_core.c | 77 +++++++++++++++++++++++++++++++++++++++
 net/netfilter/nf_nat_core.c       | 41 +++++++++++++--------
 net/netfilter/nfnetlink_queue.c   | 28 ++++++++++++--
 4 files changed, 132 insertions(+), 19 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index e8d09dc028f6..04551af2ff23 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -324,11 +324,15 @@ int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry);
 struct nf_conn;
 enum nf_nat_manip_type;
 struct nlattr;
+enum ip_conntrack_dir;
 
 struct nf_nat_hook {
 	int (*parse_nat_setup)(struct nf_conn *ct, enum nf_nat_manip_type manip,
 			       const struct nlattr *attr);
 	void (*decode_session)(struct sk_buff *skb, struct flowi *fl);
+	unsigned int (*manip_pkt)(struct sk_buff *skb, struct nf_conn *ct,
+				  enum nf_nat_manip_type mtype,
+				  enum ip_conntrack_dir dir);
 };
 
 extern struct nf_nat_hook __rcu *nf_nat_hook;
@@ -392,6 +396,7 @@ struct nf_conn;
 enum ip_conntrack_info;
 
 struct nf_ct_hook {
+	int (*update)(struct net *net, struct sk_buff *skb);
 	void (*destroy)(struct nf_conntrack *);
 };
 extern struct nf_ct_hook __rcu *nf_ct_hook;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8d109d750073..3465da2a98bd 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1607,6 +1607,82 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 	nf_conntrack_get(skb_nfct(nskb));
 }
 
+static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
+{
+	const struct nf_conntrack_l3proto *l3proto;
+	const struct nf_conntrack_l4proto *l4proto;
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_tuple tuple;
+	enum ip_conntrack_info ctinfo;
+	struct nf_nat_hook *nat_hook;
+	unsigned int dataoff, status;
+	struct nf_conn *ct;
+	u16 l3num;
+	u8 l4num;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (!ct || nf_ct_is_confirmed(ct))
+		return 0;
+
+	l3num = nf_ct_l3num(ct);
+	l3proto = nf_ct_l3proto_find_get(l3num);
+
+	if (l3proto->get_l4proto(skb, skb_network_offset(skb), &dataoff,
+				 &l4num) <= 0)
+		return -1;
+
+	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+
+	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
+			     l4num, net, &tuple, l3proto, l4proto))
+		return -1;
+
+	if (ct->status & IPS_SRC_NAT) {
+		memcpy(tuple.src.u3.all,
+		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.all,
+		       sizeof(tuple.src.u3.all));
+		tuple.src.u.all =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all;
+	}
+
+	if (ct->status & IPS_DST_NAT) {
+		memcpy(tuple.dst.u3.all,
+		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.all,
+		       sizeof(tuple.dst.u3.all));
+		tuple.dst.u.all =
+			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.all;
+	}
+
+	h = nf_conntrack_find_get(net, nf_ct_zone(ct), &tuple);
+	if (!h)
+		return 0;
+
+	/* Store status bits of the conntrack that is clashing to re-do NAT
+	 * mangling according to what it has been done already to this packet.
+	 */
+	status = ct->status;
+
+	nf_ct_put(ct);
+	ct = nf_ct_tuplehash_to_ctrack(h);
+	nf_ct_set(skb, ct, ctinfo);
+
+	nat_hook = rcu_dereference(nf_nat_hook);
+	if (!nat_hook)
+		return 0;
+
+	if (status & IPS_SRC_NAT &&
+	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_SRC,
+				IP_CT_DIR_ORIGINAL) == NF_DROP)
+		return -1;
+
+	if (status & IPS_DST_NAT &&
+	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_DST,
+				IP_CT_DIR_ORIGINAL) == NF_DROP)
+		return -1;
+
+	return 0;
+}
+
 /* Bring out ya dead! */
 static struct nf_conn *
 get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
@@ -2126,6 +2202,7 @@ int nf_conntrack_init_start(void)
 }
 
 static struct nf_ct_hook nf_conntrack_hook = {
+	.update		= nf_conntrack_update,
 	.destroy	= destroy_conntrack,
 };
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index f4d264676cfe..821f8d835f7a 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -493,17 +493,36 @@ nf_nat_alloc_null_binding(struct nf_conn *ct, unsigned int hooknum)
 }
 EXPORT_SYMBOL_GPL(nf_nat_alloc_null_binding);
 
+static unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
+				     enum nf_nat_manip_type mtype,
+				     enum ip_conntrack_dir dir)
+{
+	const struct nf_nat_l3proto *l3proto;
+	const struct nf_nat_l4proto *l4proto;
+	struct nf_conntrack_tuple target;
+
+	/* We are aiming to look like inverse of other direction. */
+	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+
+	l3proto = __nf_nat_l3proto_find(target.src.l3num);
+	l4proto = __nf_nat_l4proto_find(target.src.l3num,
+					target.dst.protonum);
+	if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
+		return NF_DROP;
+
+	return NF_ACCEPT;
+}
+
 /* Do packet manipulations according to nf_nat_setup_info. */
 unsigned int nf_nat_packet(struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo,
 			   unsigned int hooknum,
 			   struct sk_buff *skb)
 {
-	const struct nf_nat_l3proto *l3proto;
-	const struct nf_nat_l4proto *l4proto;
+	enum nf_nat_manip_type mtype = HOOK2MANIP(hooknum);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
+	unsigned int verdict = NF_ACCEPT;
 	unsigned long statusbit;
-	enum nf_nat_manip_type mtype = HOOK2MANIP(hooknum);
 
 	if (mtype == NF_NAT_MANIP_SRC)
 		statusbit = IPS_SRC_NAT;
@@ -515,19 +534,10 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
 		statusbit ^= IPS_NAT_MASK;
 
 	/* Non-atomic: these bits don't change. */
-	if (ct->status & statusbit) {
-		struct nf_conntrack_tuple target;
-
-		/* We are aiming to look like inverse of other direction. */
-		nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
+	if (ct->status & statusbit)
+		verdict = nf_nat_manip_pkt(skb, ct, mtype, dir);
 
-		l3proto = __nf_nat_l3proto_find(target.src.l3num);
-		l4proto = __nf_nat_l4proto_find(target.src.l3num,
-						target.dst.protonum);
-		if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
-			return NF_DROP;
-	}
-	return NF_ACCEPT;
+	return verdict;
 }
 EXPORT_SYMBOL_GPL(nf_nat_packet);
 
@@ -1031,6 +1041,7 @@ struct nf_nat_hook nat_hook = {
 #ifdef CONFIG_XFRM
 	.decode_session		= __nf_nat_decode_session,
 #endif
+	.manip_pkt		= nf_nat_manip_pkt,
 };
 
 static int __init nf_nat_init(void)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 74a04638ef03..2c173042ac0e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -227,6 +227,25 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 	return entry;
 }
 
+static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+{
+	struct nf_ct_hook *ct_hook;
+	int err;
+
+	if (verdict == NF_ACCEPT ||
+	    verdict == NF_STOP) {
+		rcu_read_lock();
+		ct_hook = rcu_dereference(nf_ct_hook);
+		if (ct_hook) {
+			err = ct_hook->update(entry->state.net, entry->skb);
+			if (err < 0)
+				verdict = NF_DROP;
+		}
+		rcu_read_unlock();
+	}
+	nf_reinject(entry, verdict);
+}
+
 static void
 nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 {
@@ -237,7 +256,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 		if (!cmpfn || cmpfn(entry, data)) {
 			list_del(&entry->list);
 			queue->queue_total--;
-			nf_reinject(entry, NF_DROP);
+			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
 	spin_unlock_bh(&queue->lock);
@@ -686,7 +705,7 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 err_out_unlock:
 	spin_unlock_bh(&queue->lock);
 	if (failopen)
-		nf_reinject(entry, NF_ACCEPT);
+		nfqnl_reinject(entry, NF_ACCEPT);
 err_out:
 	return err;
 }
@@ -1085,7 +1104,8 @@ static int nfqnl_recv_verdict_batch(struct net *net, struct sock *ctnl,
 	list_for_each_entry_safe(entry, tmp, &batch_list, list) {
 		if (nfqa[NFQA_MARK])
 			entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
-		nf_reinject(entry, verdict);
+
+		nfqnl_reinject(entry, verdict);
 	}
 	return 0;
 }
@@ -1208,7 +1228,7 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
 	if (nfqa[NFQA_MARK])
 		entry->skb->mark = ntohl(nla_get_be32(nfqa[NFQA_MARK]));
 
-	nf_reinject(entry, verdict);
+	nfqnl_reinject(entry, verdict);
 	return 0;
 }
 
-- 
2.11.0
