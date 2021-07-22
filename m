Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38CF2C63793
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 16:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C706052B
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jul 2021 16:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhGVQMn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 12:12:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55422 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235568AbhGVQLj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 12:11:39 -0400
Received: from localhost.localdomain (unknown [78.30.10.20])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9F1026429B
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jul 2021 18:51:46 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] parser_bison: missing initialization of ct timeout policy list
Date:   Thu, 22 Jul 2021 18:52:13 +0200
Message-Id: <20210722165214.1982-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

rule.c:1715:3: runtime error: member access within null pointer of type 'struct timeout_state'
AddressSanitizer:DEADLYSIGNAL
=================================================================
==29500==ERROR: AddressSanitizer: SEGV on unknown address 0x000000000000 (pc 0x7f5bfd43c2a4 bp 0x7ffcb82f13b0 sp 0x7ffcb82f1360 T0)
==29500==The signal is caused by a READ memory access.
==29500==Hint: address points to the zero page.
    #0 0x7f5bfd43c2a3 in obj_free /home/test/nftables/src/rule.c:1715
    #1 0x7f5bfd43875d in cmd_free /home/test/nftables/src/rule.c:1447
    #2 0x7f5bfd58e6f2 in nft_run_cmd_from_filename /home/test/nftables/src/libnftables.c:628
    #3 0x5645c48762b1 in main /home/test/nftables/src/main.c:512
    #4 0x7f5bfc0eb09a in __libc_start_main ../csu/libc-start.c:308
    #5 0x5645c4873459 in _start (/home/test/nftables/src/.libs/nft+0x9459)

AddressSanitizer can not provide additional info.
SUMMARY: AddressSanitizer: SEGV /home/test/nftables/src/rule.c:1715 in obj_free
==29500==ABORTING

Fixes: 7a0e26723496 ("rule: memleak of list of timeout policies")
Signed-off-by: Pablo Neira Ayuso <test@netfilter.org>
---
 src/parser_bison.y | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 790cd832b742..5545a43d160e 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1313,6 +1313,8 @@ delete_cmd		:	TABLE		table_or_id_spec
 			|	CT	ct_obj_type	obj_spec	ct_obj_alloc	close_scope_ct
 			{
 				$$ = cmd_alloc_obj_ct(CMD_DELETE, $2, &$3, &@$, $4);
+				if ($2 == NFT_OBJECT_CT_TIMEOUT)
+					init_list_head(&$4->ct_timeout.timeout_list);
 			}
 			|	LIMIT		obj_or_id_spec	close_scope_limit
 			{
-- 
2.20.1

