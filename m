Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A293FC352A1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Dec 2022 22:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLFWx4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Dec 2022 17:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLFWxy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2022 17:53:54 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 359504A069
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2022 14:53:54 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     kadlec@netfilter.org
Subject: [PATCH nft] scanner: munch full comment lines
Date:   Tue,  6 Dec 2022 23:53:02 +0100
Message-Id: <20221206225302.61932-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221206225302.61932-1-pablo@netfilter.org>
References: <20221206225302.61932-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Munch lines full comment lines, regular expression matches lines that
start by space or tab, then # follows, finally anything including one
single line break.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1196
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l                                 |  2 ++
 tests/shell/testcases/comments/comments_0     | 20 +++++++++++++++++++
 .../testcases/comments/dumps/comments_0.nft   |  6 ++++++
 3 files changed, 28 insertions(+)
 create mode 100755 tests/shell/testcases/comments/comments_0
 create mode 100644 tests/shell/testcases/comments/dumps/comments_0.nft

diff --git a/src/scanner.l b/src/scanner.l
index 1371cd044b65..ec9df5c2af9f 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -124,6 +124,7 @@ string		({letter}|[_.])({letter}|{digit}|[/\-_\.])*
 quotedstring	\"[^"]*\"
 asteriskstring	({string}\*|{string}\\\*|\\\*|{string}\\\*{string})
 comment		#.*$
+comment_line	^[ \t]*#.*\n
 slash		\/
 
 timestring	([0-9]+d)?([0-9]+h)?([0-9]+m)?([0-9]+s)?([0-9]+ms)?
@@ -858,6 +859,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 {tab}+
 {space}+
 {comment}
+{comment_line}
 
 <<EOF>> 		{
 				update_pos(yyget_extra(yyscanner), yylloc, 1);
diff --git a/tests/shell/testcases/comments/comments_0 b/tests/shell/testcases/comments/comments_0
new file mode 100755
index 000000000000..843927f18232
--- /dev/null
+++ b/tests/shell/testcases/comments/comments_0
@@ -0,0 +1,20 @@
+#!/bin/bash
+
+RULESET="table ip x {		# comment
+        # comment 1
+	# comment 2
+	set y { # comment here
+		type ipv4_addr	# comment
+		elements = {
+			# 1.1.1.1
+                        2.2.2.2, # comment
+                        # more comments
+                        3.3.3.3,	# comment
+                }
+		# comment
+        }
+}
+"
+
+$NFT -f - <<< "$RULESET"
+
diff --git a/tests/shell/testcases/comments/dumps/comments_0.nft b/tests/shell/testcases/comments/dumps/comments_0.nft
new file mode 100644
index 000000000000..3507e0b1d198
--- /dev/null
+++ b/tests/shell/testcases/comments/dumps/comments_0.nft
@@ -0,0 +1,6 @@
+table ip x {
+	set y {
+		type ipv4_addr
+		elements = { 2.2.2.2, 3.3.3.3 }
+	}
+}
-- 
2.30.2

