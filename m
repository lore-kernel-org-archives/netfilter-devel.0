From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 1/2 v2] evaluate: reject: check the context in reject without reason for bridge and inet tables
Date: Thu, 23 Oct 2014 19:36:56 +0200
Message-ID: <1414085817-9059-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:65334 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741AbaJWRgp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:36:45 -0400
Received: by mail-wi0-f178.google.com with SMTP id q5so1445844wiv.17
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2014 10:36:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In rules like:

  nft add rule inet filter input reject
or
  nft add rule bridge filter input reject

we use icmpx to reject it. But if we have network context, we also use type of
reject. With this patch, we check the network context. If we don't have context,
we still use icmpx. However, if we have rules with network context like:

  nft add rule inet meta nfproto ipv4 reject
or
  nft add rule bridge ether type ipv6 reject

We are going to use icmp or icmpv6 to reject it taking into account the network
context.

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Added these new rules into the reject tests for bridge and inet tables.

 src/evaluate.c                   |   44 ++++++++++++++++++++++++++++++++++++--
 tests/regression/bridge/reject.t |    3 +++
 tests/regression/inet/reject.t   |    3 +++
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 63ba82e..2dd49fa 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1357,6 +1357,9 @@ static int stmt_evaluate_reject_family(struct eval_ctx *ctx, struct stmt *stmt,
 static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 					  struct stmt *stmt)
 {
+	int protocol;
+	const struct proto_desc *desc, *base;
+
 	switch (ctx->pctx.family) {
 	case NFPROTO_IPV4:
 	case NFPROTO_IPV6:
@@ -1368,9 +1371,46 @@ static int stmt_evaluate_reject_default(struct eval_ctx *ctx,
 			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
 		break;
 	case NFPROTO_INET:
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc == NULL) {
+			stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
+			stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
+			break;
+		}
+		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case NFPROTO_IPV4:
+			stmt->reject.family = NFPROTO_IPV4;
+			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
+			break;
+		case NFPROTO_IPV6:
+			stmt->reject.family = NFPROTO_IPV6;
+			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
+			break;
+		}
+		break;
 	case NFPROTO_BRIDGE:
-		stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
-		stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc == NULL) {
+			stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
+			stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
+			break;
+		}
+		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+		base = ctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		protocol = proto_find_num(base, desc);
+		switch (protocol) {
+		case __constant_htons(ETH_P_IP):
+			stmt->reject.family = NFPROTO_IPV4;
+			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
+			break;
+		case __constant_htons(ETH_P_IPV6):
+			stmt->reject.family = NFPROTO_IPV6;
+			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
+			break;
+		}
 		break;
 	}
 	return 0;
diff --git a/tests/regression/bridge/reject.t b/tests/regression/bridge/reject.t
index 11a0f1c..43e5461 100644
--- a/tests/regression/bridge/reject.t
+++ b/tests/regression/bridge/reject.t
@@ -18,6 +18,9 @@ reject with icmpv6 type port-unreachable;ok;ether type ip6 reject
 ip protocol tcp reject with tcp reset;ok;ip protocol 6 reject with tcp reset
 
 reject;ok
+ether type ip reject;ok
+ether type ip6 reject;ok
+
 reject with icmpx type host-unreachable;ok
 reject with icmpx type no-route;ok
 reject with icmpx type admin-prohibited;ok
diff --git a/tests/regression/inet/reject.t b/tests/regression/inet/reject.t
index 2f5aef3..52e7b28 100644
--- a/tests/regression/inet/reject.t
+++ b/tests/regression/inet/reject.t
@@ -18,6 +18,9 @@ reject with icmpv6 type port-unreachable;ok;meta nfproto ipv6 reject
 reject with tcp reset;ok;meta l4proto 6 reject with tcp reset
 
 reject;ok
+meta nfproto ipv4 reject;ok
+meta nfproto ipv6 reject;ok
+
 reject with icmpx type host-unreachable;ok
 reject with icmpx type no-route;ok
 reject with icmpx type admin-prohibited;ok
-- 
1.7.10.4

