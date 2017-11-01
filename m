From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nft_set_hash: disable fast_ops for 2-len keys
Date: Wed,  1 Nov 2017 19:48:11 +0100
Message-ID: <20171101184812.4813-2-pablo@netfilter.org>
References: <20171101184812.4813-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171101184812.4813-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Anatole Denis <anatole@rezel.net>

jhash_1word of a u16 is a different value from jhash of the same u16 with
length 2.
Since elements are always inserted in sets using jhash over the actual
klen, this would lead to incorrect lookups on fixed-size sets with a key
length of 2, as they would be inserted with hash value jhash(key, 2) and
looked up with hash value jhash_1word(key), which is different.

Example reproducer(v4.13+), using anonymous sets which always have a
fixed size:

  table inet t {
      chain c {
                  type filter hook output priority 0; policy accept;
                  tcp dport { 10001, 10003, 10005, 10007, 10009 } counter packets 4 bytes 240 reject
                  tcp dport 10001 counter packets 4 bytes 240 reject
                  tcp dport 10003 counter packets 4 bytes 240 reject
                  tcp dport 10005 counter packets 4 bytes 240 reject
                  tcp dport 10007 counter packets 0 bytes 0 reject
                  tcp dport 10009 counter packets 4 bytes 240 reject
          }
  }

then use nc -z localhost <port> to probe; incorrectly hashed ports will
pass through the set lookup and increment the counter of an individual
rule.

jhash being seeded with a random value, it is not deterministic which
ports will incorrectly hash, but in testing with 5 ports in the set I
always had 4 or 5 with an incorrect hash value.

Signed-off-by: Anatole Denis <anatole@rezel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_hash.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 0fa01d772c5e..9c0d5a7ce5f9 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -643,7 +643,6 @@ nft_hash_select_ops(const struct nft_ctx *ctx, const struct nft_set_desc *desc,
 {
 	if (desc->size) {
 		switch (desc->klen) {
-		case 2:
 		case 4:
 			return &nft_hash_fast_ops;
 		default:
-- 
2.11.0
