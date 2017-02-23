From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/8] Fix bug: sometimes valid entries in hash:* types of sets were evicted
Date: Thu, 23 Feb 2017 12:14:05 +0100
Message-ID: <1487848449-2731-5-git-send-email-pablo@netfilter.org>
References: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Wrong index was used and therefore when shrinking a hash bucket at
deleting an entry, valid entries could be evicted as well.
Thanks to Eric Ewanco for the thorough bugreport.

Fixes netfilter bugzilla #1119

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1b05d4a7d5a1..f236c0bc7b3f 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -897,7 +897,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 					continue;
 				data = ahash_data(n, j, dsize);
 				memcpy(tmp->value + k * dsize, data, dsize);
-				set_bit(j, tmp->used);
+				set_bit(k, tmp->used);
 				k++;
 			}
 			tmp->pos = k;
-- 
2.1.4
