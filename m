From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 3/6] netfilter: bind at registration if no logger is already set.
Date: Thu,  8 Jan 2009 23:03:11 +0100
Message-ID: <1231452194-7800-3-git-send-email-eric@inl.fr>
References: <1231452093.10299.2.camel@ice-age>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: kaber@trash.net, jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:37539 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754746AbZAHWDT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:03:19 -0500
In-Reply-To: <1231452093.10299.2.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a bind operation when registration is done and when
there is currently no logger defined for the protocol. This emulates the
first registered wins policy and thus achieves backward compatibility.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 net/netfilter/nf_log.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index a1dcd46..1655a1f 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -35,6 +35,7 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 {
 	int ret;
+	const struct nf_logger *llog;
 
 	if (pf >= ARRAY_SIZE(nf_loggers))
 		return -EINVAL;
@@ -58,13 +59,17 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 		if (__find_logger(pf, logger->name) == NULL) {
 			ret = 0;
 			INIT_LIST_HEAD(&(logger->list[pf]));
-			/* register at end of list to honor first register win */
 			list_add_tail(&(logger->list[pf]),
 					  &nf_loggers_l[pf]);
+			llog = rcu_dereference(nf_loggers[pf]);
+			if (llog == NULL)
+				rcu_assign_pointer(nf_loggers[pf], logger);
 		}
 	}
 
 	spin_unlock_bh(&nf_log_lock);
+
+	synchronize_rcu();
 	return ret;
 }
 EXPORT_SYMBOL(nf_log_register);
-- 
1.5.6.3

