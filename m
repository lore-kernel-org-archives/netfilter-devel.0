Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0623FC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Nov 2023 18:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbjKHSX1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjKHSX1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Nov 2023 13:23:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A664C1FF5
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 10:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699467762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Jl3YWsyrlx5FOpPULAn/ttNJ0D3HgSlALeY4e6AjDhE=;
        b=GMO8GsEFZI62e4mu2u041IPB4nRf93u3FdyJsq8zdqQSd9ySsHSumFI1fw8STKK2D6hcPN
        SZ7i3U8SDwcS0pyE73cU7Ioxxy1JotwsO2xy4hFys/tjEsZcHYjV2apkbJHxC/l+s9bpwK
        N5JCL7urp4MAvT0nTBnpL6f5+cYelY4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220-ZYPYzGTlNKu1cSLBZvQQ3A-1; Wed,
 08 Nov 2023 13:22:41 -0500
X-MC-Unique: ZYPYzGTlNKu1cSLBZvQQ3A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55F8628211AC
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Nov 2023 18:22:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9B3A40C6EB9;
        Wed,  8 Nov 2023 18:22:40 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft] netlink: fix buffer size for user data in netlink_delinearize_chain()
Date:   Wed,  8 Nov 2023 19:22:20 +0100
Message-ID: <20231108182230.3999140-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The correct define is NFTNL_UDATA_CHAIN_MAX and not NFTNL_UDATA_OBJ_MAX.
In current libnftnl, they both are defined as 1, so (with current libnftnl)
there is no difference.

Fixes: 702ac2b72c0e ('src: add comment support for chains')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 2876ebad5a78..1d18280bb8c1 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -614,7 +614,7 @@ static int qsort_device_cmp(const void *a, const void *b)
 struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					const struct nftnl_chain *nlc)
 {
-	const struct nftnl_udata *ud[NFTNL_UDATA_OBJ_MAX + 1] = {};
+	const struct nftnl_udata *ud[NFTNL_UDATA_CHAIN_MAX + 1] = {};
 	int priority, policy, len = 0, i;
 	const char * const *dev_array;
 	struct chain *chain;
-- 
2.41.0

