Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E076BC25B08
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Aug 2022 14:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbiHQOCt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Aug 2022 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239981AbiHQOCI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Aug 2022 10:02:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709C19858F;
        Wed, 17 Aug 2022 07:01:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJc8-0008S7-0A; Wed, 17 Aug 2022 16:01:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 13/17] netfilter: nf_tables: disallow NFT_SET_ELEM_CATCHALL and NFT_SET_ELEM_INTERVAL_END
Date:   Wed, 17 Aug 2022 16:00:11 +0200
Message-Id: <20220817140015.25843-14-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817140015.25843-1-fw@strlen.de>
References: <20220817140015.25843-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

These flags are mutually exclusive, report EINVAL in this case.

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1d14d694f654..b1b12e083abb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5198,6 +5198,9 @@ static int nft_setelem_parse_flags(const struct nft_set *set,
 	if (!(set->flags & NFT_SET_INTERVAL) &&
 	    *flags & NFT_SET_ELEM_INTERVAL_END)
 		return -EINVAL;
+	if ((*flags & (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL)) ==
+	    (NFT_SET_ELEM_INTERVAL_END | NFT_SET_ELEM_CATCHALL))
+		return -EINVAL;
 
 	return 0;
 }
-- 
2.35.1

