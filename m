Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521484;
	b=lf29HGJyiRbty/X8+TsxrBvHoZTTecaPuARHQ5eOJ3zDvyKX8+yj2n50weSHdyTZgOLV
	 FjOcAl5coM7tcfBUxcY7a5mnUFOBcQpwMjOFRQ6s8qrAh1AS72oq6lG10bco2Z2DHAnrs
	 X7qmbuws44fjKX/qLxPkKodCT9QB3bI5A91GQTrj411bUI+zrop38OvhD2XDLYOiRZMRo
	 URxr+euWJFoS1v4w2l+MoPFEjy/DvxCZ+u790vUKDs7n9y+q70ZCu3Q9FmTYkq6X9LnYE
	 nxtp0fuTp89bT+IBuBGjBITiyOkglRo8V/BaLEw3Ns5okqojqaqIvN2yZxiwLum71iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521484;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=PLDribXdiLfnsz1c6bMjU1+Iu6odvWQ+xgo2QJBYJbc=;
	b=XQTkjIKKGRSZplFRLePoA0hrn0nhFMvKqfhC3EGTUR6UZWxCZbV6HaGc0TwsuxmtTPsa
	 RUf0TEJ0ks2PKoDBYDL8i/gh2/rlraioTWgNwycqIAJiCbdNJCO4+5mmgtYKloHqg0k/l
	 bSW/ToHVAWU7YitlA9Ox3+mLgwDdfCbxlRttaFn0aRi6ZWDvJQOxuZCAEGeQ5iNXD4e9s
	 bLnuf8TJg8IC/4flpUTy+06oF3bMtkLWl2CMdpdS0XTVtko7fn32fuA5vwe8MowHa4PFD
	 Kmp8Rq+i/oQuA7vuvmdOL2uTTwDYJMNDdeYYmloYybKDu5UDSJYNkTc0tnx7/EGSoAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=EVnH6uwC;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC6B606A323
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:11:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BC6B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=EVnH6uwC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521480;
	bh=PLDribXdiLfnsz1c6bMjU1+Iu6odvWQ+xgo2QJBYJbc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=EVnH6uwC3zplNRTYL09X6RgKOpA5Ltwusng/Awyh2dVMH2BQ85tsAvECETEE8ethC
	 L378q8v9KImh28v/XJtwIT8vFINLmFUnGwwUX3pHyuGHVFsLKspVxBakBrLXPHkalf
	 sTAQFIL0Eb6DI88J+MOYUI3GrMJk2WvfOgVew7Gtul8b6gW9VqWtRURSmGFFQh5qgL
	 +yfQ2tTldPsL1vLyZq/+JYmVhosgYPYSten4SlLJcVn2m9B8H98HpymMZsanGjkacS
	 Mwdz5t/LuX4f3IW8uwDpzJYQbRCBlcYarqyD3Pxgsb3dkv0dwJ1iAMOFqMudZzhJd2
	 Q07Gyq6Dn8jIg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E17BB6007D
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:11:19 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 6/6] netfilter: nfnetlink_queue: do not skip ct confirmation with userspace ct helpers
Date: Thu, 12 Nov 2026 23:11:06 +0100
Message-ID: <20261112221106.2278789-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221106.2278789-1-pablo@netfilter.org>
References: <20261112221106.2278789-1-pablo@netfilter.org>
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
v7: fix compilation warning due to #ifdef dependencies.

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

