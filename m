Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B990C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236518AbhKXR0J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236761AbhKXR0D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19B4C061714
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:22:53 -0800 (PST)
Received: from localhost ([::1]:44814 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvyt-000151-3V; Wed, 24 Nov 2021 18:22:51 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 3/7] set: Introduce NFTNL_SET_DESC_CONCAT_DATA
Date:   Wed, 24 Nov 2021 18:22:38 +0100
Message-Id: <20211124172242.11402-4-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172242.11402-1-phil@nwl.cc>
References: <20211124172242.11402-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Analogous to NFTNL_SET_DESC_CONCAT, introduce a data structure
describing individual data lengths of elements' concatenated data
fields.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/set.h | 1 +
 include/set.h          | 2 ++
 src/set.c              | 8 ++++++++
 3 files changed, 11 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 1ffb6c415260d..958bbc9065f67 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -33,6 +33,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_EXPR,
 	NFTNL_SET_EXPRESSIONS,
 	NFTNL_SET_DESC_BYTEORDER,
+	NFTNL_SET_DESC_CONCAT_DATA,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 816bd24faf651..a9f6225401a4e 100644
--- a/include/set.h
+++ b/include/set.h
@@ -28,6 +28,8 @@ struct nftnl_set {
 		uint32_t	byteorder;
 		uint8_t		field_len[NFT_REG32_COUNT];
 		uint8_t		field_count;
+		uint8_t		data_len[NFT_REG32_COUNT];
+		uint8_t		data_count;
 	} desc;
 	struct list_head	element_list;
 
diff --git a/src/set.c b/src/set.c
index 651eaf5503dee..e793282175eb5 100644
--- a/src/set.c
+++ b/src/set.c
@@ -100,6 +100,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 	case NFTNL_SET_TIMEOUT:
 	case NFTNL_SET_GC_INTERVAL:
 	case NFTNL_SET_DESC_BYTEORDER:
+	case NFTNL_SET_DESC_CONCAT_DATA:
 		break;
 	case NFTNL_SET_USERDATA:
 		xfree(s->user.data);
@@ -221,6 +222,10 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	case NFTNL_SET_DESC_BYTEORDER:
 		s->desc.byteorder = *(uint32_t *)data;
 		break;
+	case NFTNL_SET_DESC_CONCAT_DATA:
+		memcpy(&s->desc.data_len, data, data_len);
+		while (s->desc.data_len[++s->desc.data_count]);
+		break;
 	}
 	s->flags |= (1 << attr);
 	return 0;
@@ -318,6 +323,9 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	case NFTNL_SET_DESC_BYTEORDER:
 		*data_len = sizeof(uint32_t);
 		return &s->desc.byteorder;
+	case NFTNL_SET_DESC_CONCAT_DATA:
+		*data_len = s->desc.data_count;
+		return s->desc.data_len;
 	}
 	return NULL;
 }
-- 
2.33.0

