Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC76AC0015E
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jul 2023 19:08:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjGSTIf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jul 2023 15:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjGSTIf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2023 15:08:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB70199A
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2023 12:08:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qMCXH-0001vh-ER; Wed, 19 Jul 2023 21:08:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Stefano Brivio <sbrivio@redhat.com>,
        lonial con <kongln9170@gmail.com>
Subject: [PATCH nf] netfilter: nft_set_pipapo: fix improper element removal
Date:   Wed, 19 Jul 2023 21:08:21 +0200
Message-ID: <20230719190824.21196-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

end key should be equal to start unless NFT_SET_EXT_KEY_END is present.

Its possible to add elements that only have a start key
("{ 1.0.0.0 . 2.0.0.0 }") without an internval end.

Insertion treats this via:

if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
   end = (const u8 *)nft_set_ext_key_end(ext)->data;
else
   end = start;

but removal side always uses nft_set_ext_key_end().
This is wrong and leads to garbage remaining in the set after removal
next lookup/insert attempt will give:

BUG: KASAN: slab-use-after-free in pipapo_get+0x8eb/0xb90
Read of size 1 at addr ffff888100d50586 by task nft-pipapo_uaf_/1399
Call Trace:
 kasan_report+0x105/0x140
 pipapo_get+0x8eb/0xb90
 nft_pipapo_insert+0x1dc/0x1710
 nf_tables_newsetelem+0x31f5/0x4e00
 ..

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Cc: Stefano Brivio <sbrivio@redhat.com>
Reported-by: lonial con <kongln9170@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index db526cb7a485..49915a2a58eb 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1929,7 +1929,11 @@ static void nft_pipapo_remove(const struct net *net, const struct nft_set *set,
 		int i, start, rules_fx;
 
 		match_start = data;
-		match_end = (const u8 *)nft_set_ext_key_end(&e->ext)->data;
+
+		if (nft_set_ext_exists(&e->ext, NFT_SET_EXT_KEY_END))
+			match_end = (const u8 *)nft_set_ext_key_end(&e->ext)->data;
+		else
+			match_end = data;
 
 		start = first_rule;
 		rules_fx = rules_f0;
-- 
2.41.0

