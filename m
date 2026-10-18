Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D42B1A76BB;
	Sun, 18 Oct 2026 00:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792285017; cv=none; b=GECr/IACxLQ37aipHWfqapI/MWsgS7nxIG+nBZ6Uk7F77TwWsq0WDx3IpwmRwcmBNO9F5AeXXU9TKgrSF9Emv4U9kVBWTEbizon/ETn0u6gDdlAHL8pYBZ7MGdzYDXVfpPH0avL6PNuKbgU3Oo/z0zcX242vM8xnMsDYOO45Hg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792285017; c=relaxed/simple;
	bh=6va1fA0HXEvOIwfuHYtJiLERRkJi4PcwmMmDqlptdX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE9QTDwVuo5NtI8tvWylDxbY0zCWIsRFQd6oNV/eTh1eW3a6U4HTvafo0n5ydBpbPt1kYYHvU9thc+TT36nxtL8GIXskx5uhcFD9rD53MlfHeG7DoeZ/g+IB6u8KIIKOPlvXFq7iCWR6w/NQVfXCxz2nuikYI/ICnSH0PqG6LYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=U2utj+Ii; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="U2utj+Ii"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792285012;
	bh=zmTMvynJ4lghGZV9wql/MG8G9Kud2zkMxZ32fMZYSI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2utj+IiW/n9QEGHq2BzfmXTK8scA4AnJzaW+JiyJz85mOH/RjdvQrNoJKx/tqQPH
	 R4IDjTcDPErnFBzgO00qwQNj/QmK4DuQg91jh5KrFaNhe5piuG+EPirz7HsHv5YzRz
	 1N8/ItrybQkRw4xrKFXl4ObTS1TxaPkQokbvHohPuISqrqOcZZyvdxR+lMQE185+nZ
	 XEpeHPUwf/7DPEfX5MtOjLBwHuAggDlITBoWpLLldsuuXYnh6gJZvN5MxBH8My+OFZ
	 xnUp9Vw+JdgQiNEo7s+N8GLwiuqCT7NR+PcVMUPe+C4Q4mOQh6NmAvtOG4x08yihBh
	 SVjuAtBGew9Kw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A034260057;
	Sun, 18 Oct 2026 02:56:51 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 04/15] netfilter: nf_queue: limit the hook drop flush to the unregistered hook point
Date: Sun, 18 Oct 2026 02:56:27 +0200
Message-ID: <20261018005638.1776148-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018005638.1776148-1-pablo@netfilter.org>
References: <20261018005638.1776148-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Antonio Ojea <aojea@google.com>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_queue.h  |  3 ++-
 net/netfilter/core.c              |  2 +-
 net/netfilter/nf_conntrack_core.c |  2 +-
 net/netfilter/nf_internals.h      |  2 +-
 net/netfilter/nf_queue.c          |  4 +--
 net/netfilter/nfnetlink_queue.c   | 41 +++++++++++++++++++++++++++++--
 net/netfilter/nft_ct.c            |  2 +-
 7 files changed, 47 insertions(+), 9 deletions(-)

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
index 940dea2663e9..44c856c1e621 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -529,7 +529,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 	if (!p)
 		return;
 
-	nf_queue_nf_hook_drop(net);
+	nf_queue_nf_hook_drop(net, reg);
 	nf_hook_entries_free(p);
 }
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f9b8927327ba..8514a37c29fa 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2410,7 +2410,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 
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
index a3bc00280051..00b76c25d55c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1559,9 +1559,39 @@ static struct notifier_block nfqnl_dev_notifier = {
 	.notifier_call	= nfqnl_rcv_dev_event,
 };
 
-static void nfqnl_nf_hook_drop(struct net *net)
+/* Match the entries whose hook_index points into the hook array that
+ * __nf_unregister_net_hook() replaces when it removes @ops.
+ *
+ * ops->pf/hooknum name the hook as registered; entry->state.pf/hook
+ * name the array actually traversed - they differ only for NFPROTO_INET.
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
@@ -1574,12 +1604,19 @@ static void nfqnl_nf_hook_drop(struct net *net)
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
-- 
2.47.3

