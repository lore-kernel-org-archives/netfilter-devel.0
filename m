Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316014;
	b=avofeE99OK/3cYg+duvuEFLErGDIA52tfJBfOuVRevZSfpoEzEQO42eiRKuZHVgjoMJd
	 lg/IJvDpjiJpBA83HxqatGmJH+5sHUhpAeC89Y9fyEmQXnTIT3sixNZEPDoH8kGoU8Q56
	 0Cex4I5/6AG3p0vri7i3TekLdCtxzkAJtRhdXFZVfKugoLnx0DwuIgx1D2KwzXjGud/+X
	 8g9LUjW0IyhAzGGESpGV5qUaAEt929qM/NmE9LReAtp6eQKt6l7MrOc7YdciHdbAV258u
	 rrdDIiuWhAWb8ksBXHqlWdMfwI7iGXloTmjrkiSUHkCGbdk/JUCb5S12OvNP+bM1ZCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316014;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=Uy/k4dRvDh5j77pCh3wBpEApcgQoabusPpTZZfVJ0cA=;
	b=trS2P6AHZ2An24NKNYLTQ05/xkrgosLelh2jJjXZaiN70Fp2WqXvJbfThvTLMl5rQQhn
	 jRed5QUKhrFp2ZewSLQBpbC1pIjU4mVTzcbXAbLBwe++PTqTzDGReECLXCdDguQHDfMjD
	 MqrLo4nXSKzhBgNq99z5e+ssG2VyDgyq09kBmoinI/O+uBJuAgtTFtgfGnDV8nOxT0YAV
	 5JGYW20l0E1KrTCCzBd0YY4YLf72plcMsvlDbX1uDLJT9hOX1kEU2ZG7yxt8aM1Q+a1Fd
	 8POVErlTNJZJITyqedZ+A6fHby/FRYri1vlmsNwsiSEmzCNuKyHD5wlcsObGoJ2adCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ijbbosKa;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5F7606BFD3
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C5F7606BFD3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ijbbosKa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794316005;
	bh=Uy/k4dRvDh5j77pCh3wBpEApcgQoabusPpTZZfVJ0cA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ijbbosKaaGm6x6LbeJ11NxIuATYgPLWXuoJCgMuIQu5O7V7UsueWzzXa8A8xDnG6j
	 prdvGsUGQ0kZMS1Ea7cgMPjV5La2rGwaDNl3srqh0Xqiy1sG7w9Q98JxPkb3XfkB1Z
	 zZx2ko1LoBWFD71qug6M2n0vkgsxCVee2Mhf6ZSs6kNP9NdxFJuQbc1fNEZW8eEYMr
	 +7rgtlzMksouSf8eRi/RD9sP1W3EQYM5z6pPUjNMVW6RrNwZu+uQjgbZOl7m3dvtGe
	 +BFUPqkiKCVeXWe4eUMQWdDTWMc6oOZT4MdvFxqGu5/GZQ+0+04C015SdqML+57JEY
	 Fa1CIhFI+0Eqg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 96061605D3
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:06:45 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 5/5] netfilter: nfnetlink_queue: do not skip ct confirmation with userspace ct helpers
Date: Tue, 10 Nov 2026 14:06:37 +0100
Message-ID: <20261110130637.1832292-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110130637.1832292-1-pablo@netfilter.org>
References: <20261110130637.1832292-1-pablo@netfilter.org>
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

There are two more issues with the existing userspace ct helpers:

- A custom userspace ct helper could return an unexpected verdict could
  result in skipping the conntrack confirmation step.

- nf_conntrack_update() should only be called if this is the confirmation
  hook, there is a new helper function to check this, use it.

While at this, nfqnl_reinject() is already called from a rcu read lock
section, remove the redundant rcu_read_{un,lock}().

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: new in this series.

    LLM is barfing at something else in this core, not pointing to the root cause,
    let's see if this is enough to address it.

 net/netfilter/nfnetlink_queue.c | 58 ++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 36667a803426..eb360e612485 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -395,10 +395,11 @@ static bool nfqnl_hook_exp_support(struct nf_hook_ops *ops)
 #endif
 
 /* caller must hold rcu read-side lock */
-static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+static void nf_reinject(struct nf_queue_entry *entry,
+			const struct nf_hook_entries *hooks,
+			unsigned int verdict)
 {
 	const struct nf_hook_entry *hook_entry;
-	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
 	bool old_in_nf_duplicate;
 	unsigned int i;
@@ -413,13 +414,6 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	current->in_nf_duplicate = entry->in_nf_duplicate;
 
-	hooks = nf_queue_hook_entries(entry);
-	if (!hooks) {
-		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
-		nf_queue_entry_free(entry);
-		goto out;
-	}
-
 	hook_entry = nf_queue_hook_entry(hooks, entry);
 	if (!hook_entry) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
@@ -528,25 +522,39 @@ static bool nf_bridge_ports_valid(const struct nf_queue_entry *entry)
 	return true;
 }
 
-static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+static void nfqnl_reinject(struct nf_queue_entry *entry,
+			   unsigned int verdict)
 {
+	unsigned int verdict_mask = verdict & NF_VERDICT_MASK;
+	const struct nf_hook_entries *hooks;
 	const struct nf_ct_hook *ct_hook;
+	struct nf_hook_ops **ops;
+	unsigned int i;
+
+	hooks = nf_queue_hook_entries(entry);
+	if (!hooks)
+		goto drop;
 
 	if (!nf_bridge_ports_valid(entry))
 		verdict = NF_DROP;
 
-	if (verdict == NF_ACCEPT ||
-	    verdict == NF_REPEAT ||
-	    verdict == NF_STOP) {
-		unsigned int ct_verdict = verdict;
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+	if (verdict_mask == NF_ACCEPT ||
+	    verdict_mask == NF_REPEAT ||
+	    verdict_mask == NF_STOP) {
+		ops = nf_hook_entries_get_hook_ops(hooks);
+		if (!ops)
+			goto drop;
+
+		i = entry->hook_index;
+		if (i >= hooks->num_hook_entries)
+			goto drop;
 
-		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
-		if (ct_hook)
-			ct_verdict = ct_hook->update(entry->state.net, entry->skb);
-		rcu_read_unlock();
+		if (ct_hook && nfqnl_hook_exp_support(ops[i]))
+			verdict_mask = ct_hook->update(entry->state.net, entry->skb);
 
-		switch (ct_verdict & NF_VERDICT_MASK) {
+		switch (verdict_mask & NF_VERDICT_MASK) {
 		case NF_ACCEPT:
 			/* follow userspace verdict, could be REPEAT */
 			break;
@@ -554,12 +562,12 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 			nf_queue_entry_free(entry);
 			return;
 		default:
-			verdict = ct_verdict & NF_VERDICT_MASK;
+			verdict = verdict_mask & NF_VERDICT_MASK;
 			break;
 		}
 	}
-
-	if (verdict != NF_DROP && entry->nf_ct_is_unconfirmed) {
+#endif
+	if (verdict_mask != NF_DROP && entry->nf_ct_is_unconfirmed) {
 		/* If first queued segment was already reinjected then
 		 * there is a good chance the ct entry is now confirmed.
 		 *
@@ -575,8 +583,12 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		if (nf_ct_drop_unconfirmed(entry, NULL))
 			verdict = NF_DROP;
 	}
+	nf_reinject(entry, hooks, verdict);
 
-	nf_reinject(entry, verdict);
+	return;
+drop:
+	kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 static void
-- 
2.47.3

