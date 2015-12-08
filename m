From: Rami Rosen <rami.rosen@intel.com>
Subject: [PATCH nf-next] netfilter: nftables: Change the return type of nfulnl_set_timeout() and nfulnl_set_qthresh() to be void.
Date: Tue,  8 Dec 2015 07:09:24 -0500
Message-ID: <1449576564-30233-1-git-send-email-rami.rosen@intel.com>
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, Rami Rosen <rami.rosen@intel.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6991 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbbLHFJx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Dec 2015 00:09:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 This patch changes the return type of the static methods nfulnl_set_timeout() and
 nfulnl_set_qthresh() to be void, as there is no justification and no need for these methods to return int.

Signed-off-by: Rami Rosen <rami.rosen@intel.com>
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
2.5.0

