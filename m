From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new conntrack entries
Date: Wed, 25 Nov 2015 17:13:01 -0200
Message-ID: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbbKYTN2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 14:13:28 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit d7ee35190427 ("netfilter: nf_ct_sctp: minimal multihoming
support") allowed creating conntrack entries based on the heartbeat
exchange, so that we can track secondary paths too.

This patch adds a vtag verification to that. That is, in order to allow
a HEARTBEAT or a HEARTBEAT_ACK through, the tuple (src port, dst port,
vtag) must be already known.

As it's possible that peer A initiated the connection but peer B ends up
being the first one to send a heartbeat, there is a cross-direction
check for matching the registered conntrack directions with the
heartbeat one.

Note that this vtag verification is only possible on peers or routers
that will see all paths in use by a given association. When used, it
will only allow secondary paths if the primary one is already there.
That is, it's usually only useable at the peers themselves, and thus it
defaults to off, controlled via sysctl
net.netfilter.nf_conntrack_sctp_validate_vtag.

As we can't really track associations but just their paths, it's
possible to have multiple hits of the 3-tuple to actually reflect
multiple associations, just as it's also possible to have different
vtags for a given pair of ports.

When a heartbeat comes by, it will allow it if the vtag is one of the
two (or n) in use, no matter which association it really belongs to.
Yet, if there is a lingering conntrack entry from a previous association
built from heartbeats for that 5-tuple (saddr, daddr, sport, dport,
sctp), like from a fast port reuse, it will reject packets with the new
vtag. This is actually a result of the normal conntrack entry
verification and is not a result of this patch or d7ee35190427.

SCTP has this particularity that peer addresses are negotiated during
initial handshake _and_ also via ASCONF chunks (RFC 5061). ASCONF chunks
must be authenticated, for security reasons, and as conntrack actually
sits in the middle even when used at the peers, it cannot validate the
authentication and thus it cannot trust ASCONF chunks, so we cannot
track IP addresses and thus we can't rebuild the association itself.

It is necessary that the path that initiated the association to continue
up as it's the only one that gets hashed and we cannot promote secondary
paths, due to the above. Once the primary path is down, secondary paths
using those vtags that expires won't be able to re-activate.

Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 Documentation/networking/nf_conntrack-sysctl.txt |   9 +
 include/linux/netfilter/nf_conntrack_sctp.h      |  17 ++
 net/netfilter/nf_conntrack_proto_sctp.c          | 251 ++++++++++++++++++++++-
 3 files changed, 276 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index f55599c62c9d61335005202146fdad75c8c133b9..9113fa12fee9548a99e5ea6b5241a4e882ffbfd0 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.txt
@@ -175,3 +175,12 @@ nf_conntrack_udp_timeout_stream2 - INTEGER (seconds)
 
 	This extended timeout will be used in case there is an UDP stream
 	detected.
+
+nf_conntrack_sctp_validate_vtag - BOOLEAN
+	0 - disabled (default)
+	not 0 - enabled
+
+	Enable VTAG validation for conntrack entries created from
+	HEARTBEATs. That is, in order to allow such new entry, that vtag
+	must already be known for that port pair, no matter which
+	addresses are used. Most useful in end peers.
diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
index 22a16a23cd8a7e3d6d000ee7249477a3fef11604..8d20f79f5a2f4d0e93e2185f803100c45bc8662a 100644
--- a/include/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -3,11 +3,28 @@
 /* SCTP tracking. */
 
 #include <uapi/linux/netfilter/nf_conntrack_sctp.h>
+#include <linux/rhashtable.h>
+
+struct nf_conn;
+struct sctp_vtaghash_node {
+	struct rhash_head node;
+	__be16 sport;
+	__be16 dport;
+	__be32 vtag;
+	struct net *net;
+	int dir;
+	atomic_t count;
+	struct rcu_head rcu_head;
+};
 
 struct ip_ct_sctp {
 	enum sctp_conntrack state;
 
 	__be32 vtag[IP_CT_DIR_MAX];
+
+	struct sctp_vtaghash_node *vtagnode[IP_CT_DIR_MAX];
+	bool crossed;
+	bool from_heartbeat;
 };
 
 #endif /* _NF_CONNTRACK_SCTP_H */
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 9578a7c371ef2ce04f0a7b10c694b2533e29bd3a..f20be8f0bd5f9bd4ecfcfcdae1d400e89d79a54e 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -23,6 +23,7 @@
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <net/netns/hash.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
@@ -144,10 +145,24 @@ static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	}
 };
 
+/* vtag hash cmp arg, used for validating secondary paths */
+struct sctp_vtaghash_cmp_arg {
+	__be32 vtag;
+	__be16 sport;
+	__be16 dport;
+	struct net *net;
+	int dir;
+};
+
+static struct rhashtable vtaghash;
+
 static int sctp_net_id	__read_mostly;
 struct sctp_net {
 	struct nf_proto_net pn;
 	unsigned int timeouts[SCTP_CONNTRACK_MAX];
+	bool validate_vtag;
+	char *vtag_slabname;
+	struct kmem_cache *vtag_cachep;
 };
 
 static inline struct sctp_net *sctp_pernet(struct net *net)
@@ -200,6 +215,156 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 	seq_printf(s, "%s ", sctp_conntrack_names[state]);
 }
 
+/* vtag hash functions */
+static inline int sctp_vtag_hash_cmp(struct rhashtable_compare_arg *_arg,
+				     const void *ptr)
+{
+	const struct sctp_vtaghash_cmp_arg *arg = _arg->key;
+	const struct sctp_vtaghash_node *node = ptr;
+
+	if (arg->dir == node->dir)
+		return node->vtag != arg->vtag ||
+		       !net_eq(node->net, arg->net) ||
+		       node->sport != arg->sport ||
+		       node->dport != arg->dport;
+
+	return node->vtag != arg->vtag ||
+	       !net_eq(node->net, arg->net) ||
+	       node->sport != arg->dport ||
+	       node->dport != arg->sport;
+}
+
+static inline u32 sctp_vtag_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct sctp_vtaghash_cmp_arg *arg = data;
+
+	return jhash_3words(arg->vtag, arg->sport, arg->dport,
+			    seed + net_hash_mix(arg->net));
+}
+
+static inline u32 sctp_vtag_hash_obj(const void *data, u32 len, u32 seed)
+{
+	const struct sctp_vtaghash_node *node = data;
+
+	return jhash_3words(node->vtag, node->sport, node->dport,
+			    seed + net_hash_mix(node->net));
+}
+
+static const struct rhashtable_params sctp_vtaghash_params = {
+	.head_offset = offsetof(struct sctp_vtaghash_node, node),
+	.hashfn = sctp_vtag_hashfn,
+	.obj_hashfn = sctp_vtag_hash_obj,
+	.obj_cmpfn = sctp_vtag_hash_cmp,
+	.automatic_shrinking = true,
+};
+
+static inline void sctp_vtag_arg_init(struct sctp_vtaghash_cmp_arg *arg,
+				      struct nf_conn *ct, int dir)
+{
+	arg->vtag = ct->proto.sctp.vtag[dir];
+	arg->net = nf_ct_net(ct);
+	arg->sport = nf_ct_tuple(ct, dir)->src.u.sctp.port;
+	arg->dport = nf_ct_tuple(ct, dir)->dst.u.sctp.port;
+	arg->dir = ct->proto.sctp.crossed ? !dir : dir;
+}
+
+static inline void sctp_vtag_unhash(struct nf_conn *ct, int dir)
+{
+	struct sctp_vtaghash_node *node = ct->proto.sctp.vtagnode[dir];
+
+	if (!node)
+		return;
+
+	if (atomic_dec_and_test(&node->count)) {
+		rhashtable_remove_fast(&vtaghash,
+				       &node->node,
+				       sctp_vtaghash_params);
+		kfree_rcu(node, rcu_head);
+	}
+
+	ct->proto.sctp.vtagnode[dir] = NULL;
+}
+
+static inline int sctp_vtag_hash(struct nf_conn *ct, int dir)
+{
+	struct sctp_net *sn = sctp_pernet(nf_ct_net(ct));
+	struct sctp_vtaghash_cmp_arg arg;
+	struct sctp_vtaghash_node *node;
+	int ret;
+
+	if (ct->proto.sctp.vtagnode[dir])
+		sctp_vtag_unhash(ct, dir);
+
+again:
+	sctp_vtag_arg_init(&arg, ct, dir);
+	rcu_read_lock();
+	node = rhashtable_lookup_fast(&vtaghash, &arg, sctp_vtaghash_params);
+	if (node && atomic_add_unless(&node->count, 1, 0)) {
+		ct->proto.sctp.vtagnode[dir] = node;
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
+
+	node = kmem_cache_alloc(sn->vtag_cachep, GFP_ATOMIC);
+	if (!node)
+		return -ENOMEM;
+
+	node->vtag = arg.vtag;
+	node->sport = arg.sport;
+	node->dport = arg.dport;
+	node->net = arg.net;
+	node->dir = dir;
+	atomic_set(&node->count, 1);
+
+	ret = rhashtable_lookup_insert_key(&vtaghash, &arg, &node->node,
+					   sctp_vtaghash_params);
+	if (ret == 0) {
+		ct->proto.sctp.vtagnode[dir] = node;
+	} else {
+		kfree(node);
+		if (ret == -EEXIST)
+			goto again;
+	}
+
+	return ret;
+}
+
+/* This function checks if there is a known vtag being used with the
+ * given pair of src/dst ports. If yes, it returns true.
+ * Note that it doesn't, as it can't, validate any IP addresses.
+ */
+static inline bool sctp_vtag_is_hashed(struct nf_conn *ct, int dir)
+{
+	struct sctp_vtaghash_cmp_arg arg;
+
+	sctp_vtag_arg_init(&arg, ct, dir);
+
+	return rhashtable_lookup_fast(&vtaghash, &arg,
+				      sctp_vtaghash_params) != NULL;
+}
+
+/* This function checks if there is a known vtag being used with the
+ * given pair of src/dst ports.
+ * Note that it doesn't, as it can't, validate any IP addresses.
+ * Returns the direction on which the tag is hash, or -1 if none
+ */
+static inline int sctp_vtag_hash_probe(struct nf_conn *ct)
+{
+	struct sctp_vtaghash_cmp_arg arg;
+
+	sctp_vtag_arg_init(&arg, ct, IP_CT_DIR_ORIGINAL);
+
+	if (rhashtable_lookup_fast(&vtaghash, &arg, sctp_vtaghash_params))
+		return arg.dir;
+
+	arg.dir = !arg.dir;
+	if (rhashtable_lookup_fast(&vtaghash, &arg, sctp_vtaghash_params))
+		return arg.dir;
+
+	return -1;
+}
+
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(sctp_sctphdr_t), (count) = 0;	\
 	(offset) < (skb)->len &&					\
@@ -328,6 +493,7 @@ static int sctp_packet(struct nf_conn *ct,
 		       unsigned int hooknum,
 		       unsigned int *timeouts)
 {
+	struct sctp_net *sn = sctp_pernet(nf_ct_net(ct));
 	enum sctp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 	const struct sctphdr *sh;
@@ -390,6 +556,12 @@ static int sctp_packet(struct nf_conn *ct,
 				pr_debug("Verification tag check failed\n");
 				goto out_unlock;
 			}
+			if (sn->validate_vtag &&
+			    ct->proto.sctp.from_heartbeat &&
+			    !sctp_vtag_is_hashed(ct, dir)) {
+				pr_debug("heartbeat with unknown verification tag\n");
+				goto out_unlock;
+			}
 		}
 
 		old_state = ct->proto.sctp.state;
@@ -415,6 +587,10 @@ static int sctp_packet(struct nf_conn *ct,
 			pr_debug("Setting vtag %x for dir %d\n",
 				 ih->init_tag, !dir);
 			ct->proto.sctp.vtag[!dir] = ih->init_tag;
+			ct->proto.sctp.from_heartbeat = false;
+			ct->proto.sctp.crossed = false;
+			if (sn->validate_vtag && sctp_vtag_hash(ct, !dir))
+				goto out_unlock;
 		}
 
 		ct->proto.sctp.state = new_state;
@@ -445,6 +621,7 @@ out:
 static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		     unsigned int dataoff, unsigned int *timeouts)
 {
+	struct sctp_net *sn = sctp_pernet(nf_ct_net(ct));
 	enum sctp_conntrack new_state;
 	const struct sctphdr *sh;
 	struct sctphdr _sctph;
@@ -503,6 +680,19 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 			pr_debug("Setting vtag %x for secondary conntrack\n",
 				 sh->vtag);
 			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
+
+			if (sn->validate_vtag) {
+				int hashdir;
+
+				hashdir = sctp_vtag_hash_probe(ct);
+				if (hashdir == -1) {
+					pr_debug("but vtag is not in use\n");
+					return false;
+				}
+				ct->proto.sctp.crossed =
+						hashdir != IP_CT_DIR_ORIGINAL;
+				ct->proto.sctp.from_heartbeat = true;
+			}
 		}
 		/* If it is a shutdown ack OOTB packet, we expect a return
 		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
@@ -518,6 +708,15 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static void sctp_destroy(struct nf_conn *ct)
+{
+	/* Don't check for validate_vtag because it may have been
+	 * disabled while we already had an entry hashed.
+	 */
+	sctp_vtag_unhash(ct, IP_CT_DIR_ORIGINAL);
+	sctp_vtag_unhash(ct, IP_CT_DIR_REPLY);
+}
+
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -559,6 +758,7 @@ static const struct nla_policy sctp_nla_policy[CTA_PROTOINFO_SCTP_MAX+1] = {
 
 static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 {
+	struct sctp_net *sn = sctp_pernet(nf_ct_net(ct));
 	struct nlattr *attr = cda[CTA_PROTOINFO_SCTP];
 	struct nlattr *tb[CTA_PROTOINFO_SCTP_MAX+1];
 	int err;
@@ -585,9 +785,16 @@ static int nlattr_to_sctp(struct nlattr *cda[], struct nf_conn *ct)
 		nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_ORIGINAL]);
 	ct->proto.sctp.vtag[IP_CT_DIR_REPLY] =
 		nla_get_be32(tb[CTA_PROTOINFO_SCTP_VTAG_REPLY]);
+	ct->proto.sctp.crossed = false;
+	ct->proto.sctp.from_heartbeat = false;
+	if (sn->validate_vtag) {
+		err = sctp_vtag_hash(ct, IP_CT_DIR_ORIGINAL);
+		if (!err)
+			err = sctp_vtag_hash(ct, IP_CT_DIR_REPLY);
+	}
 	spin_unlock_bh(&ct->lock);
 
-	return 0;
+	return err;
 }
 
 static int sctp_nlattr_size(void)
@@ -709,6 +916,12 @@ static struct ctl_table sctp_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
+	{
+		.procname	= "nf_conntrack_sctp_validate_vtag",
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
 	{ }
 };
 
@@ -783,6 +996,7 @@ static int sctp_kmemdup_sysctl_table(struct nf_proto_net *pn,
 	pn->ctl_table[6].data = &sn->timeouts[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT];
 	pn->ctl_table[7].data = &sn->timeouts[SCTP_CONNTRACK_HEARTBEAT_SENT];
 	pn->ctl_table[8].data = &sn->timeouts[SCTP_CONNTRACK_HEARTBEAT_ACKED];
+	pn->ctl_table[9].data = &sn->validate_vtag;
 #endif
 	return 0;
 }
@@ -848,6 +1062,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 	.packet 		= sctp_packet,
 	.get_timeouts		= sctp_get_timeouts,
 	.new 			= sctp_new,
+	.destroy		= sctp_destroy,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= sctp_to_nlattr,
@@ -882,6 +1097,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.packet 		= sctp_packet,
 	.get_timeouts		= sctp_get_timeouts,
 	.new 			= sctp_new,
+	.destroy		= sctp_destroy,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= sctp_to_nlattr,
@@ -907,6 +1123,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 
 static int sctp_net_init(struct net *net)
 {
+	struct sctp_net *sn = sctp_pernet(net);
 	int ret = 0;
 
 	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_sctp4);
@@ -914,13 +1131,34 @@ static int sctp_net_init(struct net *net)
 		pr_err("nf_conntrack_sctp4: pernet registration failed.\n");
 		goto out;
 	}
+
 	ret = nf_ct_l4proto_pernet_register(net, &nf_conntrack_l4proto_sctp6);
 	if (ret < 0) {
 		pr_err("nf_conntrack_sctp6: pernet registration failed.\n");
 		goto cleanup_sctp4;
 	}
+
+	sn->vtag_slabname = kasprintf(GFP_KERNEL, "nf_conntrack_%p_sctp_vtag",
+				      net);
+	if (!sn->vtag_slabname) {
+		ret = -ENOMEM;
+		goto cleanup_sctp6;
+	}
+
+	sn->vtag_cachep = kmem_cache_create(sn->vtag_slabname,
+					    sizeof(struct sctp_vtaghash_node),
+					    0, 0, NULL);
+	if (!sn->vtag_cachep) {
+		ret = -ENOMEM;
+		goto slab_err;
+	}
+
 	return 0;
 
+slab_err:
+	kfree(sn->vtag_slabname);
+cleanup_sctp6:
+	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp6);
 cleanup_sctp4:
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp4);
 out:
@@ -929,8 +1167,12 @@ out:
 
 static void sctp_net_exit(struct net *net)
 {
+	struct sctp_net *sn = sctp_pernet(net);
+
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp6);
 	nf_ct_l4proto_pernet_unregister(net, &nf_conntrack_l4proto_sctp4);
+	kfree(sn->vtag_slabname);
+	kmem_cache_destroy(sn->vtag_cachep);
 }
 
 static struct pernet_operations sctp_net_ops = {
@@ -944,6 +1186,10 @@ static int __init nf_conntrack_proto_sctp_init(void)
 {
 	int ret;
 
+	ret = rhashtable_init(&vtaghash, &sctp_vtaghash_params);
+	if (ret < 0)
+		goto out_hash;
+
 	ret = register_pernet_subsys(&sctp_net_ops);
 	if (ret < 0)
 		goto out_pernet;
@@ -962,6 +1208,8 @@ out_sctp6:
 out_sctp4:
 	unregister_pernet_subsys(&sctp_net_ops);
 out_pernet:
+	rhashtable_destroy(&vtaghash);
+out_hash:
 	return ret;
 }
 
@@ -970,6 +1218,7 @@ static void __exit nf_conntrack_proto_sctp_fini(void)
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_sctp6);
 	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_sctp4);
 	unregister_pernet_subsys(&sctp_net_ops);
+	rhashtable_destroy(&vtaghash);
 }
 
 module_init(nf_conntrack_proto_sctp_init);
-- 
2.5.0

