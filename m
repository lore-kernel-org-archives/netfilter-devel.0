Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021EE2F260E
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 13:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769176453; cv=none; b=PoqtNPeiGiIF7DsoFoa9C1jWI9Xws7QwBfIyxTakC1AbEoe45r4z5+jeoAVUIuTGSGlGuuJVEcsLBDZDj6qCljtkChQpMry1Z7OEwae7S3juaKR34at9kyTkbHLa2C4EjPqY5xXKB7EjiZbrWnMmuC1eoDM2ajhNzI4jlTNBTWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769176453; c=relaxed/simple;
	bh=wV7s+eYCjG2BtUFji9vz2tNRLS5wj0uNedL6TfZ8/G0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NCCsHseQO2g5LFBGMrlUf3qvlBIpQWJZlqLcVc732+b1WghkU8ioRMd5swMzdmqMYREagC7rXvkz6jI72s/SpgyXCcKrgsTEpTanOKv9FzJVmixZrymNgzJcNVnWkQHGNH/XNqVA6XVvRSlEADx98XBoAoEDxwSZrVIhekkfiA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UETS+uha; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UETS+uha"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b740872a01so1560388eec.1
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jan 2026 05:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769176448; x=1769781248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VTuFW1tLAWm8NtKFprRkdVxY12Xqq/H8YI6MHnRJi9Q=;
        b=UETS+uhaUNZE74v6v96nlIlGENSxypG2XXm766gbidLMYDdGgYo37kFO6yz/VE7KGj
         lbz8ZKQZ4Up3z4e2wVJ5HXCqhbF2oc3MqgkajV8zPaylwSDvxPzwOtwbV1yizR38ANsD
         aTjlvB6O/Z0/FJhwsL8iUm1VWurUaGix6eV2S3pnSE2aSokyrDy4Hdav9LSglFIZhlPA
         p54NFWLfgfHF6BGUuOYLPS02kzZuZ9MVlueexcXUTfDQPn/5PW3HlCC9EPH0s6MAppal
         xjG/FI/jg9HmBaBUCwgSBOEPcVFt5aRlZDG1nfX3MDh9djbP0j3kIwUMoQXSGktTFRKJ
         xo5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769176448; x=1769781248;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VTuFW1tLAWm8NtKFprRkdVxY12Xqq/H8YI6MHnRJi9Q=;
        b=Jol4piUF2K9weJlx6gm+PAmabjfU+/s9bOQn6sB2q2+R+AqnGOtvvwwimWMRWDm38k
         QDmqIce1w/UX7z2DlI3yMuQoaXkYPzYifBOPbcpYAmgKDL9hNL35XS5uNH7zRMKdgBJG
         3b7AGXco1+aIHxDTEm2DNSoBxqR4b5Zby61Dw16oayjGrGZOCkSHb1kPG5L6mUYTpBnY
         +wtTcKwXzrn7MUAQ8UCH9r3wszKHXbAkopFBmWzPXiCesjUM3QYU6QTChJrDMcSZ1+3j
         r0KXyuqIfAhP2toFBUGxR2R5+FkUGRSVCImtmY6uRLtYesquUL5KI85ynb9YFP8MOLPZ
         rXdQ==
X-Gm-Message-State: AOJu0YyUpMhxDN0Gk+/jh/2atlorGrme2PPEt1CxSE+aPtXQ/FfnQp+2
	Rm7lQM+SbtAlRvdkDiii6QMUeelqeRM7kF2gFIPbp1vmXPs6aCTZXrlnz54bpw==
X-Gm-Gg: AZuq6aIqg2Icv6tVqSscQ2EvTL6/xvdrpR2Bx7yKQV6vx+QDBFPUFzWffalV0wsyC7h
	LSsPCY69XkScu4Vyd+T2XOlI0dxNMUSh3BNmnHJKshQVun/enwsr47VzSBUxSlmvD/318FkzAII
	4Ys+mhy8XtTO5qqm81jHJiMQheGiqxwgmlFQ+P468qwm0PjhiKFSUWgmpzEfAyiR2n5Y8CVQcz8
	Y7JXbVi8By8nC1EzLCLTj8voMbfBbbabAr7csNWtD0v3/M7fnUFTDb2NsrUkDHSCGEVWILMYkPD
	i5OsCNpRbTnfRIy7RE9lG89ZVyEmr9shOctShy/knPkSAeDRELCsaEVVLwdamXCRLYWbzAwSbMy
	k3An5MZ8fC5z1WcjVu6v8HgE3Knur1BmDSPDYLIUd5ReG9JukTdzUPT1nGovJ0TTwar3TO3FZ7V
	CSOzleF+KRQJ01Ybk/7SsEmg==
X-Received: by 2002:a05:7301:4083:b0:2b7:2ed8:7a46 with SMTP id 5a478bee46e88-2b739b77426mr1370481eec.20.1769176448401;
        Fri, 23 Jan 2026 05:54:08 -0800 (PST)
Received: from mac.com ([136.24.82.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73aa03fd0sm3064686eec.23.2026.01.23.05.54.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 23 Jan 2026 05:54:08 -0800 (PST)
From: scott.k.mitch1@gmail.com
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Scott Mitchell <scott.k.mitch1@gmail.com>
Subject: [PATCH v7] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
Date: Fri, 23 Jan 2026 05:54:04 -0800
Message-Id: <20260123135404.21118-1-scott.k.mitch1@gmail.com>
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

 include/net/netfilter/nf_queue.h |   3 +
 net/netfilter/nfnetlink_queue.c  | 129 ++++++++++++++++++++++++++-----
 2 files changed, 113 insertions(+), 19 deletions(-)

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
index 8b7b39d8a109..e7372955c5a8 100644
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
@@ -56,6 +60,16 @@
  */
 #define NFQNL_MAX_COPY_RANGE (0xffff - NLA_HDRLEN)
 
+/* Composite key for packet lookup: (net, queue_num, packet_id) */
+struct nfqnl_packet_key {
+	struct net *net;
+	u32 packet_id;
+	u16 queue_num;
+};
+
+/* Global rhashtable - one for entire system, all netns */
+static struct rhashtable nfqnl_packet_map __read_mostly;
+
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
 	struct rcu_head rcu;
@@ -100,6 +114,45 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
 }
 
+/* Extract composite key from nf_queue_entry for hashing */
+static u32 nfqnl_packet_obj_hashfn(const void *data, u32 len, u32 seed)
+{
+	const struct nf_queue_entry *entry = data;
+	struct nfqnl_packet_key key;
+
+	/* Zero entire struct including padding to ensure deterministic hashing */
+	memset(&key, 0, sizeof(key));
+	key.net = entry->state.net;
+	key.packet_id = entry->id;
+	key.queue_num = entry->queue_num;
+
+	/* jhash2 requires size to be a multiple of sizeof(u32) */
+	BUILD_BUG_ON(sizeof(key) % sizeof(u32) != 0);
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
+	return entry->state.net != key->net ||
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
@@ -191,33 +244,49 @@ instance_destroy(struct nfnl_queue_net *q, struct nfqnl_instance *inst)
 	spin_unlock(&q->instances_lock);
 }
 
-static inline void
+static inline int
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
+	/* Zero entire struct including padding to ensure deterministic hashing */
+	memset(&key, 0, sizeof(key));
+	key.net = net;
+	key.packet_id = id;
+	key.queue_num = queue->queue_num;
 
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
@@ -407,8 +476,7 @@ nfqnl_flush(struct nfqnl_instance *queue, nfqnl_cmpfn cmpfn, unsigned long data)
 	spin_lock_bh(&queue->lock);
 	list_for_each_entry_safe(entry, next, &queue->queue_list, list) {
 		if (!cmpfn || cmpfn(entry, data)) {
-			list_del(&entry->list);
-			queue->queue_total--;
+			__dequeue_entry(queue, entry);
 			nfqnl_reinject(entry, NF_DROP);
 		}
 	}
@@ -902,9 +970,25 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 	entry->id = ++queue->id_sequence;
 	*packet_id_ptr = htonl(entry->id);
 
+	/* Insert into hash BEFORE unicast. If failure don't send to userspace. */
+	err = __enqueue_entry(queue, entry);
+	if (unlikely(err)) {
+		if (queue->flags & NFQA_CFG_F_FAIL_OPEN) {
+			failopen = 1;
+			err = 0;
+		} else {
+			queue->queue_dropped++;
+			net_warn_ratelimited("nf_queue: hash insert failed: %d\n", err);
+		}
+		goto err_out_free_nskb;
+	}
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
@@ -914,8 +998,6 @@ __nfqnl_enqueue_packet(struct net *net, struct nfqnl_instance *queue,
 		goto err_out_unlock;
 	}
 
-	__enqueue_entry(queue, entry);
-
 	spin_unlock_bh(&queue->lock);
 	return 0;
 
@@ -1430,7 +1512,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 
 	verdict = ntohl(vhdr->verdict);
 
-	entry = find_dequeue_entry(queue, ntohl(vhdr->id));
+	entry = find_dequeue_entry(queue, ntohl(vhdr->id), info->net);
 	if (entry == NULL)
 		return -ENOENT;
 
@@ -1781,10 +1863,16 @@ static int __init nfnetlink_queue_init(void)
 {
 	int status;
 
+	status = rhashtable_init(&nfqnl_packet_map, &nfqnl_rhashtable_params);
+	if (status < 0) {
+		pr_err("failed to init packet hash table\n");
+		return status;
+	}
+
 	status = register_pernet_subsys(&nfnl_queue_net_ops);
 	if (status < 0) {
 		pr_err("failed to register pernet ops\n");
-		goto out;
+		goto cleanup_rhashtable;
 	}
 
 	netlink_register_notifier(&nfqnl_rtnl_notifier);
@@ -1809,7 +1897,8 @@ static int __init nfnetlink_queue_init(void)
 cleanup_netlink_notifier:
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
-out:
+cleanup_rhashtable:
+	rhashtable_destroy(&nfqnl_packet_map);
 	return status;
 }
 
@@ -1821,6 +1910,8 @@ static void __exit nfnetlink_queue_fini(void)
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
 
+	rhashtable_destroy(&nfqnl_packet_map);
+
 	rcu_barrier(); /* Wait for completion of call_rcu()'s */
 }
 
-- 
2.39.5 (Apple Git-154)

