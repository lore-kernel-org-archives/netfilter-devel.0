Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD7BEEB64DA
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 08:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGJIu1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 04:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjGJIu0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 04:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC620EB
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 01:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688978984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrK0bEk9U4KbQbhep6tjHPvEYI2ac9y/DBwL5rTysTg=;
        b=PqOddfCnEFNxm0Vb+YvJBMLqaguuCYr/XzvvB1n2Nj71VIO36iSLfXnQ8B3pIAeZJxPHOJ
        dXCSrtrzXr3yXh+G4TgPaFIFo4UdtdsPW7beIcNGX45I9obQdpHIkeqgNDZjYEPMqjWBwd
        K1g5dg5GGFO0TPmNqfnfgMrYb5Q8Mdk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-5ViaI4yiMz-yKEdabRZnhw-1; Mon, 10 Jul 2023 04:49:42 -0400
X-MC-Unique: 5ViaI4yiMz-yKEdabRZnhw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3369C803FDC
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 08:49:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.41])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A483111DCE1;
        Mon, 10 Jul 2023 08:49:41 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH 2/4] libnftables: drop unused argument nf_sock from nft_netlink()
Date:   Mon, 10 Jul 2023 10:45:17 +0200
Message-ID: <20230710084926.172198-3-thaller@redhat.com>
In-Reply-To: <20230710084926.172198-1-thaller@redhat.com>
References: <20230710084926.172198-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/libnftables.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/libnftables.c b/src/libnftables.c
index 57e0fc77f989..5b3eb2dc3df4 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -17,8 +17,7 @@
 #include <string.h>
 
 static int nft_netlink(struct nft_ctx *nft,
-		       struct list_head *cmds, struct list_head *msgs,
-		       struct mnl_socket *nf_sock)
+		       struct list_head *cmds, struct list_head *msgs)
 {
 	uint32_t batch_seqnum, seqnum = 0, last_seqnum = UINT32_MAX, num_cmds = 0;
 	struct netlink_ctx ctx = {
@@ -595,7 +594,7 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		goto err;
 	}
 
-	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
+	if (nft_netlink(nft, &cmds, &msgs) != 0)
 		rc = -1;
 err:
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
@@ -691,7 +690,7 @@ static int __nft_run_cmd_from_filename(struct nft_ctx *nft, const char *filename
 		goto err;
 	}
 
-	if (nft_netlink(nft, &cmds, &msgs, nft->nf_sock) != 0)
+	if (nft_netlink(nft, &cmds, &msgs) != 0)
 		rc = -1;
 err:
 	erec_print_list(&nft->output, &msgs, nft->debug_mask);
-- 
2.41.0

