From: Florian Westphal <fw@strlen.de>
Subject: [PATCH next] netfilter: nfnetlink_log: remove unused code
Date: Tue, 18 Feb 2014 22:35:34 +0100
Message-ID: <1392759334-12926-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56911 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbaBRVjc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:39:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index a155d19..d292c8d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -28,8 +28,6 @@
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/list.h>
-#include <linux/jhash.h>
-#include <linux/random.h>
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <net/netfilter/nf_log.h>
@@ -75,7 +73,6 @@ struct nfulnl_instance {
 };
 
 #define INSTANCE_BUCKETS	16
-static unsigned int hash_init;
 
 static int nfnl_log_net_id __read_mostly;
 
@@ -1067,11 +1064,6 @@ static int __init nfnetlink_log_init(void)
 {
 	int status = -ENOMEM;
 
-	/* it's not really all that important to have a random value, so
-	 * we can do this from the init function, even if there hasn't
-	 * been that much entropy yet */
-	get_random_bytes(&hash_init, sizeof(hash_init));
-
 	netlink_register_notifier(&nfulnl_rtnl_notifier);
 	status = nfnetlink_subsys_register(&nfulnl_subsys);
 	if (status < 0) {
-- 
1.8.1.5

