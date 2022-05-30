Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E880C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 May 2022 08:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiE3IAW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 May 2022 04:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234337AbiE3IAA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 May 2022 04:00:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8979656432
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2022 00:59:59 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sbrivio@redhat.com
Subject: [PATCH nf,v2] netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
Date:   Mon, 30 May 2022 09:59:54 +0200
Message-Id: <20220530075954.21081-1-pablo@netfilter.org>
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
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - use register size per field instead of bytes to calculate concat size
    - consolidate check for too large concatenation in nft_set_desc_concat()

 net/netfilter/nf_tables_api.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f4f1d0a2da43..dcefb5f36b3a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4246,6 +4246,9 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 	u32 len;
 	int err;
 
+	if (desc->field_count >= ARRAY_SIZE(desc->field_len))
+		return -E2BIG;
+
 	err = nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
 					  nft_concat_policy, NULL);
 	if (err < 0)
@@ -4255,9 +4258,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 		return -EINVAL;
 
 	len = ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
-
-	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
-		return -E2BIG;
+	if (!len || len > U8_MAX)
+		return -EINVAL;
 
 	desc->field_len[desc->field_count++] = len;
 
@@ -4268,7 +4270,8 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
 	struct nlattr *attr;
-	int rem, err;
+	u32 num_regs = 0;
+	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
 		if (nla_type(attr) != NFTA_LIST_ELEM)
@@ -4279,6 +4282,12 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 			return err;
 	}
 
+	for (i = 0; i < desc->field_count; i++)
+		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
+
+	if (num_regs > NFT_REG32_COUNT)
+		return -E2BIG;
+
 	return 0;
 }
 
-- 
2.30.2

