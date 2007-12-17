From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 27/64]: arp_tables: remove ipchains compat hack
Date: Tue, 18 Dec 2007 00:46:50 +0100 (MET)
Message-ID: <20071217234649.23601.16797.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38961 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759635AbXLQXqv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:51 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: arp_tables: remove ipchains compat hack

Remove compatiblity hack copied from ip_tables.c - ipchains didn't even
support arp_tables :)

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 23afc470858634c807b97379e0a7e8447463be27
tree 75d6b5ae77b5a6be5ee4c9fbd57891521feb5632
parent 5f2cccb0c367783a5207f378237c5e84c1654343
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:09 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:55 +0100

 net/ipv4/netfilter/arp_tables.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index fb4d779..cafb35a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -784,10 +784,6 @@ static int do_replace(void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (len != sizeof(tmp) + tmp.size)
-		return -ENOPROTOOPT;
-
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
