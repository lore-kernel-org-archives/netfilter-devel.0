From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4 v2] delinearize: list the icmpx reason with the string associated
Date: Fri, 17 Oct 2014 14:24:36 +0200
Message-ID: <1413548677-10287-3-git-send-email-alvaroneay@gmail.com>
References: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48319 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQMY2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:24:28 -0400
Received: by mail-wg0-f42.google.com with SMTP id z12so783283wgg.25
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2014 05:24:26 -0700 (PDT)
In-Reply-To: <1413548677-10287-1-git-send-email-alvaroneay@gmail.com>
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
[no changes in v2]

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

