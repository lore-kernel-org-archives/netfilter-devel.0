From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 23/64]: ip6_tables: use XT_ALIGN
Date: Tue, 18 Dec 2007 00:46:44 +0100 (MET)
Message-ID: <20071217234644.23601.31435.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38949 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593AbXLQXqp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:46:45 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip6_tables: use XT_ALIGN

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 04ec98b3abcf42330ae733de42af96e97128f083
tree 98332c18f03499782daefb03c578932ef033d4f0
parent 78451d30484f913d2c570148d8638ee7f17c5446
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:04 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:24:54 +0100

 include/linux/netfilter_ipv6/ip6_tables.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index c112482..110801d 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -324,7 +324,7 @@ extern int ip6_masked_addrcmp(const struct in6_addr *addr1,
 			      const struct in6_addr *mask,
 			      const struct in6_addr *addr2);
 
-#define IP6T_ALIGN(s) (((s) + (__alignof__(struct ip6t_entry)-1)) & ~(__alignof__(struct ip6t_entry)-1))
+#define IP6T_ALIGN(s) XT_ALIGN(s)
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
