From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 3/6] netfilter: ipset: Remove unnecessary OOM logging messages
Date: Tue,  6 Sep 2011 21:59:04 +0200
Message-ID: <1315339147-9617-4-git-send-email-kadlec@blackhole.kfki.hu>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Joe Perches <joe@perches.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:49967 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1IFT7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:59:45 -0400
In-Reply-To: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Joe Perches <joe@perches.com>

Removing unnecessary messages saves code and text.

Site specific OOM messages are duplications of a generic MM
out of memory message and aren't really useful, so just
delete them.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 7fa4a89..d5c4b5b 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1717,10 +1717,8 @@ ip_set_init(void)
 
 	ip_set_list = kzalloc(sizeof(struct ip_set *) * ip_set_max,
 			      GFP_KERNEL);
-	if (!ip_set_list) {
-		pr_err("ip_set: Unable to create ip_set_list\n");
+	if (!ip_set_list)
 		return -ENOMEM;
-	}
 
 	ret = nfnetlink_subsys_register(&ip_set_netlink_subsys);
 	if (ret != 0) {
-- 
1.7.0.4

