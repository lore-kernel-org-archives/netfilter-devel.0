Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD4FC07E96
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 01:17:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE8C61107
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 01:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhGGBUO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 21:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhGGBUO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 21:20:14 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49251C061574
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jul 2021 18:17:35 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id a14so152722pls.4
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Jul 2021 18:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0zcNBWPfo2b0G/+pTAU8eFEeDxHCMi1a4L+lgcq7L7o=;
        b=hhwmeEKs+ds30elDTUyZJ/3EBeBMiZSKaznWn87UUy8zs81i6mXDJp9XwsN42n1+/B
         of587Etp5lki8c6eQcsSoKlW4N43GThzI1V0nzEhlkIzbYwU2hAr2tQrDosRO3YIvTrX
         fzZ27iKuIwgIm3yLhVIifSfdjf4AHSRr2PvsFx5Yve9Gfpy2pWnYFUG6PQ/trcKTlV3D
         30R+D/T5VS+qEp/EtUvqXo0iN3bXG/EskxNPU26Fvm92IxcTf+D9Rg8/S4Da2Rqt4oFe
         8b8GMgjHk8AEVyeF6I2fxyyLqCYLQin0eKg9Ia64ZSOLYPVHubUtYcTNrRMa78eLLxTU
         QOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=0zcNBWPfo2b0G/+pTAU8eFEeDxHCMi1a4L+lgcq7L7o=;
        b=ShTqvi09rX5ljDQkHHvhODzWZK0evPi8M9y05EZrAYFN8/vOhvUs+SQDkRaZJ5kGMg
         ChnnqCrKagPHxPxoWetZcf2KlkFZPwIZWN1pyYCXrspnt1NEY3jMC5QbrGOzJNSe5WMS
         qrAszW5RMhZcZA8LQuG3bBLmLdge5AedivQj14792BXa3GWfGb4aqLQTEueBD09pzDXw
         mUBajF3lyDyiLgbncUELo1dUl9TxURpGe9Nib+IG/UvK4LSmudxtiZPdPosaSTWENGpT
         v88ZpDy8wQG0S9hp4KqWSRLr7cJ0TvcfchoGX0kXXSUIZ5fR+F9pJs2yCLk5VTk9YHEC
         WfkA==
X-Gm-Message-State: AOAM5332sOWu5t22/YilmFoZTFemU99kNRXxQ1/3ZBwnr9IzpndexgEH
        vA/J+wzcG6iRtB/QkK7cxiw=
X-Google-Smtp-Source: ABdhPJwPHVnq4PMBFvdd8kdxJ/+3o97vQSHkdM2aHac0+1rAGLP+4ieesiNFH7BJEZcDj9Kao9DvYQ==
X-Received: by 2002:a17:902:ba92:b029:129:7514:4523 with SMTP id k18-20020a170902ba92b029012975144523mr15266879pls.77.1625620654800;
        Tue, 06 Jul 2021 18:17:34 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id w123sm18511365pff.152.2021.07.06.18.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 18:17:34 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: annotation: Correctly identify item for which header is needed
Date:   Wed,  7 Jul 2021 11:17:30 +1000
Message-Id: <20210707011730.12181-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210706224657.GA12859@salvia>
References: <20210706224657.GA12859@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 examples/nf-queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/nf-queue.c b/examples/nf-queue.c
index 3da2c24..5b86e69 100644
--- a/examples/nf-queue.c
+++ b/examples/nf-queue.c
@@ -15,7 +15,7 @@
 
 #include <libnetfilter_queue/libnetfilter_queue.h>
 
-/* only for NFQA_CT, not needed otherwise: */
+/* NFQA_CT requires CTA_* attributes defined in nfnetlink_conntrack.h */
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
 static struct mnl_socket *nl;
-- 
2.17.5

