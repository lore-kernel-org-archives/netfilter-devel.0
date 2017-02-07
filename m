From: Manuel Messner <mm@skelett.io>
Subject: [PATCH nf-next 1/1] net: netfilter: nft_exthdr: add TCP option matching
Date: Tue,  7 Feb 2017 03:14:53 +0100
Message-ID: <20170207021453.22541-2-mm@skelett.io>
References: <20170207021453.22541-1-mm@skelett.io>
Cc: fw@strlen.de, mm@skelett.io
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ox.registrar-servers.com ([199.188.203.174]:41620 "EHLO
        relay.ox.registrar-servers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751524AbdBGCTw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:19:52 -0500
Received: from MTA-06-3.privateemail.com (mta-06-3.privateemail.com [198.54.127.59])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay.ox.registrar-servers.com (Postfix) with ESMTPS id 96A2FB02BA
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 21:15:07 -0500 (EST)
In-Reply-To: <20170207021453.22541-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch implements the kernel side of the TCP option patch.

Signed-off-by: Manuel Messner <mm@skelett.io>
Reviewed-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter/nf_tables.h |  17 ++++-
 net/netfilter/Kconfig                    |   4 +-
 net/netfilter/nft_exthdr.c               | 120 +++++++++++++++++++++++++++----
 3 files changed, 125 insertions(+), 16 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b00a05d1ee56..6c0c9efddad6 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -705,12 +705,13 @@ enum nft_payload_attributes {
 #define NFTA_PAYLOAD_MAX	(__NFTA_PAYLOAD_MAX - 1)
 
 /**
- * enum nft_exthdr_attributes - nf_tables IPv6 extension header expression netlink attributes
+ * enum nft_exthdr_attributes - nf_tables extension header expression netlink attributes
  *
  * @NFTA_EXTHDR_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_EXTHDR_TYPE: extension header type (NLA_U8)
  * @NFTA_EXTHDR_OFFSET: extension header offset (NLA_U32)
  * @NFTA_EXTHDR_LEN: extension header length (NLA_U32)
+ * @NFTA_EXTHDR_OP: option match type (NLA_U8)
  */
 enum nft_exthdr_attributes {
 	NFTA_EXTHDR_UNSPEC,
@@ -718,11 +719,25 @@ enum nft_exthdr_attributes {
 	NFTA_EXTHDR_TYPE,
 	NFTA_EXTHDR_OFFSET,
 	NFTA_EXTHDR_LEN,
+	NFTA_EXTHDR_OP,
 	__NFTA_EXTHDR_MAX
 };
 #define NFTA_EXTHDR_MAX		(__NFTA_EXTHDR_MAX - 1)
 
 /**
+ * enum nft_exthdr_op - nf_tables match options
+ *
+ * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
+ * @NFT_EXTHDR_OP_TCP: match against tcp options
+ */
+enum nft_exthdr_op {
+	NFT_EXTHDR_OP_IPV6,
+	NFT_EXTHDR_OP_TCPOPT,
+	__NFT_EXTHDR_OP_MAX
+};
+#define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
+
+/**
  * enum nft_meta_keys - nf_tables meta expression keys
  *
  * @NFT_META_LEN: packet length (skb->len)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c69eee3a0e54..e44c0e1ec0c5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -467,10 +467,10 @@ config NF_TABLES_NETDEV
 	  This option enables support for the "netdev" table.
 
 config NFT_EXTHDR
-	tristate "Netfilter nf_tables IPv6 exthdr module"
+	tristate "Netfilter nf_tables exthdr module"
 	help
 	  This option adds the "exthdr" expression that you can use to match
-	  IPv6 extension headers.
+	  IPv6 extension headers and tcp options.
 
 config NFT_META
 	tristate "Netfilter nf_tables meta module"
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 47beb3abcc9d..bc6518a8fe6c 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -15,19 +15,28 @@
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
-// FIXME:
-#include <net/ipv6.h>
+#include <net/tcp.h>
 
 struct nft_exthdr {
 	u8			type;
 	u8			offset;
 	u8			len;
+	u8			op;
 	enum nft_registers	dreg:8;
 };
 
-static void nft_exthdr_eval(const struct nft_expr *expr,
-			    struct nft_regs *regs,
-			    const struct nft_pktinfo *pkt)
+static unsigned int optlen(const u8 *opt, unsigned int offset)
+{
+	/* Beware zero-length options: make finite progress */
+	if (opt[offset] <= TCPOPT_NOP || opt[offset + 1] == 0)
+		return 1;
+	else
+		return opt[offset + 1];
+}
+
+static void nft_exthdr_ipv6_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
 	u32 *dest = &regs->data[priv->dreg];
@@ -47,11 +56,59 @@ static void nft_exthdr_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static void nft_exthdr_tcp_eval(const struct nft_expr *expr,
+				struct nft_regs *regs,
+				const struct nft_pktinfo *pkt)
+{
+	u8 buff[sizeof(struct tcphdr) + MAX_TCP_OPTION_SPACE];
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	unsigned int i, optl, tcphdr_len, offset;
+	u32 *dest = &regs->data[priv->dreg];
+	struct tcphdr *tcph;
+	u8 *opt;
+
+	if (!pkt->tprot_set || pkt->tprot != IPPROTO_TCP)
+		goto err;
+
+	tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, sizeof(*tcph), buff);
+	if (!tcph)
+		goto err;
+
+	tcphdr_len = __tcp_hdrlen(tcph);
+	if (tcphdr_len < sizeof(*tcph))
+		goto err;
+
+	tcph = skb_header_pointer(pkt->skb, pkt->xt.thoff, tcphdr_len, buff);
+	if (!tcph)
+		goto err;
+
+	opt = (u8 *)tcph;
+	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
+		optl = optlen(opt, i);
+
+		if (priv->type != opt[i])
+			continue;
+
+		if (i + optl > tcphdr_len || priv->len + priv->offset > optl)
+			goto err;
+
+		offset = i + priv->offset;
+		dest[priv->len / NFT_REG32_SIZE] = 0;
+		memcpy(dest, opt + offset, priv->len);
+
+		return;
+	}
+
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_DREG]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
 	[NFTA_EXTHDR_OFFSET]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_LEN]		= { .type = NLA_U32 },
+	[NFTA_EXTHDR_OP]		= { .type = NLA_U32 },
 };
 
 static int nft_exthdr_init(const struct nft_ctx *ctx,
@@ -59,13 +116,13 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 			   const struct nlattr * const tb[])
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	u32 offset, len;
+	u32 offset, len, op = NFT_EXTHDR_OP_IPV6;
 	int err;
 
-	if (tb[NFTA_EXTHDR_DREG] == NULL ||
-	    tb[NFTA_EXTHDR_TYPE] == NULL ||
-	    tb[NFTA_EXTHDR_OFFSET] == NULL ||
-	    tb[NFTA_EXTHDR_LEN] == NULL)
+	if (!tb[NFTA_EXTHDR_DREG] ||
+	    !tb[NFTA_EXTHDR_TYPE] ||
+	    !tb[NFTA_EXTHDR_OFFSET] ||
+	    !tb[NFTA_EXTHDR_LEN])
 		return -EINVAL;
 
 	err = nft_parse_u32_check(tb[NFTA_EXTHDR_OFFSET], U8_MAX, &offset);
@@ -76,10 +133,17 @@ static int nft_exthdr_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_EXTHDR_OP]) {
+		err = nft_parse_u32_check(tb[NFTA_EXTHDR_OP], U8_MAX, &op);
+		if (err < 0)
+			return err;
+	}
+
 	priv->type   = nla_get_u8(tb[NFTA_EXTHDR_TYPE]);
 	priv->offset = offset;
 	priv->len    = len;
 	priv->dreg   = nft_parse_register(tb[NFTA_EXTHDR_DREG]);
+	priv->op     = op;
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, priv->len);
@@ -97,6 +161,8 @@ static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_EXTHDR_LEN, htonl(priv->len)))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_EXTHDR_OP, htonl(priv->op)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
@@ -104,17 +170,45 @@ static int nft_exthdr_dump(struct sk_buff *skb, const struct nft_expr *expr)
 }
 
 static struct nft_expr_type nft_exthdr_type;
-static const struct nft_expr_ops nft_exthdr_ops = {
+static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
-	.eval		= nft_exthdr_eval,
+	.eval		= nft_exthdr_ipv6_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
 };
 
+static const struct nft_expr_ops nft_exthdr_tcp_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
+	.eval		= nft_exthdr_tcp_eval,
+	.init		= nft_exthdr_init,
+	.dump		= nft_exthdr_dump,
+};
+
+static const struct nft_expr_ops *
+nft_exthdr_select_ops(const struct nft_ctx *ctx,
+		      const struct nlattr * const tb[])
+{
+	u32 op;
+
+	if (!tb[NFTA_EXTHDR_OP])
+		return &nft_exthdr_ipv6_ops;
+
+	op = ntohl(nla_get_u32(tb[NFTA_EXTHDR_OP]));
+	switch (op) {
+	case NFT_EXTHDR_OP_TCPOPT:
+		return &nft_exthdr_tcp_ops;
+	case NFT_EXTHDR_OP_IPV6:
+		return &nft_exthdr_ipv6_ops;
+	}
+
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static struct nft_expr_type nft_exthdr_type __read_mostly = {
 	.name		= "exthdr",
-	.ops		= &nft_exthdr_ops,
+	.select_ops	= &nft_exthdr_select_ops,
 	.policy		= nft_exthdr_policy,
 	.maxattr	= NFTA_EXTHDR_MAX,
 	.owner		= THIS_MODULE,
-- 
2.11.1

