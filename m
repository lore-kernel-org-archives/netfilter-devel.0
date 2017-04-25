From: Florian Westphal <fw@strlen.de>
Subject: [PATCHo nf-next v2] netfilter: nf_log: don't call synchronize_rcu in nf_log_unset
Date: Tue, 25 Apr 2017 10:24:03 +0200
Message-ID: <20170425082403.558-1-fw@strlen.de>
References: <20170424133741.2707-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47520 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1176334AbdDYIX4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 04:23:56 -0400
In-Reply-To: <20170424133741.2707-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_log_unregister() (which is what gets called in the logger backends
module exit paths) does a (required, module is removed) synchronize_rcu().

But nf_log_unset() is only called from pernet exit handlers. It doesn't
free any memory so there appears to be no need to call synchronize_rcu.

v2: Liping Zhang points out that nf_log_unregister() needs to be called
after pernet unregister, else rmmod would become unsafe.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_log.c        | 1 -
 net/netfilter/nfnetlink_log.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index cc32727e3f32..8bb152a7cca4 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -71,7 +71,6 @@ void nf_log_unset(struct net *net, const struct nf_logger *logger)
 			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
 	}
 	mutex_unlock(&nf_log_mutex);
-	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_log_unset);
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 896741206a50..da9704971a83 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1140,10 +1140,10 @@ static int __init nfnetlink_log_init(void)
 
 static void __exit nfnetlink_log_fini(void)
 {
-	nf_log_unregister(&nfulnl_logger);
 	nfnetlink_subsys_unregister(&nfulnl_subsys);
 	netlink_unregister_notifier(&nfulnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_log_net_ops);
+	nf_log_unregister(&nfulnl_logger);
 }
 
 MODULE_DESCRIPTION("netfilter userspace logging");
-- 
2.10.2

