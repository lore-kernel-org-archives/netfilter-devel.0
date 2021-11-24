Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8B7C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236761AbhKXR0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbhKXR0I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:08 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AE2C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:22:58 -0800 (PST)
Received: from localhost ([::1]:44820 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvyy-00015D-L8; Wed, 24 Nov 2021 18:22:56 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 4/7] data_reg: Support varying byteorder in concat data
Date:   Wed, 24 Nov 2021 18:22:39 +0100
Message-Id: <20211124172242.11402-5-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172242.11402-1-phil@nwl.cc>
References: <20211124172242.11402-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Byteorder may be different in each field of reg->val array. Pass a 16bit
value where each bit indicates the field value at same offset is in
network byte order.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/expr/data_reg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 789958ea66c0d..289443b47f9d6 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -27,8 +27,7 @@
 static int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      const union nftnl_data_reg *reg,
-				      uint32_t flags,
-				      enum nftnl_byteorder byteorder)
+				      uint32_t flags, uint16_t byteorder_bits)
 {
 	const char *pfx = flags & DATA_F_NOPFX ? "" : "0x";
 	int offset = 0, ret, i;
@@ -37,7 +36,7 @@ nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 
 
 	for (i = 0; i < div_round_up(reg->len, sizeof(uint32_t)); i++) {
-		if (byteorder == NFTNL_BYTEORDER_NETWORK)
+		if (byteorder_bits & (1 << i))
 			value = ntohl(reg->val[i]);
 		else
 			value = reg->val[i];
@@ -72,11 +71,13 @@ int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    uint32_t flags, int reg_type,
 			    enum nftnl_byteorder byteorder)
 {
+	uint16_t byteorder_bits = byteorder == NFTNL_BYTEORDER_NETWORK ? -1 : 0;
+
 	switch(reg_type) {
 	case DATA_VALUE:
 		return nftnl_data_reg_value_snprintf_default(buf, size,
 							     reg, flags,
-							     byteorder);
+							     byteorder_bits);
 	case DATA_VERDICT:
 	case DATA_CHAIN:
 		return nftnl_data_reg_verdict_snprintf_def(buf, size,
-- 
2.33.0

