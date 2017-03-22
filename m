From: gfree.wind@foxmail.com
Subject: [PATCH nf v2 1/1] netfilter: helper: Add the rcu lock when call __nf_conntrack_helper_find
Date: Wed, 22 Mar 2017 11:51:44 +0800
Message-ID: <1490154704-74052-1-git-send-email-gfree.wind@foxmail.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgbr2.qq.com ([54.207.22.56]:35685 "EHLO smtpbgbr2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757572AbdCVDwD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 23:52:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

When invoke __nf_conntrack_helper_find, it needs the rcu lock to
protect the helper module which would not be unloaded.

Now there are two caller nf_conntrack_helper_try_module_get and
ctnetlink_create_expect which don't hold rcu lock. And the other
callers left like ctnetlink_change_helper, ctnetlink_create_conntrack,
and ctnetlink_glue_attach_expect, they already hold the rcu lock
or spin_lock_bh.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: add the rcu lock in nf_conntrack_helper_try_module_get
 v1: initial version

 net/netfilter/nf_conntrack_helper.c  | 11 ++++++++++-
 net/netfilter/nf_conntrack_netlink.c | 10 ++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 6dc44d9..023af78 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -158,16 +158,25 @@ struct nf_conntrack_helper *
 {
 	struct nf_conntrack_helper *h;
 
+	rcu_read_lock();
+
 	h = __nf_conntrack_helper_find(name, l3num, protonum);
 #ifdef CONFIG_MODULES
 	if (h == NULL) {
-		if (request_module("nfct-helper-%s", name) == 0)
+		rcu_read_unlock();
+		if (request_module("nfct-helper-%s", name) == 0) {
+			rcu_read_lock();
 			h = __nf_conntrack_helper_find(name, l3num, protonum);
+		} else {
+			return h;
+		}
 	}
 #endif
 	if (h != NULL && !try_module_get(h->me))
 		h = NULL;
 
+	rcu_read_unlock();
+
 	return h;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_try_module_get);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6806b5e..f6d1d63 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3133,23 +3133,27 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 		return -ENOENT;
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
+	rcu_read_lock();
 	if (cda[CTA_EXPECT_HELP_NAME]) {
 		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
 
 		helper = __nf_conntrack_helper_find(helpname, u3,
 						    nf_ct_protonum(ct));
 		if (helper == NULL) {
+			rcu_read_unlock();
 #ifdef CONFIG_MODULES
 			if (request_module("nfct-helper-%s", helpname) < 0) {
 				err = -EOPNOTSUPP;
 				goto err_ct;
 			}
+			rcu_read_lock();
 			helper = __nf_conntrack_helper_find(helpname, u3,
 							    nf_ct_protonum(ct));
 			if (helper) {
 				err = -EAGAIN;
-				goto err_ct;
+				goto err_rcu;
 			}
+			rcu_read_unlock();
 #endif
 			err = -EOPNOTSUPP;
 			goto err_ct;
@@ -3159,11 +3163,13 @@ static int ctnetlink_del_expect(struct net *net, struct sock *ctnl,
 	exp = ctnetlink_alloc_expect(cda, ct, helper, &tuple, &mask);
 	if (IS_ERR(exp)) {
 		err = PTR_ERR(exp);
-		goto err_ct;
+		goto err_rcu;
 	}
 
 	err = nf_ct_expect_related_report(exp, portid, report);
 	nf_ct_expect_put(exp);
+err_rcu:
+	rcu_read_unlock();
 err_ct:
 	nf_ct_put(ct);
 	return err;
-- 
1.9.1




