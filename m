Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B26C4708D
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 01:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiLHBl5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 20:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiLHBl4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 20:41:56 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2DC4E90754
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 17:41:55 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] scanner: handle files with CRLF line terminators
Date:   Thu,  8 Dec 2022 02:41:51 +0100
Message-Id: <20221208014151.529052-1-pablo@netfilter.org>
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

Update full comment line to take CRLF too.

Add test to cover this usecase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Update comment_line to accept CRLF.

 src/scanner.l                      |  6 ++++--
 tests/shell/testcases/nft-f/crlf_0 | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/nft-f/crlf_0

diff --git a/src/scanner.l b/src/scanner.l
index e72a427aab48..254a23fb4068 100644
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
@@ -124,7 +126,7 @@ string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
 asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\\\*{string})
 comment		#.*$
-comment_line	^[ \t]*#.*\n
+comment_line	^[ \t]*#.*(\r\n|\n)
 slash		\/
 
 timestring	([0-9]+d)?([0-9]+h)?([0-9]+m)?([0-9]+s)?([0-9]+ms)?
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

