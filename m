From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/4] netfilter: nf_tables: wait for call_rcu completion on module removal
Date: Thu,  2 Oct 2014 11:49:52 +0200
Message-ID: <1412243394-4596-2-git-send-email-pablo@netfilter.org>
References: <1412243394-4596-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53146 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbaJBJsq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:48:46 -0400
In-Reply-To: <1412243394-4596-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure the objects have been released before the nf_tables modules
is removed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 19e79f0..556a0df 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4163,6 +4163,7 @@ static void __exit nf_tables_module_exit(void)
 {
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
+	rcu_barrier();
 	nf_tables_core_module_exit();
 	kfree(info);
 }
-- 
1.7.10.4

