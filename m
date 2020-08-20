Return-Path: <SRS0=xTVu=B6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE94C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 17:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B878207DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Aug 2020 17:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgHTRmz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728379AbgHTRmn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Aug 2020 13:42:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00688C061386
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2020 10:42:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k8oaH-0003sO-IW; Thu, 20 Aug 2020 19:42:41 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: fix destination register zeroing
Date:   Thu, 20 Aug 2020 19:42:36 +0200
Message-Id: <20200820174236.10591-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Following bug was reported via irc:
nft list ruleset
   set knock_candidates_ipv4 {
      type ipv4_addr . inet_service
      size 65535
      elements = { 23.94.139.105 . 123,
                   23.94.139.105 . 123 }
      }
 ..
   udp dport 123 add @knock_candidates_ipv4 { ip saddr . 123 }
   udp dport 123 add @knock_candidates_ipv4 { ip saddr . udp dport }

so for some reason a duplicate entry was created, which should
be impossible.

After some debugging it turned out that the problem is the
immediate value (123) in the second-to-last rule.

Concatenations use 32bit registers, i.e. the elements are 8 bytes
each, not 6 and it turns out the kernel inserted

element 698b5e17 ffff7b00  : 0 [end]
element 698b5e17 00007b00  : 0 [end]

Note the non-zero upper bits of the first element.

It turns out that nft_immediate doesn't zero out the
destination register, but this is needed when the length isn't a
multiple of 4.

Furthermore, the zeroing in nft_payload is also broken.
We can't use [len / 4] = 0 -- if len is a multiple of 4, this results in
a buffer-off-by-one.

We can elide the zeroing in this case, so use a conditional instead of
using [(len -1) / 4].

Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_payload.c       | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index bf9491b77d16..224d194ad29d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -143,6 +143,8 @@ static inline u64 nft_reg_load64(const u32 *sreg)
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
 				 unsigned int len)
 {
+	if (len % NFT_REG32_SIZE)
+		dst[len / NFT_REG32_SIZE] = 0;
 	memcpy(dst, src, len);
 }
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index ed7cb9f747f6..7a2e59638499 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -87,7 +87,9 @@ void nft_payload_eval(const struct nft_expr *expr,
 	u32 *dest = &regs->data[priv->dreg];
 	int offset;
 
-	dest[priv->len / NFT_REG32_SIZE] = 0;
+	if (priv->len % NFT_REG32_SIZE)
+		dest[priv->len / NFT_REG32_SIZE] = 0;
+
 	switch (priv->base) {
 	case NFT_PAYLOAD_LL_HEADER:
 		if (!skb_mac_header_was_set(skb))
-- 
2.26.2

