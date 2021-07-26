Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0C80C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 10:01:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A91CC60524
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jul 2021 10:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhGZJVY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:21:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60568 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232617AbhGZJVX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 05:21:23 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3387860702
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jul 2021 12:01:22 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: stateful statement support in map
Date:   Mon, 26 Jul 2021 12:01:44 +0200
Message-Id: <20210726100144.11907-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing parser extension to support for stateful statements in map.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5545a43d160e..b9b3d026a4ee 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2052,6 +2052,12 @@ map_block		:	/* empty */	{ $$ = $<set>-1; }
 				$1->flags |= $3;
 				$$ = $1;
 			}
+			|	map_block	stateful_stmt_list		stmt_separator
+			{
+				list_splice_tail($2, &$1->stmt_list);
+				$$ = $1;
+				free($2);
+			}
 			|	map_block	ELEMENTS	'='		set_block_expr
 			{
 				$1->init = $4;
-- 
2.20.1

