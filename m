Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD71FC48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 10:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 815EF2083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 10:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfF0KuJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:50:09 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37964 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfF0KuJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 06:50:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so5175127wmj.3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 03:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=UWEDmp6BmJvgYt6WUkpRMXexEdiqkInbiwL84qzDBLs=;
        b=PQfyj0u6h0JAXtNrLS/b1amlQclZ0OPGpp3vlr0KfENBP4l9OdTk5v9+rDqV1PWUzW
         uJu2mHD3gHF2IQOJ/MNPTiYa5zpxvTsI5h4CX0Br7K02tGUhbSiDtymEsYWweXKgw4Vl
         fGO3cwi/FamjYDBWfS60ONPowT9yG6QTv9mRt0UF8+I+AuVV2jtrryCvZ8ciLZF2T+Ye
         E6f/qS1ezW/mlvuwNsrrrp0IZXdCpns18wL/GsJ5WS5WAYjsimtb+gONlKDCV+4OxOAQ
         RxVVykX/GPib4yYTPFo7yG1R42ZyIRK4thwr3bErDH6Van86tiMPLW/0E32HupeZ8Dz3
         Tscg==
X-Gm-Message-State: APjAAAWSn5DIZwWCWDJGb552AbQjIjpS/cypymkd1BkT4XgnaWmNROil
        8+CTdQamV1T1DDTXzGfRNou4i3NsGx4=
X-Google-Smtp-Source: APXvYqxEDKc7hJVK29LFye/tc4CIwRXEeoBb7FLB1D9RTa9/BFddUv8AqXexURc7twyEluP0qA117g==
X-Received: by 2002:a1c:e914:: with SMTP id q20mr2889577wmc.55.1561632606797;
        Thu, 27 Jun 2019 03:50:06 -0700 (PDT)
Received: from localhost (static.137.137.194.213.ibercom.com. [213.194.137.137])
        by smtp.gmail.com with ESMTPSA id i25sm2459938wrc.91.2019.06.27.03.50.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:50:06 -0700 (PDT)
Subject: [nft PATCH 1/3] nft: use own allocation function
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Thu, 27 Jun 2019 12:50:00 +0200
Message-ID: <156163260014.22035.13586288868224137755.stgit@endurance>
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
removes it), let's introduce a new allocation function in the nft frontend.
This results in a bit of code duplication, but given the simplicity of the code,
I don't think it's a big deal.

Other possible approach would be to have xzalloc() become part of libnftables
public API, but that is a much worse scenario I think.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 src/main.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/src/main.c b/src/main.c
index cbfd69a..d5857e8 100644
--- a/src/main.c
+++ b/src/main.c
@@ -19,9 +19,24 @@
 #include <sys/types.h>
 
 #include <nftables/libnftables.h>
+#include <nftables.h>
 #include <utils.h>
 #include <cli.h>
 
+void *xzalloc(size_t size)
+{
+	void *ptr;
+
+	ptr = malloc(size);
+	if (ptr == NULL) {
+		fprintf(stderr, "%s:%u: Memory allocation failure\n",
+			__FILE__, __LINE__);
+		exit(NFT_EXIT_NOMEM);
+	}
+	memset(ptr, 0, size);
+	return ptr;
+}
+
 static struct nft_ctx *nft;
 
 enum opt_vals {

