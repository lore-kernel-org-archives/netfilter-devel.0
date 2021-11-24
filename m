Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02B0AC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbhKXR2B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240975AbhKXR2B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9CCC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:24:51 -0800 (PST)
Received: from localhost ([::1]:44928 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpw0n-0001C1-Ll; Wed, 24 Nov 2021 18:24:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 06/15] meta: Fix hour_type size
Date:   Wed, 24 Nov 2021 18:22:42 +0100
Message-Id: <20211124172251.11539-7-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172251.11539-1-phil@nwl.cc>
References: <20211124172251.11539-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In kernel as well as when parsing, hour_type is assumed to be 32bits.
Having the struct datatype field set to 64bits breaks Big Endian and so
does passing a 64bit value and 32 as length to constant_expr_alloc() as
it makes it import the upper 32bits. Fix this by turning 'result' into a
uint32_t and introduce a temporary uint64_t just for the call to
time_parse() which expects that.

Fixes: f8f32deda31df ("meta: Introduce new conditions 'time', 'day' and 'hour'")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/meta.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 1794495ebba1c..23b1fd2759483 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -516,7 +516,8 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 {
 	struct error_record *er;
 	struct tm tm, *cur_tm;
-	uint64_t result = 0;
+	uint32_t result;
+	uint64_t tmp;
 	char *endptr;
 	time_t ts;
 
@@ -544,8 +545,8 @@ static struct error_record *hour_type_parse(struct parse_ctx *ctx,
 	if (endptr && *endptr)
 		return error(&sym->location, "Can't parse trailing input: \"%s\"\n", endptr);
 
-	if ((er = time_parse(&sym->location, sym->identifier, &result)) == NULL) {
-		result /= 1000;
+	if ((er = time_parse(&sym->location, sym->identifier, &tmp)) == NULL) {
+		result = tmp / 1000;
 		goto convert;
 	}
 
@@ -599,7 +600,7 @@ const struct datatype hour_type = {
 	.name = "hour",
 	.desc = "Hour of day of packet reception",
 	.byteorder = BYTEORDER_HOST_ENDIAN,
-	.size = sizeof(uint64_t) * BITS_PER_BYTE,
+	.size = sizeof(uint32_t) * BITS_PER_BYTE,
 	.basetype = &integer_type,
 	.print = hour_type_print,
 	.parse = hour_type_parse,
-- 
2.33.0

