Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC86C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 12:41:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjJWMl2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 08:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjJWMl2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 08:41:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B94C4
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 05:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698064839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=k05Mnf1Tedf7K2flpeGT8J6E/lihuvOZdrw6g/1ZJBM=;
        b=jOG/g7vsVE+zSd0MZSQG9Wq6MlsHVlVFxLvMABHXGeHoYI6Zh9ueVAuBrZw6uCQv6FfM22
        vdLokW5ZRb+OzM7qE21n9lnwIf3VJTKTXBKGwbmBGa/YtDzgbFRxqk3PlJmzQiDUwztgZO
        ZzcHu7e8ozA1WMhgZaAiyYA2cDh+1wo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-IC17yrEdPSyTjTN6ht_1zA-1; Mon, 23 Oct 2023 08:40:38 -0400
X-MC-Unique: IC17yrEdPSyTjTN6ht_1zA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 371EF867902
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 12:40:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A867340C6F79;
        Mon, 23 Oct 2023 12:40:37 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft] tests/shell: add missing "elem_opts_compat_0.nodump" file
Date:   Mon, 23 Oct 2023 14:40:25 +0200
Message-ID: <20231023124026.3951248-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an inconsistency. The test should have either a .nft or a
.nodump file. "./tools/check-tree.sh" enforces that and will in the
future run by `make check`.

Fixes: 22fab8681a50 ('parser_bison: Fix for broken compatibility with older dumps')
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/testcases/sets/dumps/elem_opts_compat_0.nodump | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 tests/shell/testcases/sets/dumps/elem_opts_compat_0.nodump

diff --git a/tests/shell/testcases/sets/dumps/elem_opts_compat_0.nodump b/tests/shell/testcases/sets/dumps/elem_opts_compat_0.nodump
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.41.0

