From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/09]: nf_conntrack: add \n to "expectation table full" message
Date: Mon, 10 Mar 2008 19:26:20 +0100 (MET)
Message-ID: <20080310182622.20404.52937.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYCJS0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:21 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: add \n to "expectation table full" message

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6cc9434319dd0ea32cc6e1969523a1a77043379c
tree 54392c76361f72bed435bd740a84ad3d0aa8a07a
parent 342661f5a04f90772e0d33302634e010ab3649ed
author Alexey Dobriyan <adobriyan@sw.ru> Mon, 10 Mar 2008 17:50:42 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 17:50:42 +0100

 net/netfilter/nf_conntrack_expect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index e06bf00..684ec9c 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -381,7 +381,7 @@ int nf_ct_expect_related(struct nf_conntrack_expect *expect)
 	if (nf_ct_expect_count >= nf_ct_expect_max) {
 		if (net_ratelimit())
 			printk(KERN_WARNING
-			       "nf_conntrack: expectation table full");
+			       "nf_conntrack: expectation table full\n");
 		ret = -EMFILE;
 		goto out;
 	}
