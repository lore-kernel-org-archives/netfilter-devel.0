Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1374AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbhKXR2N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242741AbhKXR2M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:12 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53746C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:25:02 -0800 (PST)
Received: from localhost ([::1]:44944 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0y-0001DG-KX; Wed, 24 Nov 2021 18:25:00 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 04/15] src: Fix payload statement mask on Big Endian
Date:   Wed, 24 Nov 2021 18:22:40 +0100
Message-Id: <20211124172251.11539-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The mask used to select bits to keep must be exported in the same
byteorder as the payload statement itself, also the length of the
exported data must match the number of bytes extracted earlier.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/evaluate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index eebd992159a11..49fb8f84fe76b 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2556,9 +2556,9 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 	mpz_clear(ff);
 
 	assert(sizeof(data) * BITS_PER_BYTE >= masklen);
-	mpz_export_data(data, bitmask, BYTEORDER_HOST_ENDIAN, sizeof(data));
+	mpz_export_data(data, bitmask, payload->byteorder, payload_byte_size);
 	mask = constant_expr_alloc(&payload->location, expr_basetype(payload),
-				   BYTEORDER_HOST_ENDIAN, masklen, data);
+				   payload->byteorder, masklen, data);
 	mpz_clear(bitmask);
 
 	payload_bytes = payload_expr_alloc(&payload->location, NULL, 0);
-- 
2.33.0

