Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4280C433E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 12:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9856C64E2E
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Feb 2021 12:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBVMF1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Feb 2021 07:05:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230101AbhBVMFM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Feb 2021 07:05:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613995426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1kCYTU4Qob6VFTxzKGPhMkp3D7qwdfp+7wSyzOOuSLg=;
        b=Pepdk2UpyfbjyNcCroXtEnb8CdzftTMrRcR2LFw2fUfRIwozzbExq4Cy/BnzhXMtsEJpsE
        uVe7GBV6bHsRRe/YPoVSt38BMc7HVNZKHfv/ZSqgElf6Y4bwqIvCMogb0PjDyYCyxTlEcP
        e+FyegOLigb/GB0pVUicS6vXe9rLer4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-DGmCLWVIPF-ZlHVgrzhaGg-1; Mon, 22 Feb 2021 07:03:44 -0500
X-MC-Unique: DGmCLWVIPF-ZlHVgrzhaGg-1
Received: by mail-ed1-f72.google.com with SMTP id q2so6820420edt.16
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Feb 2021 04:03:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1kCYTU4Qob6VFTxzKGPhMkp3D7qwdfp+7wSyzOOuSLg=;
        b=pe0PmJ/CACpjK2Zxzm4fRR+1x0VOcJRD9wtmzSVYravDVPe4kyYmCadzBnt6ugfQqX
         KE0FxfD2QQ8zNswEM/wiBQ6nsFKm4JUtmksulgwZxfCcliCIX19OHN1pBzyaTfDvo7kz
         HWP1lHnLSPZF2gUyILO5/7fFqXH2twwDlpSnbZ3ywgoOv+zR/Ag1uZP4oZpopsP2/Kqf
         eWVwj4kDmsPyLJJX6Odsv6o1k0vaWFHRL4IjObTBoeuRzKKN1DhZYeFrP7gRus24yYDi
         GH0K5mSRynRmOPYcIu1s3pj6A5G6hmWiRhvGMqPOjCYY8em0WhofbzRKQwJDVTzM+ndF
         u+Fg==
X-Gm-Message-State: AOAM530Tmxrul/vpakr4Nvqys8DPL+yl1Ztvf0gCnMSl4O9U/euS9ZvR
        /CiamJvdlDwuxJdvSIwlunReCcXAyIcvSHKtXZDI2FUEZ3PulN15keZ9FbznhwNLYQDimNinsxb
        ayvQAZg6gyBtTKCWAJusqfvdsW4nv5w4Vw6ESnP91yI7hP7h+mcW1ub2x4O25moom+0uFGjNYuQ
        7Mdg==
X-Received: by 2002:a05:6402:22f7:: with SMTP id dn23mr6590010edb.297.1613995423402;
        Mon, 22 Feb 2021 04:03:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxyOR8ECop703CbcuV2r3YEDe4jni85CLj/zZuBx69DUTx/nEdUbNRR1X9raqsMqRN0fod2qQ==
X-Received: by 2002:a05:6402:22f7:: with SMTP id dn23mr6589983edb.297.1613995423182;
        Mon, 22 Feb 2021 04:03:43 -0800 (PST)
Received: from localhost ([185.112.167.35])
        by smtp.gmail.com with ESMTPSA id o1sm2805298eds.26.2021.02.22.04.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:03:42 -0800 (PST)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Jeremy Sowden <jeremy@azazel.net>
Subject: [nft PATCH 1/2] main: fix nft --help output fallout from 719e4427
Date:   Mon, 22 Feb 2021 13:03:19 +0100
Message-Id: <20210222120320.2252514-1-snemec@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Long options were missing the double dash.

Fixes: 719e44277f8e ("main: use one data-structure to initialize getopt_long(3) arguments and help.")
Cc: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 src/main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/src/main.c b/src/main.c
index 80cf1acf0f7f..8c47064459ec 100644
--- a/src/main.c
+++ b/src/main.c
@@ -175,16 +175,17 @@ static const struct option *get_options(void)
 
 static void print_option(const struct nft_opt *opt)
 {
-	char optbuf[33] = "";
+	char optbuf[35] = "";
 	int i;
 
 	i = snprintf(optbuf, sizeof(optbuf), "  -%c", opt->val);
 	if (opt->name)
-		i += snprintf(optbuf + i, sizeof(optbuf) - i, ", %s", opt->name);
+		i += snprintf(optbuf + i, sizeof(optbuf) - i, ", --%s",
+			      opt->name);
 	if (opt->arg)
 		i += snprintf(optbuf + i, sizeof(optbuf) - i, " %s", opt->arg);
 
-	printf("%-32s%s\n", optbuf, opt->help);
+	printf("%-34s%s\n", optbuf, opt->help);
 }
 
 static void show_help(const char *name)
-- 
2.29.2

