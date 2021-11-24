Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86DAC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbhKXR0g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhKXR0g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91447C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:23:26 -0800 (PST)
Received: from localhost ([::1]:44850 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvzQ-000171-S4; Wed, 24 Nov 2021 18:23:24 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/7] set: Introduce NFTNL_SET_DESC_BYTEORDER
Date:   Wed, 24 Nov 2021 18:22:37 +0100
Message-Id: <20211124172242.11402-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172242.11402-1-phil@nwl.cc>
References: <20211124172242.11402-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This attribute allows to specify byteorder of data stored in this set's
elements.

In general, elements make use of up to three nftnl_data_reg unions: one
for the key, one for the data (with maps) and one for key_end (with
concatenated ranges). Byteorder of key and key_end is always identical.

To represent byteorder of a data_reg, 16bits are needed: each marking
whether the field at same position in 'val' array is network or host
byteorder. So for storing elements' data byteorder, a single 32bit
variable is sufficient.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/set.h | 1 +
 include/set.h          | 1 +
 src/set.c              | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index e2e5795aa9b40..1ffb6c415260d 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -32,6 +32,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_DESC_CONCAT,
 	NFTNL_SET_EXPR,
 	NFTNL_SET_EXPRESSIONS,
+	NFTNL_SET_DESC_BYTEORDER,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 55018b6b9ba95..816bd24faf651 100644
--- a/include/set.h
+++ b/include/set.h
@@ -25,6 +25,7 @@ struct nftnl_set {
 	enum nft_set_policies	policy;
 	struct {
 		uint32_t	size;
+		uint32_t	byteorder;
 		uint8_t		field_len[NFT_REG32_COUNT];
 		uint8_t		field_count;
 	} desc;
diff --git a/src/set.c b/src/set.c
index c46f8277ff687..651eaf5503dee 100644
--- a/src/set.c
+++ b/src/set.c
@@ -99,6 +99,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_DESC_CONCAT:
 	case NFTNL_SET_TIMEOUT:
 	case NFTNL_SET_GC_INTERVAL:
+	case NFTNL_SET_DESC_BYTEORDER:
 		break;
 	case NFTNL_SET_USERDATA:
 		xfree(s->user.data);
@@ -128,6 +129,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] = {
 	[NFTNL_SET_DESC_SIZE]	= sizeof(uint32_t),
 	[NFTNL_SET_TIMEOUT]		= sizeof(uint64_t),
 	[NFTNL_SET_GC_INTERVAL]	= sizeof(uint32_t),
+	[NFTNL_SET_DESC_BYTEORDER]	= sizeof(uint32_t),
 };
 
 EXPORT_SYMBOL(nftnl_set_set_data);
@@ -216,6 +218,9 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		expr = (void *)data;
 		list_add(&expr->head, &s->expr_list);
 		break;
+	case NFTNL_SET_DESC_BYTEORDER:
+		s->desc.byteorder = *(uint32_t *)data;
+		break;
 	}
 	s->flags |= (1 << attr);
 	return 0;
@@ -310,6 +315,9 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 		list_for_each_entry(expr, &s->expr_list, head)
 			break;
 		return expr;
+	case NFTNL_SET_DESC_BYTEORDER:
+		*data_len = sizeof(uint32_t);
+		return &s->desc.byteorder;
 	}
 	return NULL;
 }
-- 
2.33.0

