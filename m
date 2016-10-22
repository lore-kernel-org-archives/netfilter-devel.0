From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH nft 4/4] netlink: fix linearize numgen type
Date: Sat, 22 Oct 2016 23:36:47 +0200
Message-ID: <901d89195567977f237e66ba75e4c7003e72164e.1477170966.git.nevola@gmail.com>
References: <cover.1477170966.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35583 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755759AbcJVVgv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Oct 2016 17:36:51 -0400
Received: by mail-wm0-f65.google.com with SMTP id o81so3947317wma.2
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Oct 2016 14:36:50 -0700 (PDT)
Received: from sonyv (72.red-88-15-56.dynamicip.rima-tde.net. [88.15.56.72])
        by smtp.gmail.com with ESMTPSA id kg7sm10251552wjb.34.2016.10.22.14.36.49
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 22 Oct 2016 14:36:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1477170966.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid to treat numgen type attribute as a register.

Fixes: 345236211715 ("src: add hash expression")

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 src/netlink_linearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 15a8953..66552ac 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -181,7 +181,7 @@ static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
 
 	nle = alloc_nft_expr("numgen");
 	netlink_put_register(nle, NFTNL_EXPR_NG_DREG, dreg);
-	netlink_put_register(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_TYPE, expr->numgen.type);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_MODULUS, expr->numgen.mod);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_NG_OFFSET, expr->numgen.offset);
 	nftnl_rule_add_expr(ctx->nlr, nle);
-- 
2.9.3

