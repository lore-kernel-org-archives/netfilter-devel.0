Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CD3EEAA44
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Sep 2023 14:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbjINOK5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Sep 2023 10:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239724AbjINOK5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Sep 2023 10:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 381EDDF
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 07:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694700605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qF3efPGwetE/9xNcIyNlpD7+BtwbkucBiwmooctqHHY=;
        b=L/+wvdXm4OBKhcRMeoOpITgyrNuRQ5dOhJwhXTiD5Xyl5nldpah/d2AsLYIC0hWNOKAg+0
        aZVTtYGHXOEGCLLmylMprE/GveIlTt4XlBwJU1peFbPfGcbJ/ozA31iUblymgLlQKm/DKD
        K/8AQYUX7+osV6KMbnToDTESsGbNEB4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-533-KpP25bMkM0aDR473timupA-1; Thu, 14 Sep 2023 10:10:03 -0400
X-MC-Unique: KpP25bMkM0aDR473timupA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1717D88B7A8
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Sep 2023 14:10:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 89CB140C6EA8;
        Thu, 14 Sep 2023 14:10:02 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/1] netlink: fix leaking typeof_expr_data/typeof_expr_key in netlink_delinearize_set()
Date:   Thu, 14 Sep 2023 16:09:50 +0200
Message-ID: <20230914140952.4177765-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are various code paths that return without freeing typeof_expr_data
and typeof_expr_key. It's not at all obvious, that there isn't a leak
that way. Quite possibly there is a leak. Fix it, or at least make the
code more obviously correct.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/netlink.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 4d3c1cf1505d..2489e9864151 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -937,12 +937,13 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	const struct nftnl_udata *ud[NFTNL_UDATA_SET_MAX + 1] = {};
 	enum byteorder keybyteorder = BYTEORDER_INVALID;
 	enum byteorder databyteorder = BYTEORDER_INVALID;
-	struct expr *typeof_expr_key, *typeof_expr_data;
 	struct setelem_parse_ctx set_parse_ctx;
 	const struct datatype *datatype = NULL;
 	const struct datatype *keytype = NULL;
 	const struct datatype *dtype2 = NULL;
 	const struct datatype *dtype = NULL;
+	struct expr *typeof_expr_data = NULL;
+	struct expr *typeof_expr_key = NULL;
 	const char *udata, *comment = NULL;
 	uint32_t flags, key, objtype = 0;
 	uint32_t data_interval = 0;
@@ -951,9 +952,6 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	uint32_t ulen;
 	uint32_t klen;
 
-	typeof_expr_key = NULL;
-	typeof_expr_data = NULL;
-
 	if (nftnl_set_is_set(nls, NFTNL_SET_USERDATA)) {
 		udata = nftnl_set_get_data(nls, NFTNL_SET_USERDATA, &ulen);
 		if (nftnl_udata_parse(udata, ulen, set_parse_udata_cb, ud) < 0) {
@@ -1043,8 +1041,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 		if (set_udata_key_valid(typeof_expr_data, dlen)) {
 			typeof_expr_data->len = klen;
 			set->data = typeof_expr_data;
+			typeof_expr_data = NULL;
 		} else {
-			expr_free(typeof_expr_data);
 			set->data = constant_expr_alloc(&netlink_location,
 							dtype2,
 							databyteorder, klen,
@@ -1064,9 +1062,9 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 
 	if (set_udata_key_valid(typeof_expr_key, klen)) {
 		set->key = typeof_expr_key;
+		typeof_expr_key = NULL;
 		set->key_typeof_valid = true;
 	} else {
-		expr_free(typeof_expr_key);
 		set->key = constant_expr_alloc(&netlink_location, dtype,
 					       keybyteorder, klen,
 					       NULL);
@@ -1100,6 +1098,8 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
 	}
 
 out:
+	expr_free(typeof_expr_data);
+	expr_free(typeof_expr_key);
 	datatype_free(datatype);
 	datatype_free(keytype);
 	datatype_free(dtype2);
-- 
2.41.0

