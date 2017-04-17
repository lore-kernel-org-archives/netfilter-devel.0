From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf 1/4] netfilter: ctnetlink: drop the incorrect cthelper module request
Date: Mon, 17 Apr 2017 21:18:55 +0800
Message-ID: <1492435138-28283-2-git-send-email-zlpnobody@163.com>
References: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:56528 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753477AbdDQNTu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Apr 2017 09:19:50 -0400
In-Reply-To: <1492435138-28283-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

First, when creating a new ct, we will invoke request_module to try to
load the related inkernel cthelper. So there's no need to call the
request_module again when updating the ct helpinfo.

Second, ctnetlink_change_helper may be called with rcu_read_lock held,
i.e. rcu_read_lock -> nfqnl_recv_verdict -> nfqnl_ct_parse ->
ctnetlink_glue_parse -> ctnetlink_glue_parse_ct ->
ctnetlink_change_helper. But the request_module invocation may sleep,
so we can't call it with the rcu_read_lock held.

Remove it now.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index dc7dfd6..48c1845 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1512,23 +1512,8 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 
 	helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
 					    nf_ct_protonum(ct));
-	if (helper == NULL) {
-#ifdef CONFIG_MODULES
-		spin_unlock_bh(&nf_conntrack_expect_lock);
-
-		if (request_module("nfct-helper-%s", helpname) < 0) {
-			spin_lock_bh(&nf_conntrack_expect_lock);
-			return -EOPNOTSUPP;
-		}
-
-		spin_lock_bh(&nf_conntrack_expect_lock);
-		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
-						    nf_ct_protonum(ct));
-		if (helper)
-			return -EAGAIN;
-#endif
+	if (helper == NULL)
 		return -EOPNOTSUPP;
-	}
 
 	if (help) {
 		if (help->helper == helper) {
-- 
2.5.5


