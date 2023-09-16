Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDFECD37BC
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Sep 2023 14:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232670AbjIPOcr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Sep 2023 10:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbjIPOcX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Sep 2023 10:32:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04577CE7
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Sep 2023 07:32:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: fix memleak in prefix evaluation with wildcard interface name
Date:   Sat, 16 Sep 2023 16:31:53 +0200
Message-Id: <20230916143153.26319-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following ruleset:

  table ip x {
        chain y {
                meta iifname { abcde*, xyz }
        }
  }

triggers the following memleak:

==6871== 16 bytes in 1 blocks are definitely lost in loss record 1 of 1
==6871==    at 0x483877F: malloc (vg_replace_malloc.c:307)
==6871==    by 0x48AD898: xmalloc (utils.c:37)
==6871==    by 0x4BC8B22: __gmpz_init2 (in /usr/lib/x86_64-linux-gnu/libgmp.so.10.4.1)
==6871==    by 0x4887E67: constant_expr_alloc (expression.c:424)
==6871==    by 0x488EF1F: expr_evaluate_prefix (evaluate.c:1138)
==6871==    by 0x488EF1F: expr_evaluate (evaluate.c:2725)
==6871==    by 0x488E76D: expr_evaluate_set_elem (evaluate.c:1662)
==6871==    by 0x488E76D: expr_evaluate (evaluate.c:2739)
==6871==    by 0x4891033: list_member_evaluate (evaluate.c:1454)
==6871==    by 0x488E2B6: expr_evaluate_set (evaluate.c:1757)
==6871==    by 0x488E2B6: expr_evaluate (evaluate.c:2737)
==6871==    by 0x48910D0: elems_evaluate (evaluate.c:4605)
==6871==    by 0x4891432: set_evaluate (evaluate.c:4711)
==6871==    by 0x48915BC: implicit_set_declaration (evaluate.c:122)
==6871==    by 0x488F18A: expr_evaluate_relational (evaluate.c:2503)
==6871==    by 0x488F18A: expr_evaluate (evaluate.c:2745)

expr_evaluate_prefix() calls constant_expr_alloc() which have already
called mpz_init2(), the second call to mpz_init2() overlaps the existing
mpz_t data memory area.

Remove extra mpz_init2() call to fix this memleak.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1b7e0b37b61b..90e7bff62cce 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1142,7 +1142,6 @@ static int expr_evaluate_prefix(struct eval_ctx *ctx, struct expr **expr)
 		mpz_prefixmask(mask->value, base->len, prefix->prefix_len);
 		break;
 	case TYPE_STRING:
-		mpz_init2(mask->value, base->len);
 		mpz_bitmask(mask->value, prefix->prefix_len);
 		break;
 	}
-- 
2.30.2

