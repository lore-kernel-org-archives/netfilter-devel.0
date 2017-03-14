From: fgao@ikuai8.com
Subject: [PATCH net-next 1/1] netfilter: helper: Remove the rcu lock in nf_ct_helper_expectfn_find_by_name and nf_ct_helper_expectfn_find_by_symbol.
Date: Tue, 14 Mar 2017 16:29:05 +0800
Message-ID: <1489480145-54411-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg278.qq.com ([113.108.11.203]:33111 "EHLO smtpbg278.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750824AbdCNIhQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 04:37:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

Because these two functions return the nf_ct_helper_expectfn pointer
which should be protected by rcu lock. So it should makes sure the
caller should hold the rcu lock, not inside these functions.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_helper.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..bce3d1f 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -311,38 +311,36 @@ void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
 
+/* Caller should hold the rcu lock */
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_name(const char *name)
 {
 	struct nf_ct_helper_expectfn *cur;
 	bool found = false;
 
-	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
 		if (!strcmp(cur->name, name)) {
 			found = true;
 			break;
 		}
 	}
-	rcu_read_unlock();
 	return found ? cur : NULL;
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_name);
 
+/* Caller should hold the rcu lock */
 struct nf_ct_helper_expectfn *
 nf_ct_helper_expectfn_find_by_symbol(const void *symbol)
 {
 	struct nf_ct_helper_expectfn *cur;
 	bool found = false;
 
-	rcu_read_lock();
 	list_for_each_entry_rcu(cur, &nf_ct_helper_expectfn_list, head) {
 		if (cur->expectfn == symbol) {
 			found = true;
 			break;
 		}
 	}
-	rcu_read_unlock();
 	return found ? cur : NULL;
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_find_by_symbol);
-- 
1.9.1


