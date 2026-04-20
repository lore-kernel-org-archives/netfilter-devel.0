Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7643C2769;
	Mon, 20 Apr 2026 13:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691049; cv=none; b=GQhLg5K5pDE2Trnf5kFMCsPTXSc7Nq7LRuMTrRLD2zwVr1ObB7bElqlscEARSsAMreh6oMyhFSwSPZz9xISIDAbfTaxDHLkOK7M1wUFz8obD9EtTwiuaIb0GH4N2tlJUaBLen6eBrJxxOPNW6BLA1BuLtIHAtn7Wxl5u0ED00jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691049; c=relaxed/simple;
	bh=9aPVkcRuTSgqcTqdXSJQNUbhuhgr30ISjyLMfNdWJGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4B8wZqkuR69hkJhPsZYI84X953c7tnLidjhezkoNdq3UPMblAVVlxrgm0OttQJObYs2GRGTU0vWVsUfhMwFnWytBave+fDI5Gf5qq2vLsX1S4Ny2FEVXonicZd5N68xfhU3FQQqy0OA0s0zg0CpEYZjBhXjcw/vWY0xeDZ0SV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTqLF4vV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTqLF4vV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD75C2BCB6;
	Mon, 20 Apr 2026 13:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691049;
	bh=9aPVkcRuTSgqcTqdXSJQNUbhuhgr30ISjyLMfNdWJGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LTqLF4vV3/Sne7oYCJWMEG6rfbDUDxx81+X7XczzK5acB16PJOxXj7KI3ngX/2Eqh
	 PRlTlsRQppYZzv4o0UNC/9ugIwe3oloIiiuOzSOjm87MFgs78B0Oxxaw5snTcEoPvt
	 8LRL+AYNOO3vql9B3PVZ6cXAubt0atv2VaNgRqUBFcB7dUylrEOXRsgTKFhzGbv4VW
	 k6sN2hMZ7biEERBwEmj66cFkcb8nVUgnGuQ3miH5wdaCGF8xNSoZNtKtD8G+geT6WK
	 yReR2BER6bKHaHTkGIxg0HD0Hqyf3gIRgQ0MEkj4Ook+oVAEOfUgYHpSL3pM7WLEta
	 nmMYUUgFGiZTw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Scott Mitchell <scott.k.mitch1@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: nfnetlink_queue: make hash table per queue
Date: Mon, 20 Apr 2026 09:08:50 -0400
Message-ID: <20260420131539.986432-64-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 936206e3f6ff411581e615e930263d6f8b78df9d ]

Sharing a global hash table among all queues is tempting, but
it can cause crash:

BUG: KASAN: slab-use-after-free in nfqnl_recv_verdict+0x11ac/0x15e0 [nfnetlink_queue]
[..]
 nfqnl_recv_verdict+0x11ac/0x15e0 [nfnetlink_queue]
 nfnetlink_rcv_msg+0x46a/0x930
 kmem_cache_alloc_node_noprof+0x11e/0x450

struct nf_queue_entry is freed via kfree, but parallel cpu can still
encounter such an nf_queue_entry when walking the list.

Alternative fix is to free the nf_queue_entry via kfree_rcu() instead,
but as we have to alloc/free for each skb this will cause more mem
pressure.

Cc: Scott Mitchell <scott.k.mitch1@gmail.com>
Fixes: e19079adcd26 ("netfilter: nfnetlink_queue: optimize verdict lookup with hash table")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/net/netfilter/nf_queue.h |   1 -
 net/netfilter/nfnetlink_queue.c  | 139 +++++++++++--------------------
 2 files changed, 49 insertions(+), 91 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 45eb26b2e95b3..d17035d14d96c 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -23,7 +23,6 @@ struct nf_queue_entry {
 	struct nf_hook_state	state;
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
-	u16			queue_num;
 
 	/* extra space to store route keys */
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a39d3b989063c..fe5942535245d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -49,8 +49,8 @@
 #endif
 
 #define NFQNL_QMAX_DEFAULT 1024
-#define NFQNL_HASH_MIN     1024
-#define NFQNL_HASH_MAX     1048576
+#define NFQNL_HASH_MIN     8
+#define NFQNL_HASH_MAX     32768
 
 /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
  * includes the header length. Thus, the maximum packet length that we
@@ -60,29 +60,10 @@
  */
 #define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)
 
-/* Composite key for packet lookup: (net, queue_num, packet_id) */
-struct nfqnl_packet_key {
-	possible_net_t net;
-	u32 packet_id;
-	u16 queue_num;
-} __aligned(sizeof(u32));  /* jhash2 requires 32-bit alignment */
-
-/* Global rhashtable - one for entire system, all netns */
-static struct rhashtable nfqnl_packet_map __read_mostly;
-
-/* Helper to initialize composite key */
-static inline void nfqnl_init_key(struct nfqnl_packet_key *key,
-				  struct net *net, u32 packet_id, u16 queue_num)
-{
-	memset(key, 0, sizeof(*key));
-	write_pnet(&key->net, net);
-	key->packet_id = packet_id;
-	key->queue_num = queue_num;
-}
-
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
-	struct rcu_head rcu;
+	struct rhashtable nfqnl_packet_map;
+	struct rcu_work	rwork;
 
 	u32 peer_portid;
 	unsigned int queue_maxlen;
@@ -106,6 +87,7 @@ struct nfqnl_instance {
 
 typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
 
+static struct workqueue_struct *nfq_cleanup_wq __read_mostly;
 static unsigned int nfnl_queue_net_id __read_mostly;
 
 #define INSTANCE_BUCKETS	16
@@ -124,34 +106,10 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
 }
 
-/* Extract composite key from nf_queue_entry for hashing */
-static u32 nfqnl_packet_obj_hashfn(const void *data, u32 len, u32 seed)
-{
-	const struct nf_queue_entry *entry = data;
-	struct nfqnl_packet_key key;
-
-	nfqnl_init_key(&key, entry->state.net, entry->id, entry->queue_num);
-
-	return jhash2((u32 *)&key, sizeof(key) / sizeof(u32), seed);
-}
-
-/* Compare stack-allocated key against entry */
-static int nfqnl_packet_obj_cmpfn(struct rhashtable_compare_arg *arg,
-				  const void *obj)
-{
-	const struct nfqnl_packet_key *key = arg->key;
-	const struct nf_queue_entry *entry = obj;
-
-	return !net_eq(entry->state.net, read_pnet(&key->net)) ||
-	       entry->queue_num != key->queue_num ||
-	       entry->id != key->packet_id;
-}
-
 static const struct rhashtable_params nfqnl_rhashtable_params = {
 	.head_offset = offsetof(struct nf_queue_entry, hash_node),
-	.key_len = sizeof(struct nfqnl_packet_key),
-	.obj_hashfn = nfqnl_packet_obj_hashfn,
-	.obj_cmpfn = nfqnl_packet_obj_cmpfn,
+	.key_offset = offsetof(struct nf_queue_entry, id),
+	.key_len = sizeof(u32),
 	.automatic_shrinking = true,
 	.min_size = NFQNL_HASH_MIN,
 	.max_size = NFQNL_HASH_MAX,
@@ -190,6 +148,10 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
+	err = rhashtable_init(&inst->nfqnl_packet_map, &nfqnl_rhashtable_params);
+	if (err < 0)
+		goto out_free;
+
 	spin_lock(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err = -EEXIST;
@@ -210,6 +172,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 out_unlock:
 	spin_unlock(&q->instances_lock);
+	rhashtable_destroy(&inst->nfqnl_packet_map);
+out_free:
 	kfree(inst);
 	return ERR_PTR(err);
 }
@@ -217,15 +181,18 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 static void nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn,
 			unsigned long data);
 
-static void
-instance_destroy_rcu(struct rcu_head *head)
+static void instance_destroy_work(struct work_struct *work)
 {
-	struct nfqnl_instance *inst = container_of(head, struct nfqnl_instance,
-						   rcu);
+	struct nfqnl_instance *inst;
 
+	inst = container_of(to_rcu_work(work), struct nfqnl_instance,
+			    rwork);
 	rcu_read_lock();
 	nfqnl_flush(inst, NULL, 0);
 	rcu_read_unlock();
+
+	rhashtable_destroy(&inst->nfqnl_packet_map);
+
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -234,7 +201,9 @@ static void
 __instance_destroy(struct nfqnl_instance *inst)
 {
 	hlist_del_rcu(&inst->hlist);
-	call_rcu(&inst->rcu, instance_destroy_rcu);
+
+	INIT_RCU_WORK(&inst->rwork, instance_destroy_work);
+	queue_rcu_work(nfq_cleanup_wq, &inst->rwork);
 }
 
 static void
@@ -250,9 +219,7 @@ __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
 	int err;
 
-	entry->queue_num = queue->queue_num;
-
-	err = rhashtable_insert_fast(&nfqnl_packet_map, &entry->hash_node,
+	err = rhashtable_insert_fast(&queue->nfqnl_packet_map, &entry->hash_node,
 				     nfqnl_rhashtable_params);
 	if (unlikely(err))
 		return err;
@@ -266,23 +233,19 @@ __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 static void
 __dequeue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
-	rhashtable_remove_fast(&nfqnl_packet_map, &entry->hash_node,
+	rhashtable_remove_fast(&queue->nfqnl_packet_map, &entry->hash_node,
 			       nfqnl_rhashtable_params);
 	list_del(&entry->list);
 	queue->queue_total--;
 }
 
 static struct nf_queue_entry *
-find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id,
-		   struct net *net)
+find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
-	struct nfqnl_packet_key key;
 	struct nf_queue_entry *entry;
 
-	nfqnl_init_key(&key, net, id, queue->queue_num);
-
 	spin_lock_bh(&queue->lock);
-	entry = rhashtable_lookup_fast(&nfqnl_packet_map, &key,
+	entry = rhashtable_lookup_fast(&queue->nfqnl_packet_map, &id,
 				       nfqnl_rhashtable_params);
 
 	if (entry)
@@ -1531,7 +1494,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 
 	verdict = ntohl(vhdr->verdict);
 
-	entry = find_dequeue_entry(queue, ntohl(vhdr->id), info->net);
+	entry = find_dequeue_entry(queue, ntohl(vhdr->id));
 	if (entry == NULL)
 		return -ENOENT;
 
@@ -1880,40 +1843,38 @@ static int __init nfnetlink_queue_init(void)
 {
 	int status;
 
-	status = rhashtable_init(&nfqnl_packet_map, &nfqnl_rhashtable_params);
-	if (status < 0)
-		return status;
+	nfq_cleanup_wq = alloc_ordered_workqueue("nfq_workqueue", 0);
+	if (!nfq_cleanup_wq)
+		return -ENOMEM;
 
 	status = register_pernet_subsys(&nfnl_queue_net_ops);
-	if (status < 0) {
-		pr_err("failed to register pernet ops\n");
-		goto cleanup_rhashtable;
-	}
+	if (status < 0)
+		goto cleanup_pernet_subsys;
 
-	netlink_register_notifier(&nfqnl_rtnl_notifier);
-	status = nfnetlink_subsys_register(&nfqnl_subsys);
-	if (status < 0) {
-		pr_err("failed to create netlink socket\n");
-		goto cleanup_netlink_notifier;
-	}
+	status = netlink_register_notifier(&nfqnl_rtnl_notifier);
+	if (status < 0)
+	       goto cleanup_rtnl_notifier;
 
 	status = register_netdevice_notifier(&nfqnl_dev_notifier);
-	if (status < 0) {
-		pr_err("failed to register netdevice notifier\n");
-		goto cleanup_netlink_subsys;
-	}
+	if (status < 0)
+		goto cleanup_dev_notifier;
+
+	status = nfnetlink_subsys_register(&nfqnl_subsys);
+	if (status < 0)
+		goto cleanup_nfqnl_subsys;
 
 	nf_register_queue_handler(&nfqh);
 
 	return status;
 
-cleanup_netlink_subsys:
-	nfnetlink_subsys_unregister(&nfqnl_subsys);
-cleanup_netlink_notifier:
+cleanup_nfqnl_subsys:
+	unregister_netdevice_notifier(&nfqnl_dev_notifier);
+cleanup_dev_notifier:
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
+cleanup_rtnl_notifier:
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
-cleanup_rhashtable:
-	rhashtable_destroy(&nfqnl_packet_map);
+cleanup_pernet_subsys:
+	destroy_workqueue(nfq_cleanup_wq);
 	return status;
 }
 
@@ -1924,9 +1885,7 @@ static void __exit nfnetlink_queue_fini(void)
 	nfnetlink_subsys_unregister(&nfqnl_subsys);
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
-
-	rhashtable_destroy(&nfqnl_packet_map);
-
+	destroy_workqueue(nfq_cleanup_wq);
 	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
-- 
2.53.0

