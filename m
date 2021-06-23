Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF9CC4743C
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 11:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EF4B61076
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 11:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFWLT6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:19:58 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60492 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhFWLTr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 07:19:47 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F2A0C6423C
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2021 13:16:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: string memleak in YYERROR path
Date:   Wed, 23 Jun 2021 13:17:27 +0200
Message-Id: <20210623111727.30952-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release dynamically allocated string by lex from the YYERROR path, e.g.

 # cat test.nft
 table x {
        map test {
                type ipv4_addr . foo . inet_service : ipv4_addr . inet_service
        }
 }

 # nft -f test.nft
test.nft:3:20-22: Error: unknown datatype foo
                type ipv4_addr . foo . inet_service : ipv4_addr . inet_service
                                 ^^^
test.nft:6-9: Error: set definition does not specify key
        map test {
            ^^^^
 ==29692==ERROR: LeakSanitizer: detected memory leaks

 Direct leak of 5 byte(s) in 1 object(s) allocated from:
    #0 0x7f6c869e8810 in strdup (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x3a810)
    #1 0x7f6c8637f63a in xstrdup /home/test/nftables/src/utils.c:85
    #2 0x7f6c8648a4d3 in nft_lex /home/test/nftables/src/scanner.l:740

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Supersedes: https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210623111249.30742-1-pablo@netfilter.org/

 src/parser_bison.y | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c31cc4e7ea8f..e405c80af1ff 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -972,6 +972,7 @@ common_block		:	INCLUDE		QUOTED_STRING	stmt_separator
 				if (symbol_unbind(scope, $2) < 0) {
 					erec_queue(error(&@2, "undefined symbol '%s'", $2),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
 				xfree($2);
@@ -2162,6 +2163,7 @@ data_type_atom_expr	:	type_identifier
 				if (dtype == NULL) {
 					erec_queue(error(&@1, "unknown datatype %s", $1),
 						   state->msgs);
+					xfree($1);
 					YYERROR;
 				}
 				$$ = constant_expr_alloc(&@1, dtype, dtype->byteorder,
@@ -2717,6 +2719,7 @@ comment_spec		:	COMMENT		string
 					erec_queue(error(&@2, "comment too long, %d characters maximum allowed",
 							 NFTNL_UDATA_COMMENT_MAXLEN),
 						   state->msgs);
+					xfree($2);
 					YYERROR;
 				}
 				$$ = $2;
-- 
2.20.1

