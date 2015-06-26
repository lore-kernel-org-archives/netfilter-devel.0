From: Eric Leblond <eric@regit.org>
Subject: [PATCH nft] payload: reorder case in a switch for consistency
Date: Fri, 26 Jun 2015 11:55:21 +0200
Message-ID: <1435312521-8184-1-git-send-email-eric@regit.org>
References: <20150626085441.GB10981@acer.localdomain>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47655 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbFZJz4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 05:55:56 -0400
In-Reply-To: <20150626085441.GB10981@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As pointed out by Patrick McHardy the order in the inet switch
in payload_gen_dependency was not consistent.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/payload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/payload.c b/src/payload.c
index e67ef17..5f8c4fe 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -204,12 +204,12 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 		switch (ctx->pctx.family) {
 		case NFPROTO_INET:
 			switch (expr->payload.base) {
-			case PROTO_BASE_TRANSPORT_HDR:
-				desc = &proto_inet_service;
-				break;
 			case PROTO_BASE_LL_HDR:
 				desc = &proto_inet;
 				break;
+			case PROTO_BASE_TRANSPORT_HDR:
+				desc = &proto_inet_service;
+				break;
 			default:
 				break;
 			}
-- 
2.1.4

