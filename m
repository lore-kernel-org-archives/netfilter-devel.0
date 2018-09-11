From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/12] netfilter: nf_tables: rework ct timeout set support
Date: Tue, 11 Sep 2018 02:20:37 +0200
Message-ID: <20180911002044.9100-6-pablo@netfilter.org>
References: <20180911002044.9100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180911002044.9100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Using a private template is problematic:

1. We can't assign both a zone and a timeout policy
   (zone assigns a conntrack template, so we hit problem 1)
2. Using a template needs to take care of ct refcount, else we'll
   eventually free the private template due to ->use underflow.

This patch reworks template policy to instead work with existing conntrack.

As long as such conntrack has not yet been placed into the hash table
(unconfirmed) we can still add the timeout extension.

The only caveat is that we now need to update/correct ct->timeout to
reflect the initial/new state, otherwise the conntrack entry retains the
default 'new' timeout.

Side effect of this change is that setting the policy must
now occur from chains that are evaluated *after* the conntrack lookup
has taken place.

No released kernel contains the timeout policy feature yet, so this change
should be ok.

Changes since v2:
 - don't handle 'ct is confirmed case'
 - after previous patch, no need to special-case tcp/dccp/sctp timeout
   anymore

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_timeout.h |  2 +-
 net/netfilter/nft_ct.c                       | 59 ++++++++++++++--------------
 2 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index d5f62cc6c2ae..3394d75e1c80 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -30,7 +30,7 @@ struct nf_conn_timeout {
 };
 
 static inline unsigned int *
-nf_ct_timeout_data(struct nf_conn_timeout *t)
+nf_ct_timeout_data(const struct nf_conn_timeout *t)
 {
 	struct nf_ct_timeout *timeout;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 26a8baebd072..5dd87748afa8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -799,7 +799,7 @@ nft_ct_timeout_parse_policy(void *timeouts,
 }
 
 struct nft_ct_timeout_obj {
-	struct nf_conn		*tmpl;
+	struct nf_ct_timeout    *timeout;
 	u8			l4proto;
 };
 
@@ -809,26 +809,42 @@ static void nft_ct_timeout_obj_eval(struct nft_object *obj,
 {
 	const struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
-	struct sk_buff *skb = pkt->skb;
+	struct nf_conn_timeout *timeout;
+	const unsigned int *values;
+
+	if (priv->l4proto != pkt->tprot)
+		return;
 
-	if (ct ||
-	    priv->l4proto != pkt->tprot)
+	if (!ct || nf_ct_is_template(ct) || nf_ct_is_confirmed(ct))
 		return;
 
-	nf_ct_set(skb, priv->tmpl, IP_CT_NEW);
+	timeout = nf_ct_timeout_find(ct);
+	if (!timeout) {
+		timeout = nf_ct_timeout_ext_add(ct, priv->timeout, GFP_ATOMIC);
+		if (!timeout) {
+			regs->verdict.code = NF_DROP;
+			return;
+		}
+	}
+
+	rcu_assign_pointer(timeout->timeout, priv->timeout);
+
+	/* adjust the timeout as per 'new' state. ct is unconfirmed,
+	 * so the current timestamp must not be added.
+	 */
+	values = nf_ct_timeout_data(timeout);
+	if (values)
+		nf_ct_refresh(ct, pkt->skb, values[0]);
 }
 
 static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 				   const struct nlattr * const tb[],
 				   struct nft_object *obj)
 {
-	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	const struct nf_conntrack_l4proto *l4proto;
-	struct nf_conn_timeout *timeout_ext;
 	struct nf_ct_timeout *timeout;
 	int l3num = ctx->family;
-	struct nf_conn *tmpl;
 	__u8 l4num;
 	int ret;
 
@@ -863,28 +879,14 @@ static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
 
 	timeout->l3num = l3num;
 	timeout->l4proto = l4proto;
-	tmpl = nf_ct_tmpl_alloc(ctx->net, zone, GFP_ATOMIC);
-	if (!tmpl) {
-		ret = -ENOMEM;
-		goto err_free_timeout;
-	}
-
-	timeout_ext = nf_ct_timeout_ext_add(tmpl, timeout, GFP_ATOMIC);
-	if (!timeout_ext) {
-		ret = -ENOMEM;
-		goto err_free_tmpl;
-	}
 
 	ret = nf_ct_netns_get(ctx->net, ctx->family);
 	if (ret < 0)
-		goto err_free_tmpl;
-
-	priv->tmpl = tmpl;
+		goto err_free_timeout;
 
+	priv->timeout = timeout;
 	return 0;
 
-err_free_tmpl:
-	nf_ct_tmpl_free(tmpl);
 err_free_timeout:
 	kfree(timeout);
 err_proto_put:
@@ -896,22 +898,19 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 				       struct nft_object *obj)
 {
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
-	struct nf_conn_timeout *t = nf_ct_timeout_find(priv->tmpl);
-	struct nf_ct_timeout *timeout;
+	struct nf_ct_timeout *timeout = priv->timeout;
 
-	timeout = rcu_dereference_raw(t->timeout);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_l4proto_put(timeout->l4proto);
 	nf_ct_netns_put(ctx->net, ctx->family);
-	nf_ct_tmpl_free(priv->tmpl);
+	kfree(priv->timeout);
 }
 
 static int nft_ct_timeout_obj_dump(struct sk_buff *skb,
 				   struct nft_object *obj, bool reset)
 {
 	const struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
-	const struct nf_conn_timeout *t = nf_ct_timeout_find(priv->tmpl);
-	const struct nf_ct_timeout *timeout = rcu_dereference_raw(t->timeout);
+	const struct nf_ct_timeout *timeout = priv->timeout;
 	struct nlattr *nest_params;
 	int ret;
 
-- 
2.11.0
