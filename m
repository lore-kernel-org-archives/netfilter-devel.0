Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382D72D23B6
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 09:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763025989; cv=none; b=eStCLr3mHqTAELhb8zJmj9+KZU+Bi02/TDLAgrifVDh0IiTlCRnASxxaicp/ZIV2HG+ChkdKjsIITSeTK6leyv0wqplEx6uO0LZnH9vwbg4qYqZ3EhKCJnbEuCwV6KGbCeFqpTq0gRWUQI86UUBZUDa+GPP5w3iOL0GVYP0jfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763025989; c=relaxed/simple;
	bh=IdOxWyLd0ayhqkf2xRr55vkkoVgExwdvYyJZILi5P9A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=teTyc51nq2elPy9e3MW9SGJ7pKbWJYJ0MyIKPsAnC/aHz1m6/R6Z0DHzBT8ibJxSvJpz3OAKxLhKo0ucZXCR2fGxsBgDqlXWbnzM9aCFSIJ6OQQnqU2DyGbQ0rAiJ/2u6tjwHTJohDEoejsdS5bpkc8Fr5cNHrLSzB5HkM8txj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UW3Slt9y; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UW3Slt9y"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so685165b3a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 01:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763025986; x=1763630786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R56P5vKc1COv5rnY9hcAHmODH+ib7Zrm7T8bOVpFkAs=;
        b=UW3Slt9ypPS9QrA3eKGCBwkbN1vSGpwsIXsviBhHo3jqhbo+k33a4AtC8sZ6P17l0F
         M3ocLCiLMlZcIOMcehmGLA0hHuurd16jupv2aZiAfUAfoKW/8Z8W2hbTUnTHiO9EDSCi
         2bjMwNCJe5u4G52/jOuGTzfGAR8stRzRSKHvZUxKcBx1QCrfP7PyGJIX6xbpLqnvxFRv
         rlGtxpuXzWy6R+gemBNhNKjVXOjjiZegj7vOJDK2HTANzhgQteeAajMzKiuFBz/0TIie
         vOtBXsBfmLdeiIqeI6sQ86mAB9sXqbtaJOWlQllfMuDDicPuyoRsgjN9XMgOLtwnm3tn
         NDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763025986; x=1763630786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R56P5vKc1COv5rnY9hcAHmODH+ib7Zrm7T8bOVpFkAs=;
        b=ODrr6H8ozjib3HBojEQ+6VVK9JY42Th8TrDtnn21XOx+TuwsQHN5X2T7ZgdugC0Tiv
         bpjII2bkNbpOYKPR6oxqD3Xr1/dglE+UPA/XwT8MTFLOA6fFKjxGbqAtvS/VcvnAXG9t
         878IJLyDV00L04bs1xN8KO+O66nOjCeRaUdQhTQr1qeZT6MNnbNM3rxXwk+jbOnz+aH9
         d27D2nOv7wEbxph3rizGpI9XfyKpcLlBH4Jq9tSiIkaSB3GKFZ9VXc3Zt6Hm05SbwD+U
         uMjf1MMLly+psS2ZQzE+nLZ68N2Va8Tz2dcYOqyGzhG7UloNqXiGw8TsrIxc3t1enM/K
         GZsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwKYO0GHG1sefMhc3OOiqGF9FhS9FsFvaXA4jXGfCESq+4OT/v0+UGUtr7lPDsYYiHwfFGjInIqtHVrw6M+PY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUL83XGah9VBbVLfW139nmZZVVdnQs1WHqDz393H6QTLIkCdnp
	qtir2ZfE5m+a2/0OliTAk2dvUelqmEgoEcISAc5/ySSIQfkUSBU0QdVd
X-Gm-Gg: ASbGncuTml+ml+AdxoMJWlYfLI7SSKZRlDBbC+SccXFjLrnTK+9qvSAGYrMbBlqDTeq
	BnyNJcumEO8Rwd1o3a/uoTbXHocBqa+owbPO6HlsKcU6HEghhKWsjRw4/xpd4RV8UihP7fLny5H
	z3QgIf7PkWLEtyqrG1TA6SlXAObnCfNJh2tMSJ2jVgwYdWSWbb5iNe9Y2P6DHr+WSq61t4dBZyK
	viHoMPQj+teFpZahv5nWuBRWW/jEHEUnU+AD/V6b8mlj1NZXKrZ9BoEcCFmyaKtKz/GsEiLsg35
	v+gwOrgHnKFaRMuV4Iil5VqzYhG+7LWdgIoCY5zlM8dW5sJfRgeu0ur0SQ29i+s78Urytv0zXgX
	MhK2VDou6x4JqspCPHmGSvzpb60Uo4VVEDdGwizQ18jNZ4WrfO/C8BOGbyLLMEMTNqDgQG37Mak
	gdbw8NI7oaGr9ZQTgn
X-Google-Smtp-Source: AGHT+IGF91v9mIPXsZIOO8tb6WHj7OMVG5cVSYSMkMGsz91TA9ThFDhXhovfjMHddvJTtsguP1xuBQ==
X-Received: by 2002:a05:6a00:c93:b0:781:455:df62 with SMTP id d2e1a72fcca58-7b7a27aad60mr6306522b3a.5.1763025986227;
        Thu, 13 Nov 2025 01:26:26 -0800 (PST)
Received: from mac.com ([136.24.82.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b927d1c413sm1634714b3a.69.2025.11.13.01.26.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 13 Nov 2025 01:26:25 -0800 (PST)
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
Subject: [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Thu, 13 Nov 2025 01:26:06 -0800
Message-Id: <20251113092606.91406-1-scott_mitchell@apple.com>
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
Changes in v2:
- Use kvcalloc/kvfree with GFP_KERNEL_ACCOUNT to support larger hash
  tables with vmalloc fallback (Florian Westphal)
- Remove incorrect comment about concurrent resizes - nfnetlink subsystem
  mutex already serializes config operations (Florian Westphal)
- Fix style: remove unnecessary braces around single-line if (Florian Westphal)

 include/net/netfilter/nf_queue.h              |   1 +
 .../uapi/linux/netfilter/nfnetlink_queue.h    |   1 +
 net/netfilter/nfnetlink_queue.c               | 129 ++++++++++++++++--
 3 files changed, 123 insertions(+), 8 deletions(-)

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
index 8b7b39d8a109..f076609cac32 100644
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
@@ -114,13 +153,56 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
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
 	unsigned int h;
 	int err;
 
+	hash_size = nfqnl_normalize_hash_size(hash_size);
+
 	spin_lock(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err = -EEXIST;
@@ -133,11 +215,24 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 		goto out_unlock;
 	}
 
+	inst->queue_hash = kvcalloc(hash_size, sizeof(*inst->queue_hash),
+				    GFP_KERNEL_ACCOUNT);
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
 
@@ -154,6 +249,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 	return inst;
 
 out_free:
+	kvfree(inst->queue_hash);
 	kfree(inst);
 out_unlock:
 	spin_unlock(&q->instances_lock);
@@ -172,6 +268,7 @@ instance_destroy_rcu(struct rcu_head *head)
 	rcu_read_lock();
 	nfqnl_flush(inst, NULL, 0);
 	rcu_read_unlock();
+	kvfree(inst->queue_hash);
 	kfree(inst);
 	module_put(THIS_MODULE);
 }
@@ -194,13 +291,17 @@ instance_destroy(struct nfnl_queue_net *q, struct nfqnl_instance *inst)
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
@@ -209,10 +310,11 @@ static struct nf_queue_entry *
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
@@ -407,8 +509,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
+			__dequeue_entry(queue, entry);
 			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
@@ -1483,6 +1584,7 @@ static const struct nla_policy nfqa_cfg_policy[NFQA_CFG_MAX+1] = {
 	[NFQA_CFG_QUEUE_MAXLEN]	= { .type = NLA_U32 },
 	[NFQA_CFG_MASK]		= { .type = NLA_U32 },
 	[NFQA_CFG_FLAGS]	= { .type = NLA_U32 },
+	[NFQA_CFG_HASH_SIZE]    = { .type = NLA_U32 },
 };
 
 static const struct nf_queue_handler nfqh = {
@@ -1495,11 +1597,15 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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
 
@@ -1559,11 +1665,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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
@@ -1586,6 +1693,12 @@ static int nfqnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
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

