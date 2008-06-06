From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 01/03: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
Date: Fri,  6 Jun 2008 19:18:42 +0200 (MEST)
Message-ID: <20080606171840.28097.34095.sendpatchset@localhost.localdomain>
References: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51321 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbYFFRSn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:18:43 -0400
In-Reply-To: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()

Upstream commit 12293bf91126ad253a25e2840b307fdc7c2754c3

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit d025d91021895314ce10cc0ab8e0f627dc1a12fa
tree 585226823a29b62d80781ba2bc605bc7178aa5d3
parent a82a9bfebc74862798a3f6949fe6f6a959c1fd4e
author Alexey Dobriyan <adobriyan@parallels.com> Fri, 06 Jun 2008 19:06:15 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 19:06:15 +0200

 net/netfilter/nf_conntrack_expect.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 684ec9c..d15d70f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -550,10 +550,10 @@ int __init nf_conntrack_expect_init(void)
 	return 0;
 
 err3:
+	kmem_cache_destroy(nf_ct_expect_cachep);
+err2:
 	nf_ct_free_hashtable(nf_ct_expect_hash, nf_ct_expect_vmalloc,
 			     nf_ct_expect_hsize);
-err2:
-	kmem_cache_destroy(nf_ct_expect_cachep);
 err1:
 	return err;
 }
