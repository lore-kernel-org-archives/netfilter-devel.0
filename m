From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: align nf_conn on cacheline boundary
Date: Fri, 10 Jun 2016 22:25:22 +0200
Message-ID: <1465590322-2174-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36912 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949AbcFJUZF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 16:25:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

increases struct size by 32 bytes (288 -> 320), but it is the right thing,
else any attempt to (re-)arrange nf_conn members by cacheline won't work.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 gives checkpatch warn due to line > 80 lines but I don't want to
 add a line-break after | just for checkpatch...

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c74dac7..a459176 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1711,7 +1711,7 @@ int nf_conntrack_init_start(void)
 
 	nf_conntrack_cachep = kmem_cache_create("nf_conntrack",
 						sizeof(struct nf_conn), 0,
-						SLAB_DESTROY_BY_RCU, NULL);
+						SLAB_DESTROY_BY_RCU | SLAB_HWCACHE_ALIGN, NULL);
 	if (!nf_conntrack_cachep)
 		goto err_cachep;
 
-- 
2.7.3

