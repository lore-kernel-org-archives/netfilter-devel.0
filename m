From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 2/3] netfilter: cttimeout: unlink timeout obj again when hash resize happen
Date: Sat,  2 Jul 2016 18:59:26 +0800
Message-ID: <1467457167-5363-3-git-send-email-zlpnobody@163.com>
References: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:58571 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbcGBLAI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 07:00:08 -0400
In-Reply-To: <1467457167-5363-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Imagine such situation, nf_conntrack_htable_size now is 4096, we are doing
ctnl_untimeout, and iterate on 3000# bucket.

Meanwhile, another user try to reduce hash size to 2048, then all nf_conn
are removed to the new hashtable. When this hash resize operation finished,
we still try to itreate ct begin from 3000# bucket, find nothing to do and
just return.

Then we may miss unlinking some timeout objects. And later we will end up
with invalid references to timeout object that are already gone.

So when we find that hash resize happened, try to unlink timeout objects
from the 0# bucket again.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nfnetlink_cttimeout.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 3c84f14..1d0bc86 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -303,16 +303,26 @@ static void ctnl_untimeout(struct net *net, struct ctnl_timeout *timeout)
 {
 	struct nf_conntrack_tuple_hash *h;
 	const struct hlist_nulls_node *nn;
+	unsigned int sequence;
+	spinlock_t *lock;
 	int i;
 
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
+
 		if (i < nf_conntrack_htable_size) {
 			hlist_nulls_for_each_entry(h, nn, &nf_conntrack_hash[i], hnnode)
 				untimeout(h, timeout);
 		}
-		spin_unlock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+		spin_unlock(lock);
 	}
 	local_bh_enable();
 }
-- 
2.5.5


