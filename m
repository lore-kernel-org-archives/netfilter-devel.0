Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F4B1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240975AbhKXR2X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbhKXR2X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:23 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615EC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:25:13 -0800 (PST)
Received: from localhost ([::1]:44960 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw19-0001EE-Po; Wed, 24 Nov 2021 18:25:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 03/15] mnl: Fix for missing info in rule dumps
Date:   Wed, 24 Nov 2021 18:22:39 +0100
Message-Id: <20211124172251.11539-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 0e52cab1e64ab improved error reporting by adding rule's table and
chain names to netlink message directly, prefixed by their location
info. This in turn caused netlink dumps of the rule to not contain table
and chain name anymore. Fix this by inserting the missing info before
dumping and remove it afterwards to not cause duplicated entries in
netlink message.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_linearize.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 111102fd43346..34a6e1a941b56 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1673,5 +1673,16 @@ void netlink_linearize_rule(struct netlink_ctx *ctx,
 		nftnl_udata_buf_free(udata);
 	}
 
-	netlink_dump_rule(lctx->nlr, ctx);
+	if (ctx->nft->debug_mask & NFT_DEBUG_NETLINK) {
+		nftnl_rule_set_str(lctx->nlr, NFTNL_RULE_TABLE,
+				   rule->handle.table.name);
+		if (rule->handle.chain.name)
+			nftnl_rule_set_str(lctx->nlr, NFTNL_RULE_CHAIN,
+					   rule->handle.chain.name);
+
+		netlink_dump_rule(lctx->nlr, ctx);
+
+		nftnl_rule_unset(lctx->nlr, NFTNL_RULE_CHAIN);
+		nftnl_rule_unset(lctx->nlr, NFTNL_RULE_TABLE);
+	}
 }
-- 
2.33.0

