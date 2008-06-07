From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 37/50] netfilter: nf_conntrack_expect: fix error path unwind in nf_conntrack_expect_init()
Date: Fri, 06 Jun 2008 18:02:52 -0700
Message-ID: <20080607010626.752571721@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Alexey Dobriyan <adobriyan@parallels.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:42545 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760227AbYFGBJ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:27 -0400
Content-Disposition: inline; filename=netfilter-nf_conntrack_expect-fix-error-path-unwind-in-nf_conntrack_expect_init.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

upstream commit: 12293bf91126ad253a25e2840b307fdc7c2754c3

Signed-off-by: Alexey Dobriyan <adobriyan@parallels.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/netfilter/nf_conntrack_expect.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -550,10 +550,10 @@ int __init nf_conntrack_expect_init(void
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

-- 
