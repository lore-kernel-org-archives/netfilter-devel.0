From: Eric Leblond <eric@regit.org>
Subject: [nftables] payload: gen l4proto dependency on bridge
Date: Fri, 26 Jun 2015 10:51:45 +0200
Message-ID: <1435308705-2692-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:47131 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbbFZIwD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:52:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was not possible to add a rule like:
 bridge filter input tcp dport 22 accept

Instead we had to use:
 bridge filter input meta l4proto tcp tcp dport 22 accept
or
 bridge filter input ether type ip tcp dport 22 accept

As l4proto is available on bridge, we can simply use
payload_gen_dependency to generate the addition of
the l4proto expression like it is done for inet filtering.

The result is the following netlink message:
 bridge filter input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00001600 ]
   [ immediate reg 0 accept ]

And it is correctly simplified by delinearize as:
 tcp dport 22 accept

This patch also fixes an issue linked to the simplication
because
 bridge filter input meta l4proto tcp tcp dport 22 accept
was transformed into
 bridge filter input tcp dport 22 accept
when read from kernel. So it was not possible to restore
the ruleset after adding this type of rules.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/payload.c | 3 +++
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
2.1.4

