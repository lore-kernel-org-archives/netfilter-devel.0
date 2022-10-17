Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1BEC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 17:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJQRxh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 13:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiJQRxb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 13:53:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1E50DF53
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 10:53:29 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements
Date:   Mon, 17 Oct 2022 19:53:26 +0200
Message-Id: <20221017175326.794243-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise EINVAL is bogusly reported to userspace when deleting a set
element. NFTA_SET_ELEM_KEY_END does not need to be set in case of:

- insertion: if not present, start key is used as end key.
- deletion: only start key needs to be specified, end key is ignored.

Hence, relax the sanity check.

Fixes: 88cccd908d51 ("netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: revamp patch description again.

 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 486994d2118e..1e48cd6c67ed 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5902,8 +5902,9 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
 		if (flags & NFT_SET_ELEM_INTERVAL_END)
 			return false;
-		if (!nla[NFTA_SET_ELEM_KEY_END] &&
-		    !(flags & NFT_SET_ELEM_CATCHALL))
+
+		if (nla[NFTA_SET_ELEM_KEY_END] &&
+		    flags & NFT_SET_ELEM_CATCHALL)
 			return false;
 	} else {
 		if (nla[NFTA_SET_ELEM_KEY_END])
-- 
2.30.2

