From: Ana Rey Botello <ana@soleta.eu>
Subject: [v4 nf 1/1] netfilter: add named counters support
Date: Wed,  4 Feb 2015 19:55:09 +0100
Message-ID: <7e75ecf5afbb6c7545db8c440e3c8ef4478df5f7.1423075525.git.ana@soleta.eu>
References: <cover.1423075525.git.ana@soleta.eu>
Cc: Ana Rey Botello <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:48223 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161299AbbBDSyb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Feb 2015 13:54:31 -0500
In-Reply-To: <cover.1423075525.git.ana@soleta.eu>
In-Reply-To: <cover.1423075525.git.ana@soleta.eu>
References: <cover.1423075525.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the named counter object. It is similar to nfacct in
iptables.

Some examples of use in nft of this new feature:

* Add a new counter:
nft add counter ip filter http-traffic
nft add counter ip filter https-traffic

* Add a new counter with a specific values:
nft add counter ip filter https-traffic { packets 100 bytes 2000}

* Delete the counter (No rule uses this counter)
nft delete counter ip filter https-traffic

* Set the counter to a rule.
nft add rule ip filter output tcp dport 80 counter name http-traffic
nft add rule ip filter output tcp dport 443 counter name https-traffic

* Reset the number of bytes and packets of the counter.
nft reset counter ip filter http-traffic

* Reset the number of bytes and packets of all counter.
nft reset counters

* List all counter:
nft list counters

* List information about the counter.
nft list counter ip test https-traffic

Example of the table with some counter:

 # nft list table ip test

table ip filter {
        counter http-traffic { pkts 779 bytes 99495}
        counter https-traffic { pkts 189 bytes 37824}

        chain output {
                 type filter hook output priority 0;
                 tcp dport http counter name http-traffic
                 tcp dport https counter name https-traffic
        }
}

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 include/net/netfilter/nf_tables.h        |   47 +++
 include/uapi/linux/netfilter/nf_tables.h |   31 ++
 net/netfilter/nf_tables_api.c            |  482 +++++++++++++++++++++++++++++-
 net/netfilter/nft_counter.c              |   97 +++++-
 4 files changed, 651 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9eaaa78..2d636ac 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -408,6 +408,16 @@ struct nft_trans {
 	char				data[0];
 };
 
+struct nft_trans_counter {
+	struct nft_named_ctr	*counter;
+	u32			counter_id;
+};
+
+#define nft_trans_counter(trans)	\
+	(((struct nft_trans_counter *)trans->data)->counter)
+#define nft_trans_counter_id(trans)	\
+	(((struct nft_trans_counter *)trans->data)->counter_id)
+
 struct nft_trans_rule {
 	struct nft_rule			*rule;
 };
@@ -572,6 +582,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt,
  *	@list: used internally
  *	@chains: chains in the table
  *	@sets: sets in the table
+ *	@counters: counters in the table
  *	@hgenerator: handle generator state
  *	@use: number of chain references to this table
  *	@flags: table flag (see enum nft_table_flags)
@@ -581,6 +592,7 @@ struct nft_table {
 	struct list_head		list;
 	struct list_head		chains;
 	struct list_head		sets;
+	struct list_head		counters;
 	u64				hgenerator;
 	u32				use;
 	u16				flags;
@@ -639,6 +651,41 @@ void nft_unregister_chain_type(const struct nf_chain_type *);
 int nft_register_expr(struct nft_expr_type *);
 void nft_unregister_expr(struct nft_expr_type *);
 
+/**
+ * struct nft_counter - nf_tables counter_priv instance
+ *
+ * @pkts:  number of packets
+ * @bytes:  number of bytes
+ */
+struct nft_counter {
+	seqlock_t	lock;
+	u64		bytes;
+	u64		packets;
+};
+
+/**
+ * struct nft_named_ctr - nf_tables counter instance
+ *
+ * @list: table counter list node
+ * @name: name of the counter
+ * @counter:  nft_priv_counter
+ * @bytes:  number of bytes
+ * @use: number of rule references to this counter
+ * @flags: counter flags
+ */
+struct nft_named_ctr {
+	struct list_head	list;
+	char			name[NFT_CTR_MAXNAMELEN];
+	struct nft_counter	counter;
+	u32			use:31,
+				flags:1;
+};
+
+void nft_counter_put(struct nft_named_ctr *counter);
+int nft_counter_get(struct nft_named_ctr *counter);
+struct nft_named_ctr *nf_tables_counter_lookup(const struct nft_table *table,
+					       const struct nlattr *nla);
+
 #define nft_dereference(p)					\
 	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 832bc46..da19f57 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -2,6 +2,7 @@
 #define _LINUX_NF_TABLES_H
 
 #define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_CTR_MAXNAMELEN	16
 #define NFT_USERDATA_MAXLEN	256
 
 enum nft_registers {
@@ -53,6 +54,10 @@ enum nft_verdicts {
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
  * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
+ * @NFT_MSG_NEWCOUNTER: create a new counter (enum nft_named_ctr_attributes)
+ * @NFT_MSG_GETCOUNTER: get a counter (enum nft_named_ctr_attributes)
+ * @NFT_MSG_GETCOUNTER_ZERO: get a reset counter (enum nft_named_ctr_attributes)
+ * @NFT_MSG_DELCOUNTER: delete a counter (enum nft_named_ctr_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -72,6 +77,10 @@ enum nf_tables_msg_types {
 	NFT_MSG_DELSETELEM,
 	NFT_MSG_NEWGEN,
 	NFT_MSG_GETGEN,
+	NFT_MSG_NEWCOUNTER,
+	NFT_MSG_GETCOUNTER,
+	NFT_MSG_GETCOUNTER_ZERO,
+	NFT_MSG_DELCOUNTER,
 	NFT_MSG_MAX,
 };
 
@@ -695,16 +704,38 @@ enum nft_limit_attributes {
  *
  * @NFTA_COUNTER_BYTES: number of bytes (NLA_U64)
  * @NFTA_COUNTER_PACKETS: number of packets (NLA_U64)
+ * @NFTA_COUNTER_NAME: name of the counter (NLA_STRING)
  */
 enum nft_counter_attributes {
 	NFTA_COUNTER_UNSPEC,
 	NFTA_COUNTER_BYTES,
 	NFTA_COUNTER_PACKETS,
+	NFTA_COUNTER_NAME,
 	__NFTA_COUNTER_MAX
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
 
 /**
+ * enum nft_named_ctr_attributes - nf_tables named counter netlink attributes
+ *
+ * @NFTA_NAMED_CTR_NAME: named counter name (NLA_STRING)
+ * @NFTA_NAMED_CTR_TABLE: table name (NLA_STRING)
+ * @NFTA_NAMED_CTR_USE: number of references to this named counter (NLA_U32)
+ * @NFTA_NAMED_CTR_BYTES: number of bytes (NLA_U64)
+ * @NFTA_NAMED_CTR_PACKETS: number of packets (NLA_U64)
+ */
+enum nft_named_ctr_attributes {
+	NFTA_NAMED_CTR_UNSPEC,
+	NFTA_NAMED_CTR_NAME,
+	NFTA_NAMED_CTR_TABLE,
+	NFTA_NAMED_CTR_USE,
+	NFTA_NAMED_CTR_BYTES,
+	NFTA_NAMED_CTR_PACKETS,
+	__NFTA_NAMED_CTR_MAX
+};
+#define NFTA_NAMED_CTR_MAX	(__NFTA_NAMED_CTR_MAX - 1)
+
+/**
  * enum nft_log_attributes - nf_tables log expression netlink attributes
  *
  * @NFTA_LOG_GROUP: netlink group to send messages to (NLA_U32)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1ff04bc..e803cbf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -325,6 +325,41 @@ static int nft_delset(struct nft_ctx *ctx, struct nft_set *set)
 	return err;
 }
 
+#define NFT_NAMED_CTR_INACTIVE		(1 << 0)
+
+static int nft_trans_counter_add(struct nft_ctx *ctx, int msg_type,
+				 struct nft_named_ctr *counter)
+{
+	struct nft_trans *trans;
+
+	trans = nft_trans_alloc(ctx, msg_type,
+				sizeof(struct nft_trans_counter));
+	if (!trans)
+		return -ENOMEM;
+
+	if (msg_type == NFT_MSG_NEWCOUNTER)
+		counter->flags |= NFT_NAMED_CTR_INACTIVE;
+
+	nft_trans_counter(trans) = counter;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+}
+
+static int nft_delcounter(struct nft_ctx *ctx, struct nft_named_ctr *counter)
+{
+	int err;
+
+	err = nft_trans_counter_add(ctx, NFT_MSG_DELCOUNTER, counter);
+	if (err < 0)
+		return err;
+
+	list_del_rcu(&counter->list);
+	ctx->table->use--;
+
+	return err;
+}
+
 /*
  * Tables
  */
@@ -694,6 +729,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	nla_strlcpy(table->name, name, nla_len(name));
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
+	INIT_LIST_HEAD(&table->counters);
 	table->flags = flags;
 
 	nft_ctx_init(&ctx, skb, nlh, afi, table, NULL, nla);
@@ -712,6 +748,7 @@ static int nft_flush_table(struct nft_ctx *ctx)
 	int err;
 	struct nft_chain *chain, *nc;
 	struct nft_set *set, *ns;
+	struct nft_named_ctr *counter, *na;
 
 	list_for_each_entry(chain, &ctx->table->chains, list) {
 		ctx->chain = chain;
@@ -730,7 +767,11 @@ static int nft_flush_table(struct nft_ctx *ctx)
 		if (err < 0)
 			goto out;
 	}
-
+	list_for_each_entry_safe(counter, na, &ctx->table->counters, list) {
+		err = nft_delcounter(ctx, counter);
+		if (err < 0)
+			goto out;
+	}
 	list_for_each_entry_safe(chain, nc, &ctx->table->chains, list) {
 		ctx->chain = chain;
 
@@ -3392,6 +3433,395 @@ err:
 	return err;
 }
 
+static const struct nla_policy nft_named_ctr_policy[NFTA_NAMED_CTR_MAX + 1] = {
+	[NFTA_NAMED_CTR_NAME]		= { .type = NLA_NUL_STRING,
+					    .len = NFT_CTR_MAXNAMELEN - 1 },
+	[NFTA_NAMED_CTR_BYTES]		= { .type = NLA_U64 },
+	[NFTA_NAMED_CTR_PACKETS]	= { .type = NLA_U64 },
+};
+
+struct nft_named_ctr *nf_tables_counter_lookup(const struct nft_table *table,
+					       const struct nlattr *nla)
+{
+	struct nft_named_ctr *counter;
+
+	if (!nla)
+		return ERR_PTR(-EINVAL);
+
+	list_for_each_entry(counter, &table->counters, list) {
+		if (!nla_strcmp(nla, counter->name))
+			return counter;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+EXPORT_SYMBOL_GPL(nf_tables_counter_lookup);
+
+static int nft_ctx_init_from_counter(struct nft_ctx *ctx,
+				     const struct sk_buff *skb,
+				     const struct nlmsghdr *nlh,
+				     const struct nlattr * const nla[])
+{
+	struct net *net = sock_net(skb->sk);
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nft_af_info *afi = NULL;
+	struct nft_table *table = NULL;
+
+	if (nfmsg->nfgen_family != NFPROTO_UNSPEC) {
+		afi = nf_tables_afinfo_lookup(net, nfmsg->nfgen_family, false);
+		if (IS_ERR(afi))
+			return PTR_ERR(afi);
+	}
+
+	if (nla[NFTA_NAMED_CTR_TABLE]) {
+		if (!afi)
+			return -EAFNOSUPPORT;
+
+		table = nf_tables_table_lookup(afi, nla[NFTA_NAMED_CTR_TABLE]);
+		if (IS_ERR(table))
+			return PTR_ERR(table);
+		if (table->flags & NFT_TABLE_INACTIVE)
+			return -ENOENT;
+	}
+
+	nft_ctx_init(ctx, skb, nlh, afi, table, NULL, nla);
+
+	return 0;
+}
+
+static int nf_tables_newcounter(struct sock *nlsk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[])
+{
+	struct nft_ctx ctx;
+	const struct nlattr *name;
+	struct nft_named_ctr *counter, *matching;
+	int err;
+
+	if (!nla[NFTA_NAMED_CTR_NAME] || !nla[NFTA_NAMED_CTR_TABLE])
+		return -EINVAL;
+
+	err = nft_ctx_init_from_counter(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	 if (ctx.table->use == UINT_MAX)
+		return -EOVERFLOW;
+
+	matching = nf_tables_counter_lookup(ctx.table,
+					    nla[NFTA_NAMED_CTR_NAME]);
+	if (!IS_ERR(matching)) {
+		if (nlh->nlmsg_flags & NLM_F_EXCL)
+			return -EEXIST;
+
+		return -EOPNOTSUPP;
+	}
+
+	if (!(nlh->nlmsg_flags & NLM_F_CREATE))
+		return -ENOENT;
+
+	counter = kzalloc(sizeof(*counter), GFP_KERNEL);
+	if (!counter)
+		return -ENOMEM;
+
+	name = nla[NFTA_NAMED_CTR_NAME];
+	nla_strlcpy(counter->name, name, NFT_CTR_MAXNAMELEN);
+
+	if (nla[NFTA_NAMED_CTR_BYTES]) {
+		counter->counter.bytes =
+			be64_to_cpu(nla_get_be64(nla[NFTA_NAMED_CTR_BYTES]));
+	}
+
+	if (nla[NFTA_NAMED_CTR_PACKETS]) {
+		counter->counter.packets =
+			be64_to_cpu(nla_get_be64(nla[NFTA_NAMED_CTR_PACKETS]));
+	}
+
+	seqlock_init(&counter->counter.lock);
+
+	err = nft_trans_counter_add(&ctx, NFT_MSG_NEWCOUNTER, counter);
+	if (err < 0)
+		goto err;
+
+	list_add_tail_rcu(&counter->list, &ctx.table->counters);
+	ctx.table->use++;
+
+	return 0;
+err:
+	kfree(counter);
+	return err;
+}
+
+static int nf_tables_fill_counter(struct sk_buff *skb,
+				  const struct nft_ctx *ctx,
+				  struct nft_named_ctr *counter,
+				  u16 event, u16 flags, u32 type)
+{
+	struct nfgenmsg *nfmsg;
+	struct nlmsghdr *nlh;
+	u32 portid = ctx->portid;
+	u32 seq = ctx->seq;
+	u64 pkts, bytes;
+
+	event |= NFNL_SUBSYS_NFTABLES << 8;
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
+			flags);
+	if (!nlh)
+		goto nla_put_failure;
+
+	nfmsg = nlmsg_data(nlh);
+	nfmsg->nfgen_family	= ctx->afi->family;
+	nfmsg->version		= NFNETLINK_V0;
+	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+
+	if (type == NFT_MSG_GETCOUNTER_ZERO) {
+		write_seqlock_bh(&counter->counter.lock);
+		counter->counter.bytes = 0;
+		counter->counter.packets = 0;
+		bytes	= counter->counter.bytes;
+		pkts	= counter->counter.packets;
+		write_sequnlock_bh(&counter->counter.lock);
+	} else {
+		do {
+			seq = read_seqbegin(&counter->counter.lock);
+			bytes	= counter->counter.bytes;
+			pkts	= counter->counter.packets;
+		} while (read_seqretry(&counter->counter.lock, seq));
+	}
+
+	if (nla_put_string(skb, NFTA_NAMED_CTR_TABLE, ctx->table->name) ||
+	    nla_put_string(skb, NFTA_NAMED_CTR_NAME, counter->name) ||
+	    nla_put_be64(skb, NFTA_NAMED_CTR_PACKETS, cpu_to_be64(pkts)) ||
+	    nla_put_be64(skb, NFTA_NAMED_CTR_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be32(skb, NFTA_NAMED_CTR_USE, htonl(counter->use)))
+		goto nla_put_failure;
+
+	return nlmsg_end(skb, nlh);
+
+nla_put_failure:
+	nlmsg_trim(skb, nlh);
+	return -1;
+}
+
+static int nf_tables_counter_notify(const struct nft_ctx *ctx,
+				    struct nft_named_ctr *counter,
+				    int event, gfp_t gfp_flags)
+{
+	struct sk_buff *skb;
+	u32 portid = ctx->portid;
+	int err;
+
+	if (!ctx->report &&
+	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
+		return 0;
+
+	err = -ENOBUFS;
+	skb = nlmsg_new(NLMSG_GOODSIZE, gfp_flags);
+	if (!skb)
+		goto err;
+
+	err = nf_tables_fill_counter(skb, ctx, counter, event, 0, 0);
+	if (err < 0) {
+		kfree_skb(skb);
+		goto err;
+	}
+
+	err = nfnetlink_send(skb, ctx->net, portid, NFNLGRP_NFTABLES,
+			     ctx->report, gfp_flags);
+err:
+	if (err < 0)
+		nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, err);
+	return err;
+}
+
+static int nf_tables_delcounter(struct sock *nlsk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[])
+{
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nft_named_ctr *counter;
+	struct nft_ctx ctx;
+	int err;
+
+	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
+		return -EAFNOSUPPORT;
+	if (!nla[NFTA_NAMED_CTR_TABLE])
+		return -EINVAL;
+
+	err = nft_ctx_init_from_counter(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	counter = nf_tables_counter_lookup(ctx.table, nla[NFTA_NAMED_CTR_NAME]);
+	if (IS_ERR(counter))
+		return PTR_ERR(counter);
+	if (counter->flags & NFT_NAMED_CTR_INACTIVE)
+		return -ENOENT;
+	if (counter->use > 0)
+		return -EBUSY;
+
+	return nft_delcounter(&ctx, counter);
+}
+
+static int nf_tables_dump_counter(struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	struct nft_named_ctr *counter;
+	unsigned int idx, s_idx = cb->args[0];
+	struct nft_af_info *afi;
+	struct nft_table *table, *cur_table = (struct nft_table *)cb->args[2];
+	struct net *net = sock_net(skb->sk);
+	int cur_family = cb->args[3];
+	struct nft_ctx *ctx = cb->data, ctx_counter;
+
+	if (cb->args[1])
+		return skb->len;
+
+	rcu_read_lock();
+	cb->seq = net->nft.base_seq;
+	list_for_each_entry_rcu(afi, &net->nft.af_info, list) {
+		if (ctx->afi && ctx->afi != afi)
+			continue;
+
+		if (cur_family) {
+			if (afi->family != cur_family)
+				continue;
+
+			cur_family = 0;
+		}
+		list_for_each_entry_rcu(table, &afi->tables, list) {
+			if (ctx->table && ctx->table != table)
+				continue;
+
+			if (cur_table) {
+				if (cur_table != table)
+					continue;
+
+				cur_table = NULL;
+			}
+			idx = 0;
+			list_for_each_entry_rcu(counter, &table->counters,
+						list) {
+				if (idx < s_idx)
+					goto cont;
+
+				ctx_counter = *ctx;
+				ctx_counter.table = table;
+				ctx_counter.afi = afi;
+				if (nf_tables_fill_counter(skb, &ctx_counter,
+							   counter,
+							   NFT_MSG_NEWCOUNTER,
+							   NLM_F_MULTI,
+							   0) < 0) {
+					cb->args[0] = idx;
+					cb->args[2] = (unsigned long)table;
+					cb->args[3] = afi->family;
+					goto done;
+				}
+				nl_dump_check_consistent(cb, nlmsg_hdr(skb));
+cont:
+				idx++;
+			}
+			if (s_idx)
+				s_idx = 0;
+		}
+	}
+	cb->args[1] = 1;
+done:
+	rcu_read_unlock();
+	return skb->len;
+}
+
+static int nf_tables_dump_counter_done(struct netlink_callback *cb)
+{
+	kfree(cb->data);
+
+	return 0;
+}
+
+static int nf_tables_getcounter(struct sock *nlsk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				const struct nlattr * const nla[])
+{
+	struct nft_ctx ctx;
+	struct sk_buff *skb2;
+	int err, ret;
+	struct nft_named_ctr *counter;
+	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+
+	/* Verify existence before starting dump */
+	err = nft_ctx_init_from_counter(&ctx, skb, nlh, nla);
+	if (err < 0)
+		return err;
+
+	if (nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.dump = nf_tables_dump_counter,
+			.done = nf_tables_dump_counter_done,
+		};
+		struct nft_ctx *ctx_dump;
+
+		ctx_dump = kmalloc(sizeof(*ctx_dump), GFP_KERNEL);
+		if (!ctx_dump)
+			return -ENOMEM;
+
+		*ctx_dump = ctx;
+		c.data = ctx_dump;
+
+		return netlink_dump_start(nlsk, skb, nlh, &c);
+	}
+
+	/* Only accept unspec with dump */
+	if (nfmsg->nfgen_family == NFPROTO_UNSPEC)
+		return -EAFNOSUPPORT;
+
+	counter = nf_tables_counter_lookup(ctx.table, nla[NFTA_NAMED_CTR_NAME]);
+	if (IS_ERR(counter))
+		return PTR_ERR(counter);
+
+	if (counter->flags & NFT_NAMED_CTR_INACTIVE)
+		return -ENOENT;
+
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!skb2)
+		return -ENOMEM;
+
+	err = nf_tables_fill_counter(skb2, &ctx, counter, NFT_MSG_NEWCOUNTER, 0,
+				     NFNL_MSG_TYPE(nlh->nlmsg_type));
+	if (err < 0)
+		goto err;
+
+	ret = nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
+
+	/* this avoids a loop in nfnetlink. */
+	return ret == -EAGAIN ? -ENOBUFS : ret;
+
+err:
+	kfree_skb(skb2);
+	return err;
+}
+
+void nft_counter_put(struct nft_named_ctr *counter)
+{
+	counter->use--;
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL_GPL(nft_counter_put);
+
+int nft_counter_get(struct nft_named_ctr *counter)
+{
+	if (!try_module_get(THIS_MODULE))
+		return -ENOENT;
+
+	if (counter->use == UINT_MAX)
+		return -EOVERFLOW;
+
+	counter->use++;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nft_counter_get);
+
 static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_NEWTABLE] = {
 		.call_batch	= nf_tables_newtable,
@@ -3471,6 +3901,26 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	[NFT_MSG_GETGEN] = {
 		.call		= nf_tables_getgen,
 	},
+	[NFT_MSG_NEWCOUNTER] = {
+		.call_batch	= nf_tables_newcounter,
+		.attr_count	= NFTA_NAMED_CTR_MAX,
+		.policy		= nft_named_ctr_policy,
+	},
+	[NFT_MSG_GETCOUNTER] = {
+		.call		= nf_tables_getcounter,
+		.attr_count	= NFTA_NAMED_CTR_MAX,
+		.policy		= nft_named_ctr_policy,
+	},
+	[NFT_MSG_GETCOUNTER_ZERO] = {
+		.call		= nf_tables_getcounter,
+		.attr_count	= NFTA_NAMED_CTR_MAX,
+		.policy		= nft_named_ctr_policy,
+	},
+	[NFT_MSG_DELCOUNTER] = {
+		.call_batch	= nf_tables_delcounter,
+		.attr_count	= NFTA_NAMED_CTR_MAX,
+		.policy		= nft_named_ctr_policy,
+	},
 };
 
 static void nft_chain_commit_update(struct nft_trans *trans)
@@ -3509,6 +3959,9 @@ static void nf_tables_commit_release(struct nft_trans *trans)
 	case NFT_MSG_DELSET:
 		nft_set_destroy(nft_trans_set(trans));
 		break;
+	case NFT_MSG_DELCOUNTER:
+		kfree(nft_trans_counter(trans));
+		break;
 	}
 	kfree(trans);
 }
@@ -3614,6 +4067,20 @@ static int nf_tables_commit(struct sk_buff *skb)
 			}
 			nft_trans_destroy(trans);
 			break;
+		case NFT_MSG_NEWCOUNTER:
+			nft_trans_counter(trans)->flags &= ~NFT_NAMED_CTR_INACTIVE;
+			nf_tables_counter_notify(&trans->ctx,
+						 nft_trans_counter(trans),
+						 NFT_MSG_NEWCOUNTER,
+						 GFP_KERNEL);
+			nft_trans_destroy(trans);
+			break;
+		case NFT_MSG_DELCOUNTER:
+			nf_tables_counter_notify(&trans->ctx,
+						 nft_trans_counter(trans),
+						 NFT_MSG_DELCOUNTER,
+						 GFP_KERNEL);
+			break;
 		}
 	}
 
@@ -3644,6 +4111,9 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 	case NFT_MSG_NEWSET:
 		nft_set_destroy(nft_trans_set(trans));
 		break;
+	case NFT_MSG_NEWCOUNTER:
+		kfree(nft_trans_counter(trans));
+		break;
 	}
 	kfree(trans);
 }
@@ -3722,6 +4192,16 @@ static int nf_tables_abort(struct sk_buff *skb)
 			nft_trans_elem_set(trans)->nelems++;
 			nft_trans_destroy(trans);
 			break;
+		case NFT_MSG_NEWCOUNTER:
+			trans->ctx.table->use--;
+			list_del_rcu(&nft_trans_counter(trans)->list);
+			break;
+		case NFT_MSG_DELCOUNTER:
+			trans->ctx.table->use++;
+			list_add_tail_rcu(&nft_trans_counter(trans)->list,
+					  &trans->ctx.table->counters);
+			nft_trans_destroy(trans);
+			break;
 		}
 	}
 
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index c89ee48..fe0f219 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -17,10 +17,8 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_counter {
-	seqlock_t	lock;
-	u64		bytes;
-	u64		packets;
+struct nft_named_ctr_expr {
+	struct nft_named_ctr *counter;
 };
 
 static void nft_counter_eval(const struct nft_expr *expr,
@@ -35,6 +33,18 @@ static void nft_counter_eval(const struct nft_expr *expr,
 	write_sequnlock_bh(&priv->lock);
 }
 
+static void nft_named_ctr_eval(const struct nft_expr *expr,
+			       struct nft_data data[NFT_REG_MAX + 1],
+			       const struct nft_pktinfo *pkt)
+{
+	struct nft_named_ctr_expr *priv = nft_expr_priv(expr);
+
+	write_seqlock_bh(&priv->counter->counter.lock);
+	priv->counter->counter.bytes += pkt->skb->len;
+	priv->counter->counter.packets++;
+	write_sequnlock_bh(&priv->counter->counter.lock);
+}
+
 static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	struct nft_counter *priv = nft_expr_priv(expr);
@@ -58,11 +68,42 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_named_ctr_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	struct nft_named_ctr_expr *priv = nft_expr_priv(expr);
+	unsigned int seq;
+	u64 bytes;
+	u64 packets;
+
+	if (nla_put_string(skb, NFTA_COUNTER_NAME, priv->counter->name))
+		goto nla_put_failure;
+
+	do {
+		seq = read_seqbegin(&priv->counter->counter.lock);
+		bytes	= priv->counter->counter.bytes;
+		packets	= priv->counter->counter.packets;
+	} while (read_seqretry(&priv->counter->counter.lock, seq));
+
+	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(bytes)))
+		goto nla_put_failure;
+	if (nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(packets)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
 	[NFTA_COUNTER_PACKETS]	= { .type = NLA_U64 },
 	[NFTA_COUNTER_BYTES]	= { .type = NLA_U64 },
 };
 
+static const struct nla_policy nft_named_ctr_policy[NFTA_COUNTER_MAX + 1] = {
+	[NFTA_COUNTER_NAME]	= { .type = NLA_STRING },
+};
+
 static int nft_counter_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
@@ -78,6 +119,33 @@ static int nft_counter_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
+static int nft_named_ctr_init(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nlattr * const tb[])
+{
+	struct nft_named_ctr_expr *priv = nft_expr_priv(expr);
+	struct nft_named_ctr *counter;
+
+	if (!tb[NFTA_COUNTER_NAME])
+		return -EINVAL;
+
+	counter = nf_tables_counter_lookup(ctx->table, tb[NFTA_COUNTER_NAME]);
+	if (IS_ERR(counter))
+		return -ENOENT;
+
+	priv->counter = counter;
+
+	return nft_counter_get(priv->counter);
+}
+
+static void nft_named_ctr_destroy(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr)
+{
+	struct nft_named_ctr_expr *priv = nft_expr_priv(expr);
+
+	nft_counter_put(priv->counter);
+}
+
 static struct nft_expr_type nft_counter_type;
 static const struct nft_expr_ops nft_counter_ops = {
 	.type		= &nft_counter_type,
@@ -87,9 +155,28 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.dump		= nft_counter_dump,
 };
 
+static const struct nft_expr_ops nft_named_ctr_ops = {
+	.type		= &nft_counter_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_counter)),
+	.eval		= nft_named_ctr_eval,
+	.init		= nft_named_ctr_init,
+	.dump		= nft_named_ctr_dump,
+	.destroy	= nft_named_ctr_destroy,
+};
+
+static const struct nft_expr_ops *
+nft_counter_select_ops(const struct nft_ctx *ctx,
+		       const struct nlattr * const tb[])
+{
+	if (tb[NFTA_COUNTER_NAME])
+		return &nft_named_ctr_ops;
+
+	return &nft_counter_ops;
+}
+
 static struct nft_expr_type nft_counter_type __read_mostly = {
 	.name		= "counter",
-	.ops		= &nft_counter_ops,
+	.select_ops	= &nft_counter_select_ops,
 	.policy		= nft_counter_policy,
 	.maxattr	= NFTA_COUNTER_MAX,
 	.owner		= THIS_MODULE,
-- 
1.7.10.4

