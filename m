Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D4EC433E6
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37B1364E06
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jan 2021 21:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233467AbhA2V0n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbhA2V0h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jan 2021 16:26:37 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0A4C061786
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:20 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c6so12249998ede.0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jan 2021 13:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrJr3kAp1AOA2MAWe4av0IDZUY9ujH+yzKZciZ9I8K8=;
        b=h0h0O+ULUWibdZrldDpnXWbqlKKvHayO543aIFQb8WXe6N2648tRl/gKf9VCurgOlk
         90EuxGEeh2ivOqV95xiFzZtPZ4Fy9J7otluQClDzytZZD5cl0NVUBR44ucbdKojrshVO
         5upu/YHJR5XBwvG4AS7aQPJdS1/UzWI/I9dRqhbW2Wx6q+WgiCJCKEwaXDfoRw4Xruoo
         9EGDcnv2qyW0Sp18RJbsy7maHTwa1xqsIicfh0z6IlWuI9yosF8+gJY8+oybQwSTnUWs
         ZlXzYV5qGmJcePuZJiHOuSDdXX2cf60/OOLOZ2r3WD5JCMGPSkas1ggtjE+5EjXg2iEp
         4feA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrJr3kAp1AOA2MAWe4av0IDZUY9ujH+yzKZciZ9I8K8=;
        b=FonHOf5G+A0MicVVuMa1N+BaG4RL4+hmlmzTFONlStR2WY0qm0hd847dKTVktb3R5o
         fcnS78/fb5ITRswL5OaeyVtEcaXIOVGe9wR+SvRkN6Ylvt7S3ghgTvimELROk39ksOBy
         db8Fk+fnRaN8rB2rKvIYMQBQRrxrpTUT+FiZuzG9AMm0E+RO/Cni1rfFqd+k42/PV3A8
         7bn7Hii6WAgM8bN142vaTTLQQfytTOmoIEvGfe9ZK/3ycmW+ejTKseXznhKdW23T3q8w
         A+Dw8L1DuReAJ503k76S0ofKT5pT/KStQkMHXzmwMktJChjxPwWU5cJMK33F8OuUMk0f
         IwgQ==
X-Gm-Message-State: AOAM531EsAdZMPoc6MPfMbArd5r5G1UpOFZXHckSB6YPUTj7Fkid1Y8s
        E0tqzc73FXvWKKFiogatW1lACubl3aUZEw==
X-Google-Smtp-Source: ABdhPJz2XflXIgEVLi7H3CpYrv6h/fxBdDwdbLdlusaWrIJ6foWBGPKutyHhjjrB7BuwDPw2HRJJ/w==
X-Received: by 2002:a05:6402:160f:: with SMTP id f15mr7434488edv.348.1611955519368;
        Fri, 29 Jan 2021 13:25:19 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bd4ff.dynamic.kabel-deutschland.de. [95.91.212.255])
        by smtp.gmail.com with ESMTPSA id q2sm5143218edv.93.2021.01.29.13.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 13:25:18 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v3 6/8] conntrack.8: man update for --load-file support
Date:   Fri, 29 Jan 2021 22:24:50 +0100
Message-Id: <20210129212452.45352-7-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20210129212452.45352-1-mikhail.sennikovskii@cloud.ionos.com>
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

