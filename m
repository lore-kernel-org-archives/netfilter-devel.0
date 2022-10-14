Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B92C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Oct 2022 09:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJNJVg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Oct 2022 05:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJNJVf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2022 05:21:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BC11BE1E4
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2022 02:21:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ojGsk-0008TZ-5W; Fri, 14 Oct 2022 11:21:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: use siphash_4u64
Date:   Fri, 14 Oct 2022 11:21:21 +0200
Message-Id: <20221014092121.2994-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function is used for every packet. siphash_4u64 is
about 25% faster compared to buffer+memset+siphash_unaligned as
reported by perf-diff.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f97bda06d2a9..48c0c146cef1 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -211,28 +211,23 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
 			      unsigned int zoneid,
 			      const struct net *net)
 {
-	struct {
-		struct nf_conntrack_man src;
-		union nf_inet_addr dst_addr;
-		unsigned int zone;
-		u32 net_mix;
-		u16 dport;
-		u16 proto;
-	} __aligned(SIPHASH_ALIGNMENT) combined;
+	u64 a, b, c, d;
 
 	get_random_once(&nf_conntrack_hash_rnd, sizeof(nf_conntrack_hash_rnd));
 
-	memset(&combined, 0, sizeof(combined));
-
 	/* The direction must be ignored, so handle usable members manually. */
-	combined.src = tuple->src;
-	combined.dst_addr = tuple->dst.u3;
-	combined.zone = zoneid;
-	combined.net_mix = net_hash_mix(net);
-	combined.dport = (__force __u16)tuple->dst.u.all;
-	combined.proto = tuple->dst.protonum;
-
-	return (u32)siphash(&combined, sizeof(combined), &nf_conntrack_hash_rnd);
+	a = (u64)tuple->src.u3.all[0] << 32 | tuple->src.u3.all[1];
+	b = (u64)tuple->src.u3.all[2] << 32 | tuple->src.u3.all[3];
+
+	c = (u64)tuple->dst.u3.all[0] << 32 | tuple->dst.u3.all[1];
+	d = (u64)tuple->dst.u3.all[1] << 32 | tuple->dst.u3.all[2];
+
+	a ^= (__force __u64)tuple->dst.u.all;
+	b += tuple->dst.protonum;
+	c ^= net_hash_mix(net);
+	d += zoneid;
+
+	return (u32)siphash_4u64(a, b, c, d, &nf_conntrack_hash_rnd);
 }
 
 static u32 scale_hash(u32 hash)
-- 
2.37.3

