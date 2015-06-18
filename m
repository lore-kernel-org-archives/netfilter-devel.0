From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nft_counter: add per-cpu support
Date: Thu, 18 Jun 2015 20:21:37 +0200
Message-ID: <1434651697-9905-2-git-send-email-pablo@netfilter.org>
References: <1434651697-9905-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46186 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705AbbFRSQV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2015 14:16:21 -0400
In-Reply-To: <1434651697-9905-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds rule per-cpu counters. This introduces a new NFTA_COUNTER_TYPE
netlink attribute to indicate the type of counters to be used. The default is
the compact seqlock representation for compatibility.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   14 ++++
 net/netfilter/nft_counter.c              |  129 +++++++++++++++++++++++++++++-
 2 files changed, 139 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index a99e6a9..da3b505 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -771,15 +771,29 @@ enum nft_limit_attributes {
 #define NFTA_LIMIT_MAX		(__NFTA_LIMIT_MAX - 1)
 
 /**
+ * enum nft_counter_types - nf_tables counter types
+ *
+ * @NFT_COUNTER_DEFAULT: default seqlock counter
+ * @NFT_COUNTER_PERCPU: percpu counter
+ */
+enum nft_counter_types {
+	NFT_COUNTER_DEFAULT	= 0,
+	NFT_COUNTER_PERCPU,
+	NFT_COUNTER_MAX
+};
+
+/**
  * enum nft_counter_attributes - nf_tables counter expression netlink attributes
  *
  * @NFTA_COUNTER_BYTES: number of bytes (NLA_U64)
  * @NFTA_COUNTER_PACKETS: number of packets (NLA_U64)
+ * @NFTA_COUNTER_TYPE: counter type (NLA_U32: nft_counter_types)
  */
 enum nft_counter_attributes {
 	NFTA_COUNTER_UNSPEC,
 	NFTA_COUNTER_BYTES,
 	NFTA_COUNTER_PACKETS,
+	NFTA_COUNTER_TYPE,
 	__NFTA_COUNTER_MAX
 };
 #define NFTA_COUNTER_MAX	(__NFTA_COUNTER_MAX - 1)
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index ad78fda..6fcb0e9d 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -52,9 +52,9 @@ static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		packets	= priv->counter.packets;
 	} while (read_seqretry(&priv->lock, seq));
 
-	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(bytes)))
-		goto nla_put_failure;
-	if (nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(packets)))
+	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(packets)) ||
+	    nla_put_be32(skb, NFTA_COUNTER_TYPE, htonl(NFT_COUNTER_DEFAULT)))
 		goto nla_put_failure;
 	return 0;
 
@@ -65,6 +65,7 @@ nla_put_failure:
 static const struct nla_policy nft_counter_policy[NFTA_COUNTER_MAX + 1] = {
 	[NFTA_COUNTER_PACKETS]	= { .type = NLA_U64 },
 	[NFTA_COUNTER_BYTES]	= { .type = NLA_U64 },
+	[NFTA_COUNTER_TYPE]	= { .type = NLA_U32 },
 };
 
 static int nft_counter_init(const struct nft_ctx *ctx,
@@ -93,9 +94,129 @@ static const struct nft_expr_ops nft_counter_ops = {
 	.dump		= nft_counter_dump,
 };
 
+struct nft_counter_percpu_priv {
+	struct nft_counter_percpu __percpu *counter;
+};
+
+struct nft_counter_percpu {
+	struct nft_counter	counter;
+	struct u64_stats_sync	syncp;
+};
+
+static int nft_counter_percpu_init(const struct nft_ctx *ctx,
+				   const struct nft_expr *expr,
+				   const struct nlattr * const tb[])
+{
+	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+	struct nft_counter_percpu __percpu *cpu_stats;
+	struct nft_counter_percpu *this_cpu;
+
+	cpu_stats = netdev_alloc_pcpu_stats(struct nft_counter_percpu);
+	if (cpu_stats == NULL)
+		return ENOMEM;
+
+	preempt_disable();
+	this_cpu = this_cpu_ptr(cpu_stats);
+	if (tb[NFTA_COUNTER_PACKETS]) {
+	        this_cpu->counter.packets =
+			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+	}
+	if (tb[NFTA_COUNTER_BYTES]) {
+		this_cpu->counter.bytes =
+			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
+	}
+	preempt_enable();
+
+	priv->counter = cpu_stats;
+
+	return 0;
+}
+
+static void nft_counter_percpu_destroy(const struct nft_ctx *ctx,
+				       const struct nft_expr *expr)
+{
+	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+
+	free_percpu(priv->counter);
+}
+
+static void nft_counter_percpu_eval(const struct nft_expr *expr,
+				    struct nft_regs *regs,
+				    const struct nft_pktinfo *pkt)
+{
+	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+	struct nft_counter_percpu *this_cpu;
+
+	this_cpu = this_cpu_ptr(priv->counter);
+	this_cpu->counter.bytes += pkt->skb->len;
+	this_cpu->counter.packets++;
+}
+
+static int nft_counter_percpu_dump(struct sk_buff *skb,
+				   const struct nft_expr *expr)
+{
+	struct nft_counter_percpu_priv *priv = nft_expr_priv(expr);
+	struct nft_counter_percpu *cpu_stats;
+	struct nft_counter total;
+	u64 bytes, packets;
+	unsigned int seq;
+	int cpu;
+
+	memset(&total, 0, sizeof(total));
+	for_each_possible_cpu(cpu) {
+		cpu_stats = per_cpu_ptr(priv->counter, cpu);
+		do {
+			bytes	= cpu_stats->counter.bytes;
+			packets	= cpu_stats->counter.packets;
+		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, seq));
+
+		total.packets += packets;
+		total.bytes += bytes;
+	}
+
+	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(total.bytes)) ||
+	    nla_put_be64(skb, NFTA_COUNTER_PACKETS, cpu_to_be64(total.packets)) ||
+	    nla_put_be32(skb, NFTA_COUNTER_TYPE, htonl(NFT_COUNTER_PERCPU)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nft_expr_ops nft_counter_percpu_ops = {
+	.type		= &nft_counter_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_counter_percpu_priv)),
+	.eval		= nft_counter_percpu_eval,
+	.init		= nft_counter_percpu_init,
+	.destroy	= nft_counter_percpu_destroy,
+	.dump		= nft_counter_percpu_dump,
+};
+
+static const struct nft_expr_ops *
+nft_counter_select_ops(const struct nft_ctx *ctx,
+		       const struct nlattr * const tb[])
+{
+	u32 type;
+
+	if (tb[NFTA_COUNTER_TYPE]) {
+		type = ntohl(nla_get_be32(tb[NFTA_COUNTER_TYPE]));
+		switch (type) {
+		case NFT_COUNTER_DEFAULT:
+			return &nft_counter_ops;
+		case NFT_COUNTER_PERCPU:
+			return &nft_counter_percpu_ops;
+		default:
+			return ERR_PTR(-EINVAL);
+		}
+	}
+	return &nft_counter_ops;
+}
+
 static struct nft_expr_type nft_counter_type __read_mostly = {
 	.name		= "counter",
-	.ops		= &nft_counter_ops,
+	.select_ops	= &nft_counter_select_ops,
 	.policy		= nft_counter_policy,
 	.maxattr	= NFTA_COUNTER_MAX,
 	.flags		= NFT_EXPR_STATEFUL,
-- 
1.7.10.4

