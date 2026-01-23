Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC767217F33
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 22:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769206179; cv=none; b=hBYRk4iehGm9Z+ROtSNKNMLwDgWR2b0XPBloxon7JnB42KD8wedoqDx5mdPpgvpSsarzG/B6We0P1o2cX5sDtIJq8veMSH8wpAg8W94aqxXNNt7z0Va5AiTfutJuYTajanqrK1Su33FF2L6GzY2blftXtmBFe9X/THicxO8NWks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769206179; c=relaxed/simple;
	bh=TiaHtssePHEv7U97zx+HmQ6zUSIL9hL437irlCGOIts=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D4f0XayE+Dap6/aRcqWhmVHm3Z92z9CiNcuZL0x6cNE8yfm709OdKaP1akkwwyZjDHAK7VpW+cOqAm2xOHGcgIr02MwgGk2jy8jN5FiFKVCjn1hY6/1dOAWLaAqT8CnQ2xfbzPDhZWHEIYn/ww0l749Sr5anG1AzN4p/pcHZOE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BgQkL0Gs; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BgQkL0Gs"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b72e49776eso4250485eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 14:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769206177; x=1769810977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bggo3osF3ZghjPEX0A72yiVaO/CnLE6zRIpO955wMTU=;
        b=BgQkL0GsXX+yIQ2Sh31nEJGOWfaj2z/catgwlGoApdyVk5nZsQ0xcA94PqWCfci+EY
         niMzw/OPcfpXE99cJzC+rOyRQcH9bYWeXXRLtnXGgYDCjXIqPEbZ4CaOCcHikRlT4uoB
         hklcICcbux8g4XVGIK/+BOCYKOTLoSEB5BTe+inkceW8agzPKW//J/vb6o9EQuukk43F
         IaySqAaHbXjMIRJIjBHCgn2HJ7Pn8QqslLYfokcrDVd0fttyhy2iJzKev/6IvOKFBuEn
         Vii2zIxjC+nDoljLJc1QsZGrYDXF0iESf6M+kjoI1/6AFLKwp3WXzLPanTVkcy5G9jbI
         7ipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769206177; x=1769810977;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bggo3osF3ZghjPEX0A72yiVaO/CnLE6zRIpO955wMTU=;
        b=LmUVuXLjfWeSyXzseySUsobNPT1dxuHt4u+BHTpQG1dtGlFSO8aJVOqJ5zYuzssZix
         inhIPIq1pXV2Eh+92OnRrMWH8U6ZcvGP8qheDLUnQapYIaNcB0q1Grn6Iu4XpKGwIU5r
         tJKYn1mR0s+0uNGYNNekU+yvQ1q2u7BsU6DsS3HEifenLeZ0ejzlTFmnAFFgpFlUcKJZ
         JCUAG0d3todJ/Zwb/wBMR628RCtHPFPm95HeHzs26maFNktnt+nZNd6cvBK8ZGprk3M9
         R31YDTy3jghEuQ0zf7EIZoimgakmgrBSrnUW4CvgohL8j/s0TCECZGSWXfDh2ajgj9uw
         Anrw==
X-Gm-Message-State: AOJu0YyWmz367GUpej2Ef+ezTXhBaD90a0Y7DrwRt40ZjKFmgMF8XxUz
	/LlzFzIO/bvxv8EOC5LbfRDxSAg7ReGir4UZLW+hfc/uGDvnSNpOHvOH7aytew==
X-Gm-Gg: AZuq6aICIOr3mIQP50XrBvul/JEmytsoI1bX2mEQwFC9aIEAYs8KR2yMwussBABw1y5
	Vv2/XSjxruAMQ/fulaf1xi3R0G8bGVRPm7g7/tiDAJei6QA12XGaYFjp22HI6EnxskiwTI5toI3
	ISEhUQ7YpA0iBmKpVIg4qStN2r4/JXxQDtbDjfoCAUKmf0/iWF3fPwWicsNQkmQmLzu3IjSbry0
	+gZCY/2vRyKow6zou4Bw8rNxl/hQVG3krt+cW7Y53T0BgwoWyKhyt5RpTvpt8N2qUJua6+HRzTI
	EJTcKunVGb5r39wKEqdRx3KRV4ngotbBXzwv/Q8DgOQTMObacPGvEfddu9lTeTPdBHqTQ/oDli3
	v2GDQbzpB6KIw6oEAFXZ3+RTb2ql9VTneEZnvdZ0CFp4kLTwhalGBN0RbCW3KGgTwsDUIhFDIyX
	HgGPGoplJByDOgxAl5BqcuUOYeU/6S9skPy6QKkp0Pi1punYiwBMIap6GuRg==
X-Received: by 2002:a05:7300:8ca2:b0:2a4:3594:d54e with SMTP id 5a478bee46e88-2b739b933abmr2364130eec.27.1769206176578;
        Fri, 23 Jan 2026 14:09:36 -0800 (PST)
Received: from mr55p01nt-relayp01.apple.com ([205.154.255.171])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73a6c4a68sm5766073eec.12.2026.01.23.14.09.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Jan 2026 14:09:36 -0800 (PST)
From: scott.k.mitch1@gmail.com
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Scott Mitchell <scott.k.mitch1@gmail.com>
Subject: [PATCH v8] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Fri, 23 Jan 2026 14:09:30 -0800
Message-Id: <20260123220930.43860-1-scott.k.mitch1@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
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
---
Changes in v8:
- Use possible_net_t instead of struct net * in nfqnl_packet_key, with
  write_pnet()/read_pnet() helpers (Florian Westphal)
- Use net_eq() for network namespace comparison (Florian Westphal)
- Remove inline keyword from __enqueue_entry() (Florian Westphal)
- Add nfqnl_init_key() helper to centralize key initialization (Florian Westphal)
- Consolidate error handling with err_out_queue_drop label (Florian Westphal)
- Remove pr_err() on rhashtable_init() failure (Florian Westphal)
- Remove BUILD_BUG_ON - rely on __aligned(sizeof(u32)) for jhash2
  compatibility (Florian Westphal)

Changes in v7:
- Use global rhashtable instead of per-queue hash.
- Split previous patch 1 (no longer necessary for rhashtable)
  into independent patch series.

Changes in v6:
- Split into 2-patch series
- Patch 1: Refactor locking to allow GFP_KERNEL_ACCOUNT allocation in
  instance_create() by dropping RCU lock after instance_lookup() and
  peer_portid verification (Florian Westphal)
- Patch 2: Remove UAPI for hash size, automatic resize, attribute
  memory to cgroup.

Changes in v5:
- Use GFP_ATOMIC with kvmalloc_array instead of GFP_KERNEL_ACCOUNT due to
  rcu_read_lock held in nfqnl_recv_config. Add comment explaining that
  GFP_KERNEL_ACCOUNT would require lock refactoring (Florian Westphal)

Changes in v4:
- Fix sleeping while atomic bug: allocate hash table before taking
  spinlock in instance_create() (syzbot)

Changes in v3:
- Simplify hash function to use direct masking (id & mask) instead of
  hash_32() for better cache locality with sequential IDs (Eric Dumazet)

Changes in v2:
- Use kvcalloc/kvfree with GFP_KERNEL_ACCOUNT to support larger hash
  tables with vmalloc fallback (Florian Westphal)
- Remove incorrect comment about concurrent resizes - nfnetlink subsystem
  mutex already serializes config operations (Florian Westphal)
- Fix style: remove unnecessary braces around single-line if (Florian Westphal)

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
2.39.5 (Apple Git-154)

