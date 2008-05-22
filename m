From: Alexey Dobriyan <adobriyan@parallels.com>
Subject: [PATCH] nf_conntrack: fix error path unwind in nf_conntrack_expect_init()
Date: Thu, 22 May 2008 19:14:28 +0400
Message-ID: <200805221914.28472.adobriyan@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, devel@openvz.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:9435 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbYEVPOi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 11:14:38 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
---

 net/netfilter/nf_conntrack_expect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -587,10 +587,10 @@ int __init nf_conntrack_expect_init(void)
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
