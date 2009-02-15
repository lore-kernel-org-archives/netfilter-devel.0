From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 2/4] netfilter: suppress now unused nf_log_unregister_pf() function.
Date: Sun, 15 Feb 2009 13:37:15 +0100
Message-ID: <1234701437-2754-2-git-send-email-eric@inl.fr>
References: <49980BA7.2040108@inl.fr>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:54391 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752587AbZBOMhW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Feb 2009 07:37:22 -0500
In-Reply-To: <49980BA7.2040108@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch suppresses the now unused nf_log_unregister_pf() function
which is as been replaced by the bind and unbind functions.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 50d34db..1271b4f 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -69,19 +69,6 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_register);
 
-void nf_log_unregister_pf(u_int8_t pf)
-{
-	if (pf >= ARRAY_SIZE(nf_loggers))
-		return;
-	mutex_lock(&nf_log_mutex);
-	rcu_assign_pointer(nf_loggers[pf], NULL);
-	mutex_unlock(&nf_log_mutex);
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

