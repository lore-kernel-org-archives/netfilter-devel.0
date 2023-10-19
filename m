Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66ACAC41513
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 14:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbjJSOUL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 10:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346021AbjJSOUK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 10:20:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B088134
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 07:20:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC 7/8] netfilter: nf_tables: add timeout extension to elements to prepare for updates
Date:   Thu, 19 Oct 2023 16:19:57 +0200
Message-Id: <20231019141958.653727-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231019141958.653727-1-pablo@netfilter.org>
References: <20231019141958.653727-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Timeout extension is not allocated in case that the default set timeout
value is the same. However, with set element updates, this can be updated
too so, allocate it but do not include it in netlink messages so users
do not observe any change in the existing listings / events.

This updates c3e1b005ed1c ("netfilter: nf_tables: add set element
timeout support").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8c821135a5a0..2a9cd3886612 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5584,6 +5584,7 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+	    *nft_set_ext_timeout(ext) != READ_ONCE(set->timeout) &&
 	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
 			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
 			 NFTA_SET_ELEM_PAD))
@@ -6692,11 +6693,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != READ_ONCE(set->timeout)) {
-			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
-			if (err < 0)
-				goto err_parse_key_end;
-		}
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (num_exprs) {
-- 
2.30.2

