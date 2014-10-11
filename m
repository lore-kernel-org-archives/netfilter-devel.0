From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 2/3] delinearize: list the icmpx reason with the string associated
Date: Sat, 11 Oct 2014 16:11:11 +0200
Message-ID: <1413036673-23022-2-git-send-email-alvaroneay@gmail.com>
References: <1413036673-23022-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:63655 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbaJKOLA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:11:00 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi2so6325261wib.5
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Oct 2014 07:10:58 -0700 (PDT)
In-Reply-To: <1413036673-23022-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you add the rule:
  nft add rule inet filter input reject with icmpx type host-unreachable
  nft list table inet filter

shows:
  table inet filter {
	chain input {
		reject with icmpx type 2
	}
  }

We have to attach the icmpx datatype when we list the rules that use it. With
this patch if we list the ruleset, the output is:

  table inet filter {
	chain input {
		reject with icmpx type host-unreachable
	}
  }

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/netlink_delinearize.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 4bb4697..3e7aed4 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -928,8 +928,10 @@ static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
 		stmt->reject.expr->dtype = &icmpv6_code_type;
 		break;
 	case NFPROTO_INET:
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
+			stmt->reject.expr->dtype = &icmpx_code_type;
 			break;
+		}
 		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
 		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
@@ -944,8 +946,10 @@ static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
 		stmt->reject.family = protocol;
 		break;
 	case NFPROTO_BRIDGE:
-		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+		if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH) {
+			stmt->reject.expr->dtype = &icmpx_code_type;
 			break;
+		}
 		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
 		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
-- 
1.7.10.4

