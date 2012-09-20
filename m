From: Ulrich Weber <ulrich.weber@sophos.com>
Subject: [PATCH net-next] nat: remove obsolete rcu_read_unlock call
Date: Thu, 20 Sep 2012 15:52:04 +0200
Message-ID: <20120920135133.GA21538@uweber-WS>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.sophos.com ([145.253.124.137]:53651 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab2ITOBz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:01:55 -0400
Received: from mx1.sophos.com (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 8D4E95B83BE
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Sep 2012 14:52:09 +0100 (BST)
Received: from de-wie-exch3b.green.sophos (de-wie-exch3b.green.sophos [10.60.70.62])
	by mx1.sophos.com (Postfix) with ESMTPS id 5A4BC5B83BB
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Sep 2012 14:52:09 +0100 (BST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hlist walk in find_appropriate_src() is not protected anymore by rcu_read_lock(),
so rcu_read_unlock() is unnecessary if in_range() matches.

Signed-off-by: Ulrich Weber <ulrich.weber@sophos.com>
---
 net/netfilter/nf_nat_core.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 1816ad3..125d832 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -201,10 +201,8 @@ find_appropriate_src(struct net *net, u16 zone,
 				       &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 			result->dst = tuple->dst;
 
-			if (in_range(l3proto, l4proto, result, range)) {
-				rcu_read_unlock();
+			if (in_range(l3proto, l4proto, result, range))
 				return 1;
-			}
 		}
 	}
 	return 0;
-- 
1.7.9.5

