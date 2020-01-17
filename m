Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BE7C33CB3
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AACB2072B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="NEjdhs+H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbgAQU6K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:58:10 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55988 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgAQU6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 15:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VOjUVkKe6wSMdlzWZ+x1Rp1EF0dBnA8Wp/PX4QjKcmM=; b=NEjdhs+H0wRG/z0ue9AxYovHy+
        hTI2VI6EMLrWpS7RxiRTlfce7X8ylDsi4BZM8PBu3WZ/uY0tzlu4W+lFCmeoy9KRDdzyFpA5skIph
        kb6p5BkXaZCU+3Wscvf3fNWSMNqIXjo5wlYXKG2hAsA1rzjzjM89O2cPKGJhGXg78gszDeoFGcjsg
        jmWex64hcByzbe5qxvGNr4ZTw6Sv3QV+g9JkhRM30ICLDl4GOI47RA8wKQAGD8AIpEVh4n0deDjnJ
        cNmOjhPrPgSfqm2+PhHUxhA2eKTeI5dfHz1ACszQSFsTL0g5bzfpP7xce64OfIyGA1b5Wxf6Dpyf2
        sY1VzDkw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isYgz-0004I2-84
        for netfilter-devel@vger.kernel.org; Fri, 17 Jan 2020 20:58:09 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v2 2/6] bitwise: fix some incorrect indentation.
Date:   Fri, 17 Jan 2020 20:58:04 +0000
Message-Id: <20200117205808.172194-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117205808.172194-1-jeremy@azazel.net>
References: <20200117205808.172194-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/expr/bitwise.c            | 12 ++++++------
 tests/nft-expr_bitwise-test.c |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/expr/bitwise.c b/src/expr/bitwise.c
index c9d40df34b54..489ee8420c44 100644
--- a/src/expr/bitwise.c
+++ b/src/expr/bitwise.c
@@ -31,7 +31,7 @@ struct nftnl_expr_bitwise {
 
 static int
 nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
-			  const void *data, uint32_t data_len)
+		       const void *data, uint32_t data_len)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 
@@ -61,7 +61,7 @@ nftnl_expr_bitwise_set(struct nftnl_expr *e, uint16_t type,
 
 static const void *
 nftnl_expr_bitwise_get(const struct nftnl_expr *e, uint16_t type,
-			  uint32_t *data_len)
+		       uint32_t *data_len)
 {
 	struct nftnl_expr_bitwise *bitwise = nftnl_expr_data(e);
 
@@ -127,7 +127,7 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 		nest = mnl_attr_nest_start(nlh, NFTA_BITWISE_MASK);
 		mnl_attr_put(nlh, NFTA_DATA_VALUE, bitwise->mask.len,
-				bitwise->mask.val);
+			     bitwise->mask.val);
 		mnl_attr_nest_end(nlh, nest);
 	}
 	if (e->flags & (1 << NFTNL_EXPR_BITWISE_XOR)) {
@@ -135,7 +135,7 @@ nftnl_expr_bitwise_build(struct nlmsghdr *nlh, const struct nftnl_expr *e)
 
 		nest = mnl_attr_nest_start(nlh, NFTA_BITWISE_XOR);
 		mnl_attr_put(nlh, NFTA_DATA_VALUE, bitwise->xor.len,
-				bitwise->xor.val);
+			     bitwise->xor.val);
 		mnl_attr_nest_end(nlh, nest);
 	}
 }
@@ -185,14 +185,14 @@ static int nftnl_expr_bitwise_snprintf_default(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->mask,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, ") ^ ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = nftnl_data_reg_snprintf(buf + offset, remain, &bitwise->xor,
-				    NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
+				      NFTNL_OUTPUT_DEFAULT, 0, DATA_VALUE);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
diff --git a/tests/nft-expr_bitwise-test.c b/tests/nft-expr_bitwise-test.c
index 64c14466dbd2..e37d85832072 100644
--- a/tests/nft-expr_bitwise-test.c
+++ b/tests/nft-expr_bitwise-test.c
@@ -28,7 +28,7 @@ static void print_err(const char *msg)
 }
 
 static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
-			      struct nftnl_expr *rule_b)
+			   struct nftnl_expr *rule_b)
 {
 	uint32_t maska, maskb;
 	uint32_t xora, xorb;
@@ -50,8 +50,8 @@ static void cmp_nftnl_expr(struct nftnl_expr *rule_a,
 	nftnl_expr_get(rule_b, NFTNL_EXPR_BITWISE_XOR, &xorb);
 	if (xora != xorb)
 		print_err("Size of BITWISE_XOR mismatches");
-
 }
+
 int main(int argc, char *argv[])
 {
 	struct nftnl_rule *a, *b = NULL;
-- 
2.24.1

