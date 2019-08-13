Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986B0C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D8B2054F
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfHMSnu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:43:50 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57244 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfHMSnu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:43:50 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hxblr-0003fw-Ve; Tue, 13 Aug 2019 20:43:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nftables 1/4] src: fix jumps on bigendian arches
Date:   Tue, 13 Aug 2019 20:44:06 +0200
Message-Id: <20190813184409.10757-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813184409.10757-1-fw@strlen.de>
References: <20190813184409.10757-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

table bla {
  chain foo { }
  chain bar { jump foo }
 }
}

Fails to restore on big-endian platforms:
jump.nft:5:2-9: Error: Could not process rule: No such file or directory
 jump foo

nft passes a 0-length name to the kernel.

This is because when we export the value (the string), we provide
the size of the destination buffer.

In earlier versions, the parser allocated the name with the same
fixed size and all was fine.

After the fix, the export places the name in the wrong location
in the destination buffer.

This makes tests/shell/testcases/chains/0001jumps_0 work on s390x.

Fixes: 142350f154c78 ("src: invalid read when importing chain name")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/datatype.c | 26 +++++++++++++++++---------
 src/netlink.c  | 16 +++++++++++++---
 2 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 28f726f4e84c..6908bc22d783 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -244,10 +244,24 @@ const struct datatype invalid_type = {
 	.print		= invalid_type_print,
 };
 
-static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
+static void verdict_jump_chain_print(const char *what, const struct expr *e,
+				     struct output_ctx *octx)
 {
 	char chain[NFT_CHAIN_MAXNAMELEN];
+	unsigned int len;
+
+	memset(chain, 0, sizeof(chain));
 
+	len = e->len / BITS_PER_BYTE;
+	if (len >= sizeof(chain))
+		len = sizeof(chain) - 1;
+
+	mpz_export_data(chain, e->value, BYTEORDER_HOST_ENDIAN, len);
+	nft_print(octx, "%s %s", what, chain);
+}
+
+static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
+{
 	switch (expr->verdict) {
 	case NFT_CONTINUE:
 		nft_print(octx, "continue");
@@ -257,10 +271,7 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 		break;
 	case NFT_JUMP:
 		if (expr->chain->etype == EXPR_VALUE) {
-			mpz_export_data(chain, expr->chain->value,
-					BYTEORDER_HOST_ENDIAN,
-					NFT_CHAIN_MAXNAMELEN);
-			nft_print(octx, "jump %s", chain);
+			verdict_jump_chain_print("jump", expr->chain, octx);
 		} else {
 			nft_print(octx, "jump ");
 			expr_print(expr->chain, octx);
@@ -268,10 +279,7 @@ static void verdict_type_print(const struct expr *expr, struct output_ctx *octx)
 		break;
 	case NFT_GOTO:
 		if (expr->chain->etype == EXPR_VALUE) {
-			mpz_export_data(chain, expr->chain->value,
-					BYTEORDER_HOST_ENDIAN,
-					NFT_CHAIN_MAXNAMELEN);
-			nft_print(octx, "goto %s", chain);
+			verdict_jump_chain_print("goto", expr->chain, octx);
 		} else {
 			nft_print(octx, "goto ");
 			expr_print(expr->chain, octx);
diff --git a/src/netlink.c b/src/netlink.c
index aeeb12eaca93..f8e1120447d9 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -222,17 +222,27 @@ static void netlink_gen_verdict(const struct expr *expr,
 				struct nft_data_linearize *data)
 {
 	char chain[NFT_CHAIN_MAXNAMELEN];
+	unsigned int len;
 
 	data->verdict = expr->verdict;
 
 	switch (expr->verdict) {
 	case NFT_JUMP:
 	case NFT_GOTO:
+		len = expr->chain->len / BITS_PER_BYTE;
+
+		if (!len)
+			BUG("chain length is 0");
+
+		if (len > sizeof(chain))
+			BUG("chain is too large (%u, %u max)",
+			    len, (unsigned int)sizeof(chain));
+
+		memset(chain, 0, sizeof(chain));
+
 		mpz_export_data(chain, expr->chain->value,
-				BYTEORDER_HOST_ENDIAN,
-				NFT_CHAIN_MAXNAMELEN);
+				BYTEORDER_HOST_ENDIAN, len);
 		snprintf(data->chain, NFT_CHAIN_MAXNAMELEN, "%s", chain);
-		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
 		break;
 	}
 }
-- 
2.21.0

