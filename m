From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 2/3] nfnetlink_cttimeout: add rcu_barrier() on module removal
Date: Mon,  5 Oct 2015 16:51:02 +0200
Message-ID: <1444056663-5913-2-git-send-email-pablo@netfilter.org>
References: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Cc: stephen@networkplumber.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46826 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbbJEOoJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 10:44:09 -0400
In-Reply-To: <1444056663-5913-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure kfree_rcu() released objects before leaving the module removal
exit path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 138cd0a..e90e4fc 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -612,6 +612,7 @@ static void __exit cttimeout_exit(void)
 	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
 	RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
+	rcu_barrier();
 }
 
 module_init(cttimeout_init);
-- 
2.1.4

