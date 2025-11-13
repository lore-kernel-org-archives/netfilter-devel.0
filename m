Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D387359F8C
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763047949; cv=none; b=iWpWgN9Rzj+xBlAjXbNmPIfg97pS3A0zeHkvz/8o+QmJ/99GDZoUt/fgYA5OIoKFhLjQrQOVPbqri/rZoqgxoahg8u9T7IxwpnfGD5oODCq4B2ZkJmkFv7nXlVCmk6af+z4CZZ4Kqq3QRldwRtHRehzpR8SF+8WIKFdk+7NYRx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763047949; c=relaxed/simple;
	bh=De7fHdnsanrXr9d9tay6NdYrLy0+zdVmV34SVh7fjD4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=p3GPDMwBq+6C9VGrD3ca7IE31R5C/IJFxZTp0mnePBydVg1bHWgPiX5Q12nmcLdgdRkR8OH+pgF9BVoK1jelxoNuxbEdoQWIIVpNlEoJAngJ6FBHgV/zFhs9ovIInzivfg+jylzaU0ddvdoeTjTY02h8hXjim+muQ/5P/V1O1EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YXe2n0tg; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXe2n0tg"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-34372216275so1135805a91.2
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 07:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763047947; x=1763652747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6UiuDOl4ZAaQFG0mI1O+Xl+TMIShVuPe3v/GTvzH02k=;
        b=YXe2n0tg/XYI8voL196fG3n0ipxQ/Qu3pM9x1t1+asy2mnB5g6Uf3naxRcfvxm8iZ6
         l31Uq+uaAEShv/uM3l7224r/Jv8mVlFDe2LiWckJrvQupsrfv3mG0w69LnrLIgU/2BRZ
         JC9vl9oSSE1cENgwKwhKF7RT+b0x15vMTD8T/VzPvBrF8WOupuBX+ZbiOdNaUWJE4HYv
         GF9QAfoLsm4L2GTDBEDBcgnbaK0BaHXogKR2sbnRxTakM01643tOJtiW1Y4bJd8iD5pp
         Ueu2R34sXk554T4Sf+mzJeN63lLKuEHoDtnUxI8wMJUXcspnyQhKuvU9Uqz79/mvKoos
         krlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763047947; x=1763652747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UiuDOl4ZAaQFG0mI1O+Xl+TMIShVuPe3v/GTvzH02k=;
        b=i2EDbYwPnElH0Z56a9Fis2gtgbNgODusAmO/gvGq6Ne9aUD0isjhemHhYllKCZ/iZW
         ruOXVIQw+s5rQnwfe77oqHEjM3SVpUvEtQc9onX6rRWjy0Q8UE15SKRYwmk5TKDZG+iW
         DZQjw5Th1PL2cZyLQsuKRoJFXU4DAxDKLinRxnkCQA+vZ3pPENkoeJP9ipBVH5jwi1rl
         Rsy2c3V+OnheCeeSwTQqwCmpfaQGkjkGVEtFBvcD0bmTIOGHcIr7EWgpiZWk0xApXAw1
         StzOICoL46ImrIr6rmK6quDbghITMpunu0R/AN9FSE3TfdkaK4tpY02X8CkMX37eMQUt
         5upQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeBvJthvbolBgb3nyifdV7pre3QAcI4DkIH8jmF5FVEJLt3aQRsQpGrx2wKDHtDojg9d3IpxPw+S9Lw/shDfg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygz5BSKvAryhR0Anbe8sjqoNE01q4vS3orAWQ0o4hhsCQ4hZIg
	dO7hmQ/Gm/NrRfbkXVGD0yw82yzORycqh/trzzSNZFrl1QflNqwbC/kG
X-Gm-Gg: ASbGnctyWgQITMeNiO+3O1bZ7uhJlAR1ZDV5AivyS7h786A1nSqMFiCB+9F0u+TC3o3
	cjP4dLiUA8SjZkNG3WPBECuZPqOXMHINhqs1Ac7xrqxE3C6b8rZesGV04vixIesdyGK27YfXnds
	IawD4j8JyRXMg03J5TH3LnBxVsq+yeo61RuJzdHt9spqaLyzMEe5dgkQMzSUK9fa5AERzk9PLbC
	kXBmB37L3YJ9UL5bQ2RrG0D3ZqiB4uK1bGzioxp0QA0QZ6LM9vSXorKZaN8MxHYQyq2M5Bz4b5N
	0qacrlYeOFB9VWrCD/iKQwvfmR/vA4JqpVHtNVZ54jDnCHdssK7vsU3o7L9OOi9/p2z7t3NHfu9
	yvZU5RWXpq0tn3qhspANVi2fsljZK9so5fM+OZD1NyDl8HEABcFiPIrUVvQtaPgrDWCLDxJEvQr
	6AX/VfukEF50u22e4xEwUCEJmB617jMqH8ZfT5uVIFEA==
X-Google-Smtp-Source: AGHT+IGG61kTCpIxNCCUK21No3AOh+FTc87WjrmuK25OPP6aexot9Ru8sR3/zJOCLgpDIm9Cll8EMg==
X-Received: by 2002:a17:90a:d403:b0:33b:cfac:d5c6 with SMTP id 98e67ed59e1d1-343dde8b414mr9295163a91.29.1763047946397;
        Thu, 13 Nov 2025 07:32:26 -0800 (PST)
Received: from mr55p01nt-relayp03.apple.com ([216.157.103.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92782621fsm2653547b3a.51.2025.11.13.07.32.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 13 Nov 2025 07:32:26 -0800 (PST)
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
	Scott Mitchell <scott.k.mitch1@gmail.com>
Subject: [PATCH v3] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Thu, 13 Nov 2025 07:32:20 -0800
Message-Id: <20251113153220.16961-1-scott_mitchell@apple.com>
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
---
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
index 8b7b39d8a109..b8128fb650d8 100644
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

