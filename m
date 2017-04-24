From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: nf_log: don't call synchronize_rcu in nf_log_unset
Date: Mon, 24 Apr 2017 15:37:40 +0200
Message-ID: <20170424133741.2707-3-fw@strlen.de>
References: <20170424133741.2707-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:43544 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1171542AbdDXNhg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Apr 2017 09:37:36 -0400
In-Reply-To: <20170424133741.2707-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_log_unregister() (which is what gets called in the logger backends
module exit paths) does a (required, module is removed) synchronize_rcu().

But nf_log_unset() is only called from pernet exit handlers. It doesn't
free any memory so there appears to be no need to call synchronize_rcu.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_log.c | 1 -
 1 file changed, 1 deletion(-)

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
 
-- 
2.10.2

