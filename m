From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/8] netfilter: nft_ct: add ct timeout support
Date: Fri, 10 Aug 2018 13:16:19 +0200
Message-ID: <20180810111622.3981-6-pablo@netfilter.org>
References: <20180810111622.3981-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Harsha Sharma <harshasharmaiitr@gmail.com>

This patch allows to add, list and delete connection tracking timeout
policies via nft objref infrastructure and assigning these timeout
via nft rule.

%./libnftnl/examples/nft-ct-timeout-add ip raw cttime tcp

Ruleset:

table ip raw {
   ct timeout cttime {
       protocol tcp;
       policy = {established: 111, close: 13 }
   }

   chain output {
       type filter hook output priority -300; policy accept;
       ct timeout set "cttime"
   }
}

%./libnftnl/examples/nft-rule-ct-timeout-add ip raw output cttime

%conntrack -E
[NEW] tcp      6 111 ESTABLISHED src=172.16.19.128 dst=172.16.19.1
sport=22 dport=41360 [UNREPLIED] src=172.16.19.1 dst=172.16.19.128
sport=41360 dport=22

%nft delete rule ip raw output handle <handle>
%./libnftnl/examples/nft-ct-timeout-del ip raw cttime

Joint work with Pablo Neira.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  14 ++-
 net/netfilter/nft_ct.c                   | 204 ++++++++++++++++++++++++++++++-
 2 files changed, 216 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 94657c701f22..e23290ffdc77 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -958,6 +958,7 @@ enum nft_socket_keys {
  * @NFT_CT_DST_IP: conntrack layer 3 protocol destination (IPv4 address)
  * @NFT_CT_SRC_IP6: conntrack layer 3 protocol source (IPv6 address)
  * @NFT_CT_DST_IP6: conntrack layer 3 protocol destination (IPv6 address)
+ * @NFT_CT_TIMEOUT: connection tracking timeout policy assigned to conntrack
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -983,6 +984,7 @@ enum nft_ct_keys {
 	NFT_CT_DST_IP,
 	NFT_CT_SRC_IP6,
 	NFT_CT_DST_IP6,
+	NFT_CT_TIMEOUT,
 	__NFT_CT_MAX
 };
 #define NFT_CT_MAX		(__NFT_CT_MAX - 1)
@@ -1411,6 +1413,15 @@ enum nft_ct_helper_attributes {
 };
 #define NFTA_CT_HELPER_MAX	(__NFTA_CT_HELPER_MAX - 1)
 
+enum nft_ct_timeout_timeout_attributes {
+	NFTA_CT_TIMEOUT_UNSPEC,
+	NFTA_CT_TIMEOUT_L3PROTO,
+	NFTA_CT_TIMEOUT_L4PROTO,
+	NFTA_CT_TIMEOUT_DATA,
+	__NFTA_CT_TIMEOUT_MAX,
+};
+#define NFTA_CT_TIMEOUT_MAX	(__NFTA_CT_TIMEOUT_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
@@ -1418,7 +1429,8 @@ enum nft_ct_helper_attributes {
 #define NFT_OBJECT_LIMIT	4
 #define NFT_OBJECT_CONNLIMIT	5
 #define NFT_OBJECT_TUNNEL	6
-#define __NFT_OBJECT_MAX	7
+#define NFT_OBJECT_CT_TIMEOUT	7
+#define __NFT_OBJECT_MAX	8
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 3bc82ee5464d..4788458a0931 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -22,6 +22,8 @@
 #include <net/netfilter/nf_conntrack_helper.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
+#include <net/netfilter/nf_conntrack_timeout.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -765,6 +767,194 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+static int
+nft_ct_timeout_parse_policy(void *timeouts,
+			    const struct nf_conntrack_l4proto *l4proto,
+			    struct net *net, const struct nlattr *attr)
+{
+	struct nlattr **tb;
+	int ret = 0;
+
+	if (!l4proto->ctnl_timeout.nlattr_to_obj)
+		return 0;
+
+	tb = kcalloc(l4proto->ctnl_timeout.nlattr_max + 1, sizeof(*tb),
+		     GFP_KERNEL);
+
+	if (!tb)
+		return -ENOMEM;
+
+	ret = nla_parse_nested(tb, l4proto->ctnl_timeout.nlattr_max,
+			       attr, l4proto->ctnl_timeout.nla_policy,
+			       NULL);
+	if (ret < 0)
+		goto err;
+
+	ret = l4proto->ctnl_timeout.nlattr_to_obj(tb, net, timeouts);
+
+err:
+	kfree(tb);
+	return ret;
+}
+
+struct nft_ct_timeout_obj {
+	struct nf_conn		*tmpl;
+	u8			l4proto;
+};
+
+static void nft_ct_timeout_obj_eval(struct nft_object *obj,
+				    struct nft_regs *regs,
+				    const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
+	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
+	struct sk_buff *skb = pkt->skb;
+
+	if (ct ||
+	    priv->l4proto != pkt->tprot)
+		return;
+
+	nf_ct_set(skb, priv->tmpl, IP_CT_NEW);
+}
+
+static int nft_ct_timeout_obj_init(const struct nft_ctx *ctx,
+				   const struct nlattr * const tb[],
+				   struct nft_object *obj)
+{
+	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
+	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
+	const struct nf_conntrack_l4proto *l4proto;
+	struct nf_conn_timeout *timeout_ext;
+	struct nf_ct_timeout *timeout;
+	int l3num = ctx->family;
+	struct nf_conn *tmpl;
+	__u8 l4num;
+	int ret;
+
+	if (!tb[NFTA_CT_TIMEOUT_L3PROTO] ||
+	    !tb[NFTA_CT_TIMEOUT_L4PROTO] ||
+	    !tb[NFTA_CT_TIMEOUT_DATA])
+		return -EINVAL;
+
+	l3num = ntohs(nla_get_be16(tb[NFTA_CT_TIMEOUT_L3PROTO]));
+	l4num = nla_get_u8(tb[NFTA_CT_TIMEOUT_L4PROTO]);
+	priv->l4proto = l4num;
+
+	l4proto = nf_ct_l4proto_find_get(l3num, l4num);
+
+	if (l4proto->l4proto != l4num) {
+		ret = -EOPNOTSUPP;
+		goto err_proto_put;
+	}
+
+	timeout = kzalloc(sizeof(struct nf_ct_timeout) +
+			  l4proto->ctnl_timeout.obj_size, GFP_KERNEL);
+	if (timeout == NULL) {
+		ret = -ENOMEM;
+		goto err_proto_put;
+	}
+
+	ret = nft_ct_timeout_parse_policy(&timeout->data, l4proto, ctx->net,
+					  tb[NFTA_CT_TIMEOUT_DATA]);
+	if (ret < 0)
+		goto err_free_timeout;
+
+	timeout->l3num = l3num;
+	timeout->l4proto = l4proto;
+	tmpl = nf_ct_tmpl_alloc(ctx->net, zone, GFP_ATOMIC);
+	if (!tmpl) {
+		ret = -ENOMEM;
+		goto err_free_timeout;
+	}
+
+	timeout_ext = nf_ct_timeout_ext_add(tmpl, timeout, GFP_ATOMIC);
+	if (!timeout_ext) {
+		ret = -ENOMEM;
+		goto err_free_tmpl;
+	}
+
+	ret = nf_ct_netns_get(ctx->net, ctx->family);
+	if (ret < 0)
+		goto err_free_tmpl;
+
+	priv->tmpl = tmpl;
+
+	return 0;
+
+err_free_tmpl:
+	nf_ct_tmpl_free(tmpl);
+err_free_timeout:
+	kfree(timeout);
+err_proto_put:
+	nf_ct_l4proto_put(l4proto);
+	return ret;
+}
+
+static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
+	struct nf_conn_timeout *t = nf_ct_timeout_find(priv->tmpl);
+	struct nf_ct_timeout *timeout;
+
+	timeout = rcu_dereference_raw(t->timeout);
+	nf_ct_untimeout(ctx->net, timeout);
+	nf_ct_l4proto_put(timeout->l4proto);
+	nf_ct_netns_put(ctx->net, ctx->family);
+	nf_ct_tmpl_free(priv->tmpl);
+}
+
+static int nft_ct_timeout_obj_dump(struct sk_buff *skb,
+				   struct nft_object *obj, bool reset)
+{
+	const struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
+	const struct nf_conn_timeout *t = nf_ct_timeout_find(priv->tmpl);
+	const struct nf_ct_timeout *timeout = rcu_dereference_raw(t->timeout);
+	struct nlattr *nest_params;
+	int ret;
+
+	if (nla_put_u8(skb, NFTA_CT_TIMEOUT_L4PROTO, timeout->l4proto->l4proto) ||
+	    nla_put_be16(skb, NFTA_CT_TIMEOUT_L3PROTO, htons(timeout->l3num)))
+		return -1;
+
+	nest_params = nla_nest_start(skb, NFTA_CT_TIMEOUT_DATA | NLA_F_NESTED);
+	if (!nest_params)
+		return -1;
+
+	ret = timeout->l4proto->ctnl_timeout.obj_to_nlattr(skb, &timeout->data);
+	if (ret < 0)
+		return -1;
+	nla_nest_end(skb, nest_params);
+	return 0;
+}
+
+static const struct nla_policy nft_ct_timeout_policy[NFTA_CT_TIMEOUT_MAX + 1] = {
+	[NFTA_CT_TIMEOUT_L3PROTO] = {.type = NLA_U16 },
+	[NFTA_CT_TIMEOUT_L4PROTO] = {.type = NLA_U8 },
+	[NFTA_CT_TIMEOUT_DATA]	  = {.type = NLA_NESTED },
+};
+
+static struct nft_object_type nft_ct_timeout_obj_type;
+
+static const struct nft_object_ops nft_ct_timeout_obj_ops = {
+	.type		= &nft_ct_timeout_obj_type,
+	.size		= sizeof(struct nft_ct_timeout_obj),
+	.eval		= nft_ct_timeout_obj_eval,
+	.init		= nft_ct_timeout_obj_init,
+	.destroy	= nft_ct_timeout_obj_destroy,
+	.dump		= nft_ct_timeout_obj_dump,
+};
+
+static struct nft_object_type nft_ct_timeout_obj_type __read_mostly = {
+	.type		= NFT_OBJECT_CT_TIMEOUT,
+	.ops		= &nft_ct_timeout_obj_ops,
+	.maxattr	= NFTA_CT_TIMEOUT_MAX,
+	.policy		= nft_ct_timeout_policy,
+	.owner		= THIS_MODULE,
+};
+#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
+
 static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[],
 				  struct nft_object *obj)
@@ -949,9 +1139,17 @@ static int __init nft_ct_module_init(void)
 	err = nft_register_obj(&nft_ct_helper_obj_type);
 	if (err < 0)
 		goto err2;
-
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	err = nft_register_obj(&nft_ct_timeout_obj_type);
+	if (err < 0)
+		goto err3;
+#endif
 	return 0;
 
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+err3:
+	nft_unregister_obj(&nft_ct_helper_obj_type);
+#endif
 err2:
 	nft_unregister_expr(&nft_notrack_type);
 err1:
@@ -961,6 +1159,9 @@ static int __init nft_ct_module_init(void)
 
 static void __exit nft_ct_module_exit(void)
 {
+#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
+	nft_unregister_obj(&nft_ct_timeout_obj_type);
+#endif
 	nft_unregister_obj(&nft_ct_helper_obj_type);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
@@ -974,3 +1175,4 @@ MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("ct");
 MODULE_ALIAS_NFT_EXPR("notrack");
 MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_TIMEOUT);
-- 
2.11.0
