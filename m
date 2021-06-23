Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD085C4743C
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 11:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 881A56102A
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 11:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFWLPK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:15:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60454 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhFWLPK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 07:15:10 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 66C3F6423C
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2021 13:11:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] parser_bison: string memleak when datatype is incorrect
Date:   Wed, 23 Jun 2021 13:12:49 +0200
Message-Id: <20210623111249.30742-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
 src/parser_bison.y | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index c31cc4e7ea8f..2f895bfb35af 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2162,6 +2162,7 @@ data_type_atom_expr	:	type_identifier
 				if (dtype == NULL) {
 					erec_queue(error(&@1, "unknown datatype %s", $1),
 						   state->msgs);
+					xfree($1);
 					YYERROR;
 				}
 				$$ = constant_expr_alloc(&@1, dtype, dtype->byteorder,
-- 
2.20.1

