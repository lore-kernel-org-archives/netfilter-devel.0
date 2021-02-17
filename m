Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3EE6C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 21:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 929996186A
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 21:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhBQVcM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 16:32:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233056AbhBQVb4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 16:31:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613597430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lpNftXSQv+fcpW1lo6G+V8NOlI3WWh3u5x7QJPTtCRk=;
        b=C9SP8fNvjzFbjtKd9HJZHzqruaHBI9X+D9wMs0aaSQgoJfBPrfDQ0qJzikxgc9Mrf/NY+P
        8c+pDzLMM2vSMCG2MwpkDd06UV0UBbiob17x+YPVl7Bd/lCrxuz5UUGubEhidQl5PoZam/
        Xfrkg3Cop7D9WKorxx2LHeNUwmQ+JnA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-pdhdXcTHO5GQlrPHWCO72w-1; Wed, 17 Feb 2021 16:30:26 -0500
X-MC-Unique: pdhdXcTHO5GQlrPHWCO72w-1
Received: by mail-ed1-f69.google.com with SMTP id i21so3909820edq.2
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2021 13:30:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lpNftXSQv+fcpW1lo6G+V8NOlI3WWh3u5x7QJPTtCRk=;
        b=gOCmzU6ltoAK/V46CjmWFwQleExMqzOuHQOZR/3YPCF18CGFnhW4PO0Gec0rAeXDUZ
         58E2+oWFM1R57JeQuqrhFWB1tObkApWcyjzlG4a3Kdix70JEc8UGRdArB6o8MoUUGlZ2
         TfPkrUJKPjBAhFr+kNQWyTP37mppswO0ceVytOyPSNmgdVGIFYVdhoZxJwD+EimUSGX3
         rKBvD6CWjDKEXJYDysP/pqwAbZpNQb18YTQ47CoGj2yLgFPEWVvdCJ1othzeSgA19noV
         AwJIT9cvfM2TWmYTrK2Y0E6DjDon2wDAsixgC5NKb65M5RTxrh9q565fQn5/EMlbtC2m
         vFMA==
X-Gm-Message-State: AOAM533WgO7GooMS5YSvbSWM1x7L3LyTGlGqjR5SMsRWdofWpZWu6Nt5
        SXpZDq00ro1dASRgE63ktD8IFs8RLgrylb1m3rRhKfBFMTt8AEovwS6uCkEfbQAGbSK7dlYjkk3
        lFSV+AOF4m+VOzjpOeg4hO/NVl/i0bbJvKh3UyLQWb2Gp9Wz8/3nZJ9b19aYxUERP6dp+frdkGb
        99YJ25
X-Received: by 2002:a17:907:7781:: with SMTP id ky1mr855030ejc.255.1613597425448;
        Wed, 17 Feb 2021 13:30:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxYONcBydTr8SJH9NfzxR7U25awkCoTkn8LQaMdFRQWTh5Im/TZwtmt5H2U14603RFiaEitw==
X-Received: by 2002:a17:907:7781:: with SMTP id ky1mr855011ejc.255.1613597425186;
        Wed, 17 Feb 2021 13:30:25 -0800 (PST)
Received: from omos.redhat.com ([2a02:8308:b105:dd00:277b:6436:24db:9466])
        by smtp.gmail.com with ESMTPSA id la24sm1096075ejb.18.2021.02.17.13.30.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 13:30:24 -0800 (PST)
From:   Ondrej Mosnacek <omosnace@redhat.com>
To:     netfilter-devel@vger.kernel.org
Subject: [ebtables PATCH] Open the lockfile with O_CLOEXEC
Date:   Wed, 17 Feb 2021 22:30:23 +0100
Message-Id: <20210217213023.15403-1-omosnace@redhat.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise the fd will leak to subprocesses (e.g. modprobe). That's
mostly benign, but it may trigger an SELinux denial when the modprobe
process transitions to another domain.

Fixes: 8b5594d7c21f ("add logic to support the --concurrent option: use a file lock to support concurrent scripts running ebtables")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 libebtc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libebtc.c b/libebtc.c
index 2a9ab87..1b058ef 100644
--- a/libebtc.c
+++ b/libebtc.c
@@ -144,7 +144,7 @@ static int lock_file()
 	int fd, try = 0;
 
 retry:
-	fd = open(LOCKFILE, O_CREAT, 00600);
+	fd = open(LOCKFILE, O_CREAT|O_CLOEXEC, 00600);
 	if (fd < 0) {
 		if (try == 1 || mkdir(dirname(pathbuf), 00700))
 			return -2;
-- 
2.29.2

