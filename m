Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD3CC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbhKXR1j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbhKXR1j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:39 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D05C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:29 -0800 (PST)
Received: from localhost ([::1]:44904 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0R-0001AG-PB; Wed, 24 Nov 2021 18:24:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 08/15] ct: Fix ct label value parser
Date:   Wed, 24 Nov 2021 18:22:44 +0100
Message-Id: <20211124172251.11539-9-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Size of array to export the bit value into was eight times too large, so
on Big Endian the data written into the data reg was always zero.

Fixes: 2fcce8b0677b3 ("ct: connlabel matching support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/ct.c b/src/ct.c
index 2218ecc7a684d..6049157198ad9 100644
--- a/src/ct.c
+++ b/src/ct.c
@@ -176,7 +176,7 @@ static struct error_record *ct_label_type_parse(struct parse_ctx *ctx,
 {
 	const struct symbolic_constant *s;
 	const struct datatype *dtype;
-	uint8_t data[CT_LABEL_BIT_SIZE];
+	uint8_t data[CT_LABEL_BIT_SIZE / BITS_PER_BYTE];
 	uint64_t bit;
 	mpz_t value;
 
@@ -211,8 +211,7 @@ static struct error_record *ct_label_type_parse(struct parse_ctx *ctx,
 	mpz_export_data(data, value, BYTEORDER_HOST_ENDIAN, sizeof(data));
 
 	*res = constant_expr_alloc(&sym->location, dtype,
-				   dtype->byteorder, sizeof(data),
-				   data);
+				   dtype->byteorder, CT_LABEL_BIT_SIZE, data);
 	mpz_clear(value);
 	return NULL;
 }
-- 
2.33.0

