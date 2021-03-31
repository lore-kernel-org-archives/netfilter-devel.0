Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E16C43460
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8B4660FF1
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbhCaOQJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 10:16:09 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48044 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbhCaOPi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 10:15:38 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1045F63E4A
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 16:15:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] parser_bison: simplify flowtable offload flag parser
Date:   Wed, 31 Mar 2021 16:15:33 +0200
Message-Id: <20210331141533.25158-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210331141533.25158-1-pablo@netfilter.org>
References: <20210331141533.25158-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Remove ft_flags_spec rule.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index abe117814db0..cc477e65672a 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1996,7 +1996,6 @@ flowtable_block_alloc	:	/* empty */
 flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			|	flowtable_block	common_block
 			|	flowtable_block	stmt_separator
-			|	flowtable_block	ft_flags_spec	stmt_separator
 			|	flowtable_block	HOOK		STRING	prio_spec	stmt_separator
 			{
 				$$->hook.loc = @3;
@@ -2019,6 +2018,10 @@ flowtable_block		:	/* empty */	{ $$ = $<flowtable>-1; }
 			{
 				$$->flags |= NFT_FLOWTABLE_COUNTER;
 			}
+			|	flowtable_block	FLAGS	OFFLOAD	stmt_separator
+			{
+				$$->flags |= FLOWTABLE_F_HW_OFFLOAD;
+			}
 			;
 
 flowtable_expr		:	'{'	flowtable_list_expr	'}'
@@ -2379,12 +2382,6 @@ flags_spec		:	FLAGS		OFFLOAD
 			}
 			;
 
-ft_flags_spec		:	FLAGS		OFFLOAD
-			{
-				$<flowtable>0->flags |= FLOWTABLE_F_HW_OFFLOAD;
-			}
-			;
-
 policy_spec		:	POLICY		policy_expr
 			{
 				if ($<chain>0->policy) {
-- 
2.20.1

