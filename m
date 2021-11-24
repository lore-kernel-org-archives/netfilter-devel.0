Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623B3C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbhKXR01 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237309AbhKXR0Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:25 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6200CC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:23:15 -0800 (PST)
Received: from localhost ([::1]:44838 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvzF-00016H-Na; Wed, 24 Nov 2021 18:23:13 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 5/7] data_reg: Respect each value's size
Date:   Wed, 24 Nov 2021 18:22:40 +0100
Message-Id: <20211124172242.11402-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172242.11402-1-phil@nwl.cc>
References: <20211124172242.11402-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To consistently print reg->val fields on different architectures, length
of data in each field is relevant, because nftables simply casts u32
fields to the desired size value.

Prepare nftnl_data_reg_value_snprintf_default() to accept a u8 array
holding each rev->val field's size. This is compatible to data in struct
nftnl_set's 'desc' field.

Introduce print_data() which prints the relevant bytes of a given
reg->val field depending on data and host byte order, skipping leading
zeroes while doing so.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/data_reg.c | 61 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 289443b47f9d6..6cbf0c4860cda 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -24,24 +24,64 @@
 #include <libnftnl/rule.h>
 #include "internal.h"
 
+/* return true if running on Big Endian */
+static bool host_is_be(void)
+{
+	const unsigned int i = 1;
+
+	return !*(uint8_t *)&i;
+}
+
+static int
+print_data(char *buf, size_t size, uint8_t *data, size_t len, bool nbo)
+{
+	int ret, offset = 0, j, start = 0, end = len, inc = 1;
+
+	/* on Little Endian with data in host byte order, reverse direction */
+	if (!nbo && !host_is_be()) {
+		start = len - 1;
+		end = -1;
+		inc = -1;
+	}
+
+	/* skip over leading nul bytes */
+	for (j = start; j != end - inc && !data[j]; j += inc)
+		;
+
+	/* print all remaining bytes with leading zero */
+	for (; j != end; j += inc) {
+		ret = snprintf(buf + offset, size, "%.2x", data[j]);
+		SNPRINTF_BUFFER_SIZE(ret, size, offset);
+	}
+	return offset;
+}
+
 static int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      const union nftnl_data_reg *reg,
-				      uint32_t flags, uint16_t byteorder_bits)
+				      uint32_t flags, uint16_t byteorder_bits,
+				      const uint8_t *lengths)
 {
-	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
+	uint8_t lengths_fallback = reg->len;
+	const uint8_t *lenp = lengths;
 	int offset = 0, ret, i;
-	uint32_t value;
 
+	if (!lengths || !lengths[0])
+		lenp = &lengths_fallback;
 
+	for (i = 0; i * 4 < reg->len; i += div_round_up(*lenp++, 4)) {
 
-	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		if (byteorder_bits & (1 << i))
-			value = ntohl(reg->val[i]);
-		else
-			value = reg->val[i];
+		if (!(flags & DATA_F_NOPFX)) {
+			ret = snprintf(buf + offset, remain, "0x");
+			SNPRINTF_BUFFER_SIZE(ret, remain, offset);
+		}
+
+		ret = print_data(buf + offset, remain,
+				 (uint8_t *)(reg->val + i),
+				 *lenp, byteorder_bits & (1 << i));
+		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = snprintf(buf + offset, remain, "%s%.8x ", pfx, value);
+		ret = snprintf(buf + offset, remain, " ");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
@@ -77,7 +117,8 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 	case DATA_VALUE:
 		return nftnl_data_reg_value_snprintf_default(buf, size,
 							     reg, flags,
-							     byteorder_bits);
+							     byteorder_bits,
+							     NULL);
 	case DATA_VERDICT:
 	case DATA_CHAIN:
 		return nftnl_data_reg_verdict_snprintf_def(buf, size,
-- 
2.33.0

