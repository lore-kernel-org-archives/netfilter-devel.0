From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] src: Initialize struct stmt in _match and _target functions.
Date: Sun, 20 Aug 2017 10:25:12 +0530
Message-ID: <20170820045512.3232-1-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Varsha Rao <rvarsha016@gmail.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33148 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdHTE4w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Aug 2017 00:56:52 -0400
Received: by mail-pg0-f66.google.com with SMTP id n4so4608882pgn.0
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Aug 2017 21:56:52 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Initialize structure stmt with stmt_alloc in netlink_parse_target and
netlink_parse_match functions. This patch fixes the warning:

‘stmt’ may be used uninitialized in this function.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 src/xt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/xt.c b/src/xt.c
index 3bc38ee..9aff414 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -143,6 +143,7 @@ void netlink_parse_match(struct netlink_parse_ctx *ctx,
 	m->u.match_size = mt_len + XT_ALIGN(sizeof(struct xt_entry_match));
 	m->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_MT_REV);
 
+	stmt = stmt_alloc(loc, NULL);
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_MATCH;
 	stmt->xt.match = xt_match_clone(mt);
@@ -179,6 +180,7 @@ void netlink_parse_target(struct netlink_parse_ctx *ctx,
 	t->u.user.revision = nftnl_expr_get_u32(nle, NFTNL_EXPR_TG_REV);
 	strcpy(t->u.user.name, tg->name);
 
+	stmt = stmt_alloc(loc, NULL);
 	stmt->xt.name = strdup(name);
 	stmt->xt.type = NFT_XT_TARGET;
 	stmt->xt.target = xt_target_clone(tg);
-- 
2.13.5

