Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8FAC32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 20:12:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D6192067D
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 20:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHMUMa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 16:12:30 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57624 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbfHMUM3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 16:12:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hxd9g-0004BT-DG; Tue, 13 Aug 2019 22:12:28 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 2/3] src: parser: fix parsing of chain priority and policy on bigendian
Date:   Tue, 13 Aug 2019 22:12:45 +0200
Message-Id: <20190813201246.5543-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813201246.5543-1-fw@strlen.de>
References: <20190813201246.5543-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tests/shell/testcases/flowtable/0001flowtable_0
tests/shell/testcases/nft-f/0008split_tables_0
fail the 'dump compare' on s390x.
The priority (10) turns to 0, and accept turned to drop.

Problem is that '$1' is a 64bit value -- then we pass the address
and import 'int' -- we then get the upper all zero bits.

Add a 32bit interger type and use that.

v2: add uint32_t type to union, v1 used temporary value instead.

Fixes: 627c451b2351 ("src: allow variables in the chain priority specification")
Fixes: dba4a9b4b5fe ("src: allow variable in chain policy")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 939b9a8db6d7..bff5e274c787 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -134,6 +134,7 @@ int nft_lex(void *, void *, void *);
 
 %union {
 	uint64_t		val;
+	uint32_t		val32;
 	const char *		string;
 
 	struct list_head	*list;
@@ -561,7 +562,8 @@ int nft_lex(void *, void *, void *);
 %destructor { handle_free(&$$); } table_spec tableid_spec chain_spec chainid_spec flowtable_spec chain_identifier ruleid_spec handle_spec position_spec rule_position ruleset_spec index_spec
 %type <handle>			set_spec setid_spec set_identifier flowtable_identifier obj_spec objid_spec obj_identifier
 %destructor { handle_free(&$$); } set_spec setid_spec set_identifier obj_spec objid_spec obj_identifier
-%type <val>			family_spec family_spec_explicit chain_policy int_num
+%type <val>			family_spec family_spec_explicit
+%type <val32>			int_num	chain_policy
 %type <prio_spec>		extended_prio_spec prio_spec
 %type <string>			extended_prio_name
 %destructor { xfree($$); }	extended_prio_name
@@ -2025,7 +2027,7 @@ extended_prio_spec	:	int_num
 			}
 			;
 
-int_num		:	NUM			{ $$ = $1; }
+int_num			:	NUM			{ $$ = $1; }
 			|	DASH	NUM		{ $$ = -$2; }
 			;
 
-- 
2.21.0

