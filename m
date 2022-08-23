Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67A2C32796
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Aug 2022 15:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243561AbiHWPXf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Aug 2022 11:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241168AbiHWPWl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2022 11:22:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D991A112EDF
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2022 03:52:50 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oQRVl-0004XB-4T; Tue, 23 Aug 2022 12:51:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] expr: update EXPR_MAX and add missing comments
Date:   Tue, 23 Aug 2022 12:51:52 +0200
Message-Id: <20220823105152.13672-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

WHen flagcmp and catchall expressions got added the EXPR_MAX definition
wasn't changed.

Should have no impact in practice however, this value is only checked to
prevent crash when old nft release is used to list a ruleset generated
by a newer nft release and a unknown 'typeof' expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/expression.h b/include/expression.h
index cf7319b65e0e..547073836833 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -41,6 +41,10 @@
  * @EXPR_NUMGEN:	number generation expression
  * @EXPR_HASH:		hash expression
  * @EXPR_RT:		routing expression
+ * @EXPR_FIB		forward information base expression
+ * @EXPR_XFRM		XFRM (ipsec) expression
+ * @EXPR_SET_ELEM_CATCHALL catchall element expression
+ * @EXPR_FLAGCMP	flagcmp expression
  */
 enum expr_types {
 	EXPR_INVALID,
@@ -74,7 +78,7 @@ enum expr_types {
 	EXPR_SET_ELEM_CATCHALL,
 	EXPR_FLAGCMP,
 };
-#define EXPR_MAX EXPR_XFRM
+#define EXPR_MAX EXPR_FLAGCMP
 
 enum ops {
 	OP_INVALID,
-- 
2.35.1

