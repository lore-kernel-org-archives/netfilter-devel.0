Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A34C2D0C8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 00:09:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4B502072A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 00:09:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7fvc0n9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLZAJg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Dec 2019 19:09:36 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34973 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfLZAJg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Dec 2019 19:09:36 -0500
Received: by mail-pj1-f67.google.com with SMTP id s7so2758070pjc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Dec 2019 16:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Idwj9WaOsMr0qt00v45BLnXheQ8/XujWHBiNNm2CBV4=;
        b=d7fvc0n9PX/T5khhw+Veyi45h5jmo3S6c6USrOzEHQCY788bPkaW/ZsJlamn877BBN
         01lgaKGemI79HqrZIVhGrO/nTumV7jFJrK6+bhzUuTfRQy1PdENbTvfD2D7Ism7Tz9ic
         IJ4kzLbXX1W3VhrRhKhnvauS/CdfgMMSNnB+c0hLjnY52GintbL2trontfyQXz7J+nRp
         VAFvNPh6NtmlcaZSrOm8b/nTODk/UrsFUJ51jGewkHyRWjReIP2ZRcqx4/+e9M+j5IcU
         VStyIwbjZC1h0A6OuPPtgP15+0+oz+SKHBCe7SzLR2JBVUxNmkTmkjGtQH8ycV3dJVrn
         qWMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Idwj9WaOsMr0qt00v45BLnXheQ8/XujWHBiNNm2CBV4=;
        b=b3a+0aTvLfbsojJkXXGpSEfH4FfbiZcQtMjk63X5vwLrqAIbhqu0iquTrgTf019TfI
         hcfsSFWVXWn3oH1npnwxCnOtK6ZXlm8T2x20EyeEzF/mZaQYYtYTTSa4t6fBQ9SOtJPz
         mHy/r5yXBw5kmJ12jlBxqiCrfC59TognQUFoKrkYKCgS/OBsNy4y+1tqA/XFV199osbw
         /1LKfbLi5qzQIhriV6I6U2Fyi1+SWun9oVOLZDNNRdRPu9qEaNjCPJ0E8Vs4Xv4w3OVZ
         iSMPQ2BzI4PIxXmd7yBTW8U6k8iYkQN1uJN3/ptRHkbD3zgzSAK+fzR7Mah+4p0gqljR
         zOcw==
X-Gm-Message-State: APjAAAU9q/m53jYRUhEnL2PtNWxbTb2p9lszA3DBbK4sPFE6+PFlR7fE
        bY3zgWn6tEwAWebg8OaJTRDNQY4t2Ak=
X-Google-Smtp-Source: APXvYqwvcq5JIObS3tYYLrHUp5wWNOf/iE9LZ75mT2LQTLBev35E/OO+BWEHS9SVorduHVpw1chGNg==
X-Received: by 2002:a17:90a:8a0c:: with SMTP id w12mr15788534pjn.61.1577318975145;
        Wed, 25 Dec 2019 16:09:35 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id u1sm33001711pfn.133.2019.12.25.16.09.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 16:09:33 -0800 (PST)
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] doc: Fix typo in IGMP section
Date:   Thu, 26 Dec 2019 09:08:37 +0900
Message-Id: <20191226000837.56274-1-benjamin.poirier@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Benjamin Poirier <benjamin.poirier@gmail.com>
---
 doc/payload-expression.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
index dba42fd5..4bbf8d05 100644
--- a/doc/payload-expression.txt
+++ b/doc/payload-expression.txt
@@ -184,7 +184,7 @@ igmp_type
 IGMP maximum response time field |
 integer (8 bit)
 |checksum|
-ICMP checksum field |
+IGMP checksum field |
 integer (16 bit)
 |group|
 Group address|
-- 
2.24.1

