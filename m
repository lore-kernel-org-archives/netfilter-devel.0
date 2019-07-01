Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6577DC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 10:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44893205F4
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 10:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfGAKxU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 06:53:20 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34603 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfGAKxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 06:53:19 -0400
Received: by mail-wr1-f68.google.com with SMTP id u18so5131499wru.1
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2019 03:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=eCsQsfHsBxJsqIJaeFpudoVNDhdtmkW/LVEeu3v3T8o=;
        b=Bfg42Jc7ytrIHUvDY4IhmQ1t4iPUezFQI3wb88EdLiv6wr5xsNqjS9DzuRBlkFDRPZ
         SZMB4b5fsyAk15pvxaKmH3UFs9g4uTFdvIyfON+8R6o7Zm5IwX9mFft8De/eGJbKMntl
         1hifpLgmvDRlYHQOFeMwb1YlOgQdYiqPDs/w/zLUw1vkN8eybhXvWWoEi0WHRYU10ooi
         mXJsfSUbKmyzohAXmH7nF2UowVYbLMmUbmTlmP4r6Dm/FP0ribFh/Vpx79nOABRcHfvn
         jgN9OAL6r2/HTk6IZFqnk0mOdry0sMrfMvsVu4YBWg52boBNhkMZoDqxhD9y15CjJJoM
         Svsg==
X-Gm-Message-State: APjAAAVw26bz79hn7JSmYcpOArb2nxa0f+BxgsxxlxI+SLBMoN+oipeb
        TSjPkGg6xyrltOBRzG7vUHHkE/pv2Cg=
X-Google-Smtp-Source: APXvYqw0USAPDZ7wHc8mQqcoP2Bl3A0yxs23AVTBl5IUBg8X18dg4MiFEh1u28wGbQHKkGZWIvtrMw==
X-Received: by 2002:a05:6000:1011:: with SMTP id a17mr8500322wrx.0.1561978397229;
        Mon, 01 Jul 2019 03:53:17 -0700 (PDT)
Received: from localhost (static.137.137.194.213.ibercom.com. [213.194.137.137])
        by smtp.gmail.com with ESMTPSA id w25sm5472508wmk.18.2019.07.01.03.53.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 03:53:16 -0700 (PDT)
Subject: [nft PATCH v2 2/3] libnftables: reallocate definition of
 nft_print() and nft_gmp_print()
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Mon, 01 Jul 2019 12:53:10 +0200
Message-ID: <156197837439.14440.15425559524700127860.stgit@endurance>
In-Reply-To: <156197834773.14440.15033673835278456059.stgit@endurance>
References: <156197834773.14440.15033673835278456059.stgit@endurance>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They are not part of the libnftables library API, they are not public symbols,
so it doesn't not make sense to have them there. Move the two functions to a
different source file so libnftables.c only has the API functions.

I think copyright belongs to Phil Sutter since he introduced this code back in
commit 2535ba7006f22a6470f4c88ea7d30c343a1d8799 (src: get rid of printf).

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
v2: move code to src/print.c per Pablo's suggestion.

 src/Makefile.am   |    1 +
 src/libnftables.c |   27 ---------------------------
 src/print.c       |   38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 27 deletions(-)
 create mode 100644 src/print.c

diff --git a/src/Makefile.am b/src/Makefile.am
index fd64175..a1c18fe 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -62,6 +62,7 @@ libnftables_la_SOURCES =			\
 		nfnl_osf.c			\
 		tcpopt.c			\
 		socket.c			\
+		print.c				\
 		libnftables.c
 
 # yacc and lex generate dirty code
diff --git a/src/libnftables.c b/src/libnftables.c
index dccb8ab..f2cd267 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -507,30 +507,3 @@ err:
 		cache_release(&nft->cache);
 	return rc;
 }
-
-int nft_print(struct output_ctx *octx, const char *fmt, ...)
-{
-	int ret;
-	va_list arg;
-
-	va_start(arg, fmt);
-	ret = vfprintf(octx->output_fp, fmt, arg);
-	va_end(arg);
-	fflush(octx->output_fp);
-
-	return ret;
-}
-
-int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
-{
-	int ret;
-	va_list arg;
-
-	va_start(arg, fmt);
-	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
-	va_end(arg);
-	fflush(octx->output_fp);
-
-	return ret;
-}
-
diff --git a/src/print.c b/src/print.c
new file mode 100644
index 0000000..d1b25e8
--- /dev/null
+++ b/src/print.c
@@ -0,0 +1,38 @@
+/*
+ * Copyright (c) 2017 Phil Sutter <phil@nwl.cc>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <stdarg.h>
+#include <nftables.h>
+#include <utils.h>
+
+int nft_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	int ret;
+	va_list arg;
+
+	va_start(arg, fmt);
+	ret = vfprintf(octx->output_fp, fmt, arg);
+	va_end(arg);
+	fflush(octx->output_fp);
+
+	return ret;
+}
+
+int nft_gmp_print(struct output_ctx *octx, const char *fmt, ...)
+{
+	int ret;
+	va_list arg;
+
+	va_start(arg, fmt);
+	ret = gmp_vfprintf(octx->output_fp, fmt, arg);
+	va_end(arg);
+	fflush(octx->output_fp);
+
+	return ret;
+}

