Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52498C432BE
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 22:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D2EC60FF2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Aug 2021 22:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhH3WfO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Aug 2021 18:35:14 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45470 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbhH3WfO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Aug 2021 18:35:14 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5034F6007D;
        Tue, 31 Aug 2021 00:33:19 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 1/2] netlink_delinearize: incorrect meta protocol dependency kill again
Date:   Tue, 31 Aug 2021 00:34:11 +0200
Message-Id: <20210830223412.12865-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds __meta_dependency_may_kill() to consolidate inspection
of the meta protocol, nfproto and ether type expression to validate
dependency removal on listings.

Phil reports that 567ea4774e13 includes an update on the ip and ip6
families that is not described in the patch, moreover, it flips the
default verdict from true to false.

Fixes: 567ea4774e13 ("netlink_delinearize: incorrect meta protocol dependency kill")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c                     | 106 ++++++++++--------
 .../testcases/optimizations/dependency_kill   |  48 ++++++++
 .../optimizations/dumps/dependency_kill.nft   |  42 +++++++
 3 files changed, 151 insertions(+), 45 deletions(-)
 create mode 100755 tests/shell/testcases/optimizations/dependency_kill
 create mode 100644 tests/shell/testcases/optimizations/dumps/dependency_kill.nft

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 92617a46df6f..0f00b9555266 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1983,6 +1983,55 @@ static void payload_match_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
+static uint8_t ether_type_to_nfproto(uint16_t l3proto)
+{
+	switch(l3proto) {
+	case ETH_P_IP:
+		return NFPROTO_IPV4;
+	case ETH_P_IPV6:
+		return NFPROTO_IPV6;
+	default:
+		break;
+	}
+
+	return NFPROTO_UNSPEC;
+}
+
+static bool __meta_dependency_may_kill(const struct expr *dep, uint8_t *nfproto)
+{
+	uint16_t l3proto;
+
+	switch (dep->left->etype) {
+	case EXPR_META:
+		switch (dep->left->meta.key) {
+		case NFT_META_NFPROTO:
+			*nfproto = mpz_get_uint8(dep->right->value);
+			break;
+		case NFT_META_PROTOCOL:
+			l3proto = mpz_get_uint16(dep->right->value);
+			*nfproto = ether_type_to_nfproto(l3proto);
+			break;
+		default:
+			return true;
+		}
+		break;
+	case EXPR_PAYLOAD:
+		if (dep->left->payload.base != PROTO_BASE_LL_HDR)
+			return true;
+
+		if (dep->left->dtype != &ethertype_type)
+			return true;
+
+		l3proto = mpz_get_uint16(dep->right->value);
+		*nfproto = ether_type_to_nfproto(l3proto);
+		break;
+	default:
+		break;
+	}
+
+	return false;
+}
+
 /* We have seen a protocol key expression that restricts matching at the network
  * base, leave it in place since this is meaninful in bridge, inet and netdev
  * families. Exceptions are ICMP and ICMPv6 where this code assumes that can
@@ -1993,66 +2042,33 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 				     const struct expr *expr)
 {
 	struct expr *dep = ctx->pdep->expr;
-	uint16_t l3proto, protocol;
-	uint8_t l4proto;
+	uint8_t l4proto, nfproto;
 
 	if (ctx->pbase != PROTO_BASE_NETWORK_HDR)
 		return true;
 
+	if (__meta_dependency_may_kill(dep, &nfproto))
+		return true;
+
 	switch (family) {
 	case NFPROTO_INET:
 	case NFPROTO_NETDEV:
 	case NFPROTO_BRIDGE:
 		break;
 	default:
-		if (dep->left->etype != EXPR_META ||
-		    dep->right->etype != EXPR_VALUE)
+		if (family == NFPROTO_IPV4 &&
+		    nfproto != NFPROTO_IPV4)
+			return false;
+		else if (family == NFPROTO_IPV6 &&
+			 nfproto != NFPROTO_IPV6)
 			return false;
 
-		if (dep->left->meta.key == NFT_META_PROTOCOL) {
-			protocol = mpz_get_uint16(dep->right->value);
-
-			if (family == NFPROTO_IPV4 &&
-			    protocol == ETH_P_IP)
-				return true;
-			else if (family == NFPROTO_IPV6 &&
-				 protocol == ETH_P_IPV6)
-				return true;
-		}
-
-		return false;
+		return true;
 	}
 
 	if (expr->left->meta.key != NFT_META_L4PROTO)
 		return true;
 
-	l3proto = mpz_get_uint16(dep->right->value);
-
-	switch (dep->left->etype) {
-	case EXPR_META:
-		if (dep->left->meta.key != NFT_META_NFPROTO &&
-		    dep->left->meta.key != NFT_META_PROTOCOL)
-			return true;
-		break;
-	case EXPR_PAYLOAD:
-		if (dep->left->payload.base != PROTO_BASE_LL_HDR)
-			return true;
-
-		switch(l3proto) {
-		case ETH_P_IP:
-			l3proto = NFPROTO_IPV4;
-			break;
-		case ETH_P_IPV6:
-			l3proto = NFPROTO_IPV6;
-			break;
-		default:
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-
 	l4proto = mpz_get_uint8(expr->right->value);
 
 	switch (l4proto) {
@@ -2063,8 +2079,8 @@ static bool meta_may_dependency_kill(struct payload_dep_ctx *ctx,
 		return false;
 	}
 
-	if ((l3proto == NFPROTO_IPV4 && l4proto == IPPROTO_ICMPV6) ||
-	    (l3proto == NFPROTO_IPV6 && l4proto == IPPROTO_ICMP))
+	if ((nfproto == NFPROTO_IPV4 && l4proto == IPPROTO_ICMPV6) ||
+	    (nfproto == NFPROTO_IPV6 && l4proto == IPPROTO_ICMP))
 		return false;
 
 	return true;
diff --git a/tests/shell/testcases/optimizations/dependency_kill b/tests/shell/testcases/optimizations/dependency_kill
new file mode 100755
index 000000000000..904eecf89b6e
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dependency_kill
@@ -0,0 +1,48 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table bridge foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table ip foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table ip6 foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table netdev foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table inet foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+		meta nfproto ipv4 udp dport 67
+		meta nfproto ipv6 udp dport 67
+	}
+}"
+
+$NFT -f - <<< $RULESET
diff --git a/tests/shell/testcases/optimizations/dumps/dependency_kill.nft b/tests/shell/testcases/optimizations/dumps/dependency_kill.nft
new file mode 100644
index 000000000000..1781f7be0c09
--- /dev/null
+++ b/tests/shell/testcases/optimizations/dumps/dependency_kill.nft
@@ -0,0 +1,42 @@
+table bridge foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table ip foo {
+	chain bar {
+		udp dport 67
+		meta protocol ip6 udp dport 67
+		udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table ip6 foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		udp dport 67
+		ether type ip udp dport 67
+		udp dport 67
+	}
+}
+table netdev foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+	}
+}
+table inet foo {
+	chain bar {
+		meta protocol ip udp dport 67
+		meta protocol ip6 udp dport 67
+		ether type ip udp dport 67
+		ether type ip6 udp dport 67
+		meta nfproto ipv4 udp dport 67
+		meta nfproto ipv6 udp dport 67
+	}
+}
-- 
2.20.1

