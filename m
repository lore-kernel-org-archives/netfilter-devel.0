Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD359C001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 23:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbjGEXET (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 19:04:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjGEXES (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 19:04:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AF1910D5;
        Wed,  5 Jul 2023 16:04:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/6] netfilter: conntrack: don't fold port numbers into addresses before hashing
Date:   Thu,  6 Jul 2023 01:04:04 +0200
Message-Id: <20230705230406.52201-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230705230406.52201-1-pablo@netfilter.org>
References: <20230705230406.52201-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Originally this used jhash2() over tuple and folded the zone id,
the pernet hash value, destination port and l4 protocol number into the
32bit seed value.

When the switch to siphash was done, I used an on-stack temporary
buffer to build a suitable key to be hashed via siphash().

But this showed up as performance regression, so I got rid of
the temporary copy and collected to-be-hashed data in 4 u64 variables.

This makes it easy to build tuples that produce the same hash, which isn't
desirable even though chain lengths are limited.

Switch back to plain siphash, but just like with jhash2(), take advantage
of the fact that most of to-be-hashed data is already in a suitable order.

Use an empty struct as annotation in 'struct nf_conntrack_tuple' to mark
last member that can be used as hash input.

The only remaining data that isn't present in the tuple structure are the
zone identifier and the pernet hash: fold those into the key.

Fixes: d2c806abcf0b ("netfilter: conntrack: use siphash_4u64")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_tuple.h |  3 +++
 net/netfilter/nf_conntrack_core.c          | 20 +++++++-------------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 9334371c94e2..f7dd950ff250 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -67,6 +67,9 @@ struct nf_conntrack_tuple {
 		/* The protocol. */
 		u_int8_t protonum;
 
+		/* The direction must be ignored for the tuplehash */
+		struct { } __nfct_hash_offsetend;
+
 		/* The direction (for tuplehash) */
 		u_int8_t dir;
 	} dst;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d119f1d4c2fc..992393102d5f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -211,24 +211,18 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 			      unsigned int zoneid,
 			      const struct net *net)
 {
-	u64 a, b, c, d;
+	siphash_key_t key;
 
 	get_random_once(&nf_conntrack_hash_rnd, sizeof(nf_conntrack_hash_rnd));
 
-	/* The direction must be ignored, handle usable tuplehash members manually */
-	a = (u64)tuple->src.u3.all[0] << 32 | tuple->src.u3.all[3];
-	b = (u64)tuple->dst.u3.all[0] << 32 | tuple->dst.u3.all[3];
+	key = nf_conntrack_hash_rnd;
 
-	c = (__force u64)tuple->src.u.all << 32 | (__force u64)tuple->dst.u.all << 16;
-	c |= tuple->dst.protonum;
+	key.key[0] ^= zoneid;
+	key.key[1] ^= net_hash_mix(net);
 
-	d = (u64)zoneid << 32 | net_hash_mix(net);
-
-	/* IPv4: u3.all[1,2,3] == 0 */
-	c ^= (u64)tuple->src.u3.all[1] << 32 | tuple->src.u3.all[2];
-	d += (u64)tuple->dst.u3.all[1] << 32 | tuple->dst.u3.all[2];
-
-	return (u32)siphash_4u64(a, b, c, d, &nf_conntrack_hash_rnd);
+	return siphash((void *)tuple,
+			offsetofend(struct nf_conntrack_tuple, dst.__nfct_hash_offsetend),
+			&key);
 }
 
 static u32 scale_hash(u32 hash)
-- 
2.30.2

