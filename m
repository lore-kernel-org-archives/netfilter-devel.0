From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 69/69]: xt_iprange: fix sparse warnings
Date: Wed, 30 Jan 2008 21:18:39 +0100 (MET)
Message-ID: <20080130201837.29874.61100.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60839 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513AbYA3USk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:40 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_iprange: fix sparse warnings

  CHECK   net/netfilter/xt_iprange.c
net/netfilter/xt_iprange.c:104:19: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:37: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:19: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:37: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:19: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:37: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:19: warning: restricted degrades to integer
net/netfilter/xt_iprange.c:104:37: warning: restricted degrades to integer

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 59e1300f5bffbe2943e2c851be2bb803435420e1
tree 0a178e9489b665c73a078cbd9ef6c3ecafe23101
parent 5da2b9bf6eb8611637344f4da586d000c862e364
author Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:18 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:18 +0100

 net/netfilter/xt_iprange.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index dbea0e0..01035fc 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -101,7 +101,7 @@ iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
 	int r;
 
 	for (i = 0; i < 4; ++i) {
-		r = a->s6_addr32[i] - b->s6_addr32[i];
+		r = (__force u32)a->s6_addr32[i] - (__force u32)b->s6_addr32[i];
 		if (r != 0)
 			return r;
 	}
