Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FA4C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 May 2022 10:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350925AbiE0KZS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 May 2022 06:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiE0KZS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 May 2022 06:25:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE78461295
        for <netfilter-devel@vger.kernel.org>; Fri, 27 May 2022 03:25:16 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sbrivio@redhat.com, fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
Date:   Fri, 27 May 2022 12:25:10 +0200
Message-Id: <20220527102510.333650-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add several sanity checks for nft_set_desc_concat_parse():

- validate desc->field_count not larger than desc->field_len array.
- field length cannot be larger than desc->field_len (ie. U8_MAX)
- total length of the concatenation cannot be larger than register array.

Joint work with Florian Westphal.

Fixes: f3a2181e16f1 ("netfilter: nf_tables: Support for sets with multiple ranged fields")
Reported-by: <zhangziming.zzm@antgroup.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f4f1d0a2da43..0c7a755dfabb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4243,8 +4243,11 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 				     struct nft_set_desc *desc)
 {
 	struct nlattr *tb[NFTA_SET_FIELD_MAX + 1];
-	u32 len;
-	int err;
+	u32 len, total = 0;
+	int err, i;
+
+	if (desc->field_count >= ARRAY_SIZE(desc->field_len))
+		return -E2BIG;
 
 	err = nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
 					  nft_concat_policy, NULL);
@@ -4255,12 +4258,17 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 		return -EINVAL;
 
 	len = ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
-
-	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
+	if (len > U8_MAX)
 		return -E2BIG;
 
 	desc->field_len[desc->field_count++] = len;
 
+	for (i = 0; i < desc->field_count; i++)
+		total += desc->field_len[i];
+
+	if (total > U8_MAX || total * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.30.2

