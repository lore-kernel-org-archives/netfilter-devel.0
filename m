From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 5/7] evaluate: fix build with clang
Date: Tue, 11 Jul 2017 00:32:53 +0200
Message-ID: <20170710223255.29885-6-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41152 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754106AbdGJWdS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:18 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Building with a recent clang was failing due to the following error:

src/evaluate.c|450 col 45| error: initializer element is not constant
||    static const unsigned int max_tcpoptlen = 15 * 4 * BITS_PER_BYTE - tcphdrlen;
||                                              ^~

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/evaluate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ca8b63b..86eea19 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -446,8 +446,7 @@ static int __expr_evaluate_exthdr(struct eval_ctx *ctx, struct expr **exprp)
 
 	switch (expr->exthdr.op) {
 	case NFT_EXTHDR_OP_TCPOPT: {
-		static const uint8_t tcphdrlen = 20 * BITS_PER_BYTE;
-		static const unsigned int max_tcpoptlen = 15 * 4 * BITS_PER_BYTE - tcphdrlen;
+		static const unsigned int max_tcpoptlen = (15 * 4 - 20) * BITS_PER_BYTE;
 		unsigned int totlen = 0;
 
 		totlen += expr->exthdr.tmpl->offset;
-- 
2.13.2

