From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/4] netlink_delinearize: Avoid potential null pointer deref
Date: Fri, 12 Aug 2016 18:00:08 +0200
Message-ID: <1471017610-3473-3-git-send-email-phil@nwl.cc>
References: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46488 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbcHLQAf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 12:00:35 -0400
In-Reply-To: <1471017610-3473-1-git-send-email-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As netlink_get_register() may return NULL, we must not pass the returned
data unchecked to expr_set_type() as that will dereference it. Since the
parser has failed at that point anyway, by returning early we can skip
the useless statement allocation that follows in
netlink_parse_ct_stmt().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink_delinearize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 12d0b4a277795..6ac2e9690fd39 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -518,6 +518,8 @@ static void netlink_parse_ct_stmt(struct netlink_parse_ctx *ctx,
 
 	sreg = netlink_parse_register(nle, NFTNL_EXPR_CT_SREG);
 	expr = netlink_get_register(ctx, loc, sreg);
+	if (!expr)
+		return;
 
 	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_CT_KEY);
 	stmt = ct_stmt_alloc(loc, key, expr);
-- 
2.8.2

