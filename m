From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/4] datatype: missing byteorder in string_type
Date: Sun, 14 Dec 2014 20:47:08 +0100
Message-ID: <20141214194708.GA17579@salvia>
References: <1418576463-3606-1-git-send-email-pablo@netfilter.org>
 <1418576463-3606-2-git-send-email-pablo@netfilter.org>
 <4D4832DE-212B-481E-935D-D7B1833D3549@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58717 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbaLNTot (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Dec 2014 14:44:49 -0500
Content-Disposition: inline
In-Reply-To: <4D4832DE-212B-481E-935D-D7B1833D3549@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 14, 2014 at 07:01:10PM +0100, Patrick McHardy wrote:
> Am 14. Dezember 2014 18:01:00 MEZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
> >nft add rule filter input iifname { "lo", "eth0" } counter
> >
> >Now the listing shows:
> >
> >	iifname { "lo", "eth0"}
> >
> >instead of:
> >
> >	iifname { "", ""}
> 
> Again wondering what broke this. Let me check when I am at home,
> IIRC we have some check for strings somewhere in the netlink code
> that relies in this.

Attached an alternative to this patch. That I can remember, this is
broken since quite some time.

Let me know, thanks.

--vtzGhvizbBRQ85DL
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-datatype-fix-listing-of-string-elements.patch"

>From ddd263f8ceccf4f30784b9316e2cadfa35e5678d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sat, 13 Dec 2014 18:29:37 +0100
Subject: [PATCH] datatype: fix listing of string elements

Generalise 0451b82 ("src: generate set members using integer_type in
the appropriate byteorder") to handle string_type too, since this
datatype doesn't have any specific byteorder.

nft add rule filter input iifname { "lo", "eth0" } counter

Now the listing shows:

	iifname { "lo", "eth0"}

instead of:

	iifname { "", ""}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index e9a04dd..8762cc9 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -742,7 +742,7 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
-static void integer_type_postprocess(struct expr *expr)
+static void lookup_postprocess(struct expr *expr)
 {
 	struct expr *i;
 
@@ -757,7 +757,7 @@ static void integer_type_postprocess(struct expr *expr)
 	case EXPR_SET_REF:
 		list_for_each_entry(i, &expr->set->init->expressions, list) {
 			expr_set_type(i, expr->dtype, expr->byteorder);
-			integer_type_postprocess(i);
+			lookup_postprocess(i);
 		}
 		break;
 	default:
@@ -831,8 +831,12 @@ static void meta_match_postprocess(struct rule_pp_ctx *ctx,
 	case OP_LOOKUP:
 		expr_set_type(expr->right, expr->left->dtype,
 			      expr->left->byteorder);
-		if (expr->right->dtype == &integer_type)
-			integer_type_postprocess(expr->right);
+		switch (expr->right->dtype->type) {
+		case TYPE_STRING:
+		case TYPE_INTEGER:
+			lookup_postprocess(expr->right);
+			break;
+		}
 		break;
 	default:
 		break;
-- 
1.7.10.4


--vtzGhvizbBRQ85DL--
