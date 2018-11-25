From: Aaron Conole <aconole@bytheb.org>
Subject: [RFC -next v0 2/3] netfilter: nf_flow_table: support a new 'snoop' mode
Date: Sun, 25 Nov 2018 13:09:18 -0500
Message-ID: <20181125180919.13996-3-aconole@bytheb.org>
References: <20181125180919.13996-1-aconole@bytheb.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        Rony Efraim <ronye@mellanox.com>,
        Simon Horman <horms@verge.net>,
        Marcelo Leitner <marcelo.leitner@gmail.com>
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181125180919.13996-1-aconole@bytheb.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds the ability for a flow table to receive updates on
all flows added/removed to any flow table in the system.  This will
allow other subsystems in the kernel to register a lookup mechanism
into the nftables connection tracker for those connections which
should be sent to a flow offload table.

Each flow table can now be set with some kinds of flags, and if
one of those flags is the new 'snoop' flag, it will be updated
whenever a flow entry is added or removed to any flow table.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/net/netfilter/nf_flow_table.h    |  5 +++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_flow_table_core.c       | 44 ++++++++++++++++++++++--
 net/netfilter/nf_tables_api.c            | 13 ++++++-
 4 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 77e2761d4f2f..3fdfeb17f500 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -20,9 +20,14 @@ struct nf_flowtable_type {
 	struct module			*owner;
 };
 
+enum nf_flowtable_flags {
+	NF_FLOWTABLE_F_SNOOP		= 0x1,
+};
+
 struct nf_flowtable {
 	struct list_head		list;
 	struct rhashtable		rhashtable;
+	u32				flags;
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 7de4f1bdaf06..f1cfe30aecde 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1482,6 +1482,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
+ * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1491,6 +1492,7 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
+	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index b7a4816add76..289a2299eea2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -15,6 +15,7 @@
 struct flow_offload_entry {
 	struct flow_offload	flow;
 	struct nf_conn		*ct;
+	struct nf_flow_route	route;
 	struct rcu_head		rcu_head;
 };
 
@@ -78,6 +79,7 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 		goto err_dst_cache_reply;
 
 	entry->ct = ct;
+	entry->route = *route;
 
 	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_ORIGINAL);
 	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_REPLY);
@@ -100,6 +102,18 @@ flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
 }
 EXPORT_SYMBOL_GPL(flow_offload_alloc);
 
+static struct flow_offload *flow_offload_clone(struct flow_offload *flow)
+{
+	struct flow_offload *clone_flow_val;
+	struct flow_offload_entry *e;
+
+	e = container_of(flow, struct flow_offload_entry, flow);
+
+	clone_flow_val = flow_offload_alloc(e->ct, &e->route);
+
+	return clone_flow_val;
+}
+
 static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 {
 	tcp->state = TCP_CONNTRACK_ESTABLISHED;
@@ -182,7 +196,7 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 	.automatic_shrinking	= true,
 };
 
-int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
+static void __flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	flow->timeout = (u32)jiffies;
 
@@ -192,12 +206,30 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 	rhashtable_insert_fast(&flow_table->rhashtable,
 			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
 			       nf_flow_offload_rhash_params);
+}
+
+int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
+{
+	struct nf_flowtable *flowtable;
+
+	__flow_offload_add(flow_table, flow);
+
+	mutex_lock(&flowtable_lock);
+	list_for_each_entry(flowtable, &flowtables, list) {
+		if (flowtable != flow_table &&
+		    flowtable->flags & NF_FLOWTABLE_F_SNOOP) {
+			struct flow_offload *flow_clone =
+				flow_offload_clone(flow);
+			__flow_offload_add(flowtable, flow_clone);
+		}
+	}
+	mutex_unlock(&flowtable_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
 
-static void flow_offload_del(struct nf_flowtable *flow_table,
-			     struct flow_offload *flow)
+static void __flow_offload_del(struct nf_flowtable *flow_table,
+			       struct flow_offload *flow)
 {
 	struct flow_offload_entry *e;
 
@@ -210,6 +242,12 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	e = container_of(flow, struct flow_offload_entry, flow);
 	clear_bit(IPS_OFFLOAD_BIT, &e->ct->status);
+}
+
+static void flow_offload_del(struct nf_flowtable *flow_table,
+			     struct flow_offload *flow)
+{
+	__flow_offload_del(flow_table, flow);
 
 	flow_offload_free(flow);
 }
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42487d01a3ed..8148de9f9a54 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5569,6 +5569,15 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (err < 0)
 		goto err3;
 
+	if (nla[NFTA_FLOWTABLE_FLAGS]) {
+		flowtable->data.flags =
+			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
+		if (flowtable->data.flags & ~NF_FLOWTABLE_F_SNOOP) {
+			err = -EINVAL;
+			goto err4;
+		}
+	}
+
 	err = nf_tables_flowtable_parse_hook(&ctx, nla[NFTA_FLOWTABLE_HOOK],
 					     flowtable);
 	if (err < 0)
@@ -5694,7 +5703,9 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
 	    nla_put_be32(skb, NFTA_FLOWTABLE_USE, htonl(flowtable->use)) ||
 	    nla_put_be64(skb, NFTA_FLOWTABLE_HANDLE, cpu_to_be64(flowtable->handle),
-			 NFTA_FLOWTABLE_PAD))
+			 NFTA_FLOWTABLE_PAD) ||
+	    nla_put_be32(skb, NFTA_FLOWTABLE_FLAGS,
+			 htonl(flowtable->data.flags)))
 		goto nla_put_failure;
 
 	nest = nla_nest_start(skb, NFTA_FLOWTABLE_HOOK);
-- 
2.19.1
