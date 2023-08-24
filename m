Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EAD5C7EE43
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238658AbjHXLQd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbjHXLQU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:16:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C76019B2
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 04:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692875713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CZ1Ed5v6EodNzfMSSsflfa0AzGKd6o3LFkdUJ8XGI+4=;
        b=M4LUY7vUfS5y1a2XwZW2uwKsbwQ4J0wIktaMsuVCgoF/JdRZx+9aOkpr/NpQ4NMbOZjBsC
        tOP89Dav+98HbJsF2D3ZvUnXlpnccYa7vTpylo0UAHcRcLdpeZd0swsUSq/aT/aN2sLtta
        qAxY1o/HsusDWCav0o7QFO5zUcEyiyE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-jy4nyyvmMlqChMIsmjxHsA-1; Thu, 24 Aug 2023 07:15:12 -0400
X-MC-Unique: jy4nyyvmMlqChMIsmjxHsA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18F8A101A52E
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 11:15:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C29CC1602E;
        Thu, 24 Aug 2023 11:15:11 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 4/6] configure: use AC_USE_SYSTEM_EXTENSIONS to get _GNU_SOURCE
Date:   Thu, 24 Aug 2023 13:13:32 +0200
Message-ID: <20230824111456.2005125-5-thaller@redhat.com>
In-Reply-To: <20230824111456.2005125-1-thaller@redhat.com>
References: <20230824111456.2005125-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Let "configure" detect which features are available. Also, nftables is a
Linux project, so portability beyond gcc/clang and glibc/musl is less
relevant. And even if it were, then feature detection by "configure"
would still be preferable.

Use AC_USE_SYSTEM_EXTENSIONS ([1]).

Apparently available since autoconf 2.60, from 2006 ([2]).

[1] https://www.gnu.org/software/autoconf/manual/autoconf-2.67/html_node/Posix-Variants.html#index-AC_005fUSE_005fSYSTEM_005fEXTENSIONS-1046
[2] https://lists.gnu.org/archive/html/autoconf/2006-06/msg00111.html

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 configure.ac         | 3 +++
 include/nftdefault.h | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 42f0dc4cf392..9d859307adaa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,6 +45,9 @@ fi
 AM_PROG_AR
 LT_INIT([disable-static])
 AM_PROG_CC_C_O
+
+AC_USE_SYSTEM_EXTENSIONS
+
 AC_EXEEXT
 CHECK_GCC_FVISIBILITY
 
diff --git a/include/nftdefault.h b/include/nftdefault.h
index b7ebad7fddc0..0912cd188850 100644
--- a/include/nftdefault.h
+++ b/include/nftdefault.h
@@ -2,8 +2,6 @@
 #ifndef NFTABLES_NFTDEFAULT_H
 #define NFTABLES_NFTDEFAULT_H
 
-#define _GNU_SOURCE
-
 #include <config.h>
 
 #endif /* NFTABLES_NFTDEFAULT_H */
-- 
2.41.0

