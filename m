From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 2/3] netfilter: connlimit: make same_source_net signed
Date: Wed, 12 Mar 2014 23:49:50 +0100
Message-ID: <1394664591-21843-3-git-send-email-fw@strlen.de>
References: <1394664591-21843-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38337 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbaCLWyY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:54:24 -0400
In-Reply-To: <1394664591-21843-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

currently returns 1 if they're the same.  Make it work like mem/strcmp
so it can be used as rbtree search function.

Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 no changes since v1.

 net/netfilter/xt_connlimit.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index ad290cc..dc5207f 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -78,13 +78,14 @@ static inline bool already_closed(const struct nf_conn *conn)
 		return 0;
 }
 
-static inline unsigned int
+static int
 same_source_net(const union nf_inet_addr *addr,
 		const union nf_inet_addr *mask,
 		const union nf_inet_addr *u3, u_int8_t family)
 {
 	if (family == NFPROTO_IPV4) {
-		return (addr->ip & mask->ip) == (u3->ip & mask->ip);
+		return ntohl(addr->ip & mask->ip) -
+		       ntohl(u3->ip & mask->ip);
 	} else {
 		union nf_inet_addr lh, rh;
 		unsigned int i;
@@ -94,7 +95,7 @@ same_source_net(const union nf_inet_addr *addr,
 			rh.ip6[i] = u3->ip6[i] & mask->ip6[i];
 		}
 
-		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6)) == 0;
+		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6));
 	}
 }
 
@@ -143,7 +144,7 @@ static int count_hlist(struct net *net,
 			continue;
 		}
 
-		if (same_source_net(addr, mask, &conn->addr, family))
+		if (same_source_net(addr, mask, &conn->addr, family) == 0)
 			/* same source network -> be counted! */
 			++matches;
 		nf_ct_put(found_ct);
-- 
1.8.1.5

