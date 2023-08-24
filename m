Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78488C6FA8F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbjHXLQc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241015AbjHXLQR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:16:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325681BC3
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692875713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mES6hoywdT6ShITgghExWYaXm8mvb7LEsnDTYguFQys=;
        b=S/Wu3zNfN2cGAMwHGxRWNlHE9ZGG3fwlwwwpxvM8jtdjg50o1CiRL3L7Slys8BGRHq6ud4
        3YfG38I8BFdGwyzsIVb7SC4sZnORbnUyeTKYfnlG1UYrFYXccEO0QGra00gc8CTtUvWHB5
        DZjetAq1ksiribM2AW1T6v9sH3WGoxY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-9l-Yh9qfN9eIzXmxwN7yRw-1; Thu, 24 Aug 2023 07:15:11 -0400
X-MC-Unique: 9l-Yh9qfN9eIzXmxwN7yRw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23438101A528
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 11:15:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 96034C1602B;
        Thu, 24 Aug 2023 11:15:10 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 3/6] include: don't define _GNU_SOURCE in public header
Date:   Thu, 24 Aug 2023 13:13:31 +0200
Message-ID: <20230824111456.2005125-4-thaller@redhat.com>
In-Reply-To: <20230824111456.2005125-1-thaller@redhat.com>
References: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

