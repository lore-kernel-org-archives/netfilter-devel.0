Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8AAC83F1B
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbjH2S4s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238251AbjH2S4S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FCDCC0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+e1Una0iPBy/VDnfMKiGFgmOTBCBEJA7xgcgw066YGU=;
        b=TeBecFU2hdD2iv0RgcymUOnhlaigdXSNETc1vQJL+LDYH39RUIs+v332n0iKCP4upp+9kG
        7//6FOCBuzjaC9/ovR+/TH+PQurQovft4TUory7EnrbzCarmnjiQ71Z2S29vhM7h8aFHL3
        rTrGZv0to2MZgwtw3BFHZDjpLJEQIrA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-U2L2CE3SNy2SDhJEqmWgZQ-1; Tue, 29 Aug 2023 14:55:28 -0400
X-MC-Unique: U2L2CE3SNy2SDhJEqmWgZQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23B68101A52E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 18:55:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98409401E54;
        Tue, 29 Aug 2023 18:55:27 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/5] xt: avoid "-Wmissing-field-initializers" for "original_opts"
Date:   Tue, 29 Aug 2023 20:54:10 +0200
Message-ID: <20230829185509.374614-5-thaller@redhat.com>
In-Reply-To: <20230829185509.374614-1-thaller@redhat.com>
References: <20230829185509.374614-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Avoid this warning with clang:

      CC       src/xt.lo
    src/xt.c:353:9: error: missing field 'has_arg' initializer [-Werror,-Wmissing-field-initializers]
            { NULL },
                   ^

The warning seems not very useful, because it's well understood that
specifying only some initializers leaves the remaining fields
initialized with the default. However, as this warning is only hit once
in the code base, it doesn't seem that we violate this style frequently.
Hence, fix it instead of disabling the warning.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/xt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/xt.c b/src/xt.c
index df7140b4fa97..a217cc7b6bd0 100644
--- a/src/xt.c
+++ b/src/xt.c
@@ -350,7 +350,7 @@ err:
 }
 
 static struct option original_opts[] = {
-	{ NULL },
+	{ },
 };
 
 static struct xtables_globals xt_nft_globals = {
-- 
2.41.0

