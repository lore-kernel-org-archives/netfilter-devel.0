From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf] netfilter: ctnetlink: put back references to master ct and expect objects
Date: Fri, 10 Jul 2015 00:05:42 +0200
Message-ID: <1436479542-3571-1-git-send-email-pablo@netfilter.org>
Cc: Tim.Wiess@watchguard.com, Xinbao.Zheng@watchguard.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40394 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbbGIWAT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2015 18:00:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We have to put back the references to the master conntrack and the expectation
that we just created, otherwise we'll leak them.

Fixes: 0ef71ee1a5b9 ("netfilter: ctnetlink: refactor ctnetlink_create_expect")
Reported-by: Tim Wiess <Tim.Wiess@watchguard.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Will pass this to -stable from 3.12 upwards.

 net/netfilter/nf_conntrack_netlink.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d1c2394..de5e510 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2995,10 +2995,6 @@ ctnetlink_create_expect(struct net *net, u16 zone,
 	}
 
 	err = nf_ct_expect_related_report(exp, portid, report);
-	if (err < 0)
-		goto err_exp;
-
-	return 0;
 err_exp:
 	nf_ct_expect_put(exp);
 err_ct:
-- 
1.7.10.4

