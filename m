From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 3/3] nfnetlink: Unlock a previously locked rcu_read in nfnetlink_rcv_msg
Date: Thu, 28 Jun 2012 15:57:49 +0300
Message-ID: <1340888269-4926-4-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14685 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2F1M55 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:57:57 -0400
In-Reply-To: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 net/netfilter/nfnetlink.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4acdd76..a6366ae 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -169,8 +169,10 @@ replay:
 
 		err = nla_parse(cda, ss->cb[cb_id].attr_count,
 				attr, attrlen, ss->cb[cb_id].policy);
-		if (err < 0)
+		if (err < 0) {
+			rcu_read_unlock();
 			return err;
+		}
 
 		if (nc->call_rcu) {
 			err = nc->call_rcu(net->nfnl, skb, nlh,
-- 
1.7.8.6

