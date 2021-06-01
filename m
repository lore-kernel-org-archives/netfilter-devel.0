Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD89C47080
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79B1E613C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Jun 2021 22:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhFAWIT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Jun 2021 18:08:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39546 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbhFAWIS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Jun 2021 18:08:18 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DA17964194;
        Wed,  2 Jun 2021 00:05:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/16] netfilter: nft_exthdr: Support SCTP chunks
Date:   Wed,  2 Jun 2021 00:06:14 +0200
Message-Id: <20210601220629.18307-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210601220629.18307-1-pablo@netfilter.org>
References: <20210601220629.18307-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Chunks are SCTP header extensions similar in implementation to IPv6
extension headers or TCP options. Reusing exthdr expression to find and
extract field values from them is therefore pretty straightforward.

For now, this supports extracting data from chunks at a fixed offset
(and length) only - chunks themselves are an extensible data structure;
in order to make all fields available, a nested extension search is
needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nft_exthdr.c               | 51 ++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 1fb4ca18ffbb..19715e2679d1 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -813,11 +813,13 @@ enum nft_exthdr_flags {
  * @NFT_EXTHDR_OP_IPV6: match against ipv6 extension headers
  * @NFT_EXTHDR_OP_TCP: match against tcp options
  * @NFT_EXTHDR_OP_IPV4: match against ipv4 options
+ * @NFT_EXTHDR_OP_SCTP: match against sctp chunks
  */
 enum nft_exthdr_op {
 	NFT_EXTHDR_OP_IPV6,
 	NFT_EXTHDR_OP_TCPOPT,
 	NFT_EXTHDR_OP_IPV4,
+	NFT_EXTHDR_OP_SCTP,
 	__NFT_EXTHDR_OP_MAX
 };
 #define NFT_EXTHDR_OP_MAX	(__NFT_EXTHDR_OP_MAX - 1)
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index f64f0017e9a5..4d0b8e1c40c0 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -10,8 +10,10 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/sctp.h>
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
+#include <net/sctp/sctp.h>
 #include <net/tcp.h>
 
 struct nft_exthdr {
@@ -300,6 +302,43 @@ static void nft_exthdr_tcp_set_eval(const struct nft_expr *expr,
 	}
 }
 
+static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt)
+{
+	unsigned int offset = pkt->xt.thoff + sizeof(struct sctphdr);
+	struct nft_exthdr *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
+	const struct sctp_chunkhdr *sch;
+	struct sctp_chunkhdr _sch;
+
+	do {
+		sch = skb_header_pointer(pkt->skb, offset, sizeof(_sch), &_sch);
+		if (!sch || !sch->length)
+			break;
+
+		if (sch->type == priv->type) {
+			if (priv->flags & NFT_EXTHDR_F_PRESENT) {
+				nft_reg_store8(dest, true);
+				return;
+			}
+			if (priv->offset + priv->len > ntohs(sch->length) ||
+			    offset + ntohs(sch->length) > pkt->skb->len)
+				break;
+
+			dest[priv->len / NFT_REG32_SIZE] = 0;
+			memcpy(dest, (char *)sch + priv->offset, priv->len);
+			return;
+		}
+		offset += SCTP_PAD4(ntohs(sch->length));
+	} while (offset < pkt->skb->len);
+
+	if (priv->flags & NFT_EXTHDR_F_PRESENT)
+		nft_reg_store8(dest, false);
+	else
+		regs->verdict.code = NFT_BREAK;
+}
+
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
 	[NFTA_EXTHDR_DREG]		= { .type = NLA_U32 },
 	[NFTA_EXTHDR_TYPE]		= { .type = NLA_U8 },
@@ -499,6 +538,14 @@ static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
 	.dump		= nft_exthdr_dump_set,
 };
 
+static const struct nft_expr_ops nft_exthdr_sctp_ops = {
+	.type		= &nft_exthdr_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
+	.eval		= nft_exthdr_sctp_eval,
+	.init		= nft_exthdr_init,
+	.dump		= nft_exthdr_dump,
+};
+
 static const struct nft_expr_ops *
 nft_exthdr_select_ops(const struct nft_ctx *ctx,
 		      const struct nlattr * const tb[])
@@ -529,6 +576,10 @@ nft_exthdr_select_ops(const struct nft_ctx *ctx,
 				return &nft_exthdr_ipv4_ops;
 		}
 		break;
+	case NFT_EXTHDR_OP_SCTP:
+		if (tb[NFTA_EXTHDR_DREG])
+			return &nft_exthdr_sctp_ops;
+		break;
 	}
 
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.30.2

