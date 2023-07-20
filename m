Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92127EB64DA
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 16:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjGTQv5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 12:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjGTQv4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 12:51:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E413C1715;
        Thu, 20 Jul 2023 09:51:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qMWsZ-0001Lf-Vc; Thu, 20 Jul 2023 18:51:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 1/5] netfilter: nf_tables: fix spurious set element insertion failure
Date:   Thu, 20 Jul 2023 18:51:33 +0200
Message-ID: <20230720165143.30208-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230720165143.30208-1-fw@strlen.de>
References: <20230720165143.30208-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On some platforms there is a padding hole in the nft_verdict
structure, between the verdict code and the chain pointer.

On element insertion, if the new element clashes with an existing one and
NLM_F_EXCL flag isn't set, we want to ignore the -EEXIST error as long as
the data associated with duplicated element is the same as the existing
one.  The data equality check uses memcmp.

For normal data (NFT_DATA_VALUE) this works fine, but for NFT_DATA_VERDICT
padding area leads to spurious failure even if the verdict data is the
same.

This then makes the insertion fail with 'already exists' error, even
though the new "key : data" matches an existing entry and userspace
told the kernel that it doesn't want to receive an error indication.

Fixes: c016c7e45ddf ("netfilter: nf_tables: honor NLM_F_EXCL flag in set element insertion")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 237f739da3ca..79c7eee33dcd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10517,6 +10517,9 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 
 	if (!tb[NFTA_VERDICT_CODE])
 		return -EINVAL;
+
+	/* zero padding hole for memcmp */
+	memset(data, 0, sizeof(*data));
 	data->verdict.code = ntohl(nla_get_be32(tb[NFTA_VERDICT_CODE]));
 
 	switch (data->verdict.code) {
-- 
2.41.0

