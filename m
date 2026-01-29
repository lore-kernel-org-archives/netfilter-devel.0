Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619C93816F1;
	Thu, 29 Jan 2026 10:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769684104; cv=none; b=ApoWIlPzHquyAiLwSz0FDW7Su4/AQDndivAplQDsA/LKLLbIdFsvn7GYLEhV/8IVQBx3fQO/edbYs7oREiFvMxYRTY0Kh2kx+iBsAQ/i7wcMc8mSCXih44r+WNZfyC9Ux3YWpE26ZdmsMS64kjgcHBB/SszDlEr8mOlNxeYpnQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769684104; c=relaxed/simple;
	bh=yaEWRSqaI+2Cf9Otd8/xYtW1YKUcait8SbBYDRJ/OTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sU5V6utFgaNpejP71HDAuHNuN002ELs9qhhCEsVOq4h1ErdgT7Yw+r3OjtZvTbv837hZlyUPJ++wFqRVFih7K3t1HHkto25ZcxhFqp7cIP0NEEDbvs1Xy5nFRqqM9+t+tJ2TGVUMUlvsEmqVoGYd+bruMYZ9rZiSv40w9oAZgcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1B61460516; Thu, 29 Jan 2026 11:55:02 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH v2 net-next 7/7] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Thu, 29 Jan 2026 11:54:27 +0100
Message-ID: <20260129105427.12494-8-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129105427.12494-1-fw@strlen.de>
References: <20260129105427.12494-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Scott Mitchell <scott.k.mitch1@gmail.com>

The current implementation uses a linear list to find queued packets by
ID when processing verdicts from userspace. With large queue depths and
out-of-order verdicting, this O(n) lookup becomes a significant
bottleneck, causing userspace verdict processing to dominate CPU time.

Replace the linear search with a hash table for O(1) average-case
packet lookup by ID. A global rhashtable spanning all network
namespaces attributes hash bucket memory to kernel but is subject to
fixed upper bound.

Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_queue.h |   3 +
 net/netfilter/nfnetlink_queue.c  | 146 ++++++++++++++++++++++++-------
 2 files changed, 119 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 4aeffddb7586..e6803831d6af 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -6,11 +6,13 @@
 #include <linux/ipv6.h>
 #include <linux/jhash.h>
 #include <linux/netfilter.h>
+#include <linux/rhashtable-types.h>
 #include <linux/skbuff.h>
 
 /* Each queued (to userspace) skbuff has one of these. */
 struct nf_queue_entry {
 	struct list_head	list;
+	struct rhash_head	hash_node;
 	struct sk_buff		*skb;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
@@ -20,6 +22,7 @@ struct nf_queue_entry {
 #endif
 	struct nf_hook_state	state;
 	u16			size; /* sizeof(entry) + saved route keys */
+	u16			queue_num;
 
 	/* extra space to store route keys */
 };
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8fa0807973c9..671b52c652ef 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -30,6 +30,8 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
 #include <linux/cgroup-defs.h>
+#include <linux/rhashtable.h>
+#include <linux/jhash.h>
 #include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
@@ -47,6 +49,8 @@
 #endif
 
 #define NFQNL_QMAX_DEFAULT 1024
+#define NFQNL_HASH_MIN     1024
+#define NFQNL_HASH_MAX     1048576
 
 /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
  * includes the header length. Thus, the maximum packet length that we
@@ -56,6 +60,26 @@
  */
 #define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)
 
+/* Composite key for packet lookup: (net, queue_num, packet_id) */
+struct nfqnl_packet_key {
+	possible_net_t net;
+	u32 packet_id;
+	u16 queue_num;
+} __aligned(sizeof(u32));  /* jhash2 requires 32-bit alignment */
+
+/* Global rhashtable - one for entire system, all netns */
+static struct rhashtable nfqnl_packet_map __read_mostly;
+
+/* Helper to initialize composite key */
+static inline void nfqnl_init_key(struct nfqnl_packet_key *key,
+				  struct net *net, u32 packet_id, u16 queue_num)
+{
+	memset(key, 0, sizeof(*key));
+	write_pnet(&key->net, net);
+	key->packet_id = packet_id;
+	key->queue_num = queue_num;
+}
+
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	struct rcu_head rcu;
@@ -100,6 +124,39 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
 }
 
+/* Extract composite key from nf_queue_entry for hashing */
+static u32 nfqnl_packet_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct nf_queue_entry *entry = data;
+	struct nfqnl_packet_key key;
+
+	nfqnl_init_key(&key, entry->state.net, entry->id, entry->queue_num);
+
+	return jhash2((u32 *)&key, sizeof(key) / sizeof(u32), seed);
+}
+
+/* Compare stack-allocated key against entry */
+static int nfqnl_packet_obj_cmpfn(struct rhashtable_compare_arg *arg,
+				  const void *obj)
+{
+	const struct nfqnl_packet_key *key = arg->key;
+	const struct nf_queue_entry *entry = obj;
+
+	return !net_eq(entry->state.net, read_pnet(&key->net)) ||
+	       entry->queue_num != key->queue_num ||
+	       entry->id != key->packet_id;
+}
+
+static const struct rhashtable_params nfqnl_rhashtable_params = {
+	.head_offset = offsetof(struct nf_queue_entry, hash_node),
+	.key_len = sizeof(struct nfqnl_packet_key),
+	.obj_hashfn = nfqnl_packet_obj_hashfn,
+	.obj_cmpfn = nfqnl_packet_obj_cmpfn,
+	.automatic_shrinking = true,
+	.min_size = NFQNL_HASH_MIN,
+	.max_size = NFQNL_HASH_MAX,
+};
+
 static struct nfqnl_instance *
 instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 {
@@ -188,33 +245,45 @@ instance_destroy(struct nfnl_queue_net *q, struct nfqnl_instance *inst)
 	spin_unlock(&q->instances_lock);
 }
 
-static inline void
+static int
 __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
-       list_add_tail(&entry->list, &queue->queue_list);
-       queue->queue_total++;
+	int err;
+
+	entry->queue_num = queue->queue_num;
+
+	err = rhashtable_insert_fast(&nfqnl_packet_map, &entry->hash_node,
+				     nfqnl_rhashtable_params);
+	if (unlikely(err))
+		return err;
+
+	list_add_tail(&entry->list, &queue->queue_list);
+	queue->queue_total++;
+
+	return 0;
 }
 
 static void
 __dequeue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
+	rhashtable_remove_fast(&nfqnl_packet_map, &entry->hash_node,
+			       nfqnl_rhashtable_params);
 	list_del(&entry->list);
 	queue->queue_total--;
 }
 
 static struct nf_queue_entry *
-find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
+find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id,
+		   struct net *net)
 {
-	struct nf_queue_entry *entry = NULL, *i;
+	struct nfqnl_packet_key key;
+	struct nf_queue_entry *entry;
 
-	spin_lock_bh(&queue->lock);
+	nfqnl_init_key(&key, net, id, queue->queue_num);
 
-	list_for_each_entry(i, &queue->queue_list, list) {
-		if (i->id == id) {
-			entry = i;
-			break;
-		}
-	}
+	spin_lock_bh(&queue->lock);
+	entry = rhashtable_lookup_fast(&nfqnl_packet_map, &key,
+				       nfqnl_rhashtable_params);
 
 	if (entry)
 		__dequeue_entry(queue, entry);
@@ -404,8 +473,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
+			__dequeue_entry(queue, entry);
 			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
@@ -885,23 +953,23 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	if (nf_ct_drop_unconfirmed(entry))
 		goto err_out_free_nskb;
 
-	if (queue->queue_total >= queue->queue_maxlen) {
-		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
-			failopen = 1;
-			err = 0;
-		} else {
-			queue->queue_dropped++;
-			net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
-					     queue->queue_total);
-		}
-		goto err_out_free_nskb;
-	}
+	if (queue->queue_total >= queue->queue_maxlen)
+		goto err_out_queue_drop;
+
 	entry->id = ++queue->id_sequence;
 	*packet_id_ptr = htonl(entry->id);
 
+	/* Insert into hash BEFORE unicast. If failure don't send to userspace. */
+	err = __enqueue_entry(queue, entry);
+	if (unlikely(err))
+		goto err_out_queue_drop;
+
 	/* nfnetlink_unicast will either free the nskb or add it to a socket */
 	err = nfnetlink_unicast(nskb, net, queue->peer_portid);
 	if (err < 0) {
+		/* Unicast failed - remove entry we just inserted */
+		__dequeue_entry(queue, entry);
+
 		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
 			failopen = 1;
 			err = 0;
@@ -911,11 +979,22 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 		goto err_out_unlock;
 	}
 
-	__enqueue_entry(queue, entry);
-
 	spin_unlock_bh(&queue->lock);
 	return 0;
 
+err_out_queue_drop:
+	if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
+		failopen = 1;
+		err = 0;
+	} else {
+		queue->queue_dropped++;
+
+		if (queue->queue_total >= queue->queue_maxlen)
+			net_warn_ratelimited("nf_queue: full at %d entries, dropping packets(s)\n",
+					     queue->queue_total);
+		else
+			net_warn_ratelimited("nf_queue: hash insert failed: %d\n", err);
+	}
 err_out_free_nskb:
 	kfree_skb(nskb);
 err_out_unlock:
@@ -1427,7 +1506,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 
 	verdict = ntohl(vhdr->verdict);
 
-	entry = find_dequeue_entry(queue, ntohl(vhdr->id));
+	entry = find_dequeue_entry(queue, ntohl(vhdr->id), info->net);
 	if (entry == NULL)
 		return -ENOENT;
 
@@ -1774,10 +1853,14 @@ static int __init nfnetlink_queue_init(void)
 {
 	int status;
 
+	status = rhashtable_init(&nfqnl_packet_map, &nfqnl_rhashtable_params);
+	if (status < 0)
+		return status;
+
 	status = register_pernet_subsys(&nfnl_queue_net_ops);
 	if (status < 0) {
 		pr_err("failed to register pernet ops\n");
-		goto out;
+		goto cleanup_rhashtable;
 	}
 
 	netlink_register_notifier(&nfqnl_rtnl_notifier);
@@ -1802,7 +1885,8 @@ static int __init nfnetlink_queue_init(void)
 cleanup_netlink_notifier:
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
-out:
+cleanup_rhashtable:
+	rhashtable_destroy(&nfqnl_packet_map);
 	return status;
 }
 
@@ -1814,6 +1898,8 @@ static void __exit nfnetlink_queue_fini(void)
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
 
+	rhashtable_destroy(&nfqnl_packet_map);
+
 	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
-- 
2.52.0

