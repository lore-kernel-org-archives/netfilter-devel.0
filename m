From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nft PATCH 3/4 v2] evaluate: check in bridge and inet the network context in reject
Date: Tue, 21 Oct 2014 16:15:45 +0200
Message-ID: <1413900946-15820-3-git-send-email-alvaroneay@gmail.com>
References: <1413900946-15820-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:49865 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731AbaJUOPe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:15:34 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so1488950wgh.11
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2014 07:15:33 -0700 (PDT)
In-Reply-To: <1413900946-15820-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In Inet tables, we have to check the network context in rules that we use
icmp or icmpv6 reason in reject. To be sure that the context is the correct.
However, for icmpx and tcp reject, we don't need to check it.

In Bridge tables, we have vlan and arp traffic and they are not supported.
For this things, we have to check the network context. For example:

  nft add rule bridge test-bridge input \
			ether type arp reject with icmp type host-unreachable
or
  nft add rule bridge test-bridge input \
  			ether type vlan reject with tcp reset

In that cases, we have to throw an error. Moreover, we have to accept rules
that the network context is Ipv4 and Ipv6. For example:

  nft add rule -nnn bridge test-bridge input \
			ip protocol tcp reject with tcp reset

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
[changes in v2]
 * Check the network context is correct only in bridge tables, if we use
   icmpx or tcp reset.

 src/evaluate.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 017d9b0..79576c1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1234,12 +1234,18 @@ static int stmt_evaluate_reject_inet(struct eval_ctx *ctx, struct stmt *stmt,
 {
 	const struct proto_desc *desc;
 
-	desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
-	if (desc != NULL &&
-	    stmt_evaluate_reject_inet_family(ctx, stmt, desc) < 0)
-		return -1;
-	if (stmt->reject.type == NFT_REJECT_ICMPX_UNREACH)
+	switch (stmt->reject.type) {
+	case NFT_REJECT_TCP_RST:
+		break;
+	case NFT_REJECT_ICMPX_UNREACH:
 		return 0;
+	case NFT_REJECT_ICMP_UNREACH:
+		desc = ctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		if (desc != NULL &&
+		    stmt_evaluate_reject_inet_family(ctx, stmt, desc) < 0)
+			return -1;
+		break;
+	}
 	if (stmt_reject_gen_dependency(ctx, stmt, expr) < 0)
 		return -1;
 	return 0;
@@ -1256,11 +1262,15 @@ static int stmt_evaluate_reject_bridge_family(struct eval_ctx *ctx,
 	protocol = proto_find_num(base, desc);
 	switch (protocol) {
 	case __constant_htons(ETH_P_IP):
+		if (stmt->reject.type != NFT_REJECT_ICMP_UNREACH)
+			break;
 		if (NFPROTO_IPV4 == stmt->reject.family)
 			break;
 		return stmt_error(ctx, stmt,
 				  "conflicting protocols specified: ip vs ip6");
 	case __constant_htons(ETH_P_IPV6):
+		if (stmt->reject.type != NFT_REJECT_ICMP_UNREACH)
+			break;
 		if (NFPROTO_IPV6 == stmt->reject.family)
 			break;
 		return stmt_error(ctx, stmt,
-- 
1.7.10.4

