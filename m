Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6219C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 19:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiLPTJD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Dec 2022 14:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiLPTI4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Dec 2022 14:08:56 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C0016DCC6
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Dec 2022 11:08:55 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m19so4953046edj.8
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Dec 2022 11:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sl01uXOD8kRZWaUVYqgTcN9CY3Yz+9E9pLdE06AV7LY=;
        b=kSW4dEgpW/Uels5vLfePr4E8C+Icb/NE5pifealZa8H2SGoj2bLmnMOzOP0xRFJTFk
         ELbRk1ysVT47NFEMywQzzPm3esuvbx0qqeyS4gC+CV2UHRwOjWTXkgmnPYBiuYeOo2v8
         YgZMvnlgx2Tv3VJlfgp0KdakbUNzDS2o2aZvgpn6ZgXEbfg1TckzQptMwVNtx9xy/8T6
         ErvHtmWEm18gj1fk2WuVslpMkJ1gficXd8MEUhF8i5PRvlfBrQDa01aFXfZTn9WR78f0
         NRvkn3JOoxLHyBY0nVbdCayNrtByDXvNvlvyAPJ9NVT/Z45IVD6/KAP2BQq8gWxXbQ+l
         oAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sl01uXOD8kRZWaUVYqgTcN9CY3Yz+9E9pLdE06AV7LY=;
        b=pVv4OcSErxsVE29uWAKI2ITL/G5dt/EB0M5IrqymeyiLDuv9Ujmu4SONHO5LSgCl5i
         8KMWd3yUkjZ3MVZE0QlwUGBv+FK9Pd3wlxqXtqFJWlDqUZ/LuU/jSKH4t9g34MoMtoom
         GPBUH+AAwXC/iiSZzWFuYoGzBvLl3IFYY0ESZdMlAyF3ONWcea+crqSjnuzffh9zQmYX
         +0daO+KdZY6Ef7kfBYB6ZMHo5JcEyPoxtS2XzyTOiP9CpbVVqnF2YfCFqs/KBtUKcK8E
         5dzSsF5WhEHvt0co3CScUcRLuFssfblNEMjA1jURobKqgsDr/rlzNW4c4uMHkOLqGWev
         ejOg==
X-Gm-Message-State: ANoB5pnQ3x+zr0Ey2ckN/jJtGAsyAo5r508mIbAu59DsQDLDqOaCmCTh
        YxB70xmuhrBPEmWfXqIESR56o624HSs=
X-Google-Smtp-Source: AA0mqf4oiXmqhG3dIZPjQp9M/6fJakuNosRXpxt+eU2CoejMgUeUDHR36Wz7179223UTVF8byF4U0Q==
X-Received: by 2002:a05:6402:4442:b0:45c:835b:944f with SMTP id o2-20020a056402444200b0045c835b944fmr29086997edb.11.1671217733834;
        Fri, 16 Dec 2022 11:08:53 -0800 (PST)
Received: from localhost.localdomain ([2a02:ab88:3601:da00:f68c:50ff:fe53:cb63])
        by smtp.gmail.com with ESMTPSA id c6-20020a056402120600b0045b3853c4b7sm1184931edw.51.2022.12.16.11.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 11:08:53 -0800 (PST)
From:   =?UTF-8?q?M=C3=A1t=C3=A9=20Eckl?= <ecklm94@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Balazs Scheidler <bazsi77@gmail.com>,
        Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] src: Update copyright header to GPLv2+ in socket.c
Date:   Fri, 16 Dec 2022 20:06:10 +0100
Message-Id: <20221216190609.44993-1-ecklm94@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221207150815.73934-1-pablo@netfilter.org>
References: <20221207150815.73934-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
Cc: Balazs Scheidler <bazsi77@gmail.com>,
Cc: Florian Westphal <fw@strlen.de>,
Cc: Phil Sutter <phil@nwl.cc>
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
---
 src/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/socket.c b/src/socket.c
index eb075153..356557b4 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -4,8 +4,8 @@
  * Copyright (c) 2018 Máté Eckl <ecklm94@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
  */
 
 #include <nftables.h>
-- 
ecklm

