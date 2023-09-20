Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3CD1CE79DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbjITObI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbjITObH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:31:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90640DC
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zQh0BXkoAISyWhHgK1gPnvdSusXVryCBQEBcFr1yO5s=;
        b=PbngZGXqbtHe04Hc92cWIiux7ClFO2ccHHZt9nZVuBhCkum4ej7CuUqqlssNWTXzGbCswV
        rnMyKhUsJOJvYiXtP0m/Ner7zQyVA8YZ1UfQMpAjKYK60LKiAV/KjYL5Bwmt1Bl5r5ZemO
        cMm83gfYUB7uM2S25Gs3gxtFPPWGRUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-675enwkXP36XsUTVXPPsfw-1; Wed, 20 Sep 2023 10:30:15 -0400
X-MC-Unique: 675enwkXP36XsUTVXPPsfw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1C43D101AA6E
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:15 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E1781004145;
        Wed, 20 Sep 2023 14:30:14 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 6/9] netlink: handle invalid etype in set_make_key()
Date:   Wed, 20 Sep 2023 16:26:07 +0200
Message-ID: <20230920142958.566615-7-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It's not clear to me, what ensures that the etype is always valid.
Handle a NULL.

Fixes: 6e48df5329ea ('src: add "typeof" build/parse/print support')

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 2489e9864151..70ebf382b14f 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -896,6 +896,8 @@ static struct expr *set_make_key(const struct nftnl_udata *attr)
 
 	etype = nftnl_udata_get_u32(ud[NFTNL_UDATA_SET_TYPEOF_EXPR]);
 	ops = expr_ops_by_type(etype);
+	if (!ops)
+		return NULL;
 
 	expr = ops->parse_udata(ud[NFTNL_UDATA_SET_TYPEOF_DATA]);
 	if (!expr)
-- 
2.41.0

