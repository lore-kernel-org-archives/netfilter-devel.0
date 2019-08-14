Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 048E5C32753
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 12:35:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65FA208C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 12:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfHNMfn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 08:35:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55090 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfHNMfn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 08:35:43 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so4461361wme.4;
        Wed, 14 Aug 2019 05:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o3+1DGCI+40iCgNQeNraT+W9gH7K4q3+/wyAXdj74H0=;
        b=Y/utA6970bNuf57jmahnslU0JUuQeOYYamV9KPLj7UtwsWa3hJnwyB0gt4kpatWFHL
         rZ8eRue5rrF7RgO1UgTTjp+bB4iYsMHDAzqeKDlL0iFzbUPQUbIoCT54ErrsZqAjdTiz
         63apVmn+5WstAbbkM/Qi+DuGYbB9Jxkycq04BNoTLuwmKXlB5zP7mDtZGMZLFiCUJ+Vi
         fbrQWva8uXvPlX9RahqigeXde4fKhVjXkTnwziKlaBD/XM8OT4QBaHckydcKcSoPf+4H
         kUL/7vvC2VgxCjOSAc/8sCqjJYlvB1Vi9T8cABzsyBuhrMQVoQ2N00//MsIUCgytJyW/
         TAfg==
X-Gm-Message-State: APjAAAWbFGSpC5pFeouBuQOmLRb5TFISN5gSW3adkO1TSV25GHBIbct+
        yEM8EUBgJdt9K6wzLF6ELBoGm/sQ7FQ=
X-Google-Smtp-Source: APXvYqy2OoJyBEUvH6yudeOQVJ8pnaYwbYPqS1dOWBGxCOQfCQWCjBMRvHokvOsd0MJqwKajAkwP2A==
X-Received: by 2002:a1c:a957:: with SMTP id s84mr8429998wme.65.1565786141198;
        Wed, 14 Aug 2019 05:35:41 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id g14sm23289656wrb.38.2019.08.14.05.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 05:35:40 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>,
        netfilter-devel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Remove IP MASQUERADING record
Date:   Wed, 14 Aug 2019 15:35:02 +0300
Message-Id: <20190814123502.12863-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190813085818.4yfcaxfk2xqy32fx@salvia>
References: <20190813085818.4yfcaxfk2xqy32fx@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This entry is in MAINTAINERS for historical purpose.
It doesn't match current sources since the commit
adf82accc5f5 ("netfilter: x_tables: merge ip and
ipv6 masquerade modules") moved the module.
The net/netfilter/xt_MASQUERADE.c module is already under
the netfilter section. Thus, there is no purpose to keep this
separate entry in MAINTAINERS.

Cc: Florian Westphal <fw@strlen.de>
Cc: Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
Cc: netfilter-devel@vger.kernel.org
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b03d2d4bfca..2ab292d1fa0e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8429,11 +8429,6 @@ S:	Maintained
 F:	fs/io_uring.c
 F:	include/uapi/linux/io_uring.h
 
-IP MASQUERADING
-M:	Juanjo Ciarlante <jjciarla@raiz.uncu.edu.ar>
-S:	Maintained
-F:	net/ipv4/netfilter/ipt_MASQUERADE.c
-
 IPMI SUBSYSTEM
 M:	Corey Minyard <minyard@acm.org>
 L:	openipmi-developer@lists.sourceforge.net (moderated for non-subscribers)
-- 
2.21.0

