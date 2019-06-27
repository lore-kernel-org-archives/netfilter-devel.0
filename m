Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D663FC48BD7
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 10:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B60902083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 10:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfF0KuP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:50:15 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36256 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfF0KuP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 06:50:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so2012492wrs.3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 03:50:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UTm5vo+jiHtPAZQA4y3M3hk9iOsrVhsgqfliGbIYCsk=;
        b=TR3oh/Dx8Y0KopJqaJzMZsXdI+teFXe+NU9wrEd5nIG8iAE5JxCWYm26P+LjOK/FcF
         I+/iFJ0a+tJ2rourw48LK4nKqltRYEFsd+6IF4dK7+aDwPAR338Azxz4R/mD53+i/mrg
         FUucu7v3ljwXe/lnHwNTYJf7HWYcUHuknm7B9kPotPTas/2QXUmb8l6tLysX/g2FdOSj
         N40Kcroil0vMVGowakTkuxoYPrR8bxBRer/Dvs2+3IedagAZqCLjrQtR8f31+woy8Kgi
         5tYz/SdxBjHUHBommZK6iII68C/UOcKkMMmvbHggCKfEVvppVB5Ckxb4JYRniha5AypU
         Dz3Q==
X-Gm-Message-State: APjAAAWMY/Czg8SMtMqPJ+6i4y79t/2ndwiAiDcvu4ruC/TdqxMImfXl
        C7eiqmeHYYYpC2OsLdBYZjYqXypiv7g=
X-Google-Smtp-Source: APXvYqz9pq0hv0rsGfWY44jN/16allUlWrNfYyVeXoOr+mVJkl2RpiitkWpktOi2buE6JxVzkNL6vg==
X-Received: by 2002:adf:eb86:: with SMTP id t6mr2681272wrn.96.1561632613269;
        Thu, 27 Jun 2019 03:50:13 -0700 (PDT)
Received: from localhost (static.137.137.194.213.ibercom.com. [213.194.137.137])
        by smtp.gmail.com with ESMTPSA id x8sm3521670wre.73.2019.06.27.03.50.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:50:12 -0700 (PDT)
Subject: [nft PATCH 2/3] libnftables: reallocate definition of nft_print()
 and nft_gmp_print()
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 27 Jun 2019 12:50:11 +0200
Message-ID: <156163261193.22035.5939540630503363251.stgit@endurance>
In-Reply-To: <156163260014.22035.13586288868224137755.stgit@endurance>
References: <156163260014.22035.13586288868224137755.stgit@endurance>
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
different source file.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 src/libnftables.c |   27 ---------------------------
 src/utils.c       |   26 ++++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 27 deletions(-)

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
diff --git a/src/utils.c b/src/utils.c
index 47f5b79..69e8344 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -90,3 +90,29 @@ void xstrunescape(const char *in, char *out)
 	}
 	out[k++] = '\0';
 }
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

