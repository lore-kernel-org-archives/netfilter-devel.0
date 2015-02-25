From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 3/3] netlink_delinearize: fix postprocessing
Date: Thu, 26 Feb 2015 00:51:10 +0100
Message-ID: <1424908270-554-4-git-send-email-eric@regit.org>
References: <1424908270-554-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:42926 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbBZATu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Feb 2015 19:19:50 -0500
In-Reply-To: <1424908270-554-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following rule:
  ip protocol tcp counter packets 0 bytes 0 tcp dport ssh accept

is build in byte code as:

  ip test filter
    [ payload load 1b @ network header + 9 => reg 1 ]
    [ cmp eq reg 1 0x00000006 ]
    [ counter pkts 0 bytes 0 ]
    [ payload load 2b @ transport header + 2 => reg 1 ]
    [ cmp eq reg 1 0x00001600 ]
    [ immediate reg 0 accept ]

But the simplication process is reverting it to:
  counter tcp dport ssh accept

Which is different rule.

This patch is fixing the issue by resetting the dependency when we
are seeing a counter statement.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/netlink_delinearize.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 387bb67..181942b 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -770,6 +770,12 @@ static void payload_dependency_store(struct rule_pp_ctx *ctx,
 	ctx->pdep  = stmt;
 }
 
+static void payload_dependency_reset(struct rule_pp_ctx *ctx)
+{
+	ctx->pbase = PROTO_BASE_INVALID;
+	ctx->pdep  = NULL;
+}
+
 static void integer_type_postprocess(struct expr *expr)
 {
 	struct expr *i;
@@ -1137,6 +1143,9 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 		case STMT_REJECT:
 			stmt_reject_postprocess(rctx, stmt);
 			break;
+		case STMT_COUNTER:
+			payload_dependency_reset(&rctx);
+			break;
 		default:
 			break;
 		}
-- 
2.1.4

