From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/6] netfilter: suppress nf_log_unregister_pf function.
Date: Thu,  8 Jan 2009 23:03:10 +0100
Message-ID: <1231452194-7800-2-git-send-email-eric@inl.fr>
References: <1231452093.10299.2.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net, jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37538 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754772AbZAHWDT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:03:19 -0500
In-Reply-To: <1231452093.10299.2.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The nf_log_unregister_pf() function is not used anymore as it was
corresponding to the unbind operation which is now done via
nflog_unbind_pf().

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 include/net/netfilter/nf_log.h |    1 -
 net/netfilter/nf_log.c         |   15 ---------------
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 08b4f18..ccaa43a 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -48,7 +48,6 @@ struct nf_logger {
 /* Function to register/unregister log function. */
 int nf_log_register(u_int8_t pf, struct nf_logger *logger);
 void nf_log_unregister(struct nf_logger *logger);
-void nf_log_unregister_pf(u_int8_t pf);
 
 int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger);
 int nf_log_unbind_pf(u_int8_t pf);
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 8a5e4aa..a1dcd46 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -69,21 +69,6 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_register);
 
-void nf_log_unregister_pf(u_int8_t pf)
-{
-	struct nf_logger *e;
-	if (pf >= ARRAY_SIZE(nf_loggers))
-		return;
-	spin_lock_bh(&nf_log_lock);
-	list_for_each_entry(e, &(nf_loggers_l[pf]), list[pf])
-		list_del(&(e->list[pf]));
-	spin_unlock_bh(&nf_log_lock);
-
-	/* Give time to concurrent readers. */
-	synchronize_rcu();
-}
-EXPORT_SYMBOL(nf_log_unregister_pf);
-
 void nf_log_unregister(struct nf_logger *logger)
 {
 	int i;
-- 
1.5.6.3

