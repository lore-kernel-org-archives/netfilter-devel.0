Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B80133ADAE
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963425; cv=none; b=P/1WbncA+madMem3ML+Ltj8YAbOJodu52rDUPyp5wG2VYqftj7ln8+15d7l/aMYnkeACB1X/VVh/U3eJy1uyR/fekqFqat9/f4E0nJwiEjshZC7vxwvJIsVrDKn0IGVaQK1+ynW4uv66k+H4VPLWhAaQ65iQUVHDlkuO7EO0Cts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963425; c=relaxed/simple;
	bh=uB1oQtOQ15BLSaUWuhZgZHXrjItQNcG9k2ZhCYTfeUY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SHQS9G26mAScg9gom1dpQt/M1dToQpvqjXl+k0+0s8LBkIqOe76Uc8Z8RoN0X7ptao+uy3qsFgzA3hhAi6sCF6zw41+fdnMefwstpyjvD+flFfdquaUeiEdI8eOIyiBOxoRiTgB7aKiwpd20hbFaIIgQUXK2vZ5LRpNiJtt3EAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrNIZwfB; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrNIZwfB"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-782e93932ffso921642b3a.3
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 08:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762963423; x=1763568223; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3aer1zYnzBnP7WlGWfehdI1nNpZrBenxdLy983KU5T8=;
        b=LrNIZwfBQr4HD4cgwzirH687/+tALiZon1LFliVYTiBgc1JNrg3pRQR6P/rbtQPyjv
         ndw9BucB0dXUfbculFUY0fBXhZ6LSaSIxU3j3OzRwKVkGff+5hXRmCANHcH/Bcpxvnat
         2QPiQFhtb9K/LzRxXRS89bnjfK3FOgHeJoXLg7abdQjtnnizEeEp1LTqqlVpyhFWq/MS
         nDsLlvsaUSIrWdSYlvfsqekUj4a3gqs6+eFmfi9sjxGDfFDdvygFd7TaiE/Eqa/rFbBL
         VN8U3dUlxlB1cqUQDLGWyqhq0vpbNBSGN81X7XaW0bhQaRRYfJ1BVyAjrCtjioFL+c2v
         dSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762963423; x=1763568223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aer1zYnzBnP7WlGWfehdI1nNpZrBenxdLy983KU5T8=;
        b=KWmcxKNmfhkloVe0A4Eb2D1bsMs06ON8swO+K6rNKLOEvyjpzNzR4ePqcHvcNxHqoe
         vDkZaoenhAok4H/fELt/nTb0doSqZW440YusL5qFI8xYf1egvmwVGazhR5VVyGW8OmTZ
         AqLO5xDEsLHbisf4zCnU6/U5dWlWpma68vuHGdkgQ16Be/rVIWLBSGpS49ymqz0Q0iG1
         gBdC1elkyuRkUxL41eUBX7gwKE7foJyx2lfYgi74SJqKECebsWdX3GpdI2bVPMe1Udbf
         EgjBIKDvuF0ShDvpIktWAIs0hF3siwe2ineh7o/kGq7ikaLscXNW2BWvZi0mWKPGZL9r
         ez2A==
X-Forwarded-Encrypted: i=1; AJvYcCWJAcLhreo2+aQ3GP5B3CBO4hxbpn0OX02hK3JbALVAuvlp6KP76v2khL7M84QlgUyPHAawQW9aW3uByFlGS6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVnCOzn0APKWh69klRS7BDXxTpogzjbk86jtcEC1o084HE0Cpx
	XN0pw/xh6ZAbjDAGa9Tc3Fx/a3T0NBKbjfz6+FS3W3RdXSVwNlrbXfeP
X-Gm-Gg: ASbGncvZZuTU1lQMZ9srOXuDBj+wtNRD9fUEGQALsvogso5X60j5ZDue9ntTU4NWxVA
	i1RKX8voXfbIzIVoe6p5YXoz8yEBdOF1QAwor3XqyMityjGUrzJYTTpZ/c11vgOq7MH7DKclW3F
	iZASF+xvU+kpYs+vjZ3DY9nGow9rl9qmHn83OnEpvg9D05Gh4MISjlCjJvXb1KlcAcxIeEdB8rL
	G5bHaPKWqhibqx86/f2zxKS06Qf8eYUcM3Gu62SqjIh0GzMngb60hzPkreq4IRXCzvDQcsjni5m
	bYoBOly6b+8F7LvDxTRBIWT7q7lGnLmeMRL/IFETMZQMWBXYlRUApzlYoVlhVyxX38RurBXUej+
	+b74pLqbH7qUesGeLwZ8FMc3A3+3Np2z2HiwqhRKy1jqxFdSYOcj1cfCWXJ7V000nm6+3kQ+RsM
	ik3v0FLdv3uyQxANOzKrM/oQYRfvzS5nlimFC3QJFlIg==
X-Google-Smtp-Source: AGHT+IHBAoSxsZdpC3n/QTGqyr3DK1eINEAeZtHdkSCkrpX1RfaxlZHuNTnv+5sd0BxGuaY4f6LQwg==
X-Received: by 2002:a05:6a21:3394:b0:354:e52e:135a with SMTP id adf61e73a8af0-3590939889amr4481664637.1.1762963422093;
        Wed, 12 Nov 2025 08:03:42 -0800 (PST)
Received: from mr55p01nt-relayp04.apple.com ([216.157.103.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b8a7d9b543sm509424b3a.53.2025.11.12.08.03.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 12 Nov 2025 08:03:41 -0800 (PST)
From: Scott Mitchell <scott.k.mitch1@gmail.com>
X-Google-Original-From: Scott Mitchell <scott_mitchell@apple.com>
To: pablo@netfilter.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Scott Mitchell <scott_mitchell@apple.com>
Subject: [PATCH] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Wed, 12 Nov 2025 08:03:33 -0800
Message-Id: <20251112160333.30883-1-scott_mitchell@apple.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The current implementation uses a linear list to find queued packets by
ID when processing verdicts from userspace. With large queue depths and
out-of-order verdicting, this O(n) lookup becomes a significant
bottleneck, causing userspace verdict processing to dominate CPU time.

Replace the linear search with a hash table for O(1) average-case
packet lookup by ID. The hash table size is configurable via the new
NFQA_CFG_HASH_SIZE netlink attribute (default 1024 buckets, matching
NFQNL_QMAX_DEFAULT; max 131072). The size is normalized to a power of
two to enable efficient bitwise masking instead of modulo operations.
Unpatched kernels silently ignore the new attribute, maintaining
backward compatibility.

The existing list data structure is retained for operations requiring
linear iteration (e.g. flush, device down events). Hot fields
(queue_hash_mask, queue_hash pointer) are placed in the same cache line
as the spinlock and packet counters for optimal memory access patterns.

Signed-off-by: Scott Mitchell <scott_mitchell@apple.com>
---
 include/net/netfilter/nf_queue.h              |   1 +
 .../uapi/linux/netfilter/nfnetlink_queue.h    |   1 +
 net/netfilter/nfnetlink_queue.c               | 137 +++++++++++++++++-
 3 files changed, 131 insertions(+), 8 deletions(-)

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
diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index efcb7c044a74..bc296a17e5aa 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -107,6 +107,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
 	NFQA_CFG_MASK,			/* identify which flags to change */
 	NFQA_CFG_FLAGS,			/* value of these flags (__u32) */
+	NFQA_CFG_HASH_SIZE,		/* __u32 hash table size (rounded to power of 2) */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8b7b39d8a109..a344c987c33b 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -46,7 +46,10 @@
 #include <net/netfilter/nf_conntrack.h>
 #endif
 
-#define NFQNL_QMAX_DEFAULT 1024
+#define NFQNL_QMAX_DEFAULT      1024
+#define NFQNL_MIN_HASH_SIZE     16
+#define NFQNL_DEFAULT_HASH_SIZE 1024
+#define NFQNL_MAX_HASH_SIZE     131072
 
 /* We're using struct nlattr which has 16bit nla_len. Note that nla_len
  * includes the header length. Thus, the maximum packet length that we
@@ -65,6 +68,7 @@ struct nfqnl_instance {
 	unsigned int copy_range;
 	unsigned int queue_dropped;
 	unsigned int queue_user_dropped;
+	unsigned int queue_hash_size;
 
 
 	u_int16_t queue_num;			/* number of this queue */
@@ -77,6 +81,8 @@ struct nfqnl_instance {
 	spinlock_t	lock	____cacheline_aligned_in_smp;
 	unsigned int	queue_total;
 	unsigned int	id_sequence;		/* 'sequence' of pkt ids */
+	unsigned int	queue_hash_mask;
+	struct hlist_head *queue_hash;
 	struct list_head queue_list;		/* packets in queue */
 };
 
@@ -95,6 +101,39 @@ static struct nfnl_queue_net *nfnl_queue_pernet(struct net *net)
 	return net_generic(net, nfnl_queue_net_id);
 }
 
+static inline unsigned int
+nfqnl_packet_hash(u32 id, unsigned int mask)
+{
+	return hash_32(id, 32) & mask;
+}
+
+static inline u32
+nfqnl_normalize_hash_size(u32 hash_size)
+{
+	/* Must be power of two for queue_hash_mask to work correctly.
+	 * Avoid overflow of is_power_of_2 by bounding NFQNL_MAX_HASH_SIZE.
+	 */
+	BUILD_BUG_ON(!is_power_of_2(NFQNL_MIN_HASH_SIZE) ||
+		     !is_power_of_2(NFQNL_DEFAULT_HASH_SIZE) ||
+		     !is_power_of_2(NFQNL_MAX_HASH_SIZE) ||
+		     NFQNL_MAX_HASH_SIZE > 1U << 31);
+
+	if (!hash_size)
+		return NFQNL_DEFAULT_HASH_SIZE;
+
+	/* Clamp to valid range before power of two to avoid overflow */
+	if (hash_size <= NFQNL_MIN_HASH_SIZE)
+		return NFQNL_MIN_HASH_SIZE;
+
+	if (hash_size >= NFQNL_MAX_HASH_SIZE)
+		return NFQNL_MAX_HASH_SIZE;
+
+	if (!is_power_of_2(hash_size))
+		hash_size = roundup_pow_of_two(hash_size);
+
+	return hash_size;
+}
+
 static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 {
 	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
@@ -114,13 +153,63 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 	return NULL;
 }
 
+static int
+nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
+{
+	struct hlist_head *new_hash, *old_hash;
+	struct nf_queue_entry *entry;
+	unsigned int h, hash_mask;
+
+	/* lock scope includes kcalloc/kfree to bound memory if concurrent resizes.
+	 * lock scope could be reduced to exclude the  kcalloc/kfree at the cost
+	 * of increased code complexity (re-check of hash_size) and relaxed memory
+	 * bounds (concurrent resize may each do allocations). since resize is
+	 * expected to be rare, the broader lock scope is simpler and preferred.
+	 */
+	spin_lock_bh(&inst->lock);
+
+	hash_size = nfqnl_normalize_hash_size(hash_size);
+	if (hash_size == inst->queue_hash_size)
+		return 0;
+
+	new_hash = kcalloc(hash_size, sizeof(*new_hash), GFP_ATOMIC);
+	if (!new_hash)
+		return -ENOMEM;
+
+	hash_mask = hash_size - 1;
+
+	for (h = 0; h < hash_size; h++)
+		INIT_HLIST_HEAD(&new_hash[h]);
+
+	list_for_each_entry(entry, &inst->queue_list, list) {
+		/* No hlist_del() since old_hash will be freed and we hold lock */
+		h = nfqnl_packet_hash(entry->id, hash_mask);
+		hlist_add_head(&entry->hash_node, &new_hash[h]);
+	}
+
+	old_hash = inst->queue_hash;
+	inst->queue_hash_size = hash_size;
+	inst->queue_hash_mask = hash_mask;
+	inst->queue_hash = new_hash;
+
+	/* free before unlock. make memory available to concurrent resizes. */
+	kfree(old_hash);
+
+	spin_unlock_bh(&inst->lock);
+
+	return 0;
+}
+
 static struct nfqnl_instance *
-instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
+instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid,
+		u32 hash_size)
 {
 	struct nfqnl_instance *inst;
 	unsigned int h;
 	int err;
 
+	hash_size = nfqnl_normalize_hash_size(hash_size);
+
 	spin_lock(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err = -EEXIST;
@@ -133,11 +222,24 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 		goto out_unlock;
 	}
 
+	inst->queue_hash = kcalloc(hash_size, sizeof(*inst->queue_hash),
+				   GFP_ATOMIC);
+	if (!inst->queue_hash) {
+		kfree(inst);
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	for (h = 0; h < hash_size; h++)
+		INIT_HLIST_HEAD(&inst->queue_hash[h]);
+
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
 	inst->copy_range = NFQNL_MAX_COPY_RANGE;
 	inst->copy_mode = NFQNL_COPY_NONE;
+	inst->queue_hash_size = hash_size;
+	inst->queue_hash_mask = hash_size - 1;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
@@ -154,6 +256,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	return inst;
 
 out_free:
+	kfree(inst->queue_hash);
 	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
@@ -172,6 +275,7 @@ instance_destroy_rcu(struct rcu_head *head)
 	rcu_read_lock();
 	nfqnl_flush(inst, NULL, 0);
 	rcu_read_unlock();
+	kfree(inst->queue_hash);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -194,13 +298,17 @@ instance_destroy(struct nfnl_queue_net *q, struct nfqnl_instance *inst)
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
 }
 
 static void
 __dequeue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
 {
+	hlist_del(&entry->hash_node);
 	list_del(&entry->list);
 	queue->queue_total--;
 }
@@ -209,10 +317,11 @@ static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
 	struct nf_queue_entry *entry = NULL, *i;
+	unsigned int hash = nfqnl_packet_hash(id, queue->queue_hash_mask);
 
 	spin_lock_bh(&queue->lock);
 
-	list_for_each_entry(i, &queue->queue_list, list) {
+	hlist_for_each_entry(i, &queue->queue_hash[hash], hash_node) {
 		if (i->id == id) {
 			entry = i;
 			break;
@@ -407,8 +516,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
+			__dequeue_entry(queue, entry);
 			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
@@ -1483,6 +1591,7 @@ static const struct nla_policy nfqa_cfg_policy[NFQA_CFG_MAX+1] = {
 	[NFQA_CFG_QUEUE_MAXLEN]	= { .type = NLA_U32 },
 	[NFQA_CFG_MASK]		= { .type = NLA_U32 },
 	[NFQA_CFG_FLAGS]	= { .type = NLA_U32 },
+	[NFQA_CFG_HASH_SIZE]    = { .type = NLA_U32 },
 };
 
 static const struct nf_queue_handler nfqh = {
@@ -1495,11 +1604,16 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
+	u32 hash_size = 0;
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
 	int ret = 0;
 
+	if (nfqa[NFQA_CFG_HASH_SIZE]) {
+		hash_size = ntohl(nla_get_be32(nfqa[NFQA_CFG_HASH_SIZE]));
+	}
+
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
 
@@ -1559,11 +1673,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 				goto err_out_unlock;
 			}
 			queue = instance_create(q, queue_num,
-						NETLINK_CB(skb).portid);
+						NETLINK_CB(skb).portid, hash_size);
 			if (IS_ERR(queue)) {
 				ret = PTR_ERR(queue);
 				goto err_out_unlock;
 			}
+			hash_size = 0; /* avoid resize later in this function */
 			break;
 		case NFQNL_CFG_CMD_UNBIND:
 			if (!queue) {
@@ -1586,6 +1701,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 		goto err_out_unlock;
 	}
 
+	if (hash_size > 0) {
+		ret = nfqnl_hash_resize(queue, hash_size);
+		if (ret)
+			goto err_out_unlock;
+	}
+
 	if (nfqa[NFQA_CFG_PARAMS]) {
 		struct nfqnl_msg_config_params *params =
 			nla_data(nfqa[NFQA_CFG_PARAMS]);
-- 
2.39.5 (Apple Git-154)

