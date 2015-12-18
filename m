From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/23] netfilter: nfnetlink_log: Change setter functions to be void
Date: Fri, 18 Dec 2015 21:26:43 +0100
Message-ID: <1450470409-31427-18-git-send-email-pablo@netfilter.org>
References: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965207AbbLRUeJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 15:34:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ED3C815AE9D
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A46C2DA879
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5676FDA24A
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 21:34:04 +0100 (CET)
In-Reply-To: <1450470409-31427-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Rosen, Rami" <rami.rosen@intel.com>

Change return type of nfulnl_set_timeout() and nfulnl_set_qthresh() to
be void.

This patch changes the return type of the static methods
nfulnl_set_timeout() and nfulnl_set_qthresh() to be void, as there is no
justification and no need for these methods to return int.

Signed-off-by: Rami Rosen <rami.rosen@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index dea4676..70b6bd3 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -293,24 +293,20 @@ nfulnl_set_nlbufsiz(struct nfulnl_instance *inst, u_int32_t nlbufsiz)
 	return status;
 }
 
-static int
+static void
 nfulnl_set_timeout(struct nfulnl_instance *inst, u_int32_t timeout)
 {
 	spin_lock_bh(&inst->lock);
 	inst->flushtimeout = timeout;
 	spin_unlock_bh(&inst->lock);
-
-	return 0;
 }
 
-static int
+static void
 nfulnl_set_qthresh(struct nfulnl_instance *inst, u_int32_t qthresh)
 {
 	spin_lock_bh(&inst->lock);
 	inst->qthreshold = qthresh;
 	spin_unlock_bh(&inst->lock);
-
-	return 0;
 }
 
 static int
-- 
2.1.4

