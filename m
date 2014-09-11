From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/3] netfilter: nfnetlink: use original skbuff when committing/aborting
Date: Thu, 11 Sep 2014 17:20:18 +0200
Message-ID: <1410448819-6694-2-git-send-email-pablo@netfilter.org>
References: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47181 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbaIKPTm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:19:42 -0400
In-Reply-To: <1410448819-6694-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to access the original content of the batch from
the commit and the abort paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index c138b8f..dfc1a61 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -357,9 +357,9 @@ ack:
 	}
 done:
 	if (success && done)
-		ss->commit(skb);
+		ss->commit(oskb);
 	else
-		ss->abort(skb);
+		ss->abort(oskb);
 
 	nfnl_unlock(subsys_id);
 	kfree_skb(nskb);
-- 
1.7.10.4

