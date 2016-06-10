From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: destroy kmemcache on module removal
Date: Fri, 10 Jun 2016 17:25:19 +0200
Message-ID: <1465572319-880-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36317 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118AbcFJPZB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 11:25:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I forgot to move the kmem_cache_destroy into the exit path.

Fixes: 0c5366b3a8c7 ("netfilter: conntrack: use single slab cache)
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index db2312e..f204274 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1544,6 +1544,8 @@ void nf_conntrack_cleanup_end(void)
 	nf_conntrack_tstamp_fini();
 	nf_conntrack_acct_fini();
 	nf_conntrack_expect_fini();
+
+	kmem_cache_destroy(nf_conntrack_cachep);
 }
 
 /*
-- 
2.7.3

