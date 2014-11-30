From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 05/14] netfilter: ipset: Allocate the proper size of memory when /0 networks are supported
Date: Sun, 30 Nov 2014 19:56:56 +0100
Message-ID: <1417373825-3734-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57591 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaK3S4O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 13:56:14 -0500
In-Reply-To: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
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

