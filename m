From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net-next v16 4/8] netfilter: Add nf_ct_get_tuple_skb callback
Date: Mon, 28 May 2018 16:27:46 +0200
Message-ID: <152751766686.30935.14644567905547700823.stgit@alrua-kau>
References: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org, cake@lists.bufferbloat.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This adds a callback to netfilter to extract a conntrack tuple from an skb
that works before the _nfct skb field has been initialised (e.g., in an
ingress qdisc). The tuple is copied to the caller to avoid issues with
reference counting.

The callback will return false when conntrack is not loaded, allowing it to
be accessed without incurring a module dependency on conntrack. This is
used by the NAT mode in sch_cake.

Cc: netfilter-devel@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/linux/netfilter.h         |    6 ++++++
 net/netfilter/core.c              |   21 +++++++++++++++++++++
 net/netfilter/nf_conntrack_core.c |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 85a1a0b32c66..7cbe7e9ce527 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -375,6 +375,12 @@ nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 extern void (*ip_ct_attach)(struct sk_buff *, const struct sk_buff *) __rcu;
 void nf_ct_attach(struct sk_buff *, const struct sk_buff *);
 extern void (*nf_ct_destroy)(struct nf_conntrack *) __rcu;
+
+struct nf_conntrack_tuple;
+extern bool (*skb_ct_get_tuple)(struct nf_conntrack_tuple *,
+				const struct sk_buff *) __rcu;
+bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
+			 const struct sk_buff *skb);
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 0f6b8172fb9a..520565198f0e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -572,6 +572,27 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
 
+bool (*skb_ct_get_tuple)(struct nf_conntrack_tuple *,
+			 const struct sk_buff *) __rcu __read_mostly;
+EXPORT_SYMBOL(skb_ct_get_tuple);
+
+bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
+			 const struct sk_buff *skb)
+{
+	bool (*get_tuple)(const struct sk_buff *, struct nf_conntrack_tuple *);
+	bool ret = false;
+
+	rcu_read_lock();
+	get_tuple = rcu_dereference(skb_ct_get_tuple);
+	if (!get_tuple)
+		goto out;
+	ret = get_tuple(dst_tuple, skb);
+out:
+	rcu_read_unlock();
+	return ret;
+}
+EXPORT_SYMBOL(nf_ct_get_tuple_skb);
+
 /* Built-in default zone used e.g. by modules. */
 const struct nf_conntrack_zone nf_ct_zone_dflt = {
 	.id	= NF_CT_DEFAULT_ZONE_ID,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 41ff04ee2554..eee5c76f638c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1611,6 +1611,41 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 	nf_conntrack_get(skb_nfct(nskb));
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
@@ -1808,6 +1843,7 @@ void nf_conntrack_cleanup_start(void)
 {
 	conntrack_gc_work.exiting = true;
 	RCU_INIT_POINTER(ip_ct_attach, NULL);
+	RCU_INIT_POINTER(skb_ct_get_tuple, NULL);
 }
 
 void nf_conntrack_cleanup_end(void)
@@ -2135,6 +2171,7 @@ void nf_conntrack_init_end(void)
 	/* For use by REJECT target */
 	RCU_INIT_POINTER(ip_ct_attach, nf_conntrack_attach);
 	RCU_INIT_POINTER(nf_ct_destroy, destroy_conntrack);
+	RCU_INIT_POINTER(skb_ct_get_tuple, nf_conntrack_get_tuple_skb);
 }
 
 /*
