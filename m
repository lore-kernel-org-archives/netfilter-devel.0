Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73493C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 03:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E086108E
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Sep 2021 03:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhI0DzR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Sep 2021 23:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhI0DzR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Sep 2021 23:55:17 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2107AC061570
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Sep 2021 20:53:40 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m21so16462382pgu.13
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Sep 2021 20:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BrLhoatIija5++8ud62m28ysUFzlh5tMfHVjglnL/Mw=;
        b=VTiwOZB3QofcywUhcLDnMVVosyxukiWmLET5OedBUlUT5U4CwHdhCP77NsI2qCfVMJ
         yrYkMCHxErnmbi1VH6G2Dxd9kjv2YsnYP6hhGkakmCeTPLi+FT2/3Ri5N2aauQeuqMMd
         +QIEdPHtUdIFUSXWei3rnznJJenv1B+jifl1A2tqgOSQYnZuYQSiNVOn/avXd+5xdGXB
         VYOAIeQFhx2YSWx8pmPDjxywOTv8P4r9eZ1GDG1ocdPalfBDXgbpxUY1kGZGs4e7hjyn
         caDDANM1OQHftpjZAD+XNSGLnbgjK/cqtH3nKX2RaaVdXmUygb00HN/EA5EB5GuSxOb3
         mJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=BrLhoatIija5++8ud62m28ysUFzlh5tMfHVjglnL/Mw=;
        b=pbSZGybwfVg8eMTknnBtcc9zF5+Ajqg/2Oj0RxrWVyx2N25UXYMOM3GFVFRsXvmf62
         y2QrctNXM0+B/Pgowc4wDyHDkpKxmKZy6zwATUQIh4ZXncGQwYaa4viHyY1rfgsk4T+d
         lCYZG0hnOTP1gpIAqBQhCfotH98r/qmmS3SNP0rsuEYwxGv2jMPpjjMCj1sZfyLxfFR6
         extS/93ji8PjW0DKhlZqIMCHjDuC11ZNTJY05w1o1DkLev/s17RbFT0AdMrsoEGpOxW4
         lhRkJGE70SDp0usvkCQLNOwJaXNQmtaNZ0EyZR8s667dPbfaFTen+NjrFzF7GVrX7y4P
         MwCA==
X-Gm-Message-State: AOAM531u6o6LaW3SeNaKaGqxZqoy1K0C/KtdgOs+Gh3sJaPLhOU+udxq
        ISrHkuPHeYLOsawWLB8tjkzQ8yMQLQ0=
X-Google-Smtp-Source: ABdhPJzEa2RAcDpz5IqNEkRpVJp1lI5K24nv1x7x0peEl6md1LBe1FgHb3SndCP2QxRjXjNlraD35w==
X-Received: by 2002:a62:7696:0:b0:44b:4b19:6417 with SMTP id r144-20020a627696000000b0044b4b196417mr17486506pfc.5.1632714819727;
        Sun, 26 Sep 2021 20:53:39 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id e14sm16429926pga.23.2021.09.26.20.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 20:53:39 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 3/4] src: doc: Add \return for nflog_get_packet_hw()
Date:   Mon, 27 Sep 2021 13:53:29 +1000
Message-Id: <20210927035330.11390-3-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
References: <20210927035330.11390-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also indicate that hw_addrlen has NBO in struct nfulnl_msg_packet_hw

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/libnetfilter_log.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 581f612..66669af 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -818,11 +818,15 @@ uint32_t nflog_get_physoutdev(struct nflog_data *nfad)
  * The nfulnl_msg_packet_hw structure is defined in libnetfilter_log.h as:
  * \verbatim
 	struct nfulnl_msg_packet_hw {
-		uint16_t       hw_addrlen;
+		uint16_t       hw_addrlen; // Network Byte Order
 		uint16_t       _pad;
 		uint8_t        hw_addr[8];
 	} __attribute__ ((packed));
 \endverbatim
+ *
+ * \return Pointer to struct nfulnl_msg_packet_hw from originating host
+ * or NULL if none available (e.g. locally-originated packet not for \b lo
+ * interface).
  */
 struct nfulnl_msg_packet_hw *nflog_get_packet_hw(struct nflog_data *nfad)
 {
-- 
2.17.5

