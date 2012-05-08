From: pablo@netfilter.org
Subject: [PATCH 08/25] ipvs: WRR scheduler does not need GFP_ATOMIC allocation
Date: Tue,  8 May 2012 02:22:02 +0200
Message-ID: <1336436539-5880-9-git-send-email-pablo@netfilter.org>
References: <1336436539-5880-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51756 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017Ab2EHAW4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 May 2012 20:22:56 -0400
In-Reply-To: <1336436539-5880-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Julian Anastasov <ja@ssi.bg>

	Schedulers are initialized and bound to services only
on commands.

Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_wrr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_wrr.c b/net/netfilter/ipvs/ip_vs_wrr.c
index fd0d4e0..231be7d 100644
--- a/net/netfilter/ipvs/ip_vs_wrr.c
+++ b/net/netfilter/ipvs/ip_vs_wrr.c
@@ -84,7 +84,7 @@ static int ip_vs_wrr_init_svc(struct ip_vs_service *svc)
 	/*
 	 *    Allocate the mark variable for WRR scheduling
 	 */
-	mark = kmalloc(sizeof(struct ip_vs_wrr_mark), GFP_ATOMIC);
+	mark = kmalloc(sizeof(struct ip_vs_wrr_mark), GFP_KERNEL);
 	if (mark == NULL)
 		return -ENOMEM;
 
-- 
1.7.9.5

