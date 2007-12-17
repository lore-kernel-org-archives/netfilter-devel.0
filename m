From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 22/64]: ip_tables: remove ipchains compatibility hack
Date: Tue, 18 Dec 2007 00:46:43 +0100 (MET)
Message-ID: <20071217234642.23601.45102.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38946 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbXLQXqo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:44 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: remove ipchains compatibility hack

ipchains support has been removed years ago. kill last remains.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 78451d30484f913d2c570148d8638ee7f17c5446
tree 50647d7d3fa3fedec40ab770ced858b7b764ef99
parent d9026f418b057074d1c9b26df8197b7e5c3f222d
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:02 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:54 +0100

 net/ipv4/netfilter/ip_tables.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 98c65ac..439b292 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1263,10 +1263,6 @@ do_replace(void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (len != sizeof(tmp) + tmp.size)
-		return -ENOPROTOOPT;
-
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
@@ -1794,10 +1790,6 @@ compat_do_replace(void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (len != sizeof(tmp) + tmp.size)
-		return -ENOPROTOOPT;
-
 	/* overflow check */
 	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
