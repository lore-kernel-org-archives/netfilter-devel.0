From: Weidong Wang <wangweidong1@huawei.com>
Subject: [PATCH net-next] netfilter: nf_conntrack: remove the unneed check
 for *bucket
Date: Sat, 30 Jan 2016 20:25:32 +0800
Message-ID: <56ACABBC.9050303@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: <pablo@netfilter.org>, <kaber@trash.net>,
	<kadlec@blackhole.kfki.hu>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:61894 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbcA3MZm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jan 2016 07:25:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the 'for(...) {}', the *bucket alwasy < net->ct.htable_size,
so remove the check

Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
---
 net/netfilter/nf_conntrack_core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3cb3cb8..cd7d5c8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1383,14 +1383,12 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 		lockp = &nf_conntrack_locks[*bucket % CONNTRACK_LOCKS];
 		local_bh_disable();
 		spin_lock(lockp);
-		if (*bucket < net->ct.htable_size) {
-			hlist_nulls_for_each_entry(h, n, &net->ct.hash[*bucket], hnnode) {
-				if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
-					continue;
-				ct = nf_ct_tuplehash_to_ctrack(h);
-				if (iter(ct, data))
-					goto found;
-			}
+		hlist_nulls_for_each_entry(h, n, &net->ct.hash[*bucket], hnnode) {
+			if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
+				continue;
+			ct = nf_ct_tuplehash_to_ctrack(h);
+			if (iter(ct, data))
+				goto found;
 		}
 		spin_unlock(lockp);
 		local_bh_enable();
-- 
2.7.0


