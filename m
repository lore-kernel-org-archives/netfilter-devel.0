Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44EB8CE79DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjITObF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjITObE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B14AF
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AQwjpHFyh8Go993JjGjCb2tli6a3bFFw08ufEAyCiRU=;
        b=V1DMkJY0F7aGmEmQYniY8+wwcwlWh23IjqfWYXp3ffyqqQE3zhWGUpbFJQKqvfNZaLVxFB
        oDYS2NhQzQ0iWWwOJ6XRQJiZ5lp1+q4tV/S2Wa3dv0THBqInaZ2fNIjmMs4WVLYIX/DN/c
        Klk2NS336L5gIK2nbmDhQ+qtSwUm3yY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-222-mlDlgLFiMAuK1q4RnkSVdw-1; Wed, 20 Sep 2023 10:30:12 -0400
X-MC-Unique: mlDlgLFiMAuK1q4RnkSVdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE7D81C08971
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DC561004145;
        Wed, 20 Sep 2023 14:30:11 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/9] include: fix missing definitions in <cache.h>/<headers.h>
Date:   Wed, 20 Sep 2023 16:26:03 +0200
Message-ID: <20230920142958.566615-3-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The headers should be self-contained so they can be included in any
order. With exception of <nft.h>, which any internal header can rely on.

Some fixes for <cache.h>/<headers.h>.

In case of <cache.h>, forward declare some of the structs instead of
including the headers. <headers.h> uses struct in6_addr.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/cache.h   | 9 +++++++++
 include/headers.h | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/include/cache.h b/include/cache.h
index 934c3a74fa95..e66b0af5fe0f 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -3,6 +3,8 @@
 
 #include <string.h>
 
+#include <list.h>
+
 struct handle;
 
 enum cache_level_bits {
@@ -66,6 +68,7 @@ struct nft_cache_filter {
 };
 
 struct nft_cache;
+struct nft_ctx;
 enum cmd_ops;
 
 int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
@@ -97,6 +100,8 @@ void chain_cache_add(struct chain *chain, struct table *table);
 void chain_cache_del(struct chain *chain);
 struct chain *chain_cache_find(const struct table *table, const char *name);
 
+struct set;
+
 void set_cache_add(struct set *set, struct table *table);
 void set_cache_del(struct set *set);
 struct set *set_cache_find(const struct table *table, const char *name);
@@ -121,6 +126,8 @@ void table_cache_del(struct table *table);
 struct table *table_cache_find(const struct cache *cache, const char *name,
 			       uint32_t family);
 
+struct obj;
+
 void obj_cache_add(struct obj *obj, struct table *table);
 void obj_cache_del(struct obj *obj);
 struct obj *obj_cache_find(const struct table *table, const char *name,
@@ -138,6 +145,8 @@ struct nft_cache {
 	uint32_t		flags;
 };
 
+struct netlink_ctx;
+
 void nft_chain_cache_update(struct netlink_ctx *ctx, struct table *table,
 			    const char *chain);
 
diff --git a/include/headers.h b/include/headers.h
index 759f93bf8c7a..13324c72c734 100644
--- a/include/headers.h
+++ b/include/headers.h
@@ -1,6 +1,8 @@
 #ifndef NFTABLES_HEADERS_H
 #define NFTABLES_HEADERS_H
 
+#include <netinet/in.h>
+
 #ifndef IPPROTO_UDPLITE
 # define IPPROTO_UDPLITE	136
 #endif
-- 
2.41.0

