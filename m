Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860F3E810DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 12:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjI0M2y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 08:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjI0M2x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 08:28:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110A1B4
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 05:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695817677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/WoX7hMD2Xi6obWGLLSBed0rjaGWuAmajGQNMIX5t5E=;
        b=IHPtalVVjasEAZy/2su+/F3X6nT0YDTqPkgx0G3llF1GtDpI4k/x3ocv28SQvlatXFPzlz
        2OvtuT1nlpB13g6czqTTpz/mSSz52JjSXUEKhPcrVaDdSATsfAdcIiwCp+X9xaBqwJGkcE
        cHWiz4kYlWkNdntpKlDm9c9VN6Q04mU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-XLmw7M7VPqKQqA-UeSwUeA-1; Wed, 27 Sep 2023 08:27:56 -0400
X-MC-Unique: XLmw7M7VPqKQqA-UeSwUeA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 131663821346
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 12:27:56 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81BC440C6EA8;
        Wed, 27 Sep 2023 12:27:55 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/3] nft: add NFT_ARRAY_SIZE() helper
Date:   Wed, 27 Sep 2023 14:23:26 +0200
Message-ID: <20230927122744.3434851-2-thaller@redhat.com>
In-Reply-To: <20230927122744.3434851-1-thaller@redhat.com>
References: <20230927122744.3434851-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add NFT_ARRAY_SIZE() macro, commonly known as ARRAY_SIZE() (or G_N_ELEMENTS()).

<nft.h> is the right place for macros and static-inline functions. It is
included in *every* C sources, as it only depends on libc headers and
<config.h>. NFT_ARRAY_SIZE() is part of the basic toolset, that should
be available everywhere.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/nft.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/nft.h b/include/nft.h
index 9384054c11c8..4463b5c0fa4a 100644
--- a/include/nft.h
+++ b/include/nft.h
@@ -8,4 +8,6 @@
 #include <stdint.h>
 #include <stdlib.h>
 
+#define NFT_ARRAY_SIZE(arr) (sizeof(arr)/sizeof((arr)[0]))
+
 #endif /* NFTABLES_NFT_H */
-- 
2.41.0

