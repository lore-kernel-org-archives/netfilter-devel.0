From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net-next v19 4/8] netfilter: Add nf_ct_get_tuple_skb global
 lookup function
Date: Fri, 06 Jul 2018 17:37:19 +0200
Message-ID: <153089143936.14813.6047325174579983392.stgit@alrua-x1>
References: <153089141290.14813.1010951705929696896.stgit@alrua-x1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, cake@lists.bufferbloat.net
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <153089141290.14813.1010951705929696896.stgit@alrua-x1>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This adds a global netfilter function to extract a conntrack tuple from an
skb. The function uses a new function added to nf_ct_hook, which will try
to get the tuple from skb->_nfct, and do a full lookup if that fails. This
makes it possible to use the lookup function before the skb has passed
through the conntrack init hooks (e.g., in an ingress qdisc). The tuple is
copied to the caller to avoid issues with reference counting.

The function returns false if conntrack is not loaded, allowing it to be
used without incurring a module dependency on conntrack. This is used by
the NAT mode in sch_cake.

Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/linux/netfilter.h         |   11 +++++++++++
 net/netfilter/core.c              |   15 +++++++++++++++
 net/netfilter/nf_conntrack_core.c |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 5a5e0a2ab2a3..bf43e24b9dd0 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -410,8 +410,17 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 
 extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
 void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
+struct nf_conntrack_tuple;
+bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
+			 const struct sk_buff *skb);
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
+struct nf_conntrack_tuple;
+static inline bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
+				       const struct sk_buff *skb)
+{
+	return false;
+}
 #endif
 
 struct nf_conn;
@@ -420,6 +429,8 @@ enum ip_conntrack_info;
 struct nf_ct_hook {
 	int (*update)(struct net *net, struct sk_buff *skb);
 	void (*destroy)(struct nf_conntrack *);
+	bool (*get_tuple_skb)(struct nf_conntrack_tuple *,
+			      const struct sk_buff *);
 };
 extern struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 168af54db975..dc240cb47ddf 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -603,6 +603,21 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
 
+bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
+			 const struct sk_buff *skb)
+{
+	struct nf_ct_hook *ct_hook;
+	bool ret = false;
+
+	rcu_read_lock();
+	ct_hook = rcu_dereference(nf_ct_hook);
+	if (ct_hook)
+		ret = ct_hook->get_tuple_skb(dst_tuple, skb);
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(nf_ct_get_tuple_skb);
+
 /* Built-in default zone used e.g. by modules. */
 const struct nf_conntrack_zone nf_ct_zone_dflt = {
 	.id	= NF_CT_DEFAULT_ZONE_ID,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3465da2a98bd..85ab2fd6a665 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1683,6 +1683,41 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	return 0;
 }
 
+static bool nf_conntrack_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
+				       const struct sk_buff *skb)
+{
+	const struct nf_conntrack_tuple *src_tuple;
+	const struct nf_conntrack_tuple_hash *hash;
+	struct nf_conntrack_tuple srctuple;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct) {
+		src_tuple = nf_ct_tuple(ct, CTINFO2DIR(ctinfo));
+		memcpy(dst_tuple, src_tuple, sizeof(*dst_tuple));
+		return true;
+	}
+
+	if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+			       NFPROTO_IPV4, dev_net(skb->dev),
+			       &srctuple))
+		return false;
+
+	hash = nf_conntrack_find_get(dev_net(skb->dev),
+				     &nf_ct_zone_dflt,
+				     &srctuple);
+	if (!hash)
+		return false;
+
+	ct = nf_ct_tuplehash_to_ctrack(hash);
+	src_tuple = nf_ct_tuple(ct, !hash->tuple.dst.dir);
+	memcpy(dst_tuple, src_tuple, sizeof(*dst_tuple));
+	nf_ct_put(ct);
+
+	return true;
+}
+
 /* Bring out ya dead! */
 static struct nf_conn *
 get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
@@ -2204,6 +2239,7 @@ int nf_conntrack_init_start(void)
 static struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
 	.destroy	= destroy_conntrack,
+	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
 };
 
 void nf_conntrack_init_end(void)
