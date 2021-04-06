Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC53C43460
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82F63613CA
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhDFKKN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbhDFKKL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 06:10:11 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E78C06175F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 03:10:03 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id o10so21799687lfb.9
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2021 03:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ojk/FZNHBgSfp4ARpaUdo+aeb++rX9bFbVaHKne7SWc=;
        b=ZT1GDe/EUu+Yz0oj63AHfC7fTZi1NSKL2Pu7P2230UaOeU6otSqu7fREPmPdfacwIu
         kMSUYpFBxhY0fg0Lz7biAuJkoEEHOpA6H9NOJi6R/crKjaIkzzGJ9laiBTwlZxKOYWan
         yRb00JS+kK3D8i263PIS814LEkMLyoLQzmrsZDT4JA/w+uGufMYpalUm56ru5movQZbo
         8mwTbHuyT9A9PjE4b2DEZz3Fwnb6vyuyBhtNkwYb8BbRaKOYkqNmAiEsNEK829ao3xVI
         C3BN5hWa0jCl0vgzTsa+dTbsEo61RyExjL9wTkUkPfLttxtKDzQZwvAz0A8AE9FuMcz0
         fmzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ojk/FZNHBgSfp4ARpaUdo+aeb++rX9bFbVaHKne7SWc=;
        b=VscEC6FgbaCq6HYDOXG54U3IizvEtqaUzB5sHFt1d4lad9betYlbob0Om+oBAD2ojf
         iEO98qk/KovEbzMW387GFkGV2p6SJVrZj2E+ahZxvumJ1cmFcbMQ2MeBKM3IC1ynB532
         y62qggfcbzWoR0u1ck0K26Celc2ryJ6PSaJV0LNc/PNNLb3nQYTQs4eM5F0wx10cf0Bq
         9ak2yr1ANMYyJliIhHYd24dTgUluYOPgzzFtcoPScWSj3sTAhydizz/7Lg4AFYdOgFKa
         nUokpAjMUGBptCgj+d3f0Su0TOkhyeEx6gle96dpCuoohJ8xW39WnSeIXnmZo5utWd7l
         5ZAw==
X-Gm-Message-State: AOAM532c09lAy8KG2fXGi0tAzpvRKytwmSXCOSFqMNvyvllUyPlJxwyq
        bmBBOCWZOfkmhfTIBLcKZEJkfxSoPVUY4kCD
X-Google-Smtp-Source: ABdhPJwaGlRX0xAHsMIPuFcF3O+un1ye4xqZZ+uiDGYBXM9nIDMZKVHY6DnvYblDnqr+mVatVSuQnA==
X-Received: by 2002:a05:6512:3d20:: with SMTP id d32mr21627259lfv.9.1617703801956;
        Tue, 06 Apr 2021 03:10:01 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a00:1fa1:c4fc:25fe:f165:934d:dfbd:8cd3])
        by smtp.gmail.com with ESMTPSA id l7sm2170070lje.30.2021.04.06.03.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:10:01 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovskii@ionos.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v4 3/5] conntrack.8: man update for --load-file support
Date:   Tue,  6 Apr 2021 12:09:45 +0200
Message-Id: <20210406100947.57579-4-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
References: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 conntrack.8 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/conntrack.8 b/conntrack.8
index 898daae..a14cca6 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -23,6 +23,8 @@ conntrack \- command line interface for netfilter connection tracking
 .BR "conntrack -C [table]"
 .br
 .BR "conntrack -S "
+.br
+.BR "conntrack -R file"
 .SH DESCRIPTION
 The \fBconntrack\fP utilty provides a full featured userspace interface to the
 Netfilter connection tracking system that is intended to replace the old
@@ -102,6 +104,9 @@ Show the table counter.
 .TP
 .BI "-S, --stats "
 Show the in-kernel connection tracking system statistics.
+.TP
+.BI "-R, --load-file "
+Load entries from a given file. To read from stdin, "\-" should be specified.
 
 .SS PARAMETERS
 .TP
@@ -394,6 +399,9 @@ Delete all flow whose source address is 1.2.3.4
 .TP
 .B conntrack \-U \-s 1.2.3.4 \-m 1
 Set connmark to 1 of all the flows whose source address is 1.2.3.4
+.TP
+.B conntrack -L -w 11 -o save | sed "s/-w 11/-w 12/g" | conntrack --load-file -
+Copy all entries from ct zone 11 to ct zone 12
 
 .SH BUGS
 Please, report them to netfilter-devel@vger.kernel.org or file a bug in
-- 
2.25.1

