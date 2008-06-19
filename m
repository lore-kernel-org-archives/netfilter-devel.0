From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: nf_conntrack_h323: fix memory leak in module initialization error path
Date: Thu, 19 Jun 2008 15:05:45 +0200 (MEST)
Message-ID: <20080619130544.26204.28566.sendpatchset@localhost.localdomain>
References: <20080619130541.26204.54310.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65332 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbYFSNFq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:05:46 -0400
In-Reply-To: <20080619130541.26204.54310.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_h323: fix memory leak in module initialization error path

Upstream commit 8a548868db62422113104ebc658065e3fe976951

Properly free h323_buffer when helper registration fails.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 54863b90bba4cc974df25c2e5ad207186727d9ec
tree 380077de74a3e20a6cdb2058e7c1390483898594
parent b59adf15982f7d435e1f6c5d8352d963a6c6a93a
author Patrick McHardy <kaber@trash.net> Thu, 19 Jun 2008 14:47:43 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 19 Jun 2008 14:47:43 +0200

 net/netfilter/nf_conntrack_h323_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 898f192..6e58bc8 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1792,6 +1792,7 @@ err3:
 err2:
 	nf_conntrack_helper_unregister(&nf_conntrack_helper_q931[0]);
 err1:
+	kfree(h323_buffer);
 	return ret;
 }
 
