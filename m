From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/18] ipvs: remove null test before kfree
Date: Fri, 18 Jul 2014 13:01:11 +0200
Message-ID: <1405681272-4994-18-git-send-email-pablo@netfilter.org>
References: <1405681272-4994-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761511AbaGRLB2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:01:28 -0400
In-Reply-To: <1405681272-4994-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Fabian Frederick <fabf@skynet.be>

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_sync.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index db80126..eadffb2 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -886,8 +886,7 @@ static void ip_vs_proc_conn(struct net *net, struct ip_vs_conn_param *param,
 		cp = ip_vs_conn_new(param, daddr, dport, flags, dest, fwmark);
 		rcu_read_unlock();
 		if (!cp) {
-			if (param->pe_data)
-				kfree(param->pe_data);
+			kfree(param->pe_data);
 			IP_VS_DBG(2, "BACKUP, add new conn. failed\n");
 			return;
 		}
-- 
1.7.10.4

