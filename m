From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/10] netfilter: ipset: Fix hash:* type expiration
Date: Wed, 11 Nov 2015 18:33:37 +0100
Message-ID: <1447263223-22662-5-git-send-email-pablo@netfilter.org>
References: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1447263223-22662-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

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
2.1.4
