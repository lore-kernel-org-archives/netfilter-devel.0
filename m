Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090CB1E9B1A
	for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768671160; cv=none; b=IuXTJP9N3+zcmfDxlPKU7dB5BlEV20G4nNchXmABk7uZgTH0GZbT8g4I0cSPrYoThc05XXPBonPvMnKcXhzkJ/KLX6ukcfd6zzqMbj+DgK6mEAy8WkLyJWlTi9pS9gYZ9ymW0IDUCXEZJ4RigzA7BPsKzeYbR+1noddpGeuz4B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768671160; c=relaxed/simple;
	bh=cJYasRhiERLYuANQ7GWpF+sPnKaPFFAmKfvlSDOLXkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hn7YPSxNT7TdNhm7FIkEVVctkxCy9zmSl89APCe+Kk57MaqVN6JAPx4HARusz/igEAsoVIcC+S9RZDYgxHHlLBv+uIZAXtxXxQM4q2awg4qYkQn8aOJyJmsmNJyaOOx6jBw83b8IBeSVUmSdnIDkb5gacbDzfidmJFwP7Xkx3HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPgizIMt; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPgizIMt"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2ae61424095so3242004eec.1
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2026 09:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768671158; x=1769275958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VCHTqt9zdTEOnQwhDzXbV5p6SXRicPFE0YZbJjkWFe4=;
        b=CPgizIMtBAss10HJC4QYT3fs0ryVanWMezi0mOnOoafxx1xXTkC7Qt8BBfkbGLaHTR
         NkhRVl/a9rPypRFndbYgfp392EVzFcNrKk9Bi0RJrPpdvvKhzaFWWEqKO2BM2D8FlCkC
         shYWWlD6n3fcHpvCIRRegSg3Jby7MAF8pEyz6vjEjLIR6Skzb1C4TFfaoPqEDb/pvR4R
         JEhzd3W2H9tkS+XdouGQ/beOaZ1qOAJDq7quEW1iSSe8JVEHSkVDg8W5eOOyYPJLBF2p
         noHq++mi750AwQH5OhjfDugaQPJaCt4hUf1HMGOddB344pBuuK5Mv3/EkkF5NzlB/ULd
         ShHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768671158; x=1769275958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VCHTqt9zdTEOnQwhDzXbV5p6SXRicPFE0YZbJjkWFe4=;
        b=vNMDDSiD3NWuhVZV9cMODRLRgwvIyJH/ywmVuLZ291J8gdBlJkQuDPbdhYs1L4TAR0
         xxcshfH2Wgtkgy8Y4rX84SbzFfAzBJ14mKkogHQRQ9RtPVBvc1cDE6qn+hmbtLfTjQ6M
         O5o11HT8DWqpAFiVzNpei1wwegkj2HDmG0/mCISBeDrDsKPNTxqi1NjTN9Tc7QLx3biy
         ghU0YgNPpDOcjejVOy+JStLUWnOkk4sboDZHcHhpfeB/vciEHWD2P6JiN+wQO4KCqexR
         RRNwI2vz6jvq7JPLcXGu4kMn0zMaWbBGK5Wf5xQoFh8MVpOHina/Z/znTEFcTdxWBGt9
         6m6g==
X-Gm-Message-State: AOJu0YxkExEFusQQFiY05YU8y4X98FzMpFMRyQglXo3QSjDPvIEgngS/
	yX1uhSTUHnmERl9VuyFPObivDdEgcmiOMGvc9an3s/J4wovfA6R3rRuk6bJviw==
X-Gm-Gg: AY/fxX4O0FIvUsAQJguK5lcsNFqH1bH24oRfj9oYYBEXDpmNpU0k+MavZ+rarSbbv6L
	N7erb2FscfBlxA5k4xQs6UHTVyRsWxQq42SNmawubrMMs085KB1Ftv2vIbv5ULK778Quddi7rTT
	8qQ8T2UvxOw+uOkN4Gq56AcNhvlY5FwJRP9IgVIeOgBcQTOChMIcnbFEm/OQy1z+ytRZDlG/cyP
	s7TufVuqfIXrskh+3btB36YY6UJ6QCVo0lF+WgU7QGMsDBTrKmgrAK/pem75ARmcYz6V+cu4hyg
	S1jh3WUuK2qYRWtVIrbHlajs0eY2tiKWr7Wn3qlHmCk0p8t3FCWTPjfng98bSe2OFDXyNSLky0B
	pRaWDPhczUcboN4+VI8/AEawUYkhVsLLrx41RQ6sv2/E47RI+TUT3MAa+un1r2lLqZuOC6n1aIc
	G0Z0f9s19qEBadKMoaz4ju7sFHH8fav0f+
X-Received: by 2002:a05:7301:fa0e:b0:2ae:533d:19bd with SMTP id 5a478bee46e88-2b6b46d2fa6mr4180735eec.8.1768671157591;
        Sat, 17 Jan 2026 09:32:37 -0800 (PST)
Received: from mac.com ([136.24.82.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b6b361f5c9sm6486614eec.22.2026.01.17.09.32.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 17 Jan 2026 09:32:37 -0800 (PST)
From: scott.k.mitch1@gmail.com
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Scott Mitchell <scott.k.mitch1@gmail.com>
Subject: [PATCH v6 2/2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Sat, 17 Jan 2026 09:32:31 -0800
Message-Id: <20260117173231.88610-3-scott.k.mitch1@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
References: <20260117173231.88610-1-scott.k.mitch1@gmail.com>
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
packet lookup by ID. The hash table automatically resizes based on
queue depth: grows at 75% load factor, shrinks at 25% load factor.
To prevent rapid resize cycling during traffic bursts, shrinking only
occurs if at least 60 seconds have passed since the last shrink.

Hash table memory is allocated with GFP_KERNEL_ACCOUNT so memory is
attributed to the cgroup rather than kernel overhead.

The existing list data structure is retained for operations requiring
linear iteration (e.g. flush, device down events). Hot fields
(queue_hash_mask, queue_hash pointer, resize state) are placed in the
same cache line as the spinlock and packet counters for optimal memory
access patterns.

Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>
---
 include/net/netfilter/nf_queue.h |   1 +
 net/netfilter/nfnetlink_queue.c  | 237 +++++++++++++++++++++++++++++--
 2 files changed, 229 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 4aeffddb7586..3d0def310523 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -11,6 +11,7 @@
 /* Each queued (to userspace) skbuff has one of these. */
 struct nf_queue_entry {
 	struct list_head	list;
+	struct hlist_node	hash_node;
 	struct sk_buff		*skb;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7b2cabf08fdf..772d2a7d0d7c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -30,6 +30,11 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/list.h>
 #include <linux/cgroup-defs.h>
+#include <linux/workqueue.h>
+#include <linux/jiffies.h>
+#include <linux/log2.h>
+#include <linux/memcontrol.h>
+#include <linux/sched/mm.h>
 #include <net/gso.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
@@ -46,7 +51,11 @@
 #include <net/netfilter/nf_conntrack.h>
 #endif
 
-#define NFQNL_QMAX_DEFAULT 1024
+#define NFQNL_QMAX_DEFAULT         1024
+#define NFQNL_HASH_MIN_SIZE        16
+#define NFQNL_HASH_MAX_SIZE        131072
+#define NFQNL_HASH_DEFAULT_SIZE    NFQNL_HASH_MIN_SIZE
+#define NFQNL_HASH_SHRINK_INTERVAL (60 * HZ)	/* Only shrink every 60 seconds */
 
 /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
  * includes the header length. Thus, the maximum packet length that we
@@ -59,6 +68,11 @@
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	struct rcu_head rcu;
+	struct work_struct destroy_work;
+	struct work_struct resize_work;
+#ifdef CONFIG_MEMCG
+	struct mem_cgroup *resize_memcg;
+#endif
 
 	u32 peer_portid;
 	unsigned int queue_maxlen;
@@ -66,7 +80,6 @@ struct nfqnl_instance {
 	unsigned int queue_dropped;
 	unsigned int queue_user_dropped;
 
-
 	u_int16_t queue_num;			/* number of this queue */
 	u_int8_t copy_mode;
 	u_int32_t flags;			/* Set using NFQA_CFG_FLAGS */
@@ -77,6 +90,10 @@ struct nfqnl_instance {
 	spinlock_t	lock	____cacheline_aligned_in_smp;
 	unsigned int	queue_total;
 	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
+	unsigned int	queue_hash_size;
+	unsigned int	queue_hash_mask;
+	unsigned long	queue_hash_last_shrink_jiffies;
+	struct hlist_head *queue_hash;
 	struct list_head queue_list;		/* packets in queue */
 };
 
@@ -114,9 +131,183 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 	return NULL;
 }
 
+static inline unsigned int
+nfqnl_packet_hash(unsigned int id, unsigned int mask)
+{
+	return id & mask;
+}
+
+static inline void
+nfqnl_resize_schedule_work(struct nfqnl_instance *queue, struct sk_buff *skb)
+{
+#ifdef CONFIG_MEMCG
+	/* Capture the cgroup of the packet triggering the grow request.
+	 * If resize_memcg is already set, a previous packet claimed it.
+	 * If the worker is currently running, it clears this pointer
+	 * early, allowing us to queue the blame for the next run.
+	 */
+	if (!queue->resize_memcg && skb->sk && sk_fullsock(skb->sk) && skb->sk->sk_memcg) {
+		queue->resize_memcg = skb->sk->sk_memcg;
+		/* Increment reference count */
+		css_get(&queue->resize_memcg->css);
+	}
+#endif
+
+	schedule_work(&queue->resize_work);
+}
+
+static inline bool
+nfqnl_should_grow(struct nfqnl_instance *queue)
+{
+	/* Grow if above 75% */
+	return queue->queue_total > (queue->queue_hash_size / 4 * 3) &&
+		queue->queue_hash_size < NFQNL_HASH_MAX_SIZE;
+}
+
+static inline void
+nfqnl_check_grow(struct nfqnl_instance *queue, struct sk_buff *skb)
+{
+	if (nfqnl_should_grow(queue))
+		nfqnl_resize_schedule_work(queue, skb);
+}
+
+static inline bool
+nfqnl_should_shrink(struct nfqnl_instance *queue)
+{
+	/* shrink if below 25% and 60+ seconds since last shrink */
+	return queue->queue_total < (queue->queue_hash_size / 4) &&
+		queue->queue_hash_size > NFQNL_HASH_MIN_SIZE &&
+		time_after(jiffies,
+			   queue->queue_hash_last_shrink_jiffies + NFQNL_HASH_SHRINK_INTERVAL);
+}
+
+static inline void
+nfqnl_check_shrink(struct nfqnl_instance *queue, struct sk_buff *skb)
+{
+	if (nfqnl_should_shrink(queue))
+		nfqnl_resize_schedule_work(queue, skb);
+}
+
+static void
+nfqnl_hash_resize_work(struct work_struct *work)
+{
+	struct nfqnl_instance *inst = container_of(work, struct nfqnl_instance, resize_work);
+	struct mem_cgroup *old_memcg = NULL, *target_memcg = NULL;
+	struct hlist_head *new_hash, *old_hash;
+	struct nf_queue_entry *entry;
+	unsigned int h, hash_mask, new_size;
+
+	/* Check current size under lock and determine if grow/shrink is required */
+	spin_lock_bh(&inst->lock);
+#ifdef CONFIG_MEMCG
+	target_memcg = inst->resize_memcg;
+	inst->resize_memcg = NULL;
+#endif
+
+	new_size = inst->queue_hash_size;
+	if (nfqnl_should_grow(inst)) {
+		/* Resize cannot be done synchronously from __enqueue_entry because
+		 * it runs in softirq context where the GFP_KERNEL_ACCOUNT allocation
+		 * (which can sleep) is not allowed. Instead, resize is deferred to
+		 * work queue. During packet bursts, multiple enqueues may occur before
+		 * any work runs, so we calculate target size based on current queue_total
+		 * (aiming for 75% load) rather than just doubling. Ensure minimum 2x
+		 * growth to avoid tiny increments.
+		 */
+		new_size = (inst->queue_total > NFQNL_HASH_MAX_SIZE * 3 / 4) ?
+			NFQNL_HASH_MAX_SIZE :
+			roundup_pow_of_two(inst->queue_total / 3 * 4);
+
+		new_size = max(new_size, inst->queue_hash_size * 2);
+	} else if (nfqnl_should_shrink(inst)) {
+		new_size = inst->queue_hash_size / 2;
+	}
+
+	if (new_size == inst->queue_hash_size) {
+		spin_unlock_bh(&inst->lock);
+		goto out_put;
+	}
+
+	/* Work queue serialization guarantees only one instance of this function
+	 * runs at a time for a given queue, so we can safely drop the lock during
+	 * allocation without worrying about concurrent resizes.
+	 */
+	spin_unlock_bh(&inst->lock);
+
+	if (target_memcg)
+		old_memcg = set_active_memcg(target_memcg);
+
+	new_hash = kvmalloc_array(new_size, sizeof(*new_hash), GFP_KERNEL_ACCOUNT);
+
+	if (target_memcg)
+		set_active_memcg(old_memcg);
+
+	if (!new_hash)
+		goto out_put;
+
+	hash_mask = new_size - 1;
+	for (h = 0; h < new_size; h++)
+		INIT_HLIST_HEAD(&new_hash[h]);
+
+	spin_lock_bh(&inst->lock);
+
+	list_for_each_entry(entry, &inst->queue_list, list) {
+		/* No hlist_del() since old_hash will be freed and we hold lock */
+		h = nfqnl_packet_hash(entry->id, hash_mask);
+		hlist_add_head(&entry->hash_node, &new_hash[h]);
+	}
+
+	old_hash = inst->queue_hash;
+
+	if (new_size < inst->queue_hash_size)
+		inst->queue_hash_last_shrink_jiffies = jiffies;
+
+	inst->queue_hash_size = new_size;
+	inst->queue_hash_mask = hash_mask;
+	inst->queue_hash = new_hash;
+
+	spin_unlock_bh(&inst->lock);
+
+	kvfree(old_hash);
+
+out_put:
+#ifdef CONFIG_MEMCG
+	/* Decrement reference count after we are done */
+	if (target_memcg)
+		css_put(&target_memcg->css);
+#endif
+}
+
+static void
+instance_destroy_work(struct work_struct *work)
+{
+	struct nfqnl_instance *inst = container_of(work, struct nfqnl_instance,
+						    destroy_work);
+
+	/* Cancel resize_work to avoid use-after-free */
+	cancel_work_sync(&inst->resize_work);
+
+#ifdef CONFIG_MEMCG
+	if (inst->resize_memcg)
+		css_put(&inst->resize_memcg->css);
+#endif
+
+	kvfree(inst->queue_hash);
+	kfree(inst);
+	module_put(THIS_MODULE);
+}
+
 static struct nfqnl_instance *
 instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 {
+	/* Must be power of two for queue_hash_mask to work correctly.
+	 * Avoid overflow of is_power_of_2 by bounding NFQNL_MAX_HASH_SIZE.
+	 */
+	BUILD_BUG_ON(!is_power_of_2(NFQNL_HASH_MIN_SIZE) ||
+		     !is_power_of_2(NFQNL_HASH_DEFAULT_SIZE) ||
+		     !is_power_of_2(NFQNL_HASH_MAX_SIZE) ||
+		     NFQNL_HASH_MAX_SIZE > 1U << 31);
+
 	struct nfqnl_instance *inst;
 	unsigned int h;
 	int err;
@@ -125,11 +316,26 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	if (!inst)
 		return ERR_PTR(-ENOMEM);
 
+	inst->queue_hash_size = NFQNL_HASH_DEFAULT_SIZE;
+	inst->queue_hash_mask = inst->queue_hash_size - 1;
+	inst->queue_hash = kvmalloc_array(inst->queue_hash_size, sizeof(*inst->queue_hash),
+					  GFP_KERNEL_ACCOUNT);
+	if (!inst->queue_hash) {
+		err = -ENOMEM;
+		goto out_free;
+	}
+
+	for (h = 0; h < inst->queue_hash_size; h++)
+		INIT_HLIST_HEAD(&inst->queue_hash[h]);
+
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
 	inst->copy_range = NFQNL_MAX_COPY_RANGE;
 	inst->copy_mode = NFQNL_COPY_NONE;
+	inst->queue_hash_last_shrink_jiffies = jiffies;
+	INIT_WORK(&inst->destroy_work, instance_destroy_work);
+	INIT_WORK(&inst->resize_work, nfqnl_hash_resize_work);
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
@@ -153,6 +359,9 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 out_unlock:
 	spin_unlock(&q->instances_lock);
+
+out_free:
+	kvfree(inst->queue_hash);
 	kfree(inst);
 	return ERR_PTR(err);
 }
@@ -169,8 +378,11 @@ instance_destroy_rcu(struct rcu_head *head)
 	rcu_read_lock();
 	nfqnl_flush(inst, NULL, 0);
 	rcu_read_unlock();
-	kfree(inst);
-	module_put(THIS_MODULE);
+
+	/* Defer kvfree to process context (work queue) because kvfree can
+	 * sleep if memory was vmalloc'd, and RCU callbacks run in softirq.
+	 */
+	schedule_work(&inst->destroy_work);
 }
 
 static void
@@ -191,25 +403,33 @@ instance_destroy(struct nfnl_queue_net *q, struct nfqnl_instance *inst)
 static inline void
 __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
-       list_add_tail(&entry->list, &queue->queue_list);
-       queue->queue_total++;
+	unsigned int hash = nfqnl_packet_hash(entry->id, queue->queue_hash_mask);
+
+	hlist_add_head(&entry->hash_node, &queue->queue_hash[hash]);
+	list_add_tail(&entry->list, &queue->queue_list);
+	queue->queue_total++;
+	nfqnl_check_grow(queue, entry->skb);
 }
 
 static void
 __dequeue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
+	hlist_del(&entry->hash_node);
 	list_del(&entry->list);
 	queue->queue_total--;
+	nfqnl_check_shrink(queue, entry->skb);
 }
 
 static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
 	struct nf_queue_entry *entry = NULL, *i;
+	unsigned int hash;
 
 	spin_lock_bh(&queue->lock);
 
-	list_for_each_entry(i, &queue->queue_list, list) {
+	hash = nfqnl_packet_hash(id, queue->queue_hash_mask);
+	hlist_for_each_entry(i, &queue->queue_hash[hash], hash_node) {
 		if (i->id == id) {
 			entry = i;
 			break;
@@ -404,8 +624,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
+			__dequeue_entry(queue, entry);
 			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
-- 
2.39.5 (Apple Git-154)

