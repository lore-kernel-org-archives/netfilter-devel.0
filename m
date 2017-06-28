From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 09/17] src: ct: store proto base of ct key, if any
Date: Wed, 28 Jun 2017 12:06:51 +0200
Message-ID: <20170628100659.26976-10-fw@strlen.de>
References: <20170628100659.26976-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33374 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751489AbdF1KHN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 06:07:13 -0400
In-Reply-To: <20170628100659.26976-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ct keys can match on network and tranasport header protocol
elements, such as port numbers or ip addresses.

Store this base type so a followup commit can store and kill
dependencies, e.g. if bsae is network header we might be able
to kill an earlier expression because the dependency is implicit.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/expression.h |  1 +
 src/ct.c             | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/expression.h b/include/expression.h
index 0a07646ac4ad..10df3918c946 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -299,6 +299,7 @@ struct expr {
 		struct {
 			/* EXPR_CT */
 			enum nft_ct_keys	key;
+			enum proto_bases	base;
 			int8_t			direction;
 			uint8_t			nfproto;
 		} ct;
diff --git a/src/ct.c b/src/ct.c
index ffdc6a52ac97..a4ea6192074a 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -362,8 +362,21 @@ struct expr *ct_expr_alloc(const struct location *loc, enum nft_ct_keys key,
 	expr->ct.nfproto = nfproto;
 
 	switch (key) {
+	case NFT_CT_SRC:
+	case NFT_CT_DST:
+		expr->ct.base = PROTO_BASE_NETWORK_HDR;
+		break;
+	case NFT_CT_PROTO_SRC:
+	case NFT_CT_PROTO_DST:
+		expr->ct.base = PROTO_BASE_TRANSPORT_HDR;
+		break;
 	case NFT_CT_PROTOCOL:
 		expr->flags = EXPR_F_PROTOCOL;
+		expr->ct.base = PROTO_BASE_NETWORK_HDR;
+		break;
+	case NFT_CT_L3PROTOCOL:
+		expr->flags = EXPR_F_PROTOCOL;
+		expr->ct.base = PROTO_BASE_LL_HDR;
 		break;
 	default:
 		break;
-- 
2.13.0

