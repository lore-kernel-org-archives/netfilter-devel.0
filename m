Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABB038945A
	for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 10:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790417036; cv=none; b=S9HiNEVyUu6buAyrNc1PymcOhNBQPyuZXMhGhXm6OStZxySKZVc/l1KOgpWcj6zS0v/aqVIoUlIeDoczXMmYDJ3DdZrxeULCvh52nTc34d1fczwJTlxGrj4+ev5ZfZus5gyBwSQg5pqsp1j9Ht8uBVorWon6+z0R0+OmbrvpYoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790417036; c=relaxed/simple;
	bh=LTLS3O0G6PJ/+N1sTEH50G93El3m120zwivBUHa7E/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Nmnxi57xLzXox8f6teAf8+8NC9wLBaY1n5D5Ys45KQrrb81LuVSZU6Xlr/VwQMaebOF/izKRx1reznYhRYuwdYfvfd0qeZNxSWfGfufzfAcXvMJa1/erYsmtLNFZ/Klpn0MHKGr4EvypsIzohCElhGqWDstyZ0yTFzWNEFKnXEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ta3CxYhH; arc=none smtp.client-ip=209.85.218.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ta3CxYhH"
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2939e341f7so192198666b.2
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 03:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790417032; x=1791021832; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PfDsZQbjRfQwjgeInb4bSnXRnqbZuAxC+YA0cie2Jbw=;
        b=Ta3CxYhH7mZsqbNpY9RKJB9GJ1RJq4qH2ONQQywswkmLicER2UNSO8p9XODe/GIue6
         8jvfVixEzA4OrdkjUiCoiYtsgsDNCt13dIGlflccQpEKgcZh2uAhSb6Ca+dDhg4uuif9
         l3XAGB7rZ8YnAxN0vrHaarLvEOuixCzHxeOuRQrhWO9hkt6LwCyAdMaGrvQjzTVimKdc
         DZjFf3HC1tcl7ZDFZfz6hXuAlH3OyTxkTAL6I7zNin4qQjlhWeBL2v+t0yULTJhNi2mv
         kCwyZAMktYdTe7edRzTC8gAo+5rfu2892Kr/NL4ErH28pcym3LvTa+Zcv7KenxENee+z
         2rPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790417033; x=1791021833;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PfDsZQbjRfQwjgeInb4bSnXRnqbZuAxC+YA0cie2Jbw=;
        b=GLGBkUtWazCXgfo9vz8IDie6n+ZJqiiUkS/sODV2YqgXkMvClu33CDau8T2kAIp+Zh
         moXL6Zejflm4OvilkaslzabBtx4q8RFCjY7VdBFWaTwYr5z6qM4xjJxBxc34PhBvddH9
         DTEN/wBG3msdwcZ+sAziEizl66oKv6bKeSWo22zc64lmNKE3zj0qG5+0XLyMQV+uPPiP
         rRUt5n/Qf3SLtU/GX5B0yQQmGuk1CdJi47SbeqOkWWmxkxCBMx+4TQsGkmwLGt+bEuE6
         lesWHkyqhjj69yzhdPUhyqTjsT2b1Qf7yR1fOY8wcxa6yUYSuNJN6w3mmrTZhfRNJQ07
         HG0w==
X-Gm-Message-State: AFuF++mcOkkV0Zn1ogBrfA8PzheLnuGK35k2dKblnwUQg2ThexeMWzga
	tmMAyf5fmArd8ea28CYtUvEn1uUNdFGjRZ0ncDop84qYXWLKScIU5bAmN65gnuTdw/EBcB5/Wd+
	vcV7lJ+6WlnSPddMJEy74iQZGK1GTKKkyaS9r4sgVGXuCA65rCiwYmwGOPM+AWQoIOXjv7JXbZn
	VjDN3uIO5W46BbcpiXH1f5nZWKZAzSOajAYbKtj7LuAy8=
X-Received: from ejbwq11.prod.google.com ([2002:a17:907:64b:b0:c2d:b958:c6aa])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:c609:10b0:c2a:f5c2:5cfb
 with SMTP id a640c23a62f3a-c2af5c26112mr221141366b.7.1790417032037; Sat, 26
 Sep 2026 03:03:52 -0700 (PDT)
Date: Sat, 26 Sep 2026 10:03:50 +0000
In-Reply-To: <araAhumrNKQ48-Re@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <araAhumrNKQ48-Re@strlen.de>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260926100351.2987307-1-aojea@google.com>
Subject: [PATCH nf-next 1/2] netfilter: nf_queue: limit the hook drop flush to
 the unregistered hook point
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>
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
everything", which nf_ct_iterate_destroy() uses on module exit. The
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
 include/net/netfilter/nf_queue.h  |  3 +-
 net/netfilter/core.c              |  2 +-
 net/netfilter/nf_conntrack_core.c |  2 +-
 net/netfilter/nf_internals.h      |  2 +-
 net/netfilter/nf_queue.c          |  4 +--
 net/netfilter/nfnetlink_queue.c   | 46 +++++++++++++++++++++++++++++--
 6 files changed, 51 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 4aeffddb7586..494ca3b300cc 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -30,7 +30,8 @@ struct nf_queue_entry {
 struct nf_queue_handler {
 	int		(*outfn)(struct nf_queue_entry *entry,
 				 unsigned int queuenum);
-	void		(*nf_hook_drop)(struct net *net);
+	void		(*nf_hook_drop)(struct net *net,
+					const struct nf_hook_ops *ops);
 };
 
 void nf_register_queue_handler(const struct nf_queue_handler *qh);
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 11a702065bab..97611e48d304 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -519,7 +519,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 	if (!p)
 		return;
 
-	nf_queue_nf_hook_drop(net);
+	nf_queue_nf_hook_drop(net, reg);
 	nf_hook_entries_free(p);
 }
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 344f88295976..4b27f8daf265 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2416,7 +2416,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 
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
index 7f12e56e6e52..d9c805bc8d7c 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -112,14 +112,14 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
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
index 8b7b39d8a109..4e7ded0b0f3a 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1181,9 +1181,47 @@ static struct notifier_block nfqnl_dev_notifier = {
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
@@ -1196,12 +1234,16 @@ static void nfqnl_nf_hook_drop(struct net *net)
 	if (!q)
 		return;
 
+	/* ops is NULL on module exit, every entry has to go */
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
 

base-commit: 18a7e218cfcdca6666e1f7356533e4c988780b57
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

