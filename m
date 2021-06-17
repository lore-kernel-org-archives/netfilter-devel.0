Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376E4C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 15:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F603613F0
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 15:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhFQPnV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:43:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48454 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbhFQPnV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 11:43:21 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CE0AE6424D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jun 2021 17:39:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: memleak in osf flags
Date:   Thu, 17 Jun 2021 17:41:09 +0200
Message-Id: <20210617154109.1722-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release osf string flag after processing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index bd2232a3de27..5e702a054f44 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -4032,8 +4032,10 @@ osf_ttl			:	/* empty */
 				else {
 					erec_queue(error(&@2, "invalid ttl option"),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
+				xfree($2);
 			}
 			;
 
-- 
2.20.1

