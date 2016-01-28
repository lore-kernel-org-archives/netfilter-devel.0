From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: cttimeout: fix deadlock due to erroneous unlock/lock conversion
Date: Thu, 28 Jan 2016 13:16:59 +0100
Message-ID: <1453983419-28688-1-git-send-email-fw@strlen.de>
Cc: sasha.levin@oracle.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42064 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964868AbcA1M1b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 07:27:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The spin_unlock call should have been left as-is, revert.

Fixes: b16c29191dc89bd ("netfilter: nf_conntrack: use safer way to lock all buckets")
Reported-by: kernel test robot <fengguang.wu@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cttimeout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 94837d2..2671b9d 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -312,7 +312,7 @@ static void ctnl_untimeout(struct net *net, struct ctnl_timeout *timeout)
 			hlist_nulls_for_each_entry(h, nn, &net->ct.hash[i], hnnode)
 				untimeout(h, timeout);
 		}
-		nf_conntrack_lock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
+		spin_unlock(&nf_conntrack_locks[i % CONNTRACK_LOCKS]);
 	}
 	local_bh_enable();
 }
-- 
2.4.10

