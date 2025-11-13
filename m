Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678D52F3622
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048775; cv=none; b=D214sbf65CAG03X/vhnoBowwrvlqpCpEwo+6HtxnQoiahrBjZldt/0B8cckN8F01dgIYJe6QZA4lufeCujXTryolbjEv6nkyiy9GX9g6KJ0OPGjgL78xbeUxxxYaMIzKNnJgGzurghvVSdID7jCwEDQOCt+GtDlKbgVjqIPSOfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048775; c=relaxed/simple;
	bh=EHxAjQodyLxKTZUe1eSBMc9rnlQqTUx9xQuWpOEXOlc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f3QdGfcCcjClUWyU3iri/EQNfRqGrJ9t70iDNXHZH184+B51+pvBn63nvsCs0EpHhKf5XbqC5soQK21kRlYd/MKWFQo4j6OSsVFoSkOZZNtQuakZjl1M5ElXzcw1g5cUTlmcSV/PXsuke/wOtUTkOHV0PwRhlZ2ouezTkjoOmdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AwpzLUjm; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AwpzLUjm"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2984dfae043so8702435ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 07:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763048773; x=1763653573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xc5yrepmdjoxurs6PO4VOjZO4dMJ46a8Vl67riYYgsQ=;
        b=AwpzLUjmaN0SorY47MeXSNoaTObvjv1KE/l1OpUEYln3+aDHCAeaV2g/46XqCtrOR1
         tcENFOTyX/fac9eDOK0/SqEJ3VPn/SulERCxFj/abFWZYqIb4JI5peK6XornU+y6Iybc
         KNI6i0eYJRQu40ZxgkzsP1jdt+M9PHCx75+70z6xvqExSlNjmI9ENsUNax1H7H/1MLEm
         zcOvh5axPZZMYqD6Kr46pJzUhy1U3iSiC7OlY+ahR0P0QTtI+jSOicJKWK8+ZtjY6Fft
         rKen7VbVbG6PMeqzTc5A0ocDhsZqoBOotsJKZcKzDv0zt/dSN338Rr+EebEqJVa37FK1
         sZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048773; x=1763653573;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xc5yrepmdjoxurs6PO4VOjZO4dMJ46a8Vl67riYYgsQ=;
        b=YEGlz/x5u4Uyv0M6egKP0F5gPkEV9jLKIgcKnxpkJpnSXwmK7RVaMfCCfvOiRUq7J/
         TH4keOYFni5sVbPLwO8QW1BIlphb2mHo7/YIBYLrVdGns6fiZZGLmZvRbloe6RLwxIqO
         ZABywn5cq80USvUzIdEhKjBbs+giIzn8RzDo4hQfQIrXZVI1H7LnD3ONs3Xo1vZhHQIt
         n3T4QI07v7pP4YYRxNAAcS/Fjsw4pvITYNmFTDBp9I6eOm49ZRd8w7zyt+53m2l5h0ry
         rWono/WxWgj89Smr66v4iocJ35DKuXAL3GIiKOCFd/HMHx7lKhvAbqHbzQOmmy2aoXyj
         WNuA==
X-Forwarded-Encrypted: i=1; AJvYcCVxsc/JTypz/YqVPmbDdi9+FK99T9cL+C0/fRMw2vyO/0Bw6lB00futhIv3yKxZJ27nw8C74Y/KEp0QtI9ZYEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZjxEdb1rjetCDZbr4Y5EXWkKhGMe/h/uMtltFK/FxOx0OUj9K
	5PO1/UvXMcB22r9c7cLjwhECHcrHmxrMrdBId9qglWvDgwvuyXb4rjZO
X-Gm-Gg: ASbGncuuv1fSKYhxJflPUlsYcRPcsejjz5hBuJ4lkcRl9gpwNqwSX8So9K7NloWTsHs
	ZkFyVoom7lo+GdQ7jVUimmGAd+wQBk7LFS/DUJSfQTOHuZsc55oebyKOIGoICYGTqM90xZZz0qs
	z1v26Za2XDk9wvXsCctabBk8RdsKbWypb+sC12AkYOrGAdjNxpoqoPhesk+24InBtjm5YYAtAki
	iPfh6919IkznEM5IG00ReXzDvvgB1KX2AGgIyXnMe0e7xFNrcEsilBWYbLMYzJ7oDItUz9DShjq
	ZGmlVy3QcvJNRzr6In16vnj3qd4KY7CLamaqVW/IZqPwNRgOVWiqOpDFGy5JyWbT5vTgwqVWznD
	cdzVCjx9fcLrertbdDwIu3NFwm5iHsDIv7hLRJFs3YbyEOPqdFJkUXrojbWSKxTIztwARY097iu
	+t2+NIxfMI3yQ/7GdUzf9/Ajm7NZJ9EmRY8HOnK6tKDg==
X-Google-Smtp-Source: AGHT+IGLHAw7AhtmriuwdcKHeIFHniEPs4DLrezs+673GZioe8ORYJsd92ha9RkKwzm7w6rfxeOh8g==
X-Received: by 2002:a17:90b:3a4d:b0:340:25f0:a9b with SMTP id 98e67ed59e1d1-343dded1044mr9345261a91.33.1763048772601;
        Thu, 13 Nov 2025 07:46:12 -0800 (PST)
Received: from mr41p01nt-relayp04.apple.com ([216.157.103.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343ed556953sm2955014a91.15.2025.11.13.07.46.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 13 Nov 2025 07:46:12 -0800 (PST)
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
	Scott Mitchell <scott.k.mitch1@gmail.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH v4] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Thu, 13 Nov 2025 07:46:05 -0800
Message-Id: <20251113154605.23370-1-scott_mitchell@apple.com>
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

Signed-off-by: Scott Mitchell <scott.k.mitch1@gmail.com>

Tested-by: syzbot@syzkaller.appspotmail.com
---
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

 include/net/netfilter/nf_queue.h              |   1 +
 .../uapi/linux/netfilter/nfnetlink_queue.h    |   1 +
 net/netfilter/nfnetlink_queue.c               | 128 ++++++++++++++++--
 3 files changed, 122 insertions(+), 8 deletions(-)

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
index 8b7b39d8a109..524b7f279349 100644
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
+	return id & mask;
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
@@ -114,13 +153,65 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 	return NULL;
 }
 
+static int
+nfqnl_hash_resize(struct nfqnl_instance *inst, u32 hash_size)
+{
+	struct hlist_head *new_hash, *old_hash;
+	struct nf_queue_entry *entry;
+	unsigned int h, hash_mask;
+
+	hash_size = nfqnl_normalize_hash_size(hash_size);
+	if (hash_size == inst->queue_hash_size)
+		return 0;
+
+	new_hash = kvcalloc(hash_size, sizeof(*new_hash), GFP_KERNEL_ACCOUNT);
+	if (!new_hash)
+		return -ENOMEM;
+
+	hash_mask = hash_size - 1;
+
+	for (h = 0; h < hash_size; h++)
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
+	inst->queue_hash_size = hash_size;
+	inst->queue_hash_mask = hash_mask;
+	inst->queue_hash = new_hash;
+
+	spin_unlock_bh(&inst->lock);
+
+	kvfree(old_hash);
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
+	struct hlist_head *queue_hash;
 	unsigned int h;
 	int err;
 
+	hash_size = nfqnl_normalize_hash_size(hash_size);
+
+	queue_hash = kvcalloc(hash_size, sizeof(*queue_hash),
+			      GFP_KERNEL_ACCOUNT);
+	if (!queue_hash)
+		return ERR_PTR(-ENOMEM);
+
+	for (h = 0; h < hash_size; h++)
+		INIT_HLIST_HEAD(&queue_hash[h]);
+
 	spin_lock(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err = -EEXIST;
@@ -133,11 +224,14 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 		goto out_unlock;
 	}
 
+	inst->queue_hash = queue_hash;
 	inst->queue_num = queue_num;
 	inst->peer_portid = portid;
 	inst->queue_maxlen = NFQNL_QMAX_DEFAULT;
 	inst->copy_range = NFQNL_MAX_COPY_RANGE;
 	inst->copy_mode = NFQNL_COPY_NONE;
+	inst->queue_hash_size = hash_size;
+	inst->queue_hash_mask = hash_size - 1;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
 
@@ -157,6 +251,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
+	kvfree(queue_hash);
 	return ERR_PTR(err);
 }
 
@@ -172,6 +267,7 @@ instance_destroy_rcu(struct rcu_head *head)
 	rcu_read_lock();
 	nfqnl_flush(inst, NULL, 0);
 	rcu_read_unlock();
+	kvfree(inst->queue_hash);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -194,13 +290,17 @@ instance_destroy(struct nfnl_queue_net *q, struct nfqnl_instance *inst)
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
@@ -209,10 +309,11 @@ static struct nf_queue_entry *
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
@@ -407,8 +508,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
+			__dequeue_entry(queue, entry);
 			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
@@ -1483,6 +1583,7 @@ static const struct nla_policy nfqa_cfg_policy[NFQA_CFG_MAX+1] = {
 	[NFQA_CFG_QUEUE_MAXLEN]	= { .type = NLA_U32 },
 	[NFQA_CFG_MASK]		= { .type = NLA_U32 },
 	[NFQA_CFG_FLAGS]	= { .type = NLA_U32 },
+	[NFQA_CFG_HASH_SIZE]    = { .type = NLA_U32 },
 };
 
 static const struct nf_queue_handler nfqh = {
@@ -1495,11 +1596,15 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
+	u32 hash_size = 0;
 	struct nfqnl_msg_config_cmd *cmd = NULL;
 	struct nfqnl_instance *queue;
 	__u32 flags = 0, mask = 0;
 	int ret = 0;
 
+	if (nfqa[NFQA_CFG_HASH_SIZE])
+		hash_size = ntohl(nla_get_be32(nfqa[NFQA_CFG_HASH_SIZE]));
+
 	if (nfqa[NFQA_CFG_CMD]) {
 		cmd = nla_data(nfqa[NFQA_CFG_CMD]);
 
@@ -1559,11 +1664,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -1586,6 +1692,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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

