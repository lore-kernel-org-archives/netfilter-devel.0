From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,WIP 3/5] netfilter: nf_flow_offload: integration with conntrack
Date: Fri,  3 Nov 2017 16:26:34 +0100
Message-ID: <20171103152636.9967-4-pablo@netfilter.org>
References: <20171103152636.9967-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171103152636.9967-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds the IPS_OFFLOAD status bit, this new bit tells us that
the conntrack entry is owned by the flow offload infrastructure. The
timer of such conntrack entries is stopped - the conntrack garbage
collector skips them - and they display no internal state in the case of
TCP flows.

 # cat /proc/net/nf_conntrack
 ipv4     2 tcp      6 src=10.141.10.2 dst=147.75.205.195 sport=36392 dport=443 src=147.75.205.195 dst=192.168.2.195 sport=443 dport=36392 [OFFLOAD] mark=0 zone=0 use=2

Note the [OFFLOAD] tag in the listing.

Conntrack entries that have been offloaded to the flow table
infrastructure cannot be deleted/flushed via ctnetlink. The flow table
infrastructure is also responsible for releasing this conntrack entry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Instead of nf_flow_release_ct(), I'd rather keep a pointer reference to
the conntrack object from the flow_offload entry, so we can skip the
conntrack look up.

 include/net/netfilter/nf_conntrack.h               |  3 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |  4 +++
 net/netfilter/nf_conntrack_core.c                  |  7 ++++-
 net/netfilter/nf_conntrack_netlink.c               | 15 ++++++++-
 net/netfilter/nf_conntrack_proto_tcp.c             |  3 ++
 net/netfilter/nf_conntrack_standalone.c            | 12 +++++---
 net/netfilter/nf_flow_offload.c                    | 36 ++++++++++++++++++++--
 7 files changed, 71 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 8f3bd30511de..9af4bb0c2f46 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -272,7 +272,8 @@ static inline unsigned long nf_ct_expires(const struct nf_conn *ct)
 
 static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 {
-	return (__s32)(ct->timeout - nfct_time_stamp) <= 0;
+	return (__s32)(ct->timeout - nfct_time_stamp) <= 0 &&
+	       !test_bit(IPS_OFFLOAD_BIT, &ct->status);
 }
 
 /* use after obtaining a reference count */
diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index dc947e59d03a..6b463b88182d 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -100,6 +100,10 @@ enum ip_conntrack_status {
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
 
+	/* Conntrack has been offloaded to flow table. */
+	IPS_OFFLOAD_BIT = 14,
+	IPS_OFFLOAD = (1 << IPS_OFFLOAD_BIT),
+
 	/* Be careful here, modifying these bits can make things messy,
 	 * so don't let users modify them directly.
 	 */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 01130392b7c0..48f36c4fb756 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -901,6 +901,9 @@ static unsigned int early_drop_list(struct net *net,
 	hlist_nulls_for_each_entry_rcu(h, n, head, hnnode) {
 		tmp = nf_ct_tuplehash_to_ctrack(h);
 
+		if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
+			continue;
+
 		if (nf_ct_is_expired(tmp)) {
 			nf_ct_gc_expired(tmp);
 			continue;
@@ -1011,12 +1014,14 @@ static void gc_worker(struct work_struct *work)
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
 			scanned++;
+			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status))
+				continue;
+
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
 				expired_count++;
 				continue;
 			}
-
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index de4053d84364..79a74aec7c1e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1105,6 +1105,14 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 				    .len = NF_CT_LABELS_MAX_SIZE },
 };
 
+static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
+{
+	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
+		return 0;
+
+	return ctnetlink_filter_match(ct, data);
+}
+
 static int ctnetlink_flush_conntrack(struct net *net,
 				     const struct nlattr * const cda[],
 				     u32 portid, int report)
@@ -1117,7 +1125,7 @@ static int ctnetlink_flush_conntrack(struct net *net,
 			return PTR_ERR(filter);
 	}
 
-	nf_ct_iterate_cleanup_net(net, ctnetlink_filter_match, filter,
+	nf_ct_iterate_cleanup_net(net, ctnetlink_flush_iterate, filter,
 				  portid, report);
 	kfree(filter);
 
@@ -1163,6 +1171,11 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
+	if (test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
+		nf_ct_put(ct);
+		return -EBUSY;
+	}
+
 	if (cda[CTA_ID]) {
 		u_int32_t id = ntohl(nla_get_be32(cda[CTA_ID]));
 		if (id != (u32)(unsigned long)ct) {
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index cba1c6ffe51a..156f529d1668 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -305,6 +305,9 @@ static bool tcp_invert_tuple(struct nf_conntrack_tuple *tuple,
 /* Print out the private part of the conntrack. */
 static void tcp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 {
+	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
+		return;
+
 	seq_printf(s, "%s ", tcp_conntrack_names[ct->proto.tcp.state]);
 }
 #endif
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 5a101caa3e12..46d32baad095 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -309,10 +309,12 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	WARN_ON(!l4proto);
 
 	ret = -ENOSPC;
-	seq_printf(s, "%-8s %u %-8s %u %ld ",
+	seq_printf(s, "%-8s %u %-8s %u ",
 		   l3proto_name(l3proto->l3proto), nf_ct_l3num(ct),
-		   l4proto_name(l4proto->l4proto), nf_ct_protonum(ct),
-		   nf_ct_expires(ct)  / HZ);
+		   l4proto_name(l4proto->l4proto), nf_ct_protonum(ct));
+
+	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status))
+		seq_printf(s, "%ld ", nf_ct_expires(ct)  / HZ);
 
 	if (l4proto->print_conntrack)
 		l4proto->print_conntrack(s, ct);
@@ -339,7 +341,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		goto release;
 
-	if (test_bit(IPS_ASSURED_BIT, &ct->status))
+	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
+		seq_puts(s, "[OFFLOAD] ");
+	else if (test_bit(IPS_ASSURED_BIT, &ct->status))
 		seq_puts(s, "[ASSURED] ");
 
 	if (seq_has_overflowed(s))
diff --git a/net/netfilter/nf_flow_offload.c b/net/netfilter/nf_flow_offload.c
index c967b29d11a6..f4a3fbe11b69 100644
--- a/net/netfilter/nf_flow_offload.c
+++ b/net/netfilter/nf_flow_offload.c
@@ -13,6 +13,9 @@
 #include <linux/udp.h>
 #include <linux/icmpv6.h>
 
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
 static struct rhashtable flow_table;
 
 static u32 flow_offload_hash(const void *data, u32 len, u32 seed)
@@ -91,6 +94,34 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
 }
 
+static void nf_flow_release_ct(const struct flow_offload_tuple_rhash *th)
+{
+	struct nf_conntrack_tuple tuple = {};
+	struct nf_conntrack_tuple_hash *h;
+	struct nf_conntrack_zone zone;
+	struct nf_conn *ct;
+
+	nf_ct_zone_init(&zone, NF_CT_DEFAULT_ZONE_ID,
+			NF_CT_DEFAULT_ZONE_DIR, 0);
+
+	tuple.src.u3.ip		= th->tuple.src_v4.s_addr;
+	tuple.dst.u3.ip		= th->tuple.dst_v4.s_addr;
+	tuple.src.u.all		= th->tuple.src_port;
+	tuple.dst.u.all		= th->tuple.dst_port;
+	tuple.src.l3num		= th->tuple.l3proto;
+	tuple.dst.protonum	= th->tuple.l4proto;
+	tuple.dst.dir		= IP_CT_DIR_ORIGINAL;
+
+	h = nf_conntrack_find_get(&init_net, &zone, &tuple);
+	if (!h) {
+		pr_err("cannot find conntrack for flow hash %p\n", th);
+		return;
+	}
+	ct = nf_ct_tuplehash_to_ctrack(h);
+	nf_ct_delete(ct, 0, 0);
+	nf_ct_put(ct);
+}
+
 static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -116,9 +147,10 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
-		if (nf_flow_has_expired(flow))
+		if (nf_flow_has_expired(flow)) {
 			flow_offload_del(flow);
-
+			nf_flow_release_ct(tuplehash);
+		}
 		counter++;
 	}
 
-- 
2.11.0
