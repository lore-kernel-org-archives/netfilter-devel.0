Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC18DC77B7A
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 15:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjEPPQR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 11:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbjEPPQP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 11:16:15 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3911C40E4;
        Tue, 16 May 2023 08:16:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,4.14 5/8] netfilter: nf_tables: stricter validation of element data
Date:   Tue, 16 May 2023 17:16:03 +0200
Message-Id: <20230516151606.4892-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230516151606.4892-1-pablo@netfilter.org>
References: <20230516151606.4892-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 7e6bc1f6cabcd30aba0b11219d8e01b952eacbb6 ]

Make sure element data type and length do not mismatch the one specified
by the set declaration.

Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
Reported-by: Hugues ANGUELKOV <hanguelkov@randorisec.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1cd49af7d375..9caaac459ca9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3959,13 +3959,20 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 				  struct nft_data *data,
 				  struct nlattr *attr)
 {
+	u32 dtype;
 	int err;
 
 	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
 	if (err < 0)
 		return err;
 
-	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+	if (set->dtype == NFT_DATA_VERDICT)
+		dtype = NFT_DATA_VERDICT;
+	else
+		dtype = NFT_DATA_VALUE;
+
+	if (dtype != desc->type ||
+	    set->dlen != desc->len) {
 		nft_data_release(data, desc->type);
 		return -EINVAL;
 	}
-- 
2.30.2

