Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A83C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Dec 2022 22:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiLJW76 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Dec 2022 17:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLJW76 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Dec 2022 17:59:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E772F101FF
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Dec 2022 14:59:56 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] scanner: match full comment line in case of tie
Date:   Sat, 10 Dec 2022 23:59:51 +0100
Message-Id: <20221210225951.1311917-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  add element ip filter public_services {
          # comment 1
          tcp . 80  : jump log_accept,
  # comment 2
          tcp . 443 : jump log_accept,
  }

still fails with the error message:

  # nft -f filter_sets.ip
  In file included from filter_sets.ip:63:1-42:
  filter_sets.ip:4:12-12: Error: syntax error,
  unexpected newline, expecting comma or '}'
  # comment 2
             ^

flex honors the first rule found in case of tie, place comment_line
before comment rule.

Fixes: 931737a17198 ("scanner: munch full comment lines")
Reported-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/scanner.l                             | 2 +-
 tests/shell/testcases/comments/comments_0 | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/scanner.l b/src/scanner.l
index e72a427aab48..7e8748f51c27 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -858,10 +858,10 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 
 {tab}+
 {space}+
-{comment}
 {comment_line}		{
 				reset_pos(yyget_extra(yyscanner), yylloc);
 			}
+{comment}
 
 <<EOF>> 		{
 				update_pos(yyget_extra(yyscanner), yylloc, 1);
diff --git a/tests/shell/testcases/comments/comments_0 b/tests/shell/testcases/comments/comments_0
index b272ad675763..9975f546a6a7 100755
--- a/tests/shell/testcases/comments/comments_0
+++ b/tests/shell/testcases/comments/comments_0
@@ -10,6 +10,7 @@ RULESET="table inet x {		# comment
                         2.2.2.2, # comment
                         # more comments
                         3.3.3.3,	# comment
+# comment
                 }
 		# comment
         }
-- 
2.30.2

