From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: xt_iprange: fix typo in address family
Date: Wed,  6 Feb 2008 14:34:03 +0100 (MET)
Message-ID: <20080206133403.15303.465.sendpatchset@localhost.localdomain>
References: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763531AbYBFNeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:34:05 -0500
In-Reply-To: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_iprange: fix typo in address family

The family for iprange_mt4 should be AF_INET, not AF_INET6.
Noticed by Jiri Moravec <jim.lkml@gmail.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a9fd46af7dc44d5d5c0e547b82c73ce01024e74d
tree 30728c3c81dbd20acbdaf3a735c96ea40252c7ca
parent 9f2e0b6690028db2397bee5d50aaaea0e3993f7a
author Patrick McHardy <kaber@trash.net> Wed, 06 Feb 2008 02:51:14 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 06 Feb 2008 02:51:14 +0100

 net/netfilter/xt_iprange.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 01035fc..97715e3 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -148,7 +148,7 @@ static struct xt_match iprange_mt_reg[] __read_mostly = {
 	{
 		.name      = "iprange",
 		.revision  = 1,
-		.family    = AF_INET6,
+		.family    = AF_INET,
 		.match     = iprange_mt4,
 		.matchsize = sizeof(struct xt_iprange_mtinfo),
 		.me        = THIS_MODULE,
