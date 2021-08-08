Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E27C4320A
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Aug 2021 03:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 023A060F10
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Aug 2021 03:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhHHDH4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Aug 2021 23:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHDH4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Aug 2021 23:07:56 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0A9C061760
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Aug 2021 20:07:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j1so22589662pjv.3
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Aug 2021 20:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XrzKhcHocJ3rU7JDx2syTXWRU3/Si0PI4d6wwNeygO8=;
        b=WIZrcyu/wCLeynemorlzut+WBzCpyfzHS0wFYi182feNZEq1BhB+KVhbXAGHanTDlU
         9h/ZxaHMXcfpnFXq7c55uzhJ2MYvLwUcNgcUUgx29yP+qxsSKdukwtyas0iaiAt0+YUu
         DyizC7WJyxHjRM92A0/Yqqy8HVwIj4NdRlO89lwPl6SFLjrhgnlJGWDtO1GKAKPiC/6h
         J2RYgrrwKT+OF/USOO9eCXRTEOvdhjTS1tLDU61zlWqv1YNO+sLTqIUskymbbuEX3s/4
         7uD58n6Cam60bezqzAlUKSfj7yjVCYlVLlNs3Zpfe1o6lDcSfWISTkZ55mGgz4igaEYv
         fgqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=XrzKhcHocJ3rU7JDx2syTXWRU3/Si0PI4d6wwNeygO8=;
        b=JK743PXoeV/aEeY7Pnt6jSn5O2PMdbVAJolvqcErT6cuBGE1HDPtIq6Qm7wcz4GoIz
         5nTJBV4jI0EHa2UMnGgA+wdiLfmmf2mskvG5oUO0iKnPqF1xljcbUqL4MVYVNOrHgUsj
         xppnu5NNJK25DMkqYnOFyz9nC3d1T+3P+rDWhojG91apNDlDm8oawerxh5n2EeuGxuAO
         c0KCpx4r8Bnbrq1ppp4zrYkF/XT5oBoE5E5zlnbS/crhbqXkkDIX2vnuS8coNcdfgw2n
         StiAhQ0XHcldkLDPficxpFHS3797rVGGvyOKDJvN7z4dkpDJYS7xM040K4BzwVNRnHPc
         oyRg==
X-Gm-Message-State: AOAM531IjnMhjfjmOMdvaYUlogR/WINZZpr1WTVa3X8jHwE2IYESWWrQ
        IEAyK6nqYxsox8Knye9p/6Nq+wQgy8r8CQ==
X-Google-Smtp-Source: ABdhPJzY/WlsZv+5UA3MKyKfGf/kqVklt3T41obBXzeI3WikHROKNZT62wo1jq1HAtre98JT1QRlyA==
X-Received: by 2002:a17:902:76cb:b029:12b:2fb8:7c35 with SMTP id j11-20020a17090276cbb029012b2fb87c35mr8766195plt.16.1628392057082;
        Sat, 07 Aug 2021 20:07:37 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id z3sm13268240pjn.43.2021.08.07.20.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 20:07:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl] src: doc: Fix messed-up Netlink message batch diagram
Date:   Sun,  8 Aug 2021 13:07:31 +1000
Message-Id: <20210808030731.2762-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Put the diagram in a *verbatim* block (like all the other diagrams)

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/nlmsg.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index d398e63..ce37cbc 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -381,15 +381,16 @@ EXPORT_SYMBOL void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
  * datagram. These helpers do not perform strict memory boundary checkings.
  *
  * The following figure represents a Netlink message batch:
- *
- *   |<-------------- MNL_SOCKET_BUFFER_SIZE ------------->|
- *   |<-------------------- batch ------------------>|     |
- *   |-----------|-----------|-----------|-----------|-----------|
- *   |<- nlmsg ->|<- nlmsg ->|<- nlmsg ->|<- nlmsg ->|<- nlmsg ->|
- *   |-----------|-----------|-----------|-----------|-----------|
- *                                             ^           ^
- *                                             |           |
- *                                        message N   message N+1
+ *\verbatim
+   |<-------------- MNL_SOCKET_BUFFER_SIZE ------------->|
+   |<-------------------- batch ------------------>|     |
+   |-----------|-----------|-----------|-----------|-----------|
+   |<- nlmsg ->|<- nlmsg ->|<- nlmsg ->|<- nlmsg ->|<- nlmsg ->|
+   |-----------|-----------|-----------|-----------|-----------|
+					     ^           ^
+					     |           |
+					message N   message N+1
+\endverbatim
  *
  * To start the batch, you have to call mnl_nlmsg_batch_start() and you can
  * use mnl_nlmsg_batch_stop() to release it.
-- 
2.17.5

