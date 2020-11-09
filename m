Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F72AC5517A
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B012068D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Nov 2020 18:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="R5jY1Sso"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgKISSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729939AbgKISSC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Nov 2020 13:18:02 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7095CC0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2020 10:18:01 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id 7so13673023ejm.0
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2020 10:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrJr3kAp1AOA2MAWe4av0IDZUY9ujH+yzKZciZ9I8K8=;
        b=R5jY1SsocKZQdH7gpNAaP8yFj2jk8qytG979jWmCnVqP6hzZfi0JTySwYJcaXEGgAz
         T+oo8jHKBdPiIiV4J4vGVA1HHvuHkZ4mczX7k8O0bZI7ilQLPnTlMRAJ0x9DzDWFEgUJ
         Le8n8G1FqPwsNr+OwPRqPfulvr9pPE6Asm1DK9eOokYsaivs+73WObuZkZ+GoXTfxOSB
         zaQQ1t3xeC+OzOkDHAOOROJjL08MNrHCHUVd2QftF3o+pR0lRmSDvHOstD9QF/HsXSvu
         zZdJmlO8WCTM50g+1NgakL5LEli9WXr1QVtT25YRaJZQN4umAZRFRJA7eeb0HHkRuKhh
         ZvrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrJr3kAp1AOA2MAWe4av0IDZUY9ujH+yzKZciZ9I8K8=;
        b=kPLmvJqGcmzDpVx72PrvF6vIMhAIqAfZMC7t5Ly7ZOVM8ehqAPqFeapa1xDwUIqHg+
         fV4p3ooOVo6gqMypfoDqGjZNK9J5JOqAM9a1VVMYgiM3KejNyHb6t44oRj6MOT0aFnvJ
         pCqmAnpQg676Q/548cjS4lBHtWEgVRvbrvxfclJ4jcvRMUADex2l/nQT/WRCdLpMc7OO
         NUVWbM27ZwzRw4unM9nk5HXoTZT9g4laztW8I55QjdAX/B3ZWMF87Cbbn9wjIC4nojsk
         8QZXnw9ebGNV1tPHlcRQhzpv9cOWXBTPtagWnLI92V1FSAYBIAi9NNVrPY8BW2PdsIXz
         a5EA==
X-Gm-Message-State: AOAM533B/wDboKigD61xPFWSgOia1Le9qOhnRRj3/IneeGT42oaBNv8D
        GWfC/iBXwe8QrF4UzXJ0pE8bVS3NQ9apUQ==
X-Google-Smtp-Source: ABdhPJxxS+Pf7uMUUi+3p/pZvH/I4LceNNeNURXpLfUxZJYLWVIYVcdEWbosbmRp+Yhfp0H9Nkl+Ng==
X-Received: by 2002:a17:906:4a98:: with SMTP id x24mr15887154eju.304.1604945879955;
        Mon, 09 Nov 2020 10:17:59 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5af104.dynamic.kabel-deutschland.de. [95.90.241.4])
        by smtp.gmail.com with ESMTPSA id g25sm9056273ejh.61.2020.11.09.10.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 10:17:59 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v2 2/4] conntrack.8: man update for --load-file support
Date:   Mon,  9 Nov 2020 19:17:39 +0100
Message-Id: <20201109181741.52325-3-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20201109181741.52325-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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

