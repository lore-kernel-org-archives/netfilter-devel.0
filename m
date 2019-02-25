Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C482C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:22:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF437213A2
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfBYLWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:22:45 -0500
Received: from mx58.baidu.com ([61.135.168.58]:50803 "EHLO
        tc-sys-mailedm04.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726574AbfBYLWp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 06:22:45 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm04.tc.baidu.com (Postfix) with ESMTP id 6EBFD236C005
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 19:16:01 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH][nf-next] netfilter: replace modulo operation with bitwise AND
Date:   Mon, 25 Feb 2019 19:16:01 +0800
Message-Id: <1551093361-2150-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CONNTRACK_LOCKS is 1024 and power of 2, so modulo operations
can be replaced with AND (CONNTRACK_LOCKS - 1)

and bitwise AND operation is quicker than module operation

Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/net/netfilter/nf_conntrack_core.h |  4 +++-
 net/netfilter/nf_conntrack_core.c         | 10 +++++-----
 net/netfilter/nf_conntrack_netlink.c      |  2 +-
 net/netfilter/nf_nat_core.c               |  6 +++---
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index ae41e92251dd..1b75a141c63d 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -67,7 +67,9 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 void print_tuple(struct seq_file *s, const struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_l4proto *proto);
 
-#define CONNTRACK_LOCKS 1024
+#define CONNTRACK_LOCKS_BIT 10
+#define CONNTRACK_LOCKS  (1 << CONNTRACK_LOCKS_BIT)
+#define CONNTRACK_LOCKS_MASK (CONNTRACK_LOCKS - 1)
 
 extern spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 void nf_conntrack_lock(spinlock_t *lock);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e139c256e269..a0feb530ed00 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -116,8 +116,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_lock);
 
 static void nf_conntrack_double_unlock(unsigned int h1, unsigned int h2)
 {
-	h1 %= CONNTRACK_LOCKS;
-	h2 %= CONNTRACK_LOCKS;
+	h1 &= CONNTRACK_LOCKS_MASK;
+	h2 &= CONNTRACK_LOCKS_MASK;
 	spin_unlock(&nf_conntrack_locks[h1]);
 	if (h1 != h2)
 		spin_unlock(&nf_conntrack_locks[h2]);
@@ -127,8 +127,8 @@ static void nf_conntrack_double_unlock(unsigned int h1, unsigned int h2)
 static bool nf_conntrack_double_lock(struct net *net, unsigned int h1,
 				     unsigned int h2, unsigned int sequence)
 {
-	h1 %= CONNTRACK_LOCKS;
-	h2 %= CONNTRACK_LOCKS;
+	h1 &= CONNTRACK_LOCKS_MASK;
+	h2 &= CONNTRACK_LOCKS_MASK;
 	if (h1 <= h2) {
 		nf_conntrack_lock(&nf_conntrack_locks[h1]);
 		if (h1 != h2)
@@ -1971,7 +1971,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 	spinlock_t *lockp;
 
 	for (; *bucket < nf_conntrack_htable_size; (*bucket)++) {
-		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
+		lockp = &nf_conntrack_locks[*bucket & CONNTRACK_LOCKS_MASK];
 		local_bh_disable();
 		nf_conntrack_lock(lockp);
 		if (*bucket < nf_conntrack_htable_size) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 349b42a65c8a..8f22743c270f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -918,7 +918,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			nf_ct_put(nf_ct_evict[i]);
 		}
 
-		lockp = &nf_conntrack_locks[cb->args[0] % CONNTRACK_LOCKS];
+		lockp = &nf_conntrack_locks[cb->args[0] & CONNTRACK_LOCKS_MASK];
 		nf_conntrack_lock(lockp);
 		if (cb->args[0] >= nf_conntrack_htable_size) {
 			spin_unlock(lockp);
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 35e61038ae96..2b1d377bf3ab 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -588,7 +588,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 
 		srchash = hash_by_src(net,
 				      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-		lock = &nf_nat_locks[srchash % CONNTRACK_LOCKS];
+		lock = &nf_nat_locks[srchash & CONNTRACK_LOCKS_MASK];
 		spin_lock_bh(lock);
 		hlist_add_head_rcu(&ct->nat_bysource,
 				   &nf_nat_bysource[srchash]);
@@ -773,9 +773,9 @@ static void __nf_nat_cleanup_conntrack(struct nf_conn *ct)
 	unsigned int h;
 
 	h = hash_by_src(nf_ct_net(ct), &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	spin_lock_bh(&nf_nat_locks[h % CONNTRACK_LOCKS]);
+	spin_lock_bh(&nf_nat_locks[h & CONNTRACK_LOCKS_MASK]);
 	hlist_del_rcu(&ct->nat_bysource);
-	spin_unlock_bh(&nf_nat_locks[h % CONNTRACK_LOCKS]);
+	spin_unlock_bh(&nf_nat_locks[h & CONNTRACK_LOCKS_MASK]);
 }
 
 static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
-- 
2.16.2

