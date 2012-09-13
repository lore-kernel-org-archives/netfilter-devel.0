From: pablo@netfilter.org
Subject: [PATCH 4/5] ipvs: use list_del_init instead of list_del/INIT_LIST_HEAD
Date: Thu, 13 Sep 2012 13:01:31 +0200
Message-ID: <1347534092-3579-5-git-send-email-pablo@netfilter.org>
References: <1347534092-3579-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46321 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab2IMLDC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 07:03:02 -0400
In-Reply-To: <1347534092-3579-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_del_init() instead of list_del() + INIT_LIST_HEAD().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 767cc12..37b38d0 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -539,8 +539,7 @@ static int ip_vs_rs_unhash(struct ip_vs_dest *dest)
 	 * Remove it from the rs_table table.
 	 */
 	if (!list_empty(&dest->d_list)) {
-		list_del(&dest->d_list);
-		INIT_LIST_HEAD(&dest->d_list);
+		list_del_init(&dest->d_list);
 	}
 
 	return 1;
-- 
1.7.10.4

