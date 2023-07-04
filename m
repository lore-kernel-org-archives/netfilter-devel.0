Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6844EEB64D9
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jul 2023 10:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjGDKZg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jul 2023 06:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjGDKZf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jul 2023 06:25:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D44135
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Jul 2023 03:25:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qGdDw-00061N-1t; Tue, 04 Jul 2023 12:25:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: conntrack: don't fold port numbers into addresses before hashing
Date:   Tue,  4 Jul 2023 12:25:23 +0200
Message-Id: <20230704102523.5795-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
2.39.3

