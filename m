From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nfnetlink: don't probe module if it exists
Date: Tue, 27 Oct 2015 13:20:25 +0100
Message-ID: <1445948425-19080-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54304 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbbJ0MUb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 08:20:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nfnetlink_bind request_module()s all the time as nfnetlink_get_subsys()
shifts the argument by 8 to obtain the subsys id.

So using type instead of type << 8 always returns NULL.

Fixes: 03292745b02d11 ("netlink: add nlk->netlink_bind hook for module auto-loading")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 70277b1..27b93da 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -492,7 +492,7 @@ static int nfnetlink_bind(struct net *net, int group)
 	type = nfnl_group2type[group];
 
 	rcu_read_lock();
-	ss = nfnetlink_get_subsys(type);
+	ss = nfnetlink_get_subsys(type << 8);
 	rcu_read_unlock();
 	if (!ss)
 		request_module("nfnetlink-subsys-%d", type);
-- 
2.0.5

