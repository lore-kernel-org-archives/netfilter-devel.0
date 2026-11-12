Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521680;
	b=uyiAEg56TLBMJYjzVjEpCdLCkhLbMmjWdMmjTI1Y1ez2pieyAsF7Y+f0QdjDicEcy9gJ
	 92G1gRAb+2L0pKaatfcWtXWzC5l64GXZhg4QVFFLmM4h+JMkCVfpyKm1x/mu51poIVHBQ
	 Btdzzi97WobirZrhV7pVc4dm88ySv3nfSQnRSST4d/nujaTkg7GLOp6PjA2aSj/W4H+Fq
	 kooSdfCFK7sa6VsiPOwRPXu8Fe+W+0RQetHPtnbPk1yaGzOH9GFG4WqenEebpSwT23Xj0
	 Xi3UJ8VWDQcSvydlkvzgraVIbU6qos+MQpuMSAGkRCpxs/vf+gdnXzQghyM4PjCaREw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521680;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=m8rynb4BbJhMrnp8C9+m1bSH6F7fXIATCJJNGaeahEo=;
	b=tX3G1c7fubycg9nPtS259VzV8NG5xOZA19CK2fw4rfEJ+OMDNMS5qbfnEEUBkNUsCuiz
	 YhTbheCw6DTmbgDu9JtCCnV5gZdquTPkPZSJFT3UttqPOLTdaoFSS4oct7Bcj1EdaOlEa
	 5a2o8xHgTxdKywQyAoTO4pgk1PByK9NPQ1b75W1XD/F82Ks5ACfJ0sR6PF9Cb2MsaCVzE
	 rMcSDCZ/6uR2VHnc52qa7QXRrIHrpu1CUEhJqJSipNlJxdOXsiv54vyFaSA7DjHGsoLGg
	 39rGaGOuUD8B33ZMG1tikLhy+vAKqcFv8tBPg1rg20gPcctjqoK/O93nGkVbCeCd13w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fwLdSXn6;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41567606A331
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:14:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41567606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=fwLdSXn6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521678;
	bh=m8rynb4BbJhMrnp8C9+m1bSH6F7fXIATCJJNGaeahEo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=fwLdSXn62lmJb1UTpi0k1LCeRU20NPHQiJpgbrtBuHhqZ9IqogqrKPjhIp86e7/zM
	 49vjMZ1RjE7RjY9Ddn+YCNkXcOOz+f/w8wfR/gLPk1SdD5ealaNNxHEfuq4Ez2a86x
	 qIMg5pQvZU8oWo7jt7blXNlt4+hJo9s9XBKckecqrDRJqd7tGeEc4krPzK2MxsQPy0
	 BlLgKQNV27yVgngLQdYCe05LOBJijkKSXdZ8sDvGiIeouMMmPVUm2YvstpfDhkZMmL
	 ZrbVQPp/bgaPQLEH8JXQ6sKAzQepk/VBQpylefxCL0BC9JnXlR63xU/gnI0tarCd+J
	 ybtoelwu04C5g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A1B8760057
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:14:38 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 RESEND 7/7] netfilter: nfnetlink_queue: do not skip ct confirmation with userspace ct helpers
Date: Thu, 12 Nov 2026 23:14:29 +0100
Message-ID: <20261112221429.2279193-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221429.2279193-1-pablo@netfilter.org>
References: <20261112221429.2279193-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a two more issues with the existing userspace ct helpers:

- Disallow re-queueing packets in userspace ct helpers, none of the
  existing helper in userspace use this feature.

- nf_conntrack_update() should only be called if this is the confirmation
  hook, there is a new helper function to check this, use it.

While at this, nfqnl_reinject() is already called from a rcu read lock
section, remove the redundant rcu_read_{un,lock}().

Remove #ifdef around nfqnl_hook_exp_support() so this function can be
used regardless conntrack supported to address a compilation warning.

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: remove #ifdef to fix compilation warning due to dependencies

 net/netfilter/nfnetlink_queue.c | 45 +++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 3f6b38776ff8..4d5de657ef95 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -381,7 +381,6 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 	return &hooks->hooks[i];
 }
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
 {
 	return (ops->hook_ops_type == NF_HOOK_OP_CONNTRACK &&
@@ -392,7 +391,6 @@ static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
 		 (ops->pf == NFPROTO_BRIDGE &&
 		  ops->hooknum == NF_BR_POST_ROUTING)));
 }
-#endif
 
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry,
@@ -526,31 +524,46 @@ static void __nfqnl_reinject(struct nf_queue_entry *entry,
 			     const struct nf_hook_entries *hooks,
 			     unsigned int verdict)
 {
-	const struct nf_ct_hook *ct_hook;
+	unsigned int verdict_mask = verdict & NF_VERDICT_MASK;
 
 	if (!nf_bridge_ports_valid(entry))
-		verdict = NF_DROP;
+		goto drop;
+
+	if (verdict_mask == NF_ACCEPT ||
+	    verdict_mask == NF_REPEAT ||
+	    verdict_mask == NF_STOP ||
+	    verdict_mask == NF_QUEUE) {
+		const struct nf_ct_hook *ct_hook;
+		struct nf_hook_ops **ops;
+		unsigned int i;
+
+		ops = nf_hook_entries_get_hook_ops(hooks);
 
-	if (verdict == NF_ACCEPT ||
-	    verdict == NF_REPEAT ||
-	    verdict == NF_STOP) {
-		unsigned int ct_verdict = verdict;
+		i = entry->hook_index;
+		if (i >= hooks->num_hook_entries)
+			goto drop;
 
-		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
-		if (ct_hook)
-			ct_verdict = ct_hook->update(entry->state.net, entry->skb);
-		rcu_read_unlock();
+		if (ct_hook && nfqnl_hook_exp_support(ops[i])) {
+			if (verdict_mask == NF_QUEUE ||
+			    verdict_mask == NF_REPEAT)
+				goto drop;
 
-		switch (ct_verdict & NF_VERDICT_MASK) {
+			verdict_mask = ct_hook->update(entry->state.net, entry->skb);
+		}
+
+		switch (verdict_mask) {
 		case NF_ACCEPT:
 			/* follow userspace verdict, could be REPEAT */
 			break;
 		case NF_STOLEN:
 			nf_queue_entry_free(entry);
 			return;
+		case NF_QUEUE:
+			/* follow userspace verdict too */
+			break;
 		default:
-			verdict = ct_verdict & NF_VERDICT_MASK;
+			verdict = verdict_mask;
 			break;
 		}
 	}
@@ -572,6 +585,10 @@ static void __nfqnl_reinject(struct nf_queue_entry *entry,
 			verdict = NF_DROP;
 	}
 	nf_reinject(entry, hooks, verdict);
+	return;
+drop:
+	kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 static void nfqnl_reinject(struct nf_queue_entry *entry,
-- 
2.47.3

