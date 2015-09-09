From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_log: don't zap all loggers on unregister
Date: Wed,  9 Sep 2015 02:57:21 +0200
Message-ID: <1441760241-3220-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51353 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752699AbbIIA6p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2015 20:58:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

like nf_log_unset, nf_log_unregister must not reset the list of loggers.
Otherwise, a call to nf_log_unregister() will render loggers of other nf
protocols unusable:

iptables -A INPUT -j LOG
modprobe nf_log_arp ; rmmod nf_log_arp
iptables -A INPUT -j LOG
iptables: No chain/target/match by that name

Fixes: 30e0c6a6be ("netfilter: nf_log: prepare net namespace support for loggers")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_log.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 675d12c..a5ebd7d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -107,11 +107,15 @@ EXPORT_SYMBOL(nf_log_register);
 
 void nf_log_unregister(struct nf_logger *logger)
 {
+	const struct nf_logger *log;
 	int i;
 
 	mutex_lock(&nf_log_mutex);
-	for (i = 0; i < NFPROTO_NUMPROTO; i++)
-		RCU_INIT_POINTER(loggers[i][logger->type], NULL);
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		log = nft_log_dereference(loggers[i][logger->type]);
+		if (log == logger)
+			RCU_INIT_POINTER(loggers[i][logger->type], NULL);
+	}
 	mutex_unlock(&nf_log_mutex);
 }
 EXPORT_SYMBOL(nf_log_unregister);
-- 
2.0.5

