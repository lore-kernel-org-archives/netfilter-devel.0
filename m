From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH V2,nf 3/3] netfilter: nf_ct_helper: unlink helper again when hash resize happen
Date: Sun,  3 Jul 2016 13:18:45 +0800
Message-ID: <1467523125-61877-4-git-send-email-zlpnobody@163.com>
References: <1467523125-61877-1-git-send-email-zlpnobody@163.com>
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:47240 "EHLO m12-13.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbcGCFTl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 01:19:41 -0400
In-Reply-To: <1467523125-61877-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Similar to ctnl_untimeout, when hash resize happened, we should try
to do unhelp from the 0# bucket again.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 V2: no need to use nf_conntrack_generation to check hash resize happen.
 net/netfilter/nf_conntrack_helper.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 196cb39..db63a79 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -392,6 +392,8 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *next;
 	const struct hlist_nulls_node *nn;
+	unsigned int last_hsize;
+	spinlock_t *lock;
 	unsigned int i;
 	int cpu;
 
@@ -422,14 +424,20 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 			unhelp(h, me);
 		spin_unlock_bh(&pcpu->lock);
 	}
+
 	local_bh_disable();
-	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		nf_conntrack_lock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
-		if (i < nf_conntrack_htable_size) {
-			hlist_nulls_for_each_entry(h, nn, &nf_conntrack_hash[i], hnnode)
-				unhelp(h, me);
+restart:
+	last_hsize = nf_conntrack_htable_size;
+	for (i = 0; i < last_hsize; i++) {
+		lock = &nf_conntrack_locks[i % CONNTRACK_LOCKS];
+		nf_conntrack_lock(lock);
+		if (last_hsize != nf_conntrack_htable_size) {
+			spin_unlock(lock);
+			goto restart;
 		}
-		spin_unlock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+		hlist_nulls_for_each_entry(h, nn, &nf_conntrack_hash[i], hnnode)
+			unhelp(h, me);
+		spin_unlock(lock);
 	}
 	local_bh_enable();
 }
-- 
2.5.5


