Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EEB5C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 10:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbiKNKlV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 05:41:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbiKNKlS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 05:41:18 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 156381D306;
        Mon, 14 Nov 2022 02:41:16 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 6/6] netfilter: conntrack: use siphash_4u64
Date:   Mon, 14 Nov 2022 11:41:06 +0100
Message-Id: <20221114104106.8719-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221114104106.8719-1-pablo@netfilter.org>
References: <20221114104106.8719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
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
2.30.2

