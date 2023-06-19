Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA94EB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 20:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjFSUn3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjFSUn0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 16:43:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2038A128
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 13:43:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qBLid-0003rC-O9; Mon, 19 Jun 2023 22:43:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/6] parser: don't assert on scope underflows
Date:   Mon, 19 Jun 2023 22:43:03 +0200
Message-Id: <20230619204306.11785-4-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230619204306.11785-1-fw@strlen.de>
References: <20230619204306.11785-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

close_scope() gets called from the object destructors;
imbalance can cause us to hit assert().

Before:
nft: parser_bison.y:88: close_scope: Assertion `state->scope > 0' failed.
After:
assertion3:4:7-7: Error: too many levels of nesting jump {
assertion3:5:8-8: Error: too many levels of nesting jump
assertion3:5:9-9: Error: syntax error, unexpected newline, expecting '{'
assertion3:7:1-1: Error: syntax error, unexpected end of file

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                                        | 3 +--
 tests/shell/testcases/bogons/nft-f/scope_underflow_assert | 6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/scope_underflow_assert

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 763c1b2dcd61..f5f6bf04d064 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -80,12 +80,11 @@ static int open_scope(struct parser_state *state, struct scope *scope)
 
 static void close_scope(struct parser_state *state)
 {
-	if (state->scope_err) {
+	if (state->scope_err || state->scope == 0) {
 		state->scope_err = false;
 		return;
 	}
 
-	assert(state->scope > 0);
 	state->scope--;
 }
 
diff --git a/tests/shell/testcases/bogons/nft-f/scope_underflow_assert b/tests/shell/testcases/bogons/nft-f/scope_underflow_assert
new file mode 100644
index 000000000000..aee1dcbf9d8a
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/scope_underflow_assert
@@ -0,0 +1,6 @@
+table t {
+	chain c {
+		jump{
+			jump {
+				jump
+
-- 
2.39.3

