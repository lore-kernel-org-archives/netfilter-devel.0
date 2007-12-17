From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 20/64]: ip6_tables: fix stack leagage
Date: Tue, 18 Dec 2007 00:46:40 +0100 (MET)
Message-ID: <20071217234639.23601.54427.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38940 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159AbXLQXql (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:41 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: fix stack leagage

Fix leakage of local variable on stack. This already got fixed in ip_tables
silently by the compat patches.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1b0a8a3ff781362fdb71d2f5003b74f3c171566e
tree ed4d0be3a25d0b1892519c03fda7128dbff13d38
parent f6ef0d462fc82cabb301c055e35617fbe91e062d
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:54 +0100

 net/ipv6/netfilter/ip6_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 40893fc..fc4c62f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1154,7 +1154,7 @@ static int get_info(void __user *user, int *len, int compat)
 		       sizeof(info.underflow));
 		info.num_entries = private->number;
 		info.size = private->size;
-		memcpy(info.name, name, sizeof(info.name));
+		strcpy(info.name, name);
 
 		if (copy_to_user(user, &info, *len) != 0)
 			ret = -EFAULT;
