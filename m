Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986CCC43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 16:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75E2420663
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 16:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfFXQUL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 12:20:11 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51370 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726622AbfFXQUL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 12:20:11 -0400
Received: from localhost ([::1]:36228 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hfRhR-0002pM-Lp; Mon, 24 Jun 2019 18:20:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] parser_bison: Accept arbitrary user-defined names by quoting
Date:   Mon, 24 Jun 2019 18:20:09 +0200
Message-Id: <20190624162009.15148-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Parser already allows to quote user-defined strings in some places to
avoid clashing with defined keywords, but not everywhere. Extend this
support further and add a test case for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Note: This is a reduced variant of "src: Quote user-defined names" sent
      back in January. Discussion was not conclusive regarding whether
      to quote these names on output or not, but I assume allowing for
      users to specify them by adding quotes is a step forward without
      drawbacks.
---
 src/parser_bison.y                            |  3 ++-
 .../shell/testcases/nft-f/0018quoted-names_0  | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/nft-f/0018quoted-names_0

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 670e91f544c75..de8b097a4c222 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1761,7 +1761,7 @@ flowtable_list_expr	:	flowtable_expr_member
 			|	flowtable_list_expr	COMMA	opt_newline
 			;
 
-flowtable_expr_member	:	STRING
+flowtable_expr_member	:	string
 			{
 				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
 						       current_scope(state),
@@ -1968,6 +1968,7 @@ chain_policy		:	ACCEPT		{ $$ = NF_ACCEPT; }
 			;
 
 identifier		:	STRING
+			|	QUOTED_STRING
 			;
 
 string			:	STRING
diff --git a/tests/shell/testcases/nft-f/0018quoted-names_0 b/tests/shell/testcases/nft-f/0018quoted-names_0
new file mode 100755
index 0000000000000..9655a48d492c0
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0018quoted-names_0
@@ -0,0 +1,19 @@
+#!/bin/bash
+
+# Test if keywords are allowed as names if quoted
+
+set -e
+
+# XXX: interface names are arbitrary, too (flowtable, chain)
+RULESET='
+table inet "day" {
+	chain "minute" {}
+	set "hour" { type inet_service; }
+	flowtable "second" { hook ingress priority 0; devices = { lo }; }
+	counter "table" { packets 0 bytes 0 }
+	quota "chain" { 10 bytes }
+}'
+
+$NFT -f - <<< "$RULESET"
+OUTPUT=$($NFT list ruleset)
+$NFT -f - <<< "$OUTPUT"
-- 
2.21.0

