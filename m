From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: nf_log: wait for rcu grace after logger unregistration
Date: Thu, 17 Sep 2015 13:51:18 +0200
Message-ID: <1442490678-3535-1-git-send-email-pablo@netfilter.org>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48085 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbbIQLon (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2015 07:44:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nf_log_unregister() function needs to call synchronize_rcu() to make sure
that the objects are not dereferenced anymore on module removal.

Fixes: 5962815a6a56 ("netfilter: nf_log: use an array of loggers instead of list")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Florian: I noticed this while reviewing your patch to fix the "zap all
loggers" bug.

 net/netfilter/nf_log.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index a5ebd7d..a5d41df 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -117,6 +117,7 @@ void nf_log_unregister(struct nf_logger *logger)
 			RCU_INIT_POINTER(loggers[i][logger->type], NULL);
 	}
 	mutex_unlock(&nf_log_mutex);
+	synchronize_rcu();
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
-- 
1.7.10.4

