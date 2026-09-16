Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83483350A18
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 22:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789596181; cv=none; b=jJ3EHdo77l4Fqj9lQsAY20YojU8CHez1G9tPRVpwc364C5lyT4SA5iqZSx1tmZ1h0ElXapdUoywY0+YOhrFcYrckAi1r/FSIf79QAzupvzQkB6op9Ru+XW7VzJ42BouxTxGVIaN6yF76E1qISA65vvvrgQ+A7682BIC6257Ow1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789596181; c=relaxed/simple;
	bh=1O0zeldlGrCvMT1vPwUbU2hWkJ+wNAI4fotyXmQscYY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S2hOEJMDxPwEhg9r5ydvBBmz/IT7SPoH6GcyQupHcPetfGJdGiPliPPLo2tHWZQjZpK4zAHKJ7NBKNMzwOjucSByoh2Tjrg5YwYNlhN1AdVS36QopyPzFiUWAMz0nj+N64d4JCunryk6XcOIW1U9fpsBdk454HvP1oc1uZh7YTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZLtTEZI7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZLtTEZI7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789596174;
	bh=PAiJmkGS8N9scxMzmTQjNUnUNTUXw4R22VBIgx1zfGc=;
	h=From:To:Cc:Subject:Date:From;
	b=ZLtTEZI7GhDV+q1AhJWSCh56za9fezhTuUdTguGLPLvCaHt+sg/dbpVTKL9PxMpUu
	 HnmlT9gvimtyWLapzBMkzzdAkTpZiNsNP0mN0zlOBtJWwdgIF3JmwDYTPcdySczqnL
	 AqKf+7GvT9vIIvf4PzeMzfdYhnno+ezKY1KqZQbNb3/5bqAqjToPjBP92Z9M+wMS3o
	 VzqoK94nPEEdZT4+GoESZx59jr3JBTbpJD5SMIAaRwEqXyXw7Cq+eg9w8drjFqi7S+
	 ZlrsU8iW1Y1AvzViNNgWomJ7V6vk3Uq3NfNibbbvuPHk1Bex5wQ/Rv8smM2APfVHTj
	 4Rkfpd2XXhOrw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2F06C60097;
	Thu, 17 Sep 2026 00:02:54 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf,v2] netfilter: nfnetlink_queue: hash queue instance by portid too
Date: Thu, 17 Sep 2026 00:02:51 +0200
Message-ID: <20260916220251.97427-1-pablo@netfilter.org>
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
v2: look up at the right instance_table in instance_lookup_by_portid()

 net/netfilter/nfnetlink_queue.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a3bc00280051..07f279c9dd54 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -69,6 +69,7 @@
 
 struct nfqnl_instance {
 	struct hlist_node hlist;		/* global list of queues */
+	struct hlist_node hlist_portid;		/* global list of queues, by portid */
 	struct rhashtable nfqnl_packet_map;
 	struct rcu_work	rwork;
 
@@ -101,6 +102,7 @@ static unsigned int nfnl_queue_net_id __read_mostly;
 struct nfnl_queue_net {
 	spinlock_t instances_lock;
 	struct hlist_head instance_table[INSTANCE_BUCKETS];
+	struct hlist_head instance_table_portid[INSTANCE_BUCKETS];
 };
 
 static struct nfnl_queue_net *nfnl_queue_pernet(struct net *net)
@@ -113,6 +115,11 @@ static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 	return ((queue_num >> 8) ^ queue_num) % INSTANCE_BUCKETS;
 }
 
+static inline u8 instance_portid_hashfn(u32 portid)
+{
+	return portid % INSTANCE_BUCKETS;
+}
+
 static const struct rhashtable_params nfqnl_rhashtable_params = {
 	.head_offset = offsetof(struct nf_queue_entry, hash_node),
 	.key_offset = offsetof(struct nf_queue_entry, id),
@@ -136,6 +143,20 @@ instance_lookup(struct nfnl_queue_net *q, u_int16_t queue_num)
 	return NULL;
 }
 
+static struct nfqnl_instance *
+instance_lookup_by_portid(struct nfnl_queue_net *q, u32 portid)
+{
+	struct nfqnl_instance *inst;
+	struct hlist_head *head;
+
+	head = &q->instance_table_portid[instance_portid_hashfn(portid)];
+	hlist_for_each_entry(inst, head, hlist) {
+		if (inst->peer_portid == portid)
+			return inst;
+	}
+	return NULL;
+}
+
 static struct nfqnl_instance *
 instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 {
@@ -160,7 +181,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 		goto out_free;
 
 	spin_lock(&q->instances_lock);
-	if (instance_lookup(q, queue_num)) {
+	if (instance_lookup(q, queue_num) ||
+	    instance_lookup_by_portid(q, queue_num)) {
 		err = -EEXIST;
 		goto out_unlock;
 	}
@@ -172,6 +194,8 @@ instance_create(struct nfnl_queue_net *q, u_int16_t queue_num, u32 portid)
 
 	h = instance_hashfn(queue_num);
 	hlist_add_head_rcu(&inst->hlist, &q->instance_table[h]);
+	h = instance_portid_hashfn(portid);
+	hlist_add_head(&inst->hlist_portid, &q->instance_table_portid[h]);
 
 	spin_unlock(&q->instances_lock);
 
@@ -208,6 +232,7 @@ static void
 __instance_destroy(struct nfqnl_instance *inst)
 {
 	hlist_del_rcu(&inst->hlist);
+	hlist_del(&inst->hlist_portid);
 
 	INIT_RCU_WORK(&inst->rwork, instance_destroy_work);
 	queue_rcu_work(nfq_cleanup_wq, &inst->rwork);
@@ -2121,8 +2146,10 @@ static int __net_init nfnl_queue_net_init(struct net *net)
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

