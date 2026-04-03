Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B62B2DF15C
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775223912; cv=none; b=RsFnT/Ytz1gakYOnaPDOG+mtzjj894lb+Z0tbaIRZV6C/j/nGLPk3t5Fc9FIUcBVNuTaL4tNyM7pjhMJv7asB4G75lfRbMCJPQNRD9Rrs/K5yeBPfGJtQkSp6jJ58gj7NmIwF8I3UlKRT3Z3LGPK1TO2E5JwpdoodjmBb0EgUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775223912; c=relaxed/simple;
	bh=r+V6B06OouK+MmyMblZGORfna2I0Ld0m5iljWm4QJlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LBHINWJzOG5hnXHh47FEMNDFGu6WOnKoOFZnUsPir6TJweBPtTtg2bJ57x8QYmWkjxjNEayTFiRFNbj6BG4Z0DhAo3hQggivXVBzb3Hr07LyZmzreqyRkBevONsL/wU5sGMPqZSt+RXyX5kcjEMBIWSBck9eouBrrW7CLrws0TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CF38860913; Fri, 03 Apr 2026 15:45:07 +0200 (CEST)
Date: Fri, 3 Apr 2026 15:45:07 +0200
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue crashes kernel
Message-ID: <ac_EY9ciqt5yQ6wr@strlen.de>
References: <ac-w6e33txkgTRJj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac-w6e33txkgTRJj@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> A probably better fix is to make the rhashtable perqueue, which is
> much more intrusive at this late stage.

Tentative patch to do this, still misses selftest extensions:

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 47f7f62906e2..15c6276f6592 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
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
@@ -190,7 +148,11 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
-	spin_lock(&q->instances_lock);
+	err = rhashtable_init(&inst->nfqnl_packet_map, &nfqnl_rhashtable_params);
+	if (err < 0)
+		goto out_free;
+
+	spin_lock_bh(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err = -EEXIST;
 		goto out_unlock;
@@ -204,12 +166,14 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	h = instance_hashfn(queue_num);
 	hlist_add_head_rcu(&inst->hlist, &q->instance_table[h]);
 
-	spin_unlock(&q->instances_lock);
+	spin_unlock_bh(&q->instances_lock);
 
 	return inst;
 
 out_unlock:
-	spin_unlock(&q->instances_lock);
+	spin_unlock_bh(&q->instances_lock);
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
+	netlink_unregister_notifier(&nfqnl_dev_notifier);
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
 

