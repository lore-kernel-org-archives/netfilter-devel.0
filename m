Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F93A3D1AB3
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 19:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622323; cv=none; b=DF9qPqXQX1+HI6uPmnSulze0qxuTJ0BGxLsiIx4tRiGIGicRZZ/Odl8q0EIecv+mescf+moCW8hfwx8VM067OFB80JaEx/O6D3yNGXAxmrTnl3IoNFQAUxt/kb3gbRPZTTsR6a5bCDdeJSHOCcDHGNczbimDJ9bWTKRTX8FW2sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622323; c=relaxed/simple;
	bh=LumScKC7jVGo9IL3A9IK7uSBjJ1KCDpd5dIdi12ryxg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=nDnTv1hUczPjVrbsMLbQ4/GuCJJU2IcLSgUzfQ/zEhqbcOiCHA43w439wdkIavIs0Y4johYENlaNgUeHbTquhNqN8F0WczSN0W9M/Aew2A4KDAS0l6QC6bC3iFjRnIWGRzIIJuOa5hpMsRUeh0b18QD1pDknB0kw4J3uKvoU8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLoLnQyI; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLoLnQyI"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49ccfad90f1so27207265e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 12:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790622319; x=1791227119; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W9kEsawsuSStnMVhaHw2fC3OIOfm5OwpFLnZyu0gqVY=;
        b=fLoLnQyIYUCu8OFsaSH33EvFdkzngCcMcbaF0HQjBFaB0edMHPvifEIpEEWATCmiNZ
         +utzciGKMBtHakyunGJHhROMtQnj8zF43ditLAnaTa3kV5tddNcQHjz5TksQQJw1OWkX
         OH6l7znnrLy9fVog3IfD4uhU+Bq6FVmdGYSILuk4pbPu0XFIfR17NjrtkttMtF4ZiWyf
         IHaJuI9TMdsSG6uv0lYwPRM6xwqsVLy3RehClJ0ScT7fSybsDqKpWQpWusa/8iISNJht
         kaYaYbta43491Uc6l2KJ8lKJGd/7DDzxa8Y/XC/EwiWowvTJ2VsiPYxQ9qh6nT77PsYS
         UCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790622319; x=1791227119;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W9kEsawsuSStnMVhaHw2fC3OIOfm5OwpFLnZyu0gqVY=;
        b=fhTaj95BebX/IIAAy/kRl6KDjf+rGpKhV4pIQveePRccr33XTLHWRUDmdVL8++S8Kc
         3H4qK6TXYduH0qZa0RMmYVR4VtDGNN0NURZ7AGrkc4C8igHbfYM8yIIQisWkeOW1jSfr
         g2FUez2j4J3W845FyZZ7unzH0Qai4HmQe2ovesWzQ1uo1IfgJhCEdTa8vPItrKTMnCTz
         EOBbE7D0XwcMfhzWEhnCCuykuE2xx2G8G/AKCYwWTPGlssI2AlRDiTYJOzGyhXKv/CwJ
         yFCJAc9QBTIczyh/XvrMhe4EjtS97aSaY3vWuR5+EIjq+aWJw6VnAr3HCNz1vcdI4Gjp
         r16w==
X-Gm-Message-State: AFuF++k5n41gyAdQDQM3iQQFFPFNkFSHVcb5wrW5akVMvjhT8ZLv0P5B
	26iqk+gfE8ME7rDeB+ubWOvwFVnYIIeKwa7x54oXVjnZ4xSKDojsw9RsDl2n/Nm37hHEn73+8vG
	l1A==
X-Received: from wrbdd19.prod.google.com ([2002:a05:6000:1613:b0:488:ba51:7fa8])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:19cd:b0:49d:2536:402e
 with SMTP id 5b1f17b1804b1-49ff06f7a45mr200383195e9.30.1790622319344; Mon, 28
 Sep 2026 12:05:19 -0700 (PDT)
Date: Mon, 28 Sep 2026 18:58:02 +0000
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928185803.335307-1-aojea@google.com>
Subject: [PATCH nf-next v2 1/2] netfilter: nf_queue: limit the hook drop flush
 to the unregistered hook point
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Unregistering a netfilter hook calls nf_queue_nf_hook_drop(), which makes
nfqnl_nf_hook_drop() walk every nfqueue instance of the network namespace
and flush it, reinjecting every packet that waits for a verdict with
NF_DROP. Deleting an nftables base chain of any table, family and hook
point therefore drops the packets queued by hooks of unrelated tables,
families and hook points. The verdict that userspace sends for them
afterwards fails with -ENOENT.

Before commit 039b40ee5854 ("netfilter: nf_queue: only call
synchronize_net twice if nf_queue is active") nf_queue_nf_hook_drop()
received the removed hook and nfqueue only dropped the entries queued by
that hook. The commit removed the argument and the comparison because
base chain removal while nfqueue is in use was rare at the time. With
base chains added and removed by userspace agents while another program
holds packets in a queue this is no longer the case. Commit
960632ece694 ("netfilter: convert hook list to an array") then replaced
the hook pointer in struct nf_queue_entry with an index into the hook
array of the hook point, so a comparison per hook is no longer possible.
A comparison per hook point is: the index of an entry is only stale when
the array of its own hook point changed.

Pass the nf_hook_ops being unregistered down to the queue handler and
add nf_hook_cmp() to nfnetlink_queue, a cmpfn for nfqnl_flush() that
matches the entries whose state.pf and state.hook are the hook point of
that hook. The handler takes the nf_hook_ops rather than the family of
the modified array to keep a single argument with NULL meaning "flush
everything", which nf_ct_iterate_destroy() uses on module exit and
__nft_ct_set_destroy() uses when a ct zone expression goes away and a
queued packet may still reference its conntrack template. The
cmpfn resolves the family itself. An NFPROTO_INET hook is registered in
the IPv4 and the IPv6 array, so it matches the entries of both families;
nf_unregister_net_hook() calls __nf_unregister_net_hook() for the two
arrays back to back and the second flush finds nothing left. If the
shrink of one array fails to allocate, that array keeps its dummy hook
and its entries stay valid, so the flush for the other family drops
them without need; no entry with a stale index survives. An
NFPROTO_INET hook at NF_INET_INGRESS is registered in the netdev ingress
array, the same mapping that nf_static_key_inc() applies. nfqueue does
not accept the ingress and egress hooks (nft_queue_validate()), the
mapping keeps the comparison consistent with the registration.

The entries queued from the hook point whose array changed are still
dropped, their hook_index is stale. Registering a hook in front of the
one that queued a packet still makes nf_reinject() resume at a stale
index, so the packet traverses the queueing hook a second time; this is
not changed here.

Tested with the reproducer script from the thread, unchanged: it queues
20 UDP packets from an inet output chain to a queue program that delays
every verdict by 100 ms and changes the ruleset while they wait. Before
this change deleting an unrelated ip6 base chain or an unrelated ip6
table delivers 3 of 20 packets and the queue program exits on ENOENT;
with it all 20 are delivered. Deleting a base chain at the same hook
point (inet output, another priority, in the same or another table) or
an ip table with an output base chain still drops the queued packets;
deleting an ip6 table with an output base chain or a netdev ingress
chain does not. Adding a base chain in front of the queueing one still
queues the packets twice. The nft_queue.sh selftest passes, with
CONFIG_NETFILTER_NETLINK_QUEUE=y and built as a module. The following
patch adds a test for both outcomes that holds the verdicts instead of
delaying them.

The code and this commit message were written with an LLM coding
assistant from a task description that contained the report, the
suggestion from the thread and the two commits above. The author
reviewed the result, directed the changes and validated them with the
reproducer and the selftest in virtme-ng before and after the change.

Suggested-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/netfilter-devel/CABhP=tYtCyr-qzL==98nkmDVZr6x+f8E26V1AAOpMXgZgt0vAQ@mail.gmail.com/
Assisted-by: LLM
Signed-off-by: Antonio Ojea <aojea@google.com>
---
v1: https://lore.kernel.org/netfilter-devel/20260926100351.2987307-1-aojea@google.com/

Changes in v2:
- rebase on nf-next. Convert the nf_queue_nf_hook_drop() call that commit
  36eae0956f65 ("netfilter: nft_ct: drop pending enqueued packets on
  removal") added to __nft_ct_set_destroy(); it passes NULL and keeps
  flushing every queued packet. Mention this caller in the commit message
  and in the comment on the NULL case.
  https://lore.kernel.org/netfilter-devel/arp1eSHB_m2cFy6n@strlen.de/

 include/net/netfilter/nf_queue.h  |  3 +-
 net/netfilter/core.c              |  2 +-
 net/netfilter/nf_conntrack_core.c |  2 +-
 net/netfilter/nf_internals.h      |  2 +-
 net/netfilter/nf_queue.c          |  4 +--
 net/netfilter/nfnetlink_queue.c   | 49 +++++++++++++++++++++++++++++--
 net/netfilter/nft_ct.c            |  2 +-
 7 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index fc3e81c07364..86021c55ba3c 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -35,7 +35,8 @@ struct nf_queue_entry {
 struct nf_queue_handler {
 	int		(*outfn)(struct nf_queue_entry *entry,
 				 unsigned int queuenum);
-	void		(*nf_hook_drop)(struct net *net);
+	void		(*nf_hook_drop)(struct net *net,
+					const struct nf_hook_ops *ops);
 };
 
 void nf_register_queue_handler(const struct nf_queue_handler *qh);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 675a1034b340..9351b480115d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -515,7 +515,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 	if (!p)
 		return;
 
-	nf_queue_nf_hook_drop(net);
+	nf_queue_nf_hook_drop(net, reg);
 	nf_hook_entries_free(p);
 }
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d0d9e5ea84a0..37dbd89ac21e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2411,7 +2411,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 
 		if (atomic_read(&cnet->count) == 0)
 			continue;
-		nf_queue_nf_hook_drop(net);
+		nf_queue_nf_hook_drop(net, NULL);
 	}
 	up_read(&net_rwsem);
 
diff --git a/net/netfilter/nf_internals.h b/net/netfilter/nf_internals.h
index 25403023060b..ce5aff2cae71 100644
--- a/net/netfilter/nf_internals.h
+++ b/net/netfilter/nf_internals.h
@@ -24,7 +24,7 @@
 #define CTA_FILTER_FLAG(ctattr) CTA_FILTER_F_ ## ctattr
 
 /* nf_queue.c */
-void nf_queue_nf_hook_drop(struct net *net);
+void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_ops *ops);
 
 /* nf_log.c */
 int __init netfilter_log_init(void);
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 73363ceedebe..166d05e994ac 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -129,14 +129,14 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
-void nf_queue_nf_hook_drop(struct net *net)
+void nf_queue_nf_hook_drop(struct net *net, const struct nf_hook_ops *ops)
 {
 	const struct nf_queue_handler *qh;
 
 	rcu_read_lock();
 	qh = rcu_dereference(nf_queue_handler);
 	if (qh)
-		qh->nf_hook_drop(net);
+		qh->nf_hook_drop(net, ops);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(nf_queue_nf_hook_drop);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c727668b0c5b..0b1a0e287aea 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1559,9 +1559,47 @@ static struct notifier_block nfqnl_dev_notifier = {
 	.notifier_call	= nfqnl_rcv_dev_event,
 };
 
-static void nfqnl_nf_hook_drop(struct net *net)
+/* Match the entries whose hook_index points into the hook array that
+ * __nf_unregister_net_hook() replaces when it removes @ops.
+ *
+ * ops->pf and ops->hooknum name the hook point as it was registered.
+ * entry->state.pf and entry->state.hook name the array the packet was
+ * traversing when it was queued.  They differ where one registration
+ * covers a different array than its name says, see nf_hook_entry_head():
+ *
+ *   NFPROTO_INET, hooknum != NF_INET_INGRESS: hooks_ipv4[] and hooks_ipv6[],
+ *   entries carry NFPROTO_IPV4 or NFPROTO_IPV6.
+ *   NFPROTO_INET, NF_INET_INGRESS: dev->nf_hooks_ingress, the array of the
+ *   NFPROTO_NETDEV/NF_NETDEV_INGRESS hook point, entries carry that pair.
+ *
+ * Every other family uses the array of its own name.
+ */
+static int nf_hook_cmp(struct nf_queue_entry *entry, unsigned long ops_ptr)
+{
+	const struct nf_hook_ops *ops = (const struct nf_hook_ops *)ops_ptr;
+	unsigned int hooknum = ops->hooknum;
+	u8 pf = ops->pf;
+
+	/* same translation as nf_static_key_inc() */
+	if (pf == NFPROTO_INET && hooknum == NF_INET_INGRESS) {
+		pf = NFPROTO_NETDEV;
+		hooknum = NF_NETDEV_INGRESS;
+	}
+
+	if (entry->state.hook != hooknum)
+		return 0;
+
+	if (pf == NFPROTO_INET)
+		return entry->state.pf == NFPROTO_IPV4 ||
+		       entry->state.pf == NFPROTO_IPV6;
+
+	return entry->state.pf == pf;
+}
+
+static void nfqnl_nf_hook_drop(struct net *net, const struct nf_hook_ops *ops)
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
+	nfqnl_cmpfn cmpfn = NULL;
 	int i;
 
 	/* This function is also called on net namespace error unwind,
@@ -1574,12 +1612,19 @@ static void nfqnl_nf_hook_drop(struct net *net)
 	if (!q)
 		return;
 
+	/* ops is NULL when the caller is not unregistering a hook but
+	 * removing an object queued packets may reference, every entry
+	 * has to go
+	 */
+	if (ops)
+		cmpfn = nf_hook_cmp;
+
 	for (i = 0; i < INSTANCE_BUCKETS; i++) {
 		struct nfqnl_instance *inst;
 		struct hlist_head *head = &q->instance_table[i];
 
 		hlist_for_each_entry_rcu(inst, head, hlist)
-			nfqnl_flush(inst, NULL, 0);
+			nfqnl_flush(inst, cmpfn, (unsigned long)ops);
 	}
 }
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 3c4c2faa7398..5a8db5592036 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -542,7 +542,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
-		nf_queue_nf_hook_drop(ctx->net);
+		nf_queue_nf_hook_drop(ctx->net, NULL);
 		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();

base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

