Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20879EB64DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 20:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjFSUni (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjFSUnh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 16:43:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692CE72
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 13:43:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qBLil-0003ry-Sm; Mon, 19 Jun 2023 22:43:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 5/6] parser: reject zero-length interface names in flowtables
Date:   Mon, 19 Jun 2023 22:43:05 +0200
Message-Id: <20230619204306.11785-6-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230619204306.11785-1-fw@strlen.de>
References: <20230619204306.11785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previous patch wasn't enough, also disable this for flowtable device lists.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            | 20 +++++++++++--------
 .../zero_length_devicename_flowtable_assert   |  5 +++++
 2 files changed, 17 insertions(+), 8 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index d5a2f85387cb..8a559103250e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2380,17 +2380,21 @@ flowtable_list_expr	:	flowtable_expr_member
 
 flowtable_expr_member	:	QUOTED_STRING
 			{
-				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 strlen($1) * BITS_PER_BYTE, $1);
-				xfree($1);
+				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
+
+				if (!expr)
+					YYERROR;
+
+				$$ = expr;
 			}
 			|	STRING
 			{
-				$$ = constant_expr_alloc(&@$, &string_type,
-							 BYTEORDER_HOST_ENDIAN,
-							 strlen($1) * BITS_PER_BYTE, $1);
-				xfree($1);
+				struct expr *expr = ifname_expr_alloc(&@$, state->msgs, $1);
+
+				if (!expr)
+					YYERROR;
+
+				$$ = expr;
 			}
 			|	variable_expr
 			{
diff --git a/tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert
new file mode 100644
index 000000000000..2c3e6c3ffbd2
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/zero_length_devicename_flowtable_assert
@@ -0,0 +1,5 @@
+table t {
+	flowtable f {
+		devices = { """"lo }
+	}
+}
-- 
2.39.3

