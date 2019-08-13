Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D070C32750
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 06:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B75A20842
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 06:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfHMGJx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 02:09:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41315 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfHMGJw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 02:09:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id j16so4345924wrr.8;
        Mon, 12 Aug 2019 23:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=maxOAdMiS/xfSYWsDRy3DYEAb7NCOxMvoqPrTEM6hGg=;
        b=GHc70X+zF+QSjj8x/Tij6dQQpQSWVL7Oj6n6qfoZ/0WCPeo1LzhEJQ9coz3+WResai
         4TtzSE1+0ijiP+DWqg7yxhmxh0ut0281kTKBsqL5lvrdyCno+8l0VEJH5Ctn1egZ/Fw8
         nw2f4Q7AC2H/ZE+ivbG88eemN0/zo5uEgc+cwxjOWeFoBdhAZs/WAQpCkIVDq09/MfQa
         OqGAY1lHMC0Bu42UuJeZH9y5nva3olWB1KnMQIhPTvBfWmN4lJ/5i0e794OcrketSGjN
         VPx3sbF3L7KSsMj2JhnYS/CF245I8eqoMn4pHdvUCWqdZVXZ5QlTaVkb7Rdi/JdnMtO+
         guMA==
X-Gm-Message-State: APjAAAUgE8VWyCO41bv1whGLrHOsQHBYlyDQfr+UlA8taDqjVN8WxVJe
        9okb6/2Vi0PPGlZbkcBDgCfJpj4qP/s=
X-Google-Smtp-Source: APXvYqzbBriL+bF8uJ2yyYWXnrkp6leIJkJrAeXCvoExrnAuLLrZH6dxl12sou/Xc17YJNSW4PNngA==
X-Received: by 2002:adf:db09:: with SMTP id s9mr17326965wri.214.1565676590476;
        Mon, 12 Aug 2019 23:09:50 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id o11sm402494wmh.46.2019.08.12.23.09.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 23:09:50 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: ip masquerading: Update path to the driver
Date:   Tue, 13 Aug 2019 09:09:41 +0300
Message-Id: <20190813060941.15012-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
References: <7cd8d12f59bcacd18a78f599b46dac555f7f16c0.camel@perches.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update MAINTAINERS record to reflect the filename change
from ipt_MASQUERADE.c to xt_MASQUERADE.c

Cc: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
Cc: netfilter-devel@vger.kernel.org
Fixes: adf82accc5f5 ("netfilter: x_tables: merge ip and ipv6 masquerade modules")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 25eb86f3261e..87ac0378186c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8443,7 +8443,7 @@ F:	include/uapi/linux/io_uring.h
 IP MASQUERADING
 M:	Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
 S:	Maintained
-F:	net/ipv4/netfilter/ipt_MASQUERADE.c
+F:	net/netfilter/xt_MASQUERADE.c
 
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard@acm.org>
-- 
2.21.0

