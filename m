Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620A8C0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 10:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F35E2089F
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 10:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbfGAKwv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 06:52:51 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54008 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfGAKwv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 06:52:51 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so15352998wmj.3
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2019 03:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=N7UsTl/W0uX2IQ4IYrvAR1td2CKC4ar3fkVw3NTNN6I=;
        b=ibBck4Xcnid5XSTPnNCeipaZymbnwK9ZPs8UYUXpJg+9zhCI5esHTphMbUEL5IufZt
         dqqwlHGIp0aJNM4xg2rZBc34Hu5g/EQnC0E19zndb/57McIRlBeB44v6xhEXBYw3aeC1
         ldICi92OzWzObm+ftG8YXVvzX4U39AYZ67cPBnIg8pi5s3m1cftLFHtCmIp79oN/nINJ
         9mE25X4OKcwsq3tdkLqxBLGmhI8cSxkJvj264zAQ3Z/DHY4m0L+o9tO99gVp+1DfZ2rB
         PNsf/hAlnmBGzZDAHuLWtUuQffontR9rbplZYcKdHJZlRVJW+xJdcwWyZtpxdqlwDV9z
         g/IQ==
X-Gm-Message-State: APjAAAXvY46RDeXfdRMuvNOsf2X4x7fO1/CZgdrYP8KHXLCoUq/pjUyZ
        xmq+T9MzRSe/ao65oOqsaqK7mqDPDs0=
X-Google-Smtp-Source: APXvYqzWsGsxg3HVlIdMXX54zvQNqbAzLotBvty03Xf6eBgP2L70N9fWQpXKuangX5DLRbu7L2ZuSg==
X-Received: by 2002:a1c:c915:: with SMTP id f21mr15598501wmb.123.1561978369330;
        Mon, 01 Jul 2019 03:52:49 -0700 (PDT)
Received: from localhost (static.137.137.194.213.ibercom.com. [213.194.137.137])
        by smtp.gmail.com with ESMTPSA id u205sm8605656wmg.36.2019.07.01.03.52.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 03:52:48 -0700 (PDT)
Subject: [nft PATCH v2 1/3] nft: don't use xzalloc()
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Mon, 01 Jul 2019 12:52:48 +0200
Message-ID: <156197834773.14440.15033673835278456059.stgit@endurance>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In the current setup, nft (the frontend object) is using the xzalloc() function
from libnftables, which does not makes sense, as this is typically an internal
helper function.

In order to don't use this public libnftables symbol (a later patch just
removes it), let's use calloc() directly in the nft frontend.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
v2: use calloc() instead of re-defining xzalloc() per Pablo's suggestion.

 src/main.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/main.c b/src/main.c
index cbfd69a..8e6c897 100644
--- a/src/main.c
+++ b/src/main.c
@@ -19,6 +19,7 @@
 #include <sys/types.h>
 
 #include <nftables/libnftables.h>
+#include <nftables.h>
 #include <utils.h>
 #include <cli.h>
 
@@ -302,7 +303,12 @@ int main(int argc, char * const *argv)
 		for (len = 0, i = optind; i < argc; i++)
 			len += strlen(argv[i]) + strlen(" ");
 
-		buf = xzalloc(len);
+		buf = calloc(1, len);
+		if (buf == NULL) {
+			fprintf(stderr, "%s:%u: Memory allocation failure\n",
+				__FILE__, __LINE__);
+			exit(NFT_EXIT_NOMEM);
+		}
 		for (i = optind; i < argc; i++) {
 			strcat(buf, argv[i]);
 			if (i + 1 < argc)

