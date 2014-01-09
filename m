From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH netfilter: nft v2] netfilter: nf_tables Add set op to
 nft_ct module
Date: Thu, 9 Jan 2014 20:15:28 +0100
Message-ID: <20140109191528.GA22096@localhost>
References: <1389109434-3056-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbaAITPo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:15:44 -0500
Content-Disposition: inline
In-Reply-To: <1389109434-3056-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 07, 2014 at 04:43:54PM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> This patch adds kernel support for setting properties of tracked connections.
> Currently, only connmark is supported. One use-case for this feature is to
> provide the same functionality as -j CONNMARK --save-mark in iptables.
> 
> Some restructuring was needed to implement the set op. The new structure follows
> that of nft_meta.

Made several changes, see below.

> v1->v2:
> Check if mark changes value before updating, to prevent event storm.
> 
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |   2 +
>  net/netfilter/nft_ct.c                   | 163 +++++++++++++++++++++++++------
>  2 files changed, 134 insertions(+), 31 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index aa86a152..ead57b1 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -605,12 +605,14 @@ enum nft_ct_keys {
>   * @NFTA_CT_DREG: destination register (NLA_U32)
>   * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
>   * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
> + * @NFTA_CT_SREG: source register (NLA_U32)
>   */
>  enum nft_ct_attributes {
>  	NFTA_CT_UNSPEC,
>  	NFTA_CT_DREG,
>  	NFTA_CT_KEY,
>  	NFTA_CT_DIRECTION,
> +	NFTA_CT_SREG,
>  	__NFTA_CT_MAX
>  };
>  #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 955f4e6..8936c01 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -18,17 +18,21 @@
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_tuple.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
> +#include <net/netfilter/nf_conntrack_ecache.h>
>  
>  struct nft_ct {
>  	enum nft_ct_keys	key:8;
>  	enum ip_conntrack_dir	dir:8;
> -	enum nft_registers	dreg:8;
> +	union{
> +		enum nft_registers	dreg:8;
> +		enum nft_registers	sreg:8;
> +	};
>  	uint8_t			family;
>  };
>  
> -static void nft_ct_eval(const struct nft_expr *expr,
> -			struct nft_data data[NFT_REG_MAX + 1],
> -			const struct nft_pktinfo *pkt)
> +static void nft_ct_get_eval(const struct nft_expr *expr,
> +			    struct nft_data data[NFT_REG_MAX + 1],
> +			    const struct nft_pktinfo *pkt)
>  {
>  	const struct nft_ct *priv = nft_expr_priv(expr);
>  	struct nft_data *dest = &data[priv->dreg];
> @@ -123,24 +127,45 @@ err:
>  	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
>  }
>  
> +static void nft_ct_set_eval(const struct nft_expr *expr,
> +			    struct nft_data data[NFT_REG_MAX + 1],
> +			    const struct nft_pktinfo *pkt)
> +{
> +	const struct nft_ct *priv = nft_expr_priv(expr);
> +	struct sk_buff *skb = pkt->skb;
> +	u32 value = data[priv->sreg].data[0];
> +	enum ip_conntrack_info ctinfo;
> +	struct nf_conn *ct;
> +
> +	ct = nf_ct_get(skb, &ctinfo);
> +
> +	if (ct == NULL)
> +		return;
> +
> +	switch (priv->key) {
> +#ifdef CONFIG_NF_CONNTRACK_MARK
> +	case NFT_CT_MARK:
> +		if (ct->mark != value) {
> +			ct->mark = value;
> +			nf_conntrack_event_cache(IPCT_MARK, ct);
> +		}
> +		break;
> +#endif
> +	}
> +}
> +
>  static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
>  	[NFTA_CT_DREG]		= { .type = NLA_U32 },
>  	[NFTA_CT_KEY]		= { .type = NLA_U32 },
>  	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
> +	[NFTA_CT_SREG]		= { .type = NLA_U32 },
>  };
>  
> -static int nft_ct_init(const struct nft_ctx *ctx,
> -		       const struct nft_expr *expr,
> -		       const struct nlattr * const tb[])
> +static int nft_ct_init_validate_get(const struct nft_expr *expr,
> +				    const struct nlattr * const tb[])
>  {
>  	struct nft_ct *priv = nft_expr_priv(expr);
> -	int err;
>  
> -	if (tb[NFTA_CT_DREG] == NULL ||
> -	    tb[NFTA_CT_KEY] == NULL)
> -		return -EINVAL;
> -
> -	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
>  	if (tb[NFTA_CT_DIRECTION] != NULL) {
>  		priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
>  		switch (priv->dir) {
> @@ -179,24 +204,56 @@ static int nft_ct_init(const struct nft_ctx *ctx,
>  		return -EOPNOTSUPP;
>  	}
>  
> -	err = nf_ct_l3proto_try_module_get(ctx->afi->family);
> -	if (err < 0)
> -		return err;
> +	return 0;
> +}
> +
> +static int nft_ct_init_validate_set(uint32_t key) {
> +	switch (key) {
> +	case NFT_CT_MARK:
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return 0;
> +}
> +
> +static int nft_ct_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
> +		       const struct nlattr * const tb[])
> +{
> +	struct nft_ct *priv = nft_expr_priv(expr);
> +	int err;
> +
> +	priv->key = ntohl(nla_get_be32(tb[NFTA_META_KEY]));
>  	priv->family = ctx->afi->family;
>  
> -	priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
> -	err = nft_validate_output_register(priv->dreg);
> -	if (err < 0)
> -		goto err1;
> +	if (tb[NFTA_CT_DREG]) {
> +		err = nft_ct_init_validate_get(expr, tb);
> +		if (err < 0)
> +			return err;
> +
> +		priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
> +		err = nft_validate_output_register(priv->dreg);
> +		if (err < 0)
> +			return err;
> +
> +		err = nft_validate_data_load(ctx, priv->dreg, NULL,
> +					     NFT_DATA_VALUE);
> +		if (err < 0)
> +			return err;
> +	} else {
> +		err = nft_ct_init_validate_set(priv->key);
> +		if (err < 0)
> +			return err;
>  
> -	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
> +		priv->sreg = ntohl(nla_get_be32(tb[NFTA_CT_SREG]));

Added missing sreg validation, it was also missing in nft_meta.

> +	}
> +
> +	err = nf_ct_l3proto_try_module_get(ctx->afi->family);
>  	if (err < 0)
> -		goto err1;
> -	return 0;
> +		return err;
>  
> -err1:
> -	nf_ct_l3proto_module_put(ctx->afi->family);
> -	return err;

Rebased this patch upon last Patrick's to support the new inet table,
this was clashing with it.

> +	return 0;
>  }
>  
>  static void nft_ct_destroy(const struct nft_expr *expr)
> @@ -206,7 +263,7 @@ static void nft_ct_destroy(const struct nft_expr *expr)
>  	nf_ct_l3proto_module_put(priv->family);
>  }
>  
> -static int nft_ct_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
>  {
>  	const struct nft_ct *priv = nft_expr_priv(expr);
>  
> @@ -222,19 +279,63 @@ nla_put_failure:
>  	return -1;
>  }
>  
> +static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
> +{
> +	const struct nft_ct *priv = nft_expr_priv(expr);
> +
> +	if (nla_put_be32(skb, NFTA_CT_SREG, htonl(priv->sreg)))
> +		goto nla_put_failure;
> +	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
> +		goto nla_put_failure;
> +	if (nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
> +		goto nla_put_failure;

We're not using the direction attribute in nft_ct/set, so I remove it.

I took over your patch and rebased it. Find it attached, if no
complains I'll include this in the net-next batch for nf_tables.

--k1lZvvs/B4yU6o8G
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nft_ct-Add-support-to-set-the-connmark.patch"

>From a4cfc86d3b2b35d2a9d8fb002c24509d09d8069e Mon Sep 17 00:00:00 2001
From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Tue, 7 Jan 2014 16:43:54 +0100
Subject: [PATCH] netfilter: nft_ct: Add support to set the connmark

This patch adds kernel support for setting properties of tracked
connections. Currently, only connmark is supported. One use-case
for this feature is to provide the same functionality as
-j CONNMARK --save-mark in iptables.

Some restructuring was needed to implement the set op. The new
structure follows that of nft_meta.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: Pablo took over this patch and removed the direction attribute from the
    nft_ct/set variant and rebased upon latest Patrick's patch.

 include/uapi/linux/netfilter/nf_tables.h |    2 +
 net/netfilter/nft_ct.c                   |  158 +++++++++++++++++++++++++-----
 2 files changed, 134 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 448593c..83c985a 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -609,12 +609,14 @@ enum nft_ct_keys {
  * @NFTA_CT_DREG: destination register (NLA_U32)
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
+ * @NFTA_CT_SREG: source register (NLA_U32)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
 	NFTA_CT_DREG,
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
+	NFTA_CT_SREG,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 3727a32..76729f3 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -18,17 +18,21 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_ecache.h>
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
 	enum ip_conntrack_dir	dir:8;
-	enum nft_registers	dreg:8;
+	union{
+		enum nft_registers	dreg:8;
+		enum nft_registers	sreg:8;
+	};
 	uint8_t			family;
 };
 
-static void nft_ct_eval(const struct nft_expr *expr,
-			struct nft_data data[NFT_REG_MAX + 1],
-			const struct nft_pktinfo *pkt)
+static void nft_ct_get_eval(const struct nft_expr *expr,
+			    struct nft_data data[NFT_REG_MAX + 1],
+			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 	struct nft_data *dest = &data[priv->dreg];
@@ -123,10 +127,37 @@ err:
 	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
+static void nft_ct_set_eval(const struct nft_expr *expr,
+			    struct nft_data data[NFT_REG_MAX + 1],
+			    const struct nft_pktinfo *pkt)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	u32 value = data[priv->sreg].data[0];
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return;
+
+	switch (priv->key) {
+#ifdef CONFIG_NF_CONNTRACK_MARK
+	case NFT_CT_MARK:
+		if (ct->mark != value) {
+			ct->mark = value;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+#endif
+	}
+}
+
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
 	[NFTA_CT_DREG]		= { .type = NLA_U32 },
 	[NFTA_CT_KEY]		= { .type = NLA_U32 },
 	[NFTA_CT_DIRECTION]	= { .type = NLA_U8 },
+	[NFTA_CT_SREG]		= { .type = NLA_U32 },
 };
 
 static int nft_ct_l3proto_try_module_get(uint8_t family)
@@ -162,18 +193,11 @@ static void nft_ct_l3proto_module_put(uint8_t family)
 		nf_ct_l3proto_module_put(family);
 }
 
-static int nft_ct_init(const struct nft_ctx *ctx,
-		       const struct nft_expr *expr,
-		       const struct nlattr * const tb[])
+static int nft_ct_init_validate_get(const struct nft_expr *expr,
+				    const struct nlattr * const tb[])
 {
 	struct nft_ct *priv = nft_expr_priv(expr);
-	int err;
 
-	if (tb[NFTA_CT_DREG] == NULL ||
-	    tb[NFTA_CT_KEY] == NULL)
-		return -EINVAL;
-
-	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
 	if (tb[NFTA_CT_DIRECTION] != NULL) {
 		priv->dir = nla_get_u8(tb[NFTA_CT_DIRECTION]);
 		switch (priv->dir) {
@@ -212,21 +236,61 @@ static int nft_ct_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	return 0;
+}
+
+static int nft_ct_init_validate_set(uint32_t key)
+{
+	switch (key) {
+	case NFT_CT_MARK:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int nft_ct_init(const struct nft_ctx *ctx,
+		       const struct nft_expr *expr,
+		       const struct nlattr * const tb[])
+{
+	struct nft_ct *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->key = ntohl(nla_get_be32(tb[NFTA_CT_KEY]));
+
 	err = nft_ct_l3proto_try_module_get(ctx->afi->family);
 	if (err < 0)
 		return err;
+
 	priv->family = ctx->afi->family;
 
-	priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
-	err = nft_validate_output_register(priv->dreg);
-	if (err < 0)
-		goto err1;
+	if (tb[NFTA_CT_DREG]) {
+		err = nft_ct_init_validate_get(expr, tb);
+		if (err < 0)
+			goto err1;
 
-	err = nft_validate_data_load(ctx, priv->dreg, NULL, NFT_DATA_VALUE);
-	if (err < 0)
-		goto err1;
-	return 0;
+		priv->dreg = ntohl(nla_get_be32(tb[NFTA_CT_DREG]));
+		err = nft_validate_output_register(priv->dreg);
+		if (err < 0)
+			goto err1;
+
+		err = nft_validate_data_load(ctx, priv->dreg, NULL,
+					     NFT_DATA_VALUE);
+		if (err < 0)
+			goto err1;
+	} else {
+		err = nft_ct_init_validate_set(priv->key);
+		if (err < 0)
+			goto err1;
 
+		priv->sreg = ntohl(nla_get_be32(tb[NFTA_CT_SREG]));
+		err = nft_validate_input_register(priv->sreg);
+		if (err < 0)
+			goto err1;
+	}
+	return 0;
 err1:
 	nft_ct_l3proto_module_put(ctx->afi->family);
 	return err;
@@ -239,7 +303,7 @@ static void nft_ct_destroy(const struct nft_expr *expr)
 	nft_ct_l3proto_module_put(priv->family);
 }
 
-static int nft_ct_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
 
@@ -255,19 +319,61 @@ nla_put_failure:
 	return -1;
 }
 
+static int nft_ct_set_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_ct *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_CT_SREG, htonl(priv->sreg)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
 static struct nft_expr_type nft_ct_type;
-static const struct nft_expr_ops nft_ct_ops = {
+static const struct nft_expr_ops nft_ct_get_ops = {
 	.type		= &nft_ct_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
-	.eval		= nft_ct_eval,
+	.eval		= nft_ct_get_eval,
 	.init		= nft_ct_init,
 	.destroy	= nft_ct_destroy,
-	.dump		= nft_ct_dump,
+	.dump		= nft_ct_get_dump,
 };
 
+static const struct nft_expr_ops nft_ct_set_ops = {
+	.type		= &nft_ct_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_ct)),
+	.eval		= nft_ct_set_eval,
+	.init		= nft_ct_init,
+	.destroy	= nft_ct_destroy,
+	.dump		= nft_ct_set_dump,
+};
+
+static const struct nft_expr_ops *
+nft_ct_select_ops(const struct nft_ctx *ctx,
+		    const struct nlattr * const tb[])
+{
+	if (tb[NFTA_CT_KEY] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_CT_DREG] && tb[NFTA_CT_SREG])
+		return ERR_PTR(-EINVAL);
+
+	if (tb[NFTA_CT_DREG])
+		return &nft_ct_get_ops;
+
+	if (tb[NFTA_CT_SREG])
+		return &nft_ct_set_ops;
+
+	return ERR_PTR(-EINVAL);
+}
+
 static struct nft_expr_type nft_ct_type __read_mostly = {
 	.name		= "ct",
-	.ops		= &nft_ct_ops,
+	.select_ops	= &nft_ct_select_ops,
 	.policy		= nft_ct_policy,
 	.maxattr	= NFTA_CT_MAX,
 	.owner		= THIS_MODULE,
-- 
1.7.10.4


--k1lZvvs/B4yU6o8G--
