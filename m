From: Simon Horman <horms@verge.net.au>
Subject: [PATCH 04/17] ipvs: WRR scheduler does not need GFP_ATOMIC allocation
Date: Wed,  2 May 2012 10:24:48 +0900
Message-ID: <1335921901-21284-5-git-send-email-horms@verge.net.au>
References: <1335921901-21284-1-git-send-email-horms@verge.net.au>
Cc: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Wensong Zhang <wensong@linux-vs.org>,
	Julian Anastasov <ja@ssi.bg>,
	Hans Schillstrom <hans.schillstrom@ericsson.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Hans Schillstrom <hans@schillstrom.com>,
	Simon Horman <horms@verge.net.au>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:59908 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2EBBZX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 May 2012 21:25:23 -0400
In-Reply-To: <1335921901-21284-1-git-send-email-horms@verge.net.au>
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

