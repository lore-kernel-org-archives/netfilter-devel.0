From: Florian Westphal <fw@strlen.de>
Subject: [RFC nf-next] netfilter: ct: add helper assignment support
Date: Wed, 15 Feb 2017 17:25:36 +0100
Message-ID: <20170215162536.982-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36014 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751223AbdBOQZW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 11:25:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This RFC adds native support to assign conntrack helpers.
Not even compile tested.

It adds NFT_OBJECT_CT_HELPER to assign helpers to connections
by using the stateful objects infra that is in place for quota and counter.

This would also need NFT_OBJECT_CT_TIMEOUT to support
custom timeouts in nftables.

Does this look sane to you from a design p.o.v.?
If yes, I would start looking into userspace side of things.

Thanks,
Florian
---
 include/uapi/linux/netfilter/nf_tables.h |  12 ++-
 net/netfilter/nft_ct.c                   | 130 ++++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 05215d30fe5c..121e79cacc49 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1246,10 +1246,20 @@ enum nft_fib_flags {
 	NFTA_FIB_F_OIF		= 1 << 4,	/* restrict to oif */
 };
 
+enum nft_ct_helper_attributes {
+	NFTA_CT_HELPER_UNSPEC,
+	NFTA_CT_HELPER_NAME,
+	NFTA_CT_HELPER_L3PROTO,

Note from myself, i dislike L3PROTO, it would be nicer to be able
to handle this via the table family but I did not yet find a way
to detect this from the obj->init() function.

Its needed for nf_conntrack_helper_try_module_get().

This also begs the question of how one would handle
NFPROTO_INET, in that case we'd want both v4 and v6, but that
would require stashing two struct nf_conntrack_helper in
priv area.

Any ideas/suggestions?

+	NFTA_CT_HELPER_L4PROTO,
+	__NFTA_CT_HELPER_MAX,
+};
+#define NFTA_CT_HELPER_MAX	(__NFTA_CT_HELPER_MAX - 1)
+
 #define NFT_OBJECT_UNSPEC	0
 #define NFT_OBJECT_COUNTER	1
 #define NFT_OBJECT_QUOTA	2
-#define __NFT_OBJECT_MAX	3
+#define NFT_OBJECT_CT_HELPER	3
+#define __NFT_OBJECT_MAX	4
 #define NFT_OBJECT_MAX		(__NFT_OBJECT_MAX - 1)
 
 /**
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index c6b8022c0e47..2a5bd9955122 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -32,6 +32,12 @@ struct nft_ct {
 	};
 };
 
+struct nft_ct_helper_obj  {
+	struct nf_conntrack_helper *helper;
+	u16 l3proto;
+	u8 l4proto;
+};
+
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 static DEFINE_PER_CPU(struct nf_conn *, nft_ct_pcpu_template);
 static unsigned int nft_ct_pcpu_template_refcnt __read_mostly;
@@ -729,28 +735,147 @@ static struct nft_expr_type nft_notrack_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
+static int nft_ct_helper_obj_init(const struct nlattr * const tb[],
+				  struct nft_object *obj)
+{
+	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
+	struct nf_conntrack_helper *helper;
+	char name[NF_CT_HELPER_NAME_LEN];
+	int family;
+	u8 proto;
+
+	if (!tb[NFTA_CT_HELPER_NAME] || !tb[NFTA_CT_HELPER_L4PROTO] ||
+	    !tb[NFTA_CT_HELPER_L3PROTO])
+		return -EINVAL;
+
+	family = ntohs(nla_get_be16(tb[NFTA_CT_HELPER_L3PROTO]));
+	switch (family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		break;
+	default:
+		return -EAFNOSUPPORT;
+	}
+
+	proto = nla_get_u8(tb[NFTA_CT_HELPER_L4PROTO]);
+	if (!proto)
+		return -ENOENT;
+
+
+	if (nla_strlcpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name)) >= sizeof(name))
+		return -EINVAL;
+
+	helper = nf_conntrack_helper_try_module_get(name, family, proto);
+	if (!helper)
+		return -ENOENT;
+
+	priv->helper = helper;
+	priv->l4proto = proto;
+	priv->l3proto = family;
+
+	return 0;
+}
+
+static void nft_ct_helper_obj_destroy(struct nft_object *obj)
+{
+	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
+
+	module_put(priv->helper->me);
+}
+
+static void nft_ct_helper_obj_eval(struct nft_object *obj,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct_helper_obj *priv = nft_obj_data(obj);
+	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
+	struct nf_conn_help *help;
+
+	if (!ct)
+		return;
+
+	if (nf_ct_is_template(ct))
+		return;
+
+	if (nf_ct_is_confirmed(ct))
+		return;
+
+	if (test_bit(IPS_HELPER_BIT, &ct->status))
+		return;
+
+	help = nf_ct_helper_ext_add(ct, priv->helper, GFP_ATOMIC);
+	if (help) {
+		rcu_assign_pointer(help->helper, priv->helper);
+		set_bit(IPS_HELPER_BIT, &ct->status);
+	}
+}
+
+static int nft_ct_helper_obj_dump(struct sk_buff *skb,
+				  struct nft_object *obj, bool reset)
+{
+	const struct nft_ct_helper_obj *priv = nft_obj_data(obj);
+	const struct nf_conntrack_helper *helper = priv->helper;
+
+	if (nla_put_string(skb, NFTA_CT_HELPER_NAME, helper->name))
+		return -1;
+
+	if (nla_put_u8(skb, NFTA_CT_HELPER_L4PROTO, priv->l4proto))
+		return -1;
+
+	if (nla_put_u16(skb, NFTA_CT_HELPER_L4PROTO, htons(priv->l3proto)))
+		return -1;
+
+	return 0;
+}
+
+static const struct nla_policy nft_ct_helper_policy[NFTA_CT_HELPER_MAX + 1] = {
+	[NFTA_CT_HELPER_NAME] = { .type = NLA_STRING, .len = NF_CT_HELPER_NAME_LEN - 1 },
+	[NFTA_CT_HELPER_L3PROTO] = { .type = NLA_U16 },
+	[NFTA_CT_HELPER_L4PROTO] = { .type = NLA_U8 },
+};
+
+static struct nft_object_type nft_ct_helper_obj __read_mostly = {
+	.type		= NFT_OBJECT_CT_HELPER,
+	.size		= sizeof(struct nft_ct_helper_obj),
+	.maxattr	= NFTA_CT_HELPER_MAX,
+	.policy		= nft_ct_helper_policy,
+	.eval		= nft_ct_helper_obj_eval,
+	.init		= nft_ct_helper_obj_init,
+	.destroy	= nft_ct_helper_obj_destroy,
+	.dump		= nft_ct_helper_obj_dump,
+	.owner		= THIS_MODULE,
+};
+
 static int __init nft_ct_module_init(void)
 {
 	int err;
 
 	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE > NFT_REG_SIZE);
 
-	err = nft_register_expr(&nft_ct_type);
+	err = nft_register_obj(&nft_ct_helper_obj);
 	if (err < 0)
 		return err;
 
-	err = nft_register_expr(&nft_notrack_type);
+	err = nft_register_expr(&nft_ct_type);
 	if (err < 0)
 		goto err1;
 
+	err = nft_register_expr(&nft_notrack_type);
+	if (err < 0)
+		goto err2;
+
 	return 0;
+
 err1:
+	nft_unregister_obj(&nft_ct_helper_obj);
+err2:
 	nft_unregister_expr(&nft_ct_type);
 	return err;
 }
 
 static void __exit nft_ct_module_exit(void)
 {
+	nft_unregister_obj(&nft_ct_helper_obj);
 	nft_unregister_expr(&nft_notrack_type);
 	nft_unregister_expr(&nft_ct_type);
 }
@@ -762,3 +887,4 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_ALIAS_NFT_EXPR("ct");
 MODULE_ALIAS_NFT_EXPR("notrack");
+MODULE_ALIAS_NFT_OBJ(NFT_OBJECT_CT_HELPER);
-- 
2.10.2

