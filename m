From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/3] netfilter: ipset: Fix hash:* type expiration
Date: Sat,  7 Nov 2015 13:42:24 +0100
Message-ID: <1446900145-14190-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:35839 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbbKGMkt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 07:40:49 -0500
In-Reply-To: <1446900145-14190-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Incorrect index was used when the data blob was shrinked at expiration,
which could lead to falsely expired entries and memory leak when
the comment extension was used too.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 4ff2219..fa4f637 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -523,7 +523,7 @@ mtype_expire(struct ip_set *set, struct htype *h, u8 nets_length, size_t dsize)
 					continue;
 				data = ahash_data(n, j, dsize);
 				memcpy(tmp->value + d * dsize, data, dsize);
-				set_bit(j, tmp->used);
+				set_bit(d, tmp->used);
 				d++;
 			}
 			tmp->pos = d;
-- 
1.8.5.1

