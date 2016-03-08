From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/4] netlink_delinearize: fix bogus offset w exthdr expressions
Date: Wed,  9 Mar 2016 00:09:46 +0100
Message-ID: <1457478588-12592-2-git-send-email-fw@strlen.de>
References: <1457478588-12592-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39525 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbcCHXQ4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 18:16:56 -0500
In-Reply-To: <1457478588-12592-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Need to fetch the offset from the exthdr template.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink_linearize.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 07f70e0..49b4676 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -320,19 +320,24 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 static void payload_shift_value(const struct expr *left, struct expr *right)
 {
+	unsigned int offset;
+
 	if (right->ops->type != EXPR_VALUE)
 		return;
 
 	switch (left->ops->type) {
 	case EXPR_PAYLOAD:
+		offset = left->payload.offset;
+		break;
 	case EXPR_EXTHDR:
+		offset = left->exthdr.tmpl->offset;
 		break;
 	default:
 		return;
 	}
 
 	mpz_lshift_ui(right->value,
-			payload_shift_calc(left, left->payload.offset));
+			payload_shift_calc(left, offset));
 }
 
 static struct expr *netlink_gen_prefix(struct netlink_linearize_ctx *ctx,
-- 
2.4.10

