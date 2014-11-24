From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 05/10] netfilter: ipset: Allocate the proper size of memory when /0 networks are supported
Date: Mon, 24 Nov 2014 21:46:47 +0100
Message-ID: <1416862012-31139-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51378 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaKXUqA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:46:00 -0500
In-Reply-To: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8ef9135..974ff38 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1101,8 +1101,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 	hsize = sizeof(*h);
 #ifdef IP_SET_HASH_WITH_NETS
-	hsize += sizeof(struct net_prefixes) *
-		(set->family == NFPROTO_IPV4 ? 32 : 128);
+	hsize += sizeof(struct net_prefixes) * NLEN(set->family);
 #endif
 	h = kzalloc(hsize, GFP_KERNEL);
 	if (!h)
-- 
1.8.5.1

