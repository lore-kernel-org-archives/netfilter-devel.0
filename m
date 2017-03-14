From: fgao@ikuai8.com
Subject: [PATCH nf 1/1] netfilter: helper: Fix possible panic caused by invoking expectfn unloaded
Date: Tue, 14 Mar 2017 14:26:06 +0800
Message-ID: <1489472766-89568-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg339.qq.com ([14.17.44.34]:56783 "EHLO smtpbg339.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750825AbdCNG01 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 02:26:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

The helper module permits the helper modules register expectfn, and
it could be hold by external caller. But when the module is unloaded,
there may be some pending expect nodes which still hold the function
reference. It may cause unexpected behavior, even panic.

Now it would delete the expect nodes which uses the expectfn when
unregister expectfn. And it must use the rcu_read_lock to protect
the expectfn until insert it or doesn't access it ever.

There is only one caller which doesn't hold the rcu lock now.
It is ctnetlink_create_expect.

BTW, nf_ct_helper_expectfn_find_by_name/symbol invokes the rcu lock
to protect the lookup. But it is not enough, because it returns the
nf_ct_helper_expectfn pointer which should be protected by rcu lock.
Actually the caller should hold the rcu lock instead of these funcs.
I will refine it in the cleanup patch.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_helper.c  | 23 +++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c |  3 +++
 2 files changed, 26 insertions(+)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..2be820b 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -305,9 +305,32 @@ void nf_ct_helper_expectfn_register(struct nf_ct_helper_expectfn *n)
 
 void nf_ct_helper_expectfn_unregister(struct nf_ct_helper_expectfn *n)
 {
+	struct nf_conntrack_expect *exp;
+	const struct hlist_node *next;
+	u32 i;
+
 	spin_lock_bh(&nf_conntrack_expect_lock);
 	list_del_rcu(&n->head);
 	spin_unlock_bh(&nf_conntrack_expect_lock);
+
+	/* Make sure everyone who holds the expect func already
+	 * has inserted it
+	 */
+	synchronize_rcu();
+
+	/* Get rid of expectations used the dying expectfn */
+	spin_lock_bh(&nf_conntrack_expect_lock);
+	for (i = 0; i < nf_ct_expect_hsize; i++) {
+		hlist_for_each_entry_safe(exp, next,
+					  &nf_ct_expect_hash[i], hnode) {
+			if (exp->expectfn == n->expectfn &&
+			    del_timer(&exp->timeout)) {
+				nf_ct_unlink_expect(exp);
+				nf_ct_expect_put(exp);
+			}
+		}
+	}
+	spin_unlock_bh(&nf_conntrack_expect_lock);
 }
 EXPORT_SYMBOL_GPL(nf_ct_helper_expectfn_unregister);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6806b5e..37784e2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3156,14 +3156,17 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 		}
 	}
 
+	rcu_read_lock();
 	exp = ctnetlink_alloc_expect(cda, ct, helper, &tuple, &mask);
 	if (IS_ERR(exp)) {
+		rcu_read_unlock();
 		err = PTR_ERR(exp);
 		goto err_ct;
 	}
 
 	err = nf_ct_expect_related_report(exp, portid, report);
 	nf_ct_expect_put(exp);
+	rcu_read_unlock();
 err_ct:
 	nf_ct_put(ct);
 	return err;
-- 
1.9.1


