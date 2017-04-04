From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] exthdr: avoid crash with older kernels
Date: Tue,  4 Apr 2017 20:46:46 +0200
Message-ID: <20170404184646.16038-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37124 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752518AbdDDSo6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Apr 2017 14:44:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

if kernel is older it won't understand the EXTHDR_OP attribute, i.e.
the rule gets accepted as a check for ipv6 exthdr.

On dump nft is then presented with a invalid ipv6 exthdr.
So we need to get rid of the assert and output an "invalid" message on
list.  Longterm we need a proper vm description or kernel-side check
to reject such messages in first place.

After patch, test suite yields erros of type
ip6/tcpopt.t: WARNING: 'src/nft add rule --debug=netlink ip6 test-ip6 \
   input tcp option sack right 1': 'tcp option sack right 1' mismatches
'ip6 nexthdr 6 unknown-exthdr unknown 0x1 [invalid type]'

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/exthdr.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/src/exthdr.c b/src/exthdr.c
index 375e18f..c8599f2 100644
--- a/src/exthdr.c
+++ b/src/exthdr.c
@@ -44,9 +44,10 @@ static void exthdr_expr_print(const struct expr *expr)
 	} else {
 		if (expr->exthdr.flags & NFT_EXTHDR_F_PRESENT)
 			printf("exthdr %s", expr->exthdr.desc->name);
-		else
-			printf("%s %s", expr->exthdr.desc->name,
+		else {
+			printf("%s %s", expr->exthdr.desc ? expr->exthdr.desc->name : "unknown-exthdr",
 					expr->exthdr.tmpl->token);
+		}
 	}
 }
 
@@ -116,7 +117,7 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 		     unsigned int offset, unsigned int len,
 		     enum nft_exthdr_op op, uint32_t flags)
 {
-	const struct proto_hdr_template *tmpl;
+	const struct proto_hdr_template *tmpl = &exthdr_unknown_template;
 	unsigned int i;
 
 	assert(expr->ops->type == EXPR_EXTHDR);
@@ -126,23 +127,27 @@ void exthdr_init_raw(struct expr *expr, uint8_t type,
 	expr->len = len;
 	expr->exthdr.flags = flags;
 	expr->exthdr.offset = offset;
-	expr->exthdr.desc = exthdr_protocols[type];
-	assert(expr->exthdr.desc != NULL);
+	expr->exthdr.desc = NULL;
 
-	for (i = 0; i < array_size(expr->exthdr.desc->templates); i++) {
-		tmpl = &expr->exthdr.desc->templates[i];
-		if (tmpl->offset != offset ||
-		    tmpl->len    != len)
-			continue;
+	if (type < array_size(exthdr_protocols))
+		expr->exthdr.desc = exthdr_protocols[type];
 
-		if (flags & NFT_EXTHDR_F_PRESENT)
-			expr->dtype = &boolean_type;
-		else
-			expr->dtype = tmpl->dtype;
+	if (expr->exthdr.desc == NULL)
+		goto out;
 
-		expr->exthdr.tmpl = tmpl;
-		return;
+	for (i = 0; i < array_size(expr->exthdr.desc->templates); i++) {
+		tmpl = &expr->exthdr.desc->templates[i];
+		if (tmpl->offset == offset && tmpl->len == len)
+			goto out;
 	}
+
+	tmpl = &exthdr_unknown_template;
+ out:
+	expr->exthdr.tmpl = tmpl;
+	if (flags & NFT_EXTHDR_F_PRESENT)
+		expr->dtype = &boolean_type;
+	else
+		expr->dtype = tmpl->dtype;
 }
 
 static unsigned int mask_length(const struct expr *mask)
-- 
2.9.3

