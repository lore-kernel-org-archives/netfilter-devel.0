From: Anatole Denis <anatole@rezel.net>
Subject: [PATCH nf] netfilter: nft_set_hash: disable fast_ops for 2-len keys
Date: Wed,  4 Oct 2017 01:17:14 +0100
Message-ID: <20171004001714.12778-1-anatole@rezel.net>
Cc: Anatole Denis <anatole@rezel.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from inara.rezel.net ([212.129.30.46]:56088 "EHLO inara.rezel.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdJDARg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2017 20:17:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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

---

Another possibility would be to create a separate nft_hash_insert_fast
which uses the same jhash_1word optimization for inserting when using
2-length keys, but this is the simplest fix which basically reverts to
the behavior of 4.12

I also verified that jhash_1word and jhash(.., 4) correctly have the
same value, so this can be left enabled for 4-length keys.

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
2.14.2

