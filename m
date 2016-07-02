From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 3/3] netfilter: nf_ct_helper: unlink helper again when hash resize happen
Date: Sat,  2 Jul 2016 18:59:27 +0800
Message-ID: <1467457167-5363-4-git-send-email-zlpnobody@163.com>
References: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58710 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbcGBLAJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 07:00:09 -0400
In-Reply-To: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Similar to ctnl_untimeout, when hash resize happened, we should try
to do unhelp from the 0# bucket again.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_conntrack_helper.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 196cb39..9d02b75 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -392,6 +392,8 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 	struct nf_conntrack_expect *exp;
 	const struct hlist_node *next;
 	const struct hlist_nulls_node *nn;
+	unsigned int sequence;
+	spinlock_t *lock;
 	unsigned int i;
 	int cpu;
 
@@ -422,14 +424,22 @@ static void __nf_conntrack_helper_unregister(struct nf_conntrack_helper *me,
 			unhelp(h, me);
 		spin_unlock_bh(&pcpu->lock);
 	}
+
 	local_bh_disable();
+restart:
+	sequence = read_seqcount_begin(&nf_conntrack_generation);
 	for (i = 0; i < nf_conntrack_htable_size; i++) {
-		nf_conntrack_lock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+		lock = &nf_conntrack_locks[i % CONNTRACK_LOCKS];
+		nf_conntrack_lock(lock);
+		if (read_seqcount_retry(&nf_conntrack_generation, sequence)) {
+			spin_unlock(lock);
+			goto restart;
+		}
 		if (i < nf_conntrack_htable_size) {
 			hlist_nulls_for_each_entry(h, nn, &nf_conntrack_hash[i], hnnode)
 				unhelp(h, me);
 		}
-		spin_unlock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+		spin_unlock(lock);
 	}
 	local_bh_enable();
 }
-- 
2.5.5


