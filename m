Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14354C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 19:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiLGTao (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 14:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLGTan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 14:30:43 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B09A10FD5
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 11:30:42 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] scanner: handle files with CRLF line terminators
Date:   Wed,  7 Dec 2022 20:30:38 +0100
Message-Id: <20221207193038.94095-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend scanner.l to deal with CRLF, otherwise -f fails to load:

 # file test.nft
 test.nft: ASCII text, with CRLF, LF line terminators
 # nft -f test.nft
 test.nft:1:13-13: Error: syntax error, unexpected junk
 table ip x {
             ^

Add test to cover this usecase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l                      |  4 +++-
 tests/shell/testcases/nft-f/crlf_0 | 17 +++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/nft-f/crlf_0

diff --git a/src/scanner.l b/src/scanner.l
index e72a427aab48..358fba495759 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -113,7 +113,9 @@ extern void	yyset_column(int, yyscan_t);
 
 space		[ ]
 tab		\t
-newline		\n
+newline_lf	\n
+newline_crlf	\r\n
+newline		({newline_lf}|{newline_crlf})
 digit		[0-9]
 hexdigit	[0-9a-fA-F]
 decstring	{digit}+
diff --git a/tests/shell/testcases/nft-f/crlf_0 b/tests/shell/testcases/nft-f/crlf_0
new file mode 100755
index 000000000000..7ba785c8656a
--- /dev/null
+++ b/tests/shell/testcases/nft-f/crlf_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip foo {\r\n\tchain ber {\r\n\t}\r\n}"
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo -e "$RULESET" > $tmpfile
+
+$NFT -f "$tmpfile"
-- 
2.30.2

