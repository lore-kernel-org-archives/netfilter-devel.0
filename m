Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3C2C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 08:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F54C61159
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 08:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241915AbhHFIjC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241898AbhHFIjC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 04:39:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC575C061798
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Aug 2021 01:38:45 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so21646818pjb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Aug 2021 01:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gRoiP4B9z0eH0+FgjgYbu/THJjIqFN3Q144HgkSCMUo=;
        b=N7ZA7rvxATRoybiR3YJZ/Ue9PjXAtKyLL7XzycjJllahIRZmZgzybpj+WWdygQGyQ1
         0WF1xRD5bkklan+V6abTUboudB/1fel9UGewojH0ddKl76eNFFojHow7tcAM5YkZnJVB
         5DOGezZY7ZrXDKe3dlqw9bEEhjy8yzl7r12DIkd0szifEkucSTzLgH09pfTDS595AhEf
         bEoxgJnTmZnLqEPBaYCfLWYLgklcbbewT8ggONPL8hF8uhEGMnUfnC+10hNTcOW0d/Zz
         BeZJoK4APmxmpHXcLeLwyn5yruWMnyLaOyXR322UKHRUW/o31aGpmITNzazNHBKhwbeH
         gdsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=gRoiP4B9z0eH0+FgjgYbu/THJjIqFN3Q144HgkSCMUo=;
        b=rocM3YKmY1qM8pnVslbK6Qvd/L+tM121uO/LnxHukJ1nAQTDmcUnbeV+YRUhG9Ie4O
         71NolT4XnqLEEA7WE6zUZqtDclEcJSeQAYUaeK8NYt+b0iDfARTSJt/EDTAp0iGLJLtt
         LKDuI+fNSVHDhR0XhUdHMbEejSKancJVkmK3yRlNksZVhD+1ewi9gwd1T0LnbvkVtakr
         JmjPdTXBZfHHAnZrn8HHilvO/bmUajvI5yPKT3k39+BwQj037Pq8TTgdm1wfHScMi8r9
         aObbZpmisd2rZ1N5F4tJlEfrfRqZTq4DUPHBl3+FtbgO3tJjHIfFvvlIEmFdacP0pb9J
         +o/A==
X-Gm-Message-State: AOAM530akEAhP42dwfBk+gmBWAqscXpOIMLI0Nq7O2bQubmQgySatkTr
        TWIWn6yInSmuVhvVqJ8MzPrjC+mfzblbOA==
X-Google-Smtp-Source: ABdhPJw0X7NSakTwajQNXnqmk99DsBTst2LH3nkqChY8Zd4sAwvkn8xGnfQ1IwrASQmyb1KbglrI9w==
X-Received: by 2002:a63:1405:: with SMTP id u5mr131338pgl.268.1628239125370;
        Fri, 06 Aug 2021 01:38:45 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id i1sm12755430pjs.31.2021.08.06.01.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 01:38:44 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: If doxygen is not available, be sure to report "doxygen: no" to ./configure
Date:   Fri,  6 Aug 2021 18:38:40 +1000
Message-Id: <20210806083840.440-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 configure.ac | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index bdbee98..cf50003 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,6 +52,7 @@ AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
 AS_IF([test "x$DOXYGEN" = x], [
 	dnl Only run doxygen Makefile if doxygen installed
 	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
+	with_doxygen=no
 ])
 AC_OUTPUT
 
-- 
2.17.5

