From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/4] netlink_delinearize: Avoid potential null pointer deref
Date: Tue, 30 Aug 2016 19:39:50 +0200
Message-ID: <1472578792-2991-3-git-send-email-phil@nwl.cc>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53972 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932463AbcH3Rkb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 13:40:31 -0400
In-Reply-To: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As netlink_get_register() may return NULL, we must not pass the returned
data unchecked to expr_set_type() as that will dereference it. Since the
parser has failed at that point anyway, by returning early we can skip
the useless statement allocation that follows in
netlink_parse_ct_stmt().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix for the same problem in netlink_parse_meta_stmt(), too.
- Print error message instead of silently failing.
- Align coding style with other post netlink_get_register() checks.
---
 src/netlink_delinearize.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1a1cfbded4e1e..e3846a700ca8e 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -517,6 +517,9 @@ static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_META_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
+	if (expr == NULL)
+		return netlink_error(ctx, loc,
+				     "No expression in register %u", sreg);
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_META_KEY);
 	stmt = meta_stmt_alloc(loc, key, expr);
@@ -562,6 +565,9 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
+	if (expr == NULL)
+		return netlink_error(ctx, loc,
+				     "No expression in register %u", sreg);
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
 	stmt = ct_stmt_alloc(loc, key, expr);
-- 
2.8.2

