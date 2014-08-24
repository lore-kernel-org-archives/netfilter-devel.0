From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/4] netfilter: ipset: Removed invalid IPSET_ATTR_MARKMASK validation
Date: Sun, 24 Aug 2014 19:49:40 +0200
Message-ID: <1408902583-22451-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:52355 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbaHXR4I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:56:08 -0400
In-Reply-To: <1408902583-22451-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Vytas Dauksa <vytas.dauksa@smoothwall.net>

Markmask is an u32, hence it can't be greater then 4294967295 ( i.e.
0xffffffff ). This was causing smatch warning:
 net/netfilter/ipset/ip_set_hash_gen.h:1084 hash_ipmark_create() warn:
 impossible condition '(markmask > 4294967295) => (0-u32max > u32max)'

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 61c7fb0..0398a92 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1093,7 +1093,7 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	if (tb[IPSET_ATTR_MARKMASK]) {
 		markmask = ntohl(nla_get_u32(tb[IPSET_ATTR_MARKMASK]));
 
-		if ((markmask > 4294967295u) || markmask == 0)
+		if (markmask == 0)
 			return -IPSET_ERR_INVALID_MARKMASK;
 	}
 #endif
-- 
1.8.5.1

