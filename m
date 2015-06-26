From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] payload: fix transport matching with no network layer info in bridge family
Date: Fri, 26 Jun 2015 10:45:01 +0200
Message-ID: <1435308301-15867-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58328 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbbFZIjn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:39:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft --debug=netlink add rule bridge filter input tcp dport 22
 bridge filter input
  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 2 => reg 1 ]
  [ cmp eq reg 1 0x00001600 ]

Reported-by: Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/payload.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index 08578fd..e67ef17 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -219,6 +219,9 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 			case PROTO_BASE_LL_HDR:
 				desc = &proto_eth;
 				break;
+			case PROTO_BASE_TRANSPORT_HDR:
+				desc = &proto_inet_service;
+				break;
 			default:
 				break;
 			}
-- 
1.7.10.4

