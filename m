From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 13:30:27 +0000
Message-ID: <61379b1e-8f7e-4596-badb-fd41e1657f83@email.android.com>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: Nikolay Aleksandrov <nikolay@redhat.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63009 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaBONac (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:30:32 -0500
In-Reply-To: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15. Februar 2014 13:17:22 GMT+00:00, Nikolay Aleksandrov <nikolay@redhat.com> wrote:
>The new "write" expression can be used to manipulate packet data.
>The parameters that it has are source register (source for the bytes
>which are to be written), offset in the packet and length to write.
>It uses a select_ops method to choose between fast ops in the cases
>length is 1,2 or 4 bytes and slow ops (i.e. using memcpy) in other
>cases.
>
>Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
>---
>I needed a way (other than passing the packets to user-space) to alter
>the ToS field via nftables, so I decided to make it a bit more general.
>I
>use it with the immediate expression to load the new ToS and then write
>it.
>If you find this useful I can post the libnftnl patch as well.
>Right now as you can see it continues even if the "write" wasn't
>successful
>which should be probably changed to NFT_BREAK for that case.

Yes.

>This patch applies to Dave's net-next tree.

I think this is a useful addition. However I prefer to put thus into the payload expression and select the proper ops based on the presence of sreg/dreg.

>+++ b/net/netfilter/nft_write.c
>@@ -0,0 +1,160 @@
>+/*
>+ * Copyright (c) 2014 Nikolay Aleksandrov <nikolay@redhat.com>
>+ *
>+ * This program is free software; you can redistribute it and/or
>modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+
>+#include <linux/kernel.h>
>+#include <linux/init.h>
>+#include <linux/module.h>
>+#include <linux/netlink.h>
>+#include <linux/netfilter.h>
>+#include <linux/netfilter/nf_tables.h>
>+#include <net/netfilter/nf_tables.h>
>+
>+struct nft_write_expr {
>+	enum nft_registers      sreg:8;
>+	u32			offset;
>+	u8			wlen;

Probably obsolete when combining this with payload, but you can save memory by moving wlen next to sreg.

>+};
>+
>+static void nft_write_eval(const struct nft_expr *expr,
>+			   struct nft_data data[NFT_REG_MAX + 1],
>+			   const struct nft_pktinfo *pkt)
>+{
>+	struct nft_write_expr *priv = nft_expr_priv(expr);
>+	struct nft_data *src = &data[priv->sreg];
>+
>+	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;

Not necessary, NFT_CONTINUE is the default.

>+	if (!skb_make_writable(pkt->skb, priv->offset+priv->wlen))
>+		return;
>+	pr_debug("Writing at %u : 0x%x len %u\n",
>+		 priv->offset, src->data[0], priv->wlen);
>+	memcpy(pkt->skb->data + priv->offset, src, priv->wlen);

The offset should be relative to a payload base.

>+}
>+
>+static void nft_write_fast_eval(const struct nft_expr *expr,
>+				struct nft_data data[NFT_REG_MAX + 1],
>+				const struct nft_pktinfo *pkt)
>+{
>+	struct nft_write_expr *priv = nft_expr_priv(expr);
>+	struct nft_data *src = &data[priv->sreg];
>+	unsigned char *ptr;
>+
>+	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
>+	if (!skb_make_writable(pkt->skb, priv->offset+priv->wlen))
>+		return;
>+	ptr = pkt->skb->data + priv->offset;
>+	pr_debug("Writing at %u : 0x%x len %u\n",
>+		 priv->offset, src->data[0], priv->wlen);
>+	if (priv->wlen == 4)
>+		*(u32 *)ptr = *(u32 *)src->data;
>+	else if (priv->wlen == 2)
>+		*(u16 *)ptr = *(u16 *)src->data;
>+	else
>+		*(u8 *)ptr = *(u8 *)src->data;
>+}

I'm not sure we need this. The payload fast types exist because to inline the very common operation. I wouldn't expect it to be much of a gain in this case.

>+
>+
>+static const struct nla_policy nft_write_policy[NFTA_WRITE_MAX + 1] =
>{
>+	[NFTA_WRITE_SREG]		= { .type = NLA_U32 },
>+	[NFTA_WRITE_OFFSET]		= { .type = NLA_U32 },
>+	[NFTA_WRITE_WLEN]		= { .type = NLA_U8 },
>+};
>+
>+static int nft_write_init(const struct nft_ctx *ctx,
>+			  const struct nft_expr *expr,
>+			  const struct nlattr * const tb[])
>+{
>+	struct nft_write_expr *priv = nft_expr_priv(expr);
>+
>+	priv->sreg = ntohl(nla_get_be32(tb[NFTA_WRITE_SREG]));
>+	priv->wlen = nla_get_u8(tb[NFTA_WRITE_WLEN]);
>+	priv->offset = ntohl(nla_get_be32(tb[NFTA_WRITE_OFFSET]));
>+
>+	return 0;
>+}
>+
>+static int nft_write_dump(struct sk_buff *skb, const struct nft_expr
>*expr)
>+{
>+	const struct nft_write_expr *priv = nft_expr_priv(expr);
>+
>+	nla_put_be32(skb, NFTA_WRITE_SREG, htonl(priv->sreg));
>+	nla_put_be32(skb, NFTA_WRITE_OFFSET, htonl(priv->offset));
>+	nla_put_u8(skb, NFTA_WRITE_WLEN, priv->wlen);
>+
>+	return 0;
>+}
>+
>+static struct nft_expr_type nft_write_type;
>+static const struct nft_expr_ops nft_write_ops = {
>+	.type		= &nft_write_type,
>+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_write_expr)),
>+	.eval		= nft_write_eval,
>+	.init		= nft_write_init,
>+	.dump		= nft_write_dump,
>+};
>+
>+static const struct nft_expr_ops nft_write_fast_ops = {
>+	.type		= &nft_write_type,
>+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_write_expr)),
>+	.eval		= nft_write_fast_eval,
>+	.init		= nft_write_init,
>+	.dump		= nft_write_dump,
>+};
>+
>+static const struct nft_expr_ops *
>+nft_write_select_ops(const struct nft_ctx *ctx,
>+		     const struct nlattr * const tb[])
>+{
>+	enum nft_registers sreg;
>+	u32 offset;
>+	u8 wlen;
>+	int err;
>+
>+	if (tb[NFTA_WRITE_OFFSET] == NULL ||
>+	    tb[NFTA_WRITE_WLEN] == NULL ||
>+	    tb[NFTA_WRITE_SREG] == NULL)
>+		return ERR_PTR(-EINVAL);
>+
>+	wlen = nla_get_u8(tb[NFTA_WRITE_WLEN]);
>+	if (wlen == 0 || wlen > FIELD_SIZEOF(struct nft_data, data))
>+		return ERR_PTR(-EINVAL);
>+	sreg = ntohl(nla_get_be32(tb[NFTA_WRITE_SREG]));
>+	err = nft_validate_input_register(sreg);
>+	if (err < 0)
>+		return ERR_PTR(err);
>+	offset = ntohl(nla_get_u32(tb[NFTA_WRITE_OFFSET]));
>+
>+	if (wlen != 3 && wlen <= 4 && IS_ALIGNED(offset, wlen))
>+		return &nft_write_fast_ops;
>+	else
>+		return &nft_write_ops;
>+}
>+
>+static struct nft_expr_type nft_write_type __read_mostly = {
>+	.name		= "write",
>+	.select_ops	= &nft_write_select_ops,
>+	.policy		= nft_write_policy,
>+	.maxattr	= NFTA_WRITE_MAX,
>+	.owner		= THIS_MODULE,
>+};
>+
>+static int __init nft_write_module_init(void)
>+{
>+	return nft_register_expr(&nft_write_type);
>+}
>+
>+static void __exit nft_write_module_exit(void)
>+{
>+	nft_unregister_expr(&nft_write_type);
>+}
>+
>+module_init(nft_write_module_init);
>+module_exit(nft_write_module_exit);
>+
>+MODULE_LICENSE("GPL");
>+MODULE_AUTHOR("Nikolay Aleksandrov <nikolay@redhat.com>");
>+MODULE_ALIAS_NFT_EXPR("write");
>-- 
>1.8.4.2


