From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/2] netfilter: ipset: fix netiface set name overflow
Date: Thu, 22 Nov 2012 12:32:45 +0100
Message-ID: <1353583966-12402-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37262 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151Ab2KVTfl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:35:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

attribute is copied to IFNAMSIZ-size stack variable,
but IFNAMSIZ is smaller than IPSET_MAXNAMELEN.

Fortunately nfnetlink needs CAP_NET_ADMIN.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_hash_netiface.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index b9a6338..45a1014 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -793,7 +793,7 @@ static struct ip_set_type hash_netiface_type __read_mostly = {
 		[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 		[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 		[IPSET_ATTR_IFACE]	= { .type = NLA_NUL_STRING,
-					    .len = IPSET_MAXNAMELEN - 1 },
+					    .len  = IFNAMSIZ - 1 },
 		[IPSET_ATTR_CADT_FLAGS]	= { .type = NLA_U32 },
 		[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
 		[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
-- 
1.7.8.6

