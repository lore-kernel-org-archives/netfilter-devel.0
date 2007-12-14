From: Eric Dumazet <dada1@cosmosbay.com>
Subject: [NETFILTER] xt_hashlimit : speedups hash_dst()
Date: Fri, 14 Dec 2007 12:09:31 +0100
Message-ID: <4762646B.30207@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010708070504020308000902"
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010708070504020308000902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

1) Using jhash2() instead of jhash() is a litle bit faster if applicable.

2) Thanks to jhash, hash value uses full 32 bits.
    Instead of returning hash % size (implying a divide)
    we return the high 32 bits of the (hash * size) that will
    give results between [0 and size-1] and same hash distribution.

   On most cpus, a multiply is less expensive than a divide, by an order
   of magnitude.
  
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>



--------------010708070504020308000902
Content-Type: text/plain;
 name="xt_hashlimit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_hashlimit.patch"

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 033d448..7cc04e8 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -105,7 +105,16 @@ static inline bool dst_cmp(const struct dsthash_ent *ent,
 static u_int32_t
 hash_dst(const struct xt_hashlimit_htable *ht, const struct dsthash_dst *dst)
 {
-	return jhash(dst, sizeof(*dst), ht->rnd) % ht->cfg.size;
+	u_int32_t hash = jhash2((const u32 *)dst,
+				sizeof(*dst)/sizeof(u32),
+				ht->rnd);
+	/*
+	 * Instead of returning hash % ht->cfg.size (implying a divide)
+	 * we return the high 32 bits of the (hash * ht->cfg.size) that will
+	 * give results between [0 and cfg.size-1] and same hash distribution,
+	 * but using a multiply, less expensive than a divide
+	 */
+	return ((u64)hash * ht->cfg.size) >> 32;
 }
 
 static struct dsthash_ent *

--------------010708070504020308000902--


