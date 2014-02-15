From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 14:17:22 +0100
Message-ID: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbaBONRb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:17:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The new "write" expression can be used to manipulate packet data.
The parameters that it has are source register (source for the bytes
which are to be written), offset in the packet and length to write.
It uses a select_ops method to choose between fast ops in the cases
length is 1,2 or 4 bytes and slow ops (i.e. using memcpy) in other
cases.

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
I needed a way (other than passing the packets to user-space) to alter
the ToS field via nftables, so I decided to make it a bit more general. I
use it with the immediate expression to load the new ToS and then write it.
If you find this useful I can post the libnftnl patch as well.
Right now as you can see it continues even if the "write" wasn't successful
which should be probably changed to NFT_BREAK for that case.
This patch applies to Dave's net-next tree.

 include/uapi/linux/netfilter/nf_tables.h |  16 ++++
 net/netfilter/Kconfig                    |   7 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_write.c                | 160 +++++++++++++++++++++++++++++++
 4 files changed, 184 insertions(+)
 create mode 100644 net/netfilter/nft_write.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 83c985a..ac8b37b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -745,4 +745,20 @@ enum nft_nat_attributes {
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
 
+/**
+ * enum nft_write_attributes - nf_tables write expression netlink attributes
+ *
+ * @NFTA_WRITE_SREG: source register (source for the bytes to be written)
+ * @NFTA_WRITE_OFFSET: offset into packet to write
+ * @NFTA_WRITE_WLEN: number of bytes to write
+ */
+enum nft_write_attributes {
+	NFTA_WRITE_UNSPEC,
+	NFTA_WRITE_SREG,
+	NFTA_WRITE_OFFSET,
+	NFTA_WRITE_WLEN,
+	__NFTA_WRITE_MAX
+};
+#define NFTA_WRITE_MAX	(__NFTA_WRITE_MAX - 1)
+
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e9410d1..54dbff6 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -534,6 +534,13 @@ config NFT_COMPAT
 	  x_tables match/target extensions over the nf_tables
 	  framework.
 
+config NFT_WRITE
+	depends on NF_TABLES
+	tristate "Netfilter nf_tables write module"
+	help
+	  This option adds the "write" expression that you can use to
+	  manipulate packet data.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index bffdad7..9fbedb8 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_NFT_CT)		+= nft_ct.o
 obj-$(CONFIG_NFT_LIMIT)		+= nft_limit.o
 obj-$(CONFIG_NFT_NAT)		+= nft_nat.o
 obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
+obj-$(CONFIG_NFT_WRITE)		+= nft_write.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
 obj-$(CONFIG_NFT_RBTREE)	+= nft_rbtree.o
diff --git a/net/netfilter/nft_write.c b/net/netfilter/nft_write.c
new file mode 100644
index 0000000..2fd5608
--- /dev/null
+++ b/net/netfilter/nft_write.c
@@ -0,0 +1,160 @@
+/*
+ * Copyright (c) 2014 Nikolay Aleksandrov <nikolay@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+
+struct nft_write_expr {
+	enum nft_registers      sreg:8;
+	u32			offset;
+	u8			wlen;
+};
+
+static void nft_write_eval(const struct nft_expr *expr,
+			   struct nft_data data[NFT_REG_MAX + 1],
+			   const struct nft_pktinfo *pkt)
+{
+	struct nft_write_expr *priv = nft_expr_priv(expr);
+	struct nft_data *src = &data[priv->sreg];
+
+	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+	if (!skb_make_writable(pkt->skb, priv->offset+priv->wlen))
+		return;
+	pr_debug("Writing at %u : 0x%x len %u\n",
+		 priv->offset, src->data[0], priv->wlen);
+	memcpy(pkt->skb->data + priv->offset, src, priv->wlen);
+}
+
+static void nft_write_fast_eval(const struct nft_expr *expr,
+				struct nft_data data[NFT_REG_MAX + 1],
+				const struct nft_pktinfo *pkt)
+{
+	struct nft_write_expr *priv = nft_expr_priv(expr);
+	struct nft_data *src = &data[priv->sreg];
+	unsigned char *ptr;
+
+	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+	if (!skb_make_writable(pkt->skb, priv->offset+priv->wlen))
+		return;
+	ptr = pkt->skb->data + priv->offset;
+	pr_debug("Writing at %u : 0x%x len %u\n",
+		 priv->offset, src->data[0], priv->wlen);
+	if (priv->wlen == 4)
+		*(u32 *)ptr = *(u32 *)src->data;
+	else if (priv->wlen == 2)
+		*(u16 *)ptr = *(u16 *)src->data;
+	else
+		*(u8 *)ptr = *(u8 *)src->data;
+}
+
+
+static const struct nla_policy nft_write_policy[NFTA_WRITE_MAX + 1] = {
+	[NFTA_WRITE_SREG]		= { .type = NLA_U32 },
+	[NFTA_WRITE_OFFSET]		= { .type = NLA_U32 },
+	[NFTA_WRITE_WLEN]		= { .type = NLA_U8 },
+};
+
+static int nft_write_init(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nlattr * const tb[])
+{
+	struct nft_write_expr *priv = nft_expr_priv(expr);
+
+	priv->sreg = ntohl(nla_get_be32(tb[NFTA_WRITE_SREG]));
+	priv->wlen = nla_get_u8(tb[NFTA_WRITE_WLEN]);
+	priv->offset = ntohl(nla_get_be32(tb[NFTA_WRITE_OFFSET]));
+
+	return 0;
+}
+
+static int nft_write_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_write_expr *priv = nft_expr_priv(expr);
+
+	nla_put_be32(skb, NFTA_WRITE_SREG, htonl(priv->sreg));
+	nla_put_be32(skb, NFTA_WRITE_OFFSET, htonl(priv->offset));
+	nla_put_u8(skb, NFTA_WRITE_WLEN, priv->wlen);
+
+	return 0;
+}
+
+static struct nft_expr_type nft_write_type;
+static const struct nft_expr_ops nft_write_ops = {
+	.type		= &nft_write_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_write_expr)),
+	.eval		= nft_write_eval,
+	.init		= nft_write_init,
+	.dump		= nft_write_dump,
+};
+
+static const struct nft_expr_ops nft_write_fast_ops = {
+	.type		= &nft_write_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_write_expr)),
+	.eval		= nft_write_fast_eval,
+	.init		= nft_write_init,
+	.dump		= nft_write_dump,
+};
+
+static const struct nft_expr_ops *
+nft_write_select_ops(const struct nft_ctx *ctx,
+		     const struct nlattr * const tb[])
+{
+	enum nft_registers sreg;
+	u32 offset;
+	u8 wlen;
+	int err;
+
+	if (tb[NFTA_WRITE_OFFSET] == NULL ||
+	    tb[NFTA_WRITE_WLEN] == NULL ||
+	    tb[NFTA_WRITE_SREG] == NULL)
+		return ERR_PTR(-EINVAL);
+
+	wlen = nla_get_u8(tb[NFTA_WRITE_WLEN]);
+	if (wlen == 0 || wlen > FIELD_SIZEOF(struct nft_data, data))
+		return ERR_PTR(-EINVAL);
+	sreg = ntohl(nla_get_be32(tb[NFTA_WRITE_SREG]));
+	err = nft_validate_input_register(sreg);
+	if (err < 0)
+		return ERR_PTR(err);
+	offset = ntohl(nla_get_u32(tb[NFTA_WRITE_OFFSET]));
+
+	if (wlen != 3 && wlen <= 4 && IS_ALIGNED(offset, wlen))
+		return &nft_write_fast_ops;
+	else
+		return &nft_write_ops;
+}
+
+static struct nft_expr_type nft_write_type __read_mostly = {
+	.name		= "write",
+	.select_ops	= &nft_write_select_ops,
+	.policy		= nft_write_policy,
+	.maxattr	= NFTA_WRITE_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_write_module_init(void)
+{
+	return nft_register_expr(&nft_write_type);
+}
+
+static void __exit nft_write_module_exit(void)
+{
+	nft_unregister_expr(&nft_write_type);
+}
+
+module_init(nft_write_module_init);
+module_exit(nft_write_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Nikolay Aleksandrov <nikolay@redhat.com>");
+MODULE_ALIAS_NFT_EXPR("write");
-- 
1.8.4.2

