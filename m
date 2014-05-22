From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] netlink_delinearize: fix double free in relational_binop_postprocess()
Date: Thu, 22 May 2014 17:17:16 +0200
Message-ID: <1400771837-7670-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33368 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaEVPR3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2014 11:17:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

free(expr->right) and free(value) point to the same object, so one
single free() is enough.

This manifests in valgrind with:

==4020== Invalid read of size 4
==4020==    at 0x40A429: expr_free (expression.c:65)
==4020==    by 0x414032: expr_postprocess (netlink_delinearize.c:747)
==4020==    by 0x414C33: netlink_delinearize_rule (netlink_delinearize.c:883)
==4020==    by 0x411305: netlink_events_cb (netlink.c:1692)
==4020==    by 0x55040AD: mnl_cb_run (callback.c:77)
==4020==    by 0x4171E4: nft_mnl_recv (mnl.c:45)
==4020==    by 0x407B44: do_command (rule.c:895)
==4020==    by 0x405C6C: nft_run (main.c:183)
==4020==    by 0x405849: main (main.c:334)
==4020==  Address 0x5d126f8 is 56 bytes inside a block of size 120 free'd
==4020==    at 0x4C2AF5C: free (vg_replace_malloc.c:446)
==4020==    by 0x41402A: expr_postprocess (netlink_delinearize.c:746)
==4020==    by 0x414C33: netlink_delinearize_rule (netlink_delinearize.c:883)
==4020==    by 0x411305: netlink_events_cb (netlink.c:1692)
==4020==    by 0x55040AD: mnl_cb_run (callback.c:77)
==4020==    by 0x4171E4: nft_mnl_recv (mnl.c:45)
==4020==    by 0x407B44: do_command (rule.c:895)
==4020==    by 0x405C6C: nft_run (main.c:183)
==4020==    by 0x405849: main (main.c:334)
==4020==

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 62cbf0e..479c643 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -743,7 +743,6 @@ static void relational_binop_postprocess(struct expr *expr)
 		 * Split the flags into a list of flag values and convert the
 		 * op to OP_FLAGCMP.
 		 */
-		expr_free(expr->right);
 		expr_free(value);
 
 		expr->left  = expr_get(binop->left);
-- 
1.7.10.4

