From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH] nfnetlink: use rcu_assign_pointer in nfnetlink_subsys_unregister
Date: Tue, 8 Oct 2013 18:04:08 +0800
Message-ID: <1381226648-10959-1-git-send-email-gaofeng@cn.fujitsu.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2235 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3JHKD1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:03:27 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r98A2xvw017395
	for <netfilter-devel@vger.kernel.org>; Tue, 8 Oct 2013 18:02:59 +0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Though I don't face an oops, but it is more safer to
set table's subsys through rcu_assign_pointer.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/nfnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 572d87d..3cd2fe6 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
 int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
 {
 	nfnl_lock(n->subsys_id);
-	table[n->subsys_id].subsys = NULL;
+	rcu_assign_pointer(table[n->subsys_id].subsys, NULL);
 	nfnl_unlock(n->subsys_id);
 	synchronize_rcu();
 	return 0;
-- 
1.8.3.1

