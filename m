Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80138C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Apr 2022 13:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242295AbiDIOBV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Apr 2022 10:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240479AbiDIOBU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Apr 2022 10:01:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1634E0AA
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Apr 2022 06:59:13 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndBcO-0008Ma-Ap; Sat, 09 Apr 2022 15:59:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 8/9] segtree: use correct byte order for 'element get'
Date:   Sat,  9 Apr 2022 15:58:31 +0200
Message-Id: <20220409135832.17401-9-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220409135832.17401-1-fw@strlen.de>
References: <20220409135832.17401-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fails when the argument / set contains strings: we need to use
host byte order if element has string base type.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/segtree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index bed8bbcf0c8e..0135a07492b0 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -720,6 +720,7 @@ static void set_elem_add(const struct set *set, struct expr *init, mpz_t value,
 
 struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 {
+	enum byteorder byteorder = get_key_byteorder(set->key);
 	struct expr *new_init;
 	mpz_t low, high;
 	struct expr *i;
@@ -733,7 +734,7 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 		switch (i->key->etype) {
 		case EXPR_VALUE:
 			set_elem_add(set, new_init, i->key->value,
-				     i->flags, i->byteorder);
+				     i->flags, byteorder);
 			break;
 		case EXPR_CONCAT:
 			compound_expr_add(new_init, expr_clone(i));
-- 
2.35.1

