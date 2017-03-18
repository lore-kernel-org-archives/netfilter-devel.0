From: fgao@ikuai8.com
Subject: [PATCH nf 1/1] netfilter: ctlink: Fix one possible use-after-free in ctnetlink_create_expect
Date: Sat, 18 Mar 2017 11:46:10 +0800
Message-ID: <1489808770-29622-1-git-send-email-fgao@ikuai8.com>
Cc: Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        gfree.wind@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG352.QQ.COM ([183.57.50.167]:53577 "EHLO smtpbg352.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbdCRD4i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 23:56:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There is no rcu_read_lock during ctlink gets the helper and inserts the
expectation. So there is one possible use-after-free issue when unload
the helper module.

For example:

        CPU1                                CPU2
ctlink gets the helper
                            helper module unload and remove all expectations
insert the expectation

Now there is one expectation which references one helper whose module is
unloaded.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 net/netfilter/nf_conntrack_netlink.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

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


