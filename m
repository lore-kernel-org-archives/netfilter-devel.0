Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A20C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Nov 2023 06:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjKLG7b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Nov 2023 01:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjKLG7b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Nov 2023 01:59:31 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63402D6B
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Nov 2023 22:59:27 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1cc921a4632so30443905ad.1
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Nov 2023 22:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699772367; x=1700377167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+HMOKajMzMaS+H8dygfXxCWA6IdbFwg5PDL5rujcvwQ=;
        b=U2k1y8dcd8CqlwMzMfEbtDEWxlYch53r+u93ImbkC0WsiLEBFPuETGb9BzbDq/JCgB
         RJFGCqmd6+Lm3XF6bTW/5mX65M9U2BFIAcSvL9JsNLHg18DuHWz9OAAA71nF/siB2VZQ
         6nvkeAN/Y2a0/Mkbd6mql2pRMnJCWzq3HUrJbHyPNCFHQSK/yDJ01AB01Lp465fl4U02
         awp96U68JIxzsdbRBk1SqR0YCN5FYU2Sdk05bO2pyql1P05JIygHMkAWS7O4X9Ad30ii
         juNqGcc9hJhMZjdSjVMiYy7kb4m8cBmhDOazPvhDXUPEaXipG/4un+MGZ6JhDS5YVg0x
         BI8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699772367; x=1700377167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+HMOKajMzMaS+H8dygfXxCWA6IdbFwg5PDL5rujcvwQ=;
        b=QOnAgsiU/R4Yt5SjFASpzmCOfdAqZ9Cq8fInTlBXLhaGlJBQGciUDRq5lDM1bcS65J
         lrSg/LZ1x9/iMSGbVKXPpl24K21LPLsE/fjoXGX/NFtQbwnvTSib4WdXFAcJ7ZBEOkj1
         cqPXDz9N1ASFoCagZZiEeClmMlVvpmuEBacl8GGMVS9Tg5tls2n2CaAWdPwTtaYQQoW2
         Bo1pteiK6MiyCIKhUbLOIEYOw3qIL1Aqzmfc/y2n5sNpLg7cEQfMRBkNwEgqu3/jRS6Q
         /pNtXimPTnUJ4/ls6Cnt9iXN8vc+Gs8gXpondiw1L7ROgg6N9OAVUuOtqLHqBMeOe26K
         xjqA==
X-Gm-Message-State: AOJu0YxSvREyb4jprrNiJVNlvMEO4NwPM+YCWWI1qlXdHU2uyi7Kb4xf
        7QYmsEQaYEIpIFB93zzqdHoa0GYaGb8=
X-Google-Smtp-Source: AGHT+IGyXvIwf4dJqk60zIuNnSq663Dr9x4pqZTP9nvHV1yvMAzhLau6yqgcuEi47FfVBc7DQ8wRFQ==
X-Received: by 2002:a17:902:b08f:b0:1cc:4cbb:c564 with SMTP id p15-20020a170902b08f00b001cc4cbbc564mr3392467plr.69.1699772367254;
        Sat, 11 Nov 2023 22:59:27 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d30400b001c9bfd20d0csm2159363plc.124.2023.11.11.22.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Nov 2023 22:59:26 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: libnfnetlink dependency elimination
Date:   Sun, 12 Nov 2023 17:59:21 +1100
Message-Id: <20231112065922.3414-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some of these documented changes haven't happened yet.

Duncan Roe (1):
  doc: First update for libnfnetlink-based API over libmnl

 src/libnetfilter_queue.c | 56 +++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 18 deletions(-)

-- 
2.35.8

