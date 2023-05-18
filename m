Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 161A9C7EE22
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjERJq7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjERJq6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:46:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C10710DC
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:46:57 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pzaDk-0005bn-U7; Thu, 18 May 2023 11:46:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@breakpoint.cc
Cc:     Jakub Kicinski <kuba@kernel.org>, eric@breakpoint.cc,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 2/9] netfilter: nf_tables: always increment set element count
Date:   Thu, 18 May 2023 11:46:35 +0200
Message-Id: <20230518094642.84097-3-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518094642.84097-1-fw@strlen.de>
References: <20230518094642.84097-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59fb8320ab4d..7a61de80a8d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6541,10 +6541,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (!(flags & NFT_SET_ELEM_CATCHALL) && set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
-		err = -ENFILE;
-		goto err_set_full;
+	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
+		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+
+		if (!atomic_add_unless(&set->nelems, 1, max)) {
+			err = -ENFILE;
+			goto err_set_full;
+		}
 	}
 
 	nft_trans_elem(trans) = elem;
-- 
2.40.1

