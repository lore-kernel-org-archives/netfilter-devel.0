Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D69AC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Nov 2022 12:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiKBMqo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 08:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiKBMqm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 08:46:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6055829809
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 05:46:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oqD8f-0003Sw-U5; Wed, 02 Nov 2022 13:46:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2] netfilter: conntrack: use siphash_4u64
Date:   Wed,  2 Nov 2022 13:46:33 +0100
Message-Id: <20221102124633.14863-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function is used for every packet, siphash_4u64 is noticeably faster
than using local buffer + siphash:

Before:
  1.23%  kpktgend_0       [kernel.vmlinux]     [k] __siphash_unaligned
  0.14%  kpktgend_0       [nf_conntrack]       [k] hash_conntrack_raw
After:
  0.79%  kpktgend_0       [kernel.vmlinux]     [k] siphash_4u64
  0.15%  kpktgend_0       [nf_conntrack]       [k] hash_conntrack_raw

In the pktgen test this gives about ~2.4% performance improvement.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: better ipv4 handling.  In ipv4 case, all[0..3] are 0, so place
 "middle part" of ipv6 addresses in c, d and mix in zoneid/hash etc.

 net/netfilter/nf_conntrack_core.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f97bda06d2a9..d633ef028a3d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -211,28 +211,22 @@ static u32 hash_conntrack_raw(const struct nf_conntrack_tuple *tuple,
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
+	/* The direction must be ignored, handle usable tuplehash members manually */
+	a = (u64)tuple->src.u3.all[0] << 32 | tuple->src.u3.all[3];
+	b = (u64)tuple->dst.u3.all[0] << 32 | tuple->dst.u3.all[3];
 
-	/* The direction must be ignored, so handle usable members manually. */
-	combined.src = tuple->src;
-	combined.dst_addr = tuple->dst.u3;
-	combined.zone = zoneid;
-	combined.net_mix = net_hash_mix(net);
-	combined.dport = (__force __u16)tuple->dst.u.all;
-	combined.proto = tuple->dst.protonum;
+	c = (u64)tuple->src.u.all << 32 | tuple->dst.u.all << 16 | tuple->dst.protonum;
+	d = (u64)zoneid << 32 | net_hash_mix(net);
 
-	return (u32)siphash(&combined, sizeof(combined), &nf_conntrack_hash_rnd);
+	/* IPv4: u3.all[1,2,3] == 0 */
+	c ^= (u64)tuple->src.u3.all[1] << 32 | tuple->src.u3.all[2];
+	d += (u64)tuple->dst.u3.all[1] << 32 | tuple->dst.u3.all[2];
+
+	return (u32)siphash_4u64(a, b, c, d, &nf_conntrack_hash_rnd);
 }
 
 static u32 scale_hash(u32 hash)
-- 
2.37.4

