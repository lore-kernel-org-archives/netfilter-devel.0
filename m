From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] netlink_delinearize: restore listing of host byteorder set elements
Date: Wed,  3 Jun 2015 20:16:41 +0200
Message-ID: <1433355401-21332-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51587 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbbFCSLj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2015 14:11:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

before:

table ip filter {
        chain test {
                cpu { 67108864, 50331648, 33554432}
        }
}

after:

table ip filter {
        chain test {
                cpu { 4, 3, 2 }
        }
}

Related to 525323352904 ("expr: add set_elem_expr as container for set element
attributes").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Note: This patch applies to the next-4.1 branch.

 src/netlink_delinearize.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b1ce911..ea60c86 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -824,6 +824,10 @@ static void integer_type_postprocess(struct expr *expr)
 			integer_type_postprocess(i);
 		}
 		break;
+	case EXPR_SET_ELEM:
+		expr_set_type(expr->key, expr->dtype, expr->byteorder);
+		integer_type_postprocess(expr->key);
+		break;
 	default:
 		break;
 	}
-- 
1.7.10.4

