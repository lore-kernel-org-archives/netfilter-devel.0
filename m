Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA66C0032E
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 14:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344848AbjJYOMk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 10:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344842AbjJYOMj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 10:12:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4104D18B
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 07:12:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: reject set in concatenation
Date:   Wed, 25 Oct 2023 16:12:10 +0200
Message-Id: <20231025141210.124123-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Consider the following ruleset.

 define ext_if = { "eth0", "eth1" }
 table ip filter {
    chain c {
        iifname . tcp dport { $ext_if . 22 } accept
    }
 }

Attempting to load this ruleset results in:

BUG: invalid expression type 'set' in setnft: netlink.c:304: __netlink_gen_concat_key: Assertion `0' failed.
Aborted (core dumped)

After this patch:

 # nft -f ruleset.nft
 ruleset.nft:1:17-40: Error: cannot use set in concatenation
 define ext_if = { "eth0", 127.0.0.0/24 }
                 ^^^^^^^^^^^^^^^^^^^^^^^^

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1715
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2196e92813d0..894987df7895 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1511,6 +1511,12 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
 
 		if (list_member_evaluate(ctx, &i) < 0)
 			return -1;
+
+		if (i->etype == EXPR_SET)
+			return expr_error(ctx->msgs, i,
+					  "cannot use %s in concatenation",
+					  expr_name(i));
+
 		flags &= i->flags;
 
 		if (!key && i->dtype->type == TYPE_INTEGER) {
-- 
2.30.2

