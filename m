Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488BCC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 18:25:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjKHSZb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjKHSZa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 13:25:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEAFC1FFB
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 10:24:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699467885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1SXFKCpkPfe0dfbeK33H69/kHQSMpYYTr0IMU5B4bfA=;
        b=cI2EGRE+H40UNOvQ0k4msV2u9XGMWdUjT+rJChVxNm29TlKV+q7gkRDqCkdE/SdfrJkinc
        EkdJMstmxVs76XaYWT+G85Gjhybw3UbhfbXN4XJO6Ws3SYflw+pGlLJIMLOoO/WzTUVG70
        rORhs4LAVE8If9e2SINiCJ5NJB9rL8I=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-w5R0L4cSM0iYVxkM15yXsA-1; Wed,
 08 Nov 2023 13:24:43 -0500
X-MC-Unique: w5R0L4cSM0iYVxkM15yXsA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5319F3C025B4
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 18:24:43 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C7CD61C060AE;
        Wed,  8 Nov 2023 18:24:42 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 2/2] netlink: add and use _nftnl_udata_buf_alloc() helper
Date:   Wed,  8 Nov 2023 19:24:25 +0100
Message-ID: <20231108182431.4005745-2-thaller@redhat.com>
In-Reply-To: <20231108182431.4005745-1-thaller@redhat.com>
References: <20231108182431.4005745-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We don't want to handle allocation errors, but crash via memory_allocation_error().
Also, we usually just allocate NFT_USERDATA_MAXLEN buffers.

Add a helper for that and use it.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/netlink.h       |  3 +++
 src/mnl.c               | 16 ++++------------
 src/netlink.c           |  7 ++-----
 src/netlink_linearize.c |  4 +---
 4 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/include/netlink.h b/include/netlink.h
index 6766d7e8563f..15cbb332c8dd 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -260,4 +260,7 @@ struct nft_expr_loc *nft_expr_loc_find(const struct nftnl_expr *nle,
 
 struct dl_proto_ctx *dl_proto_ctx(struct rule_pp_ctx *ctx);
 
+#define _nftnl_udata_buf_alloc() \
+	memory_allocation_check(nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN))
+
 #endif /* NFTABLES_NETLINK_H */
diff --git a/src/mnl.c b/src/mnl.c
index 0fb36bd588ee..1263c611cd20 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -823,9 +823,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 					    CHAIN_F_HW_OFFLOAD);
 		}
 		if (cmd->chain->comment) {
-			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-			if (!udbuf)
-				memory_allocation_error();
+			udbuf = _nftnl_udata_buf_alloc();
 			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_CHAIN_COMMENT, cmd->chain->comment))
 				memory_allocation_error();
 			nftnl_chain_set_data(nlc, NFTNL_CHAIN_USERDATA, nftnl_udata_buf_data(udbuf),
@@ -1057,9 +1055,7 @@ int mnl_nft_table_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_table_set_u32(nlt, NFTNL_TABLE_FLAGS, cmd->table->flags);
 
 		if (cmd->table->comment) {
-			udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-			if (!udbuf)
-				memory_allocation_error();
+			udbuf = _nftnl_udata_buf_alloc();
 			if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_TABLE_COMMENT, cmd->table->comment))
 				memory_allocation_error();
 			nftnl_table_set_data(nlt, NFTNL_TABLE_USERDATA, nftnl_udata_buf_data(udbuf),
@@ -1256,9 +1252,7 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		nftnl_set_set_u32(nls, NFTNL_SET_DESC_SIZE, set->init->size);
 	}
 
-	udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-	if (!udbuf)
-		memory_allocation_error();
+	udbuf = _nftnl_udata_buf_alloc();
 	if (!nftnl_udata_put_u32(udbuf, NFTNL_UDATA_SET_KEYBYTEORDER,
 				 set->key->byteorder))
 		memory_allocation_error();
@@ -1453,9 +1447,7 @@ int mnl_nft_obj_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	nftnl_obj_set_u32(nlo, NFTNL_OBJ_TYPE, obj->type);
 
 	if (obj->comment) {
-		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-		if (!udbuf)
-			memory_allocation_error();
+		udbuf = _nftnl_udata_buf_alloc();
 		if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_OBJ_COMMENT, obj->comment))
 			memory_allocation_error();
 		nftnl_obj_set_data(nlo, NFTNL_OBJ_USERDATA, nftnl_udata_buf_data(udbuf),
diff --git a/src/netlink.c b/src/netlink.c
index 120a8ba9ceb1..0c858065ca15 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -175,11 +175,8 @@ struct nftnl_set_elem *alloc_nftnl_setelem(const struct expr *set,
 						netlink_gen_stmt_stateful(stmt));
 		}
 	}
-	if (elem->comment || expr->elem_flags) {
-		udbuf = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-		if (!udbuf)
-			memory_allocation_error();
-	}
+	if (elem->comment || expr->elem_flags)
+		udbuf = _nftnl_udata_buf_alloc();
 	if (elem->comment) {
 		if (!nftnl_udata_put_strz(udbuf, NFTNL_UDATA_SET_ELEM_COMMENT,
 					  elem->comment))
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 0c62341112d8..b5adc4d186c8 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1760,9 +1760,7 @@ void netlink_linearize_rule(struct netlink_ctx *ctx,
 	if (rule->comment) {
 		struct nftnl_udata_buf *udata;
 
-		udata = nftnl_udata_buf_alloc(NFT_USERDATA_MAXLEN);
-		if (!udata)
-			memory_allocation_error();
+		udata = _nftnl_udata_buf_alloc();
 
 		if (!nftnl_udata_put_strz(udata, NFTNL_UDATA_RULE_COMMENT,
 					  rule->comment))
-- 
2.41.0

