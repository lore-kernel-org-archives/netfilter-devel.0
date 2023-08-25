Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6F0C7EE2C
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Aug 2023 11:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjHYLjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbjHYLjM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Aug 2023 07:39:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16ADB1FF7
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mES6hoywdT6ShITgghExWYaXm8mvb7LEsnDTYguFQys=;
        b=D3bnYDMez7KlOg/7kTbhwt1XfQR8Rj21AwGsCL1d1eBZlFXastRyXC0/3wB8PXo/zsjVCd
        yjQA+4q3zTk5EkWJ9mhjzCgf1PX3dzVVEXavTTgtwAvb1HkWLoocm94uErQHbnvN5I+VJZ
        b9j8GJRn5mre/MNSiRn1G52oyZX1Sm0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-ZSZ2a8ZEMdaWQJ0ADUb9qg-1; Fri, 25 Aug 2023 07:38:24 -0400
X-MC-Unique: ZSZ2a8ZEMdaWQJ0ADUb9qg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C1DA381AE57
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Aug 2023 11:38:24 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AF0791121319;
        Fri, 25 Aug 2023 11:38:23 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 3/6] include: don't define _GNU_SOURCE in public header
Date:   Fri, 25 Aug 2023 13:36:31 +0200
Message-ID: <20230825113810.2620133-4-thaller@redhat.com>
In-Reply-To: <20230825113810.2620133-1-thaller@redhat.com>
References: <20230825113810.2620133-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

_GNU_SOURCE is supposed to be defined as first thing, before including any
libc headers. Defining it in the public header of nftables is wrong, because
it would only (somewhat) work if the user includes the nftables header as first
thing too. But that is not what users commonly would do, in particular with
autotools projects, where users would include <config.h> first.

It's also unnecessary. Nothing in "nftables/libnftables.h" itself
requires _GNU_SOURCE. Drop it.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/nftables/libnftables.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index cc05969215bc..c1d48d765a42 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -9,7 +9,6 @@
 #ifndef LIB_NFTABLES_H
 #define LIB_NFTABLES_H
 
-#define _GNU_SOURCE
 #include <stdint.h>
 #include <stdio.h>
 #include <stdbool.h>
-- 
2.41.0

