From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] netfilter:ipset fix revision reporting
Date: Sat, 19 Mar 2011 11:10:04 +0100
Message-ID: <1300529404-18673-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:51889 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab1CSKKF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Mar 2011 06:10:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Sorry, my last patch broke the revision reporting (I should have ran the
testsuite first). So please apply this patch on top of the previous ones.

Best regards,
Jozsef

The patch 'netfilter:ipset: fix checking the type revision at create command'
broke the set type revisioning.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index b11cc5e..d6b4823 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -136,7 +136,7 @@ find_set_type_minmax(const char *name, u8 family, u8 *min, u8 *max)
 			found = true;
 			if (type->revision < *min)
 				*min = type->revision;
-			else if (type->revision > *max)
+			if (type->revision > *max)
 				*max = type->revision;
 		}
 	rcu_read_unlock();
-- 
1.7.0.4

