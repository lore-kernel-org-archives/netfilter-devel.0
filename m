From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: decnet: only register hooks in init namespace
Date: Thu, 20 Apr 2017 00:42:07 +0200
Message-ID: <20170419224207.3219-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45322 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1765212AbdDSWlt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 18:41:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

looks like decnet isn't namespacified in first place, so restrict hook
registration to the initial namespace.

Prepares for eventual removal of legacy nf_register_hook() api.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/decnet/netfilter/dn_rtmsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/decnet/netfilter/dn_rtmsg.c b/net/decnet/netfilter/dn_rtmsg.c
index 85f2fdc360c2..f44303a40105 100644
--- a/net/decnet/netfilter/dn_rtmsg.c
+++ b/net/decnet/netfilter/dn_rtmsg.c
@@ -134,7 +134,7 @@ static int __init dn_rtmsg_init(void)
 		return -ENOMEM;
 	}
 
-	rv = nf_register_hook(&dnrmg_ops);
+	rv = nf_register_net_hook(&init_net, &dnrmg_ops);
 	if (rv) {
 		netlink_kernel_release(dnrmg);
 	}
@@ -144,7 +144,7 @@ static int __init dn_rtmsg_init(void)
 
 static void __exit dn_rtmsg_fini(void)
 {
-	nf_unregister_hook(&dnrmg_ops);
+	nf_unregister_net_hook(&init_net, &dnrmg_ops);
 	netlink_kernel_release(dnrmg);
 }
 
-- 
2.10.2

