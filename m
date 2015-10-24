From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: fix mapping evaluation
Date: Sat, 24 Oct 2015 20:11:14 +0200
Message-ID: <1445710274-2071-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, aschultz@tpip.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38856 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbbJXSE0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Oct 2015 14:04:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # cat ruleset.file
 table ip mangle {
        map CLASS05 {
                type ipv4_addr : mark
                elements = { 192.168.0.10 : 0x00000001}
        }

        chain OUTPUT {
                type route hook output priority 0; policy accept;
                mark set ip saddr map @CLASS05
        }
 }
 # nft -f ruleset.file
 ruleset.file:4:28-54: Error: mapping outside of map context
                elements = { 192.168.0.10 : 0x00000001}
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^

This actually is fixing two problems:

1) Validate datatype of the rhs before evaluating the map definition,
   this is also setting set->datalen which is needed for the element
   evaluation.

2) Add missing set context.

Reported-by: Andreas Schultz <aschultz@tpip.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ccbe8b3..ea43fc1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1883,28 +1883,29 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
 		return set_error(ctx, set, "unqualified key data type "
 				 "specified in %s definition", type);
 
+	if (set->flags & SET_F_MAP) {
+		if (set->datatype == NULL)
+			return set_error(ctx, set, "map definition does not "
+					 "specify mapping data type");
+
+		set->datalen = set->datatype->size;
+		if (set->datalen == 0 && set->datatype->type != TYPE_VERDICT)
+			return set_error(ctx, set, "unqualified mapping data "
+					 "type specified in map definition");
+	}
+
+	ctx->set = set;
 	if (set->init != NULL) {
 		expr_set_context(&ctx->ectx, set->keytype, set->keylen);
 		if (expr_evaluate(ctx, &set->init) < 0)
 			return -1;
 	}
+	ctx->set = NULL;
 
 	/* Default timeout value implies timeout support */
 	if (set->timeout)
 		set->flags |= SET_F_TIMEOUT;
 
-	if (!(set->flags & SET_F_MAP))
-		return 0;
-
-	if (set->datatype == NULL)
-		return set_error(ctx, set, "map definition does not specify "
-				 "mapping data type");
-
-	set->datalen = set->datatype->size;
-	if (set->datalen == 0 && set->datatype->type != TYPE_VERDICT)
-		return set_error(ctx, set, "unqualified mapping data type "
-				 "specified in map definition");
-
 	return 0;
 }
 
-- 
2.1.4

