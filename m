From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_queue: add _SREG_FROM and _SRGE_TO to select the queue numbers
Date: Sun, 11 Sep 2016 22:05:28 +0800
Message-ID: <1473602728-33502-2-git-send-email-zlpnobody@163.com>
References: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:41462 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755780AbcIKOGH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Sep 2016 10:06:07 -0400
In-Reply-To: <1473602728-33502-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Currently, the user can specify the queue numbers by _QUEUE_NUM and
_QUEUE_TOTAL attributes, this is enough in most situations.

But acctually, it is not very flexible, for example:
  tcp dport 80 mapped to queue0
  tcp dport 81 mapped to queue1
  tcp dport 82 mapped to queue2
In order to do this thing, we must add 3 nft rules, and more
mapping means more rules ...

So similer to nft_nat, take two registers to select the queue numbers,
then we can add one simple rule to mapping queues, maybe like this:
  queue num tcp dport map { 80:0, 81:1, 82:2 ... }

Another drawback is that queue range 0-65535 is not available, because
queue_total is u16 type, range 0-65535 means queue_total is 65536, then
it is overflowed to 0. Now there's no such restriction when we use
_SREG_FROM and _SREG_TO.

For compatibility, _SREG_FROM and _QUEUE_NUM can be specified at the same
time, but we will be preferred to use _SREG_FROM attr.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 ++
 net/netfilter/nft_queue.c                | 99 +++++++++++++++++++++++++-------
 2 files changed, 82 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 24161e2..5b4e373 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -886,12 +886,16 @@ enum nft_log_attributes {
  * @NFTA_QUEUE_NUM: netlink queue to send messages to (NLA_U16)
  * @NFTA_QUEUE_TOTAL: number of queues to load balance packets on (NLA_U16)
  * @NFTA_QUEUE_FLAGS: various flags (NLA_U16)
+ * @NFTA_QUEUE_SREG_FROM: source register of queue number start (NLA_U32: nft_registers)
+ * @NFTA_QUEUE_SREG_TO: source register of queue number end (NLA_U32: nft_registers)
  */
 enum nft_queue_attributes {
 	NFTA_QUEUE_UNSPEC,
 	NFTA_QUEUE_NUM,
 	NFTA_QUEUE_TOTAL,
 	NFTA_QUEUE_FLAGS,
+	NFTA_QUEUE_SREG_FROM,
+	NFTA_QUEUE_SREG_TO,
 	__NFTA_QUEUE_MAX
 };
 #define NFTA_QUEUE_MAX		(__NFTA_QUEUE_MAX - 1)
diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index d16d599..6557118 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -22,9 +22,11 @@
 static u32 jhash_initval __read_mostly;
 
 struct nft_queue {
-	u16	queuenum;
-	u16	queues_total;
-	u16	flags;
+	enum nft_registers	sreg_from:8;
+	enum nft_registers	sreg_to:8;
+	u16			queuenum;
+	u16			queues_total;
+	u16			flags;
 };
 
 static void nft_queue_eval(const struct nft_expr *expr,
@@ -32,17 +34,30 @@ static void nft_queue_eval(const struct nft_expr *expr,
 			   const struct nft_pktinfo *pkt)
 {
 	struct nft_queue *priv = nft_expr_priv(expr);
-	u32 queue = priv->queuenum;
+	u32 queue, queues_total, queue_end;
 	u32 ret;
 
-	if (priv->queues_total > 1) {
+	if (priv->sreg_from) {
+		queue = (u16)regs->data[priv->sreg_from];
+		queue_end = (u16)regs->data[priv->sreg_to];
+
+		if (queue_end > queue)
+			queues_total = queue_end - queue + 1;
+		else
+			queues_total = 1;
+	} else {
+		queue = priv->queuenum;
+		queues_total = priv->queues_total;
+	}
+
+	if (queues_total > 1) {
 		if (priv->flags & NFT_QUEUE_FLAG_CPU_FANOUT) {
 			int cpu = smp_processor_id();
 
-			queue = priv->queuenum + cpu % priv->queues_total;
+			queue += cpu % queues_total;
 		} else {
 			queue = nfqueue_hash(pkt->skb, queue,
-					     priv->queues_total, pkt->pf,
+					     queues_total, pkt->pf,
 					     jhash_initval);
 		}
 	}
@@ -58,6 +73,8 @@ static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
 	[NFTA_QUEUE_NUM]	= { .type = NLA_U16 },
 	[NFTA_QUEUE_TOTAL]	= { .type = NLA_U16 },
 	[NFTA_QUEUE_FLAGS]	= { .type = NLA_U16 },
+	[NFTA_QUEUE_SREG_FROM]	= { .type = NLA_U32 },
+	[NFTA_QUEUE_SREG_TO]	= { .type = NLA_U32 },
 };
 
 static int nft_queue_init(const struct nft_ctx *ctx,
@@ -66,30 +83,58 @@ static int nft_queue_init(const struct nft_ctx *ctx,
 {
 	struct nft_queue *priv = nft_expr_priv(expr);
 	u32 maxid;
+	int err;
 
-	if (tb[NFTA_QUEUE_NUM] == NULL)
+	if (!tb[NFTA_QUEUE_NUM] && !tb[NFTA_QUEUE_SREG_FROM])
 		return -EINVAL;
 
 	init_hashrandom(&jhash_initval);
-	priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
 
-	if (tb[NFTA_QUEUE_TOTAL] != NULL)
-		priv->queues_total = ntohs(nla_get_be16(tb[NFTA_QUEUE_TOTAL]));
-	else
-		priv->queues_total = 1;
+	/* nftables has no idea whether the kernel supports _SREG_FROM or not,
+	 * so for compatibility reason, it may specify the _SREG_FROM and
+	 * _QUEUE_NUM attributes at the same time. We prefer to use _SREG_FROM,
+	 * it is more flexible and has less restriction, for example, queue
+	 * range 0-65535 is ok when use _SREG_FROM and _SREG_TO.
+	 */
+	if (tb[NFTA_QUEUE_SREG_FROM]) {
+		priv->sreg_from = nft_parse_register(tb[NFTA_QUEUE_SREG_FROM]);
+		err = nft_validate_register_load(priv->sreg_from, sizeof(u16));
+		if (err < 0)
+			return err;
+
+		if (tb[NFTA_QUEUE_SREG_TO]) {
+			priv->sreg_to =
+				nft_parse_register(tb[NFTA_QUEUE_SREG_TO]);
+			err = nft_validate_register_load(priv->sreg_to,
+							 sizeof(u16));
+			if (err < 0)
+				return err;
+		} else {
+			priv->sreg_to = priv->sreg_from;
+		}
+	} else if (tb[NFTA_QUEUE_NUM]) {
+		priv->queuenum = ntohs(nla_get_be16(tb[NFTA_QUEUE_NUM]));
 
-	if (priv->queues_total == 0)
-		return -EINVAL;
+		if (tb[NFTA_QUEUE_TOTAL])
+			priv->queues_total =
+				ntohs(nla_get_be16(tb[NFTA_QUEUE_TOTAL]));
+		else
+			priv->queues_total = 1;
 
-	maxid = priv->queues_total - 1 + priv->queuenum;
-	if (maxid > U16_MAX)
-		return -ERANGE;
+		if (priv->queues_total == 0)
+			return -EINVAL;
+
+		maxid = priv->queues_total - 1 + priv->queuenum;
+		if (maxid > U16_MAX)
+			return -ERANGE;
+	}
 
 	if (tb[NFTA_QUEUE_FLAGS] != NULL) {
 		priv->flags = ntohs(nla_get_be16(tb[NFTA_QUEUE_FLAGS]));
 		if (priv->flags & ~NFT_QUEUE_FLAG_MASK)
 			return -EINVAL;
 	}
+
 	return 0;
 }
 
@@ -97,9 +142,21 @@ static int nft_queue_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_queue *priv = nft_expr_priv(expr);
 
-	if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)) ||
-	    nla_put_be16(skb, NFTA_QUEUE_TOTAL, htons(priv->queues_total)) ||
-	    nla_put_be16(skb, NFTA_QUEUE_FLAGS, htons(priv->flags)))
+	if (priv->sreg_from) {
+		if (nft_dump_register(skb, NFTA_QUEUE_SREG_FROM,
+				      priv->sreg_from))
+			goto nla_put_failure;
+		if (nft_dump_register(skb, NFTA_QUEUE_SREG_TO,
+				      priv->sreg_to))
+			goto nla_put_failure;
+	} else {
+		if (nla_put_be16(skb, NFTA_QUEUE_NUM, htons(priv->queuenum)) ||
+		    nla_put_be16(skb, NFTA_QUEUE_TOTAL,
+				 htons(priv->queues_total)))
+			goto nla_put_failure;
+	}
+
+	if (nla_put_be16(skb, NFTA_QUEUE_FLAGS, htons(priv->flags)))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.5.5


