Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997CE53CA71
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 18:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188857; cv=none; b=UOI1dXqRErJnLHE7MdKMcICSW3N+Hsno2cvGwvmkI9TrcNP3yR1NOVJc/L+2svlxbZVKwS7fzI7VX975NPBZMmiAJxttoDHPvumUw8w7pl6+Az1wUlZJpC6dp2lH89NaP9C3TWItXj7qNik/Esg/xVNUz4+17XTjaVuG8ZwR2r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188857; c=relaxed/simple;
	bh=3MQp8ld5cJHA/DFUJ5k/29SgYrTZIM7i3rBfHAcKPLE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uMTLuWpeOBe9Uo4pvG7aOvKDrQj/WGLH2Td3gbR7gKAMetKBLGxTpAzay+9lUGZdQMWlcih3yL0faToG22xjEjG7frtJ3VzETAPsX3hBKNjMKftuO6SRMIK9UZgHxvbBtJ8n0JZxIbPggYuZa/JLU2bbEdAbB4sTS3sLEbhWQWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rxQOOQ+U; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rxQOOQ+U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790188850;
	bh=O1wPzJtBBjQiIMg2ykCcAQiq89f3TX8aUiyattlYd6U=;
	h=From:To:Cc:Subject:Date:From;
	b=rxQOOQ+UTI+A0FlOpx37GciuYiqx/uqZw4FhD+QdFevboQ7vBDfIDJyDKxyqb5vuK
	 xPVPsYZWWKpyxXfJC7QHj08MpISI7rXIHph6B+Zyv7MVQ72AEfHmMjzwMx8B4/7D+a
	 uS+49acmh7i5zagkB/2t0k6LfVIdKyNURXC6umYdi0LIIsjgvmj/lq9Ky/+OMRODi/
	 /XrujqSDzM3YNUYcyHNBAdjGXHZJ5/k7JcV0tZmKDlKRJNhSbJ5M1EOObizo351g1x
	 CYm/y+z0ELI4CodHlgHdgRYOOkIY4EeURsNK8IuIHuV0nnabo9VGz4O6/1iR/MB/xX
	 ny9LxVchdnXww==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 12FB76005D;
	Wed, 23 Sep 2026 20:40:50 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v3] netfilter: nfnetlink_queue: hash queue instance by portid too
Date: Wed, 23 Sep 2026 20:40:46 +0200
Message-ID: <20260923184047.48492-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netlink_release() calls netlink_remove() before delivering the
NETLINK_URELEASE event. And a new queue instance can be created before
delivering such NETLINK_URELEASE event. This allows for two different
queue instances with the same portid to co-exist for a little while.
Since the instance that is going away is destroyed by portid via netlink
notifier, both the newly created instance and the one that is going away
with the same portid are destroyed.

Fixes: 7af4cc3fa158 ("[NETFILTER]: Add "nfnetlink_queue" netfilter queue handler over nfnetlink")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: - use siphash instead of lazy hash
    - fix incorrect hlist and wrong instance_lookup_by_portid()

 net/netfilter/nfnetlink_queue.c | 36 +++++++++++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c727668b0c5b..a2086c192063 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -69,6 +69,7 @@
 
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
+	struct hlist_node hlist_portid;		/* global list of queues, by portid */
 	struct rhashtable nfqnl_packet_map;
 	struct rcu_work	rwork;
 
@@ -96,11 +97,13 @@ typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
 
 static struct workqueue_struct *nfq_cleanup_wq __read_mostly;
 static unsigned int nfnl_queue_net_id __read_mostly;
+static siphash_aligned_key_t nfnl_queue_hash_key;
 
 #define INSTANCE_BUCKETS	16
 struct nfnl_queue_net {
 	spinlock_t instances_lock;
 	struct hlist_head instance_table[INSTANCE_BUCKETS];
+	struct hlist_head instance_table_portid[INSTANCE_BUCKETS];
 };
 
 static struct nfnl_queue_net *nfnl_queue_pernet(struct net *net)
@@ -113,6 +116,15 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
 }
 
+static inline u8 instance_portid_hashfn(u32 portid)
+{
+	u64 hash = siphash_1u32(portid, &nfnl_queue_hash_key);
+
+	net_get_random_once(&nfnl_queue_hash_key, sizeof(nfnl_queue_hash_key));
+
+	return reciprocal_scale(hash, INSTANCE_BUCKETS);
+}
+
 static const struct rhashtable_params nfqnl_rhashtable_params = {
 	.head_offset = offsetof(struct nf_queue_entry, hash_node),
 	.key_offset = offsetof(struct nf_queue_entry, id),
@@ -136,6 +148,20 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 	return NULL;
 }
 
+static struct nfqnl_instance *
+instance_lookup_by_portid(struct nfnl_queue_net *q, u32 portid)
+{
+	struct nfqnl_instance *inst;
+	struct hlist_head *head;
+
+	head = &q->instance_table_portid[instance_portid_hashfn(portid)];
+	hlist_for_each_entry(inst, head, hlist_portid) {
+		if (inst->peer_portid == portid)
+			return inst;
+	}
+	return NULL;
+}
+
 static struct nfqnl_instance *
 instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 {
@@ -160,7 +186,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 		goto out_free;
 
 	spin_lock(&q->instances_lock);
-	if (instance_lookup(q, queue_num)) {
+	if (instance_lookup(q, queue_num) ||
+	    unlikely(instance_lookup_by_portid(q, portid))) {
 		err = -EEXIST;
 		goto out_unlock;
 	}
@@ -172,6 +199,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 	h = instance_hashfn(queue_num);
 	hlist_add_head_rcu(&inst->hlist, &q->instance_table[h]);
+	h = instance_portid_hashfn(portid);
+	hlist_add_head(&inst->hlist_portid, &q->instance_table_portid[h]);
 
 	spin_unlock(&q->instances_lock);
 
@@ -208,6 +237,7 @@ static void
 __instance_destroy(struct nfqnl_instance *inst)
 {
 	hlist_del_rcu(&inst->hlist);
+	hlist_del(&inst->hlist_portid);
 
 	INIT_RCU_WORK(&inst->rwork, instance_destroy_work);
 	queue_rcu_work(nfq_cleanup_wq, &inst->rwork);
@@ -2119,8 +2149,10 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 	unsigned int i;
 	struct nfnl_queue_net *q = nfnl_queue_pernet(net);
 
-	for (i = 0; i < INSTANCE_BUCKETS; i++)
+	for (i = 0; i < INSTANCE_BUCKETS; i++) {
 		INIT_HLIST_HEAD(&q->instance_table[i]);
+		INIT_HLIST_HEAD(&q->instance_table_portid[i]);
+	}
 
 	spin_lock_init(&q->instances_lock);
 
-- 
2.47.3

