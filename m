From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/49]: xt_hashlimit: remove ip6tables module dependency
Date: Tue,  4 Dec 2007 13:02:22 +0100 (MET)
Message-ID: <20071204120222.2442.75048.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62157 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXLDMCX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:23 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_hashlimit: remove ip6tables module dependency

Switch from ipv6_find_hdr to ipv6_skip_exthdr to avoid pulling in ip6_tables
and ipv6 when only using it for IPv4.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a999d6f9c41df6fdf01d58728d13a450b0712afb
tree 1ae8c17820eba48122247d09ae1c38bf6af08d9d
parent 5ccda5a2efbe4c504144db8fae1861a795a39258
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:11 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:28:18 +0100

 net/netfilter/xt_hashlimit.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 8a8b267..033d448 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -21,6 +21,7 @@
 #include <linux/in.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/ipv6.h>
 #include <net/net_namespace.h>
 
 #include <linux/netfilter/x_tables.h>
@@ -379,7 +380,7 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		   const struct sk_buff *skb, unsigned int protoff)
 {
 	__be16 _ports[2], *ports;
-	int nexthdr;
+	u8 nexthdr;
 
 	memset(dst, 0, sizeof(*dst));
 
@@ -407,8 +408,9 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
 			return 0;
-		nexthdr = ipv6_find_hdr(skb, &protoff, -1, NULL);
-		if (nexthdr < 0)
+		nexthdr = ipv6_hdr(skb)->nexthdr;
+		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr);
+		if ((int)protoff < 0)
 			return -1;
 		break;
 #endif
