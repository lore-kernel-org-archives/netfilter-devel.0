Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE91C7113C
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377630AbjHROMc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377651AbjHROM0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:12:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B1A30F6
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692367898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NqrkECguXkAPP7WZ9mU+Lstj/kKS62vfJ7mdsDLQyT8=;
        b=YOYMF0DOpX0oScX9vq3LGBvlH634hBYGTwWt5A5JW4ccUxstXG16YkuBSgCLPuM7+F3ISS
        iYh37AWABEUAE5NvDRmtdPmqvAvNMBA7fhzJS4xme9nI1vVi7LelMhXDGFCF8H20NcSASq
        ht+pKqxK9X5Vc920nSrqbJwmNBlicYM=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-678-KbbDJ0FYPnadPBTF1rrRgw-1; Fri, 18 Aug 2023 10:11:36 -0400
X-MC-Unique: KbbDJ0FYPnadPBTF1rrRgw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A68F12823810
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 14:11:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2529040C6F4E;
        Fri, 18 Aug 2023 14:11:36 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [nft PATCH v3 1/3] nftutils: add new internal file for general utilities
Date:   Fri, 18 Aug 2023 16:08:19 +0200
Message-ID: <20230818141124.859037-2-thaller@redhat.com>
In-Reply-To: <20230818141124.859037-1-thaller@redhat.com>
References: <20230818141124.859037-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No code there, yet.

Similar to "utils.c", it is a place for various helper functions.

But this will be GPL-2.0-or-later licensed, from the start.

"utils.c" would be a better name, but that is already taken.

The header is not under include/ directory, but placed alongside the
source files. That is, because this is internal API to the library.
It also should be included with quotes instead of angle brackets.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/Makefile.am | 2 ++
 src/nftutils.c  | 5 +++++
 src/nftutils.h  | 5 +++++
 3 files changed, 12 insertions(+)
 create mode 100644 src/nftutils.c
 create mode 100644 src/nftutils.h

diff --git a/src/Makefile.am b/src/Makefile.am
index ace38bd75a97..ad22a918c120 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -64,6 +64,8 @@ libnftables_la_SOURCES =			\
 		segtree.c			\
 		gmputil.c			\
 		utils.c				\
+		nftutils.c			\
+		nftutils.h			\
 		erec.c				\
 		mnl.c				\
 		iface.c				\
diff --git a/src/nftutils.c b/src/nftutils.c
new file mode 100644
index 000000000000..758283d1b650
--- /dev/null
+++ b/src/nftutils.c
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#include <config.h>
+
+#include "nftutils.h"
diff --git a/src/nftutils.h b/src/nftutils.h
new file mode 100644
index 000000000000..9ad68d55ce47
--- /dev/null
+++ b/src/nftutils.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef NFTUTILS_H
+#define NFTUTILS_H
+
+#endif /* NFTUTILS_H */
-- 
2.41.0

