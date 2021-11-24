Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98EBFC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbhKXR1e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237938AbhKXR1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:27:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F8AC06173E
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:13 -0800 (PST)
Received: from localhost ([::1]:44886 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0B-000191-95; Wed, 24 Nov 2021 18:24:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 07/15] datatype: Fix size of time_type
Date:   Wed, 24 Nov 2021 18:22:43 +0100
Message-Id: <20211124172251.11539-8-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Used by 'ct expiration', time_type is supposed to be 32bits. Passing a
64bits variable to constant_expr_alloc() causes the value to be always
zero on Big Endian.

Fixes: 0974fa84f162a ("datatype: seperate time parsing/printing from time_type")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/datatype.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index a06c39960fa0c..b2e667cef2c62 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1068,6 +1068,7 @@ static struct error_record *time_type_parse(struct parse_ctx *ctx,
 					    struct expr **res)
 {
 	struct error_record *erec;
+	uint32_t s32;
 	uint64_t s;
 
 	erec = time_parse(&sym->location, sym->identifier, &s);
@@ -1077,9 +1078,10 @@ static struct error_record *time_type_parse(struct parse_ctx *ctx,
 	if (s > UINT32_MAX)
 		return error(&sym->location, "value too large");
 
+	s32 = s;
 	*res = constant_expr_alloc(&sym->location, &time_type,
 				   BYTEORDER_HOST_ENDIAN,
-				   sizeof(uint32_t) * BITS_PER_BYTE, &s);
+				   sizeof(uint32_t) * BITS_PER_BYTE, &s32);
 	return NULL;
 }
 
@@ -1088,7 +1090,7 @@ const struct datatype time_type = {
 	.name		= "time",
 	.desc		= "relative time",
 	.byteorder	= BYTEORDER_HOST_ENDIAN,
-	.size		= 8 * BITS_PER_BYTE,
+	.size		= 4 * BITS_PER_BYTE,
 	.basetype	= &integer_type,
 	.print		= time_type_print,
 	.json		= time_type_json,
-- 
2.33.0

