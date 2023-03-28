Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE34FC6FD18
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Mar 2023 16:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjC1Qo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 12:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjC1QoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 12:44:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB2398
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Mar 2023 09:44:22 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1phCQm-0007Yf-8b; Tue, 28 Mar 2023 18:44:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nfnetlink_log: remove rcu_bh usage
Date:   Tue, 28 Mar 2023 18:44:15 +0200
Message-Id: <20230328164415.4928-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

structure is free'd via call_rcu, so its safe to use rcu_read_lock only.

While at it, skip rcu_read_lock for lookup from packet path, its always
called with rcu held.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 36 ++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d97eb280cb2e..2eb75fedabc9 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -103,9 +103,9 @@ static inline u_int8_t instance_hashfn(u_int16_t group_num)
 }
 
 static struct nfulnl_instance *
-__instance_lookup(struct nfnl_log_net *log, u_int16_t group_num)
+__instance_lookup(const struct nfnl_log_net *log, u_int16_t group_num)
 {
-	struct hlist_head *head;
+	const struct hlist_head *head;
 	struct nfulnl_instance *inst;
 
 	head = &log->instance_table[instance_hashfn(group_num)];
@@ -123,15 +123,25 @@ instance_get(struct nfulnl_instance *inst)
 }
 
 static struct nfulnl_instance *
-instance_lookup_get(struct nfnl_log_net *log, u_int16_t group_num)
+instance_lookup_get_rcu(const struct nfnl_log_net *log, u_int16_t group_num)
 {
 	struct nfulnl_instance *inst;
 
-	rcu_read_lock_bh();
 	inst = __instance_lookup(log, group_num);
 	if (inst && !refcount_inc_not_zero(&inst->use))
 		inst = NULL;
-	rcu_read_unlock_bh();
+
+	return inst;
+}
+
+static struct nfulnl_instance *
+instance_lookup_get(const struct nfnl_log_net *log, u_int16_t group_num)
+{
+	struct nfulnl_instance *inst;
+
+	rcu_read_lock();
+	inst = instance_lookup_get_rcu(log, group_num);
+	rcu_read_unlock();
 
 	return inst;
 }
@@ -698,7 +708,7 @@ nfulnl_log_packet(struct net *net,
 	else
 		li = &default_loginfo;
 
-	inst = instance_lookup_get(log, li->u.ulog.group);
+	inst = instance_lookup_get_rcu(log, li->u.ulog.group);
 	if (!inst)
 		return;
 
@@ -1030,7 +1040,7 @@ static struct hlist_node *get_first(struct net *net, struct iter_state *st)
 		struct hlist_head *head = &log->instance_table[st->bucket];
 
 		if (!hlist_empty(head))
-			return rcu_dereference_bh(hlist_first_rcu(head));
+			return rcu_dereference(hlist_first_rcu(head));
 	}
 	return NULL;
 }
@@ -1038,7 +1048,7 @@ static struct hlist_node *get_first(struct net *net, struct iter_state *st)
 static struct hlist_node *get_next(struct net *net, struct iter_state *st,
 				   struct hlist_node *h)
 {
-	h = rcu_dereference_bh(hlist_next_rcu(h));
+	h = rcu_dereference(hlist_next_rcu(h));
 	while (!h) {
 		struct nfnl_log_net *log;
 		struct hlist_head *head;
@@ -1048,7 +1058,7 @@ static struct hlist_node *get_next(struct net *net, struct iter_state *st,
 
 		log = nfnl_log_pernet(net);
 		head = &log->instance_table[st->bucket];
-		h = rcu_dereference_bh(hlist_first_rcu(head));
+		h = rcu_dereference(hlist_first_rcu(head));
 	}
 	return h;
 }
@@ -1066,9 +1076,9 @@ static struct hlist_node *get_idx(struct net *net, struct iter_state *st,
 }
 
 static void *seq_start(struct seq_file *s, loff_t *pos)
-	__acquires(rcu_bh)
+	__acquires(rcu)
 {
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	return get_idx(seq_file_net(s), s->private, *pos);
 }
 
@@ -1079,9 +1089,9 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void seq_stop(struct seq_file *s, void *v)
-	__releases(rcu_bh)
+	__releases(rcu)
 {
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 }
 
 static int seq_show(struct seq_file *s, void *v)
-- 
2.39.2

