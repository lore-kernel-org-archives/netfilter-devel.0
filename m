Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C03C4332B
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECEDF64FE8
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 01:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240430AbhCDBPY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 20:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454322AbhCDBIf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 20:08:35 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25223C061761
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Mar 2021 17:07:55 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lHcT3-0005NU-Pe; Thu, 04 Mar 2021 02:07:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] parser: compact ct obj list types
Date:   Thu,  4 Mar 2021 02:07:35 +0100
Message-Id: <20210304010735.28683-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210304010735.28683-1-fw@strlen.de>
References: <20210304010735.28683-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new ct_cmd_type and avoid copypaste of the ct cmd_list rules.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c4f3e341333d..bfb181747ca1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -838,7 +838,7 @@ int nft_lex(void *, void *, void *);
 %destructor { expr_free($$); }	exthdr_exists_expr
 %type <val>			exthdr_key
 
-%type <val>			ct_l4protoname ct_obj_type
+%type <val>			ct_l4protoname ct_obj_type ct_cmd_type
 
 %type <list>			timeout_states timeout_state
 %destructor { xfree($$); }	timeout_states timeout_state
@@ -1393,17 +1393,9 @@ list_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_LIST, $2, &$3, &@$, NULL);
 			}
-			|       CT		HELPERS		TABLE   table_spec
+			|       CT		ct_cmd_type 	TABLE   table_spec
 			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CT_HELPERS, &$4, &@$, NULL);
-			}
-			|	CT		TIMEOUT		TABLE		table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CT_TIMEOUT, &$4, &@$, NULL);
-			}
-			|	CT		EXPECTATION		TABLE		table_spec
-			{
-				$$ = cmd_alloc(CMD_LIST, CMD_OBJ_CT_EXPECT, &$4, &@$, NULL);
+				$$ = cmd_alloc(CMD_LIST, $2, &$4, &@$, NULL);
 			}
 			;
 
@@ -4292,6 +4284,11 @@ ct_obj_type		:	HELPER		{ $$ = NFT_OBJECT_CT_HELPER; }
 			|	EXPECTATION	{ $$ = NFT_OBJECT_CT_EXPECT; }
 			;
 
+ct_cmd_type		:	HELPERS		{ $$ = CMD_OBJ_CT_HELPERS; }
+			|	TIMEOUT		{ $$ = CMD_OBJ_CT_TIMEOUT; }
+			|	EXPECTATION	{ $$ = CMD_OBJ_CT_EXPECT; }
+			;
+
 ct_l4protoname		:	TCP	{ $$ = IPPROTO_TCP; }
 			|	UDP	{ $$ = IPPROTO_UDP; }
 			;
-- 
2.26.2

