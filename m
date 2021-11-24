Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FB2C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbhKXR0n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhKXR0m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:42 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 427BBC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:23:32 -0800 (PST)
Received: from localhost ([::1]:44856 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvzW-00017d-HT; Wed, 24 Nov 2021 18:23:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 6/7] include: Introduce and publish struct nftnl_set_desc
Date:   Wed, 24 Nov 2021 18:22:41 +0100
Message-Id: <20211124172242.11402-7-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172242.11402-1-phil@nwl.cc>
References: <20211124172242.11402-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This embedded struct in struct nftnl_set holds useful info about data in
elements. Export it to users for later use as parameter to API
functions.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/set.h | 10 ++++++++++
 include/set.h          | 10 ++--------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 958bbc9065f67..d19635716b581 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -7,6 +7,7 @@
 #include <sys/types.h>
 
 #include <libnftnl/common.h>
+#include <linux/netfilter/nf_tables.h>
 
 #ifdef __cplusplus
 extern "C" {
@@ -38,6 +39,15 @@ enum nftnl_set_attr {
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
 
+struct nftnl_set_desc {
+	uint32_t	size;
+	uint32_t	byteorder;
+	uint8_t		field_len[NFT_REG32_COUNT];
+	uint8_t		field_count;
+	uint8_t		data_len[NFT_REG32_COUNT];
+	uint8_t		data_count;
+};
+
 struct nftnl_set;
 
 struct nftnl_set *nftnl_set_alloc(void);
diff --git a/include/set.h b/include/set.h
index a9f6225401a4e..42e761a2a22bf 100644
--- a/include/set.h
+++ b/include/set.h
@@ -2,6 +2,7 @@
 #define _LIBNFTNL_SET_INTERNAL_H_
 
 #include <linux/netfilter/nf_tables.h>
+#include <libnftnl/set.h>
 
 struct nftnl_set {
 	struct list_head	head;
@@ -23,14 +24,7 @@ struct nftnl_set {
 	} user;
 	uint32_t		id;
 	enum nft_set_policies	policy;
-	struct {
-		uint32_t	size;
-		uint32_t	byteorder;
-		uint8_t		field_len[NFT_REG32_COUNT];
-		uint8_t		field_count;
-		uint8_t		data_len[NFT_REG32_COUNT];
-		uint8_t		data_count;
-	} desc;
+	struct nftnl_set_desc	desc;
 	struct list_head	element_list;
 
 	uint32_t		flags;
-- 
2.33.0

