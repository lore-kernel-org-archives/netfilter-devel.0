Return-Path: <SRS0=e//N=EM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9731C388F2
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Nov 2020 08:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E867208B3
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Nov 2020 08:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vaPz8WGl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgKFIUT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Nov 2020 03:20:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgKFIUT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Nov 2020 03:20:19 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35704C0613CF;
        Fri,  6 Nov 2020 00:20:19 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id v12so602841pfm.13;
        Fri, 06 Nov 2020 00:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f2B4u15lC2Ii8tq/d8kCTsZtVNP3WmCeuq2bZvx3ex0=;
        b=vaPz8WGlio/V0T7a0R81qmZoIkZpylBBNoCVbgjXNYSAAtFYVSfPZW/1aCza+xy3Qq
         Z3lOeF68roT/EEpuMSAcSFTocyXuW98Cmr1PL+fTK9ZERXdSxu3FORYit5DfDwS2ZxNl
         dUFd7gs+Mn5q/KaCu+Fw7quVHVCvbgmS4gyp7Lro3Qi6WbjVO2xbHIyoCV39JKwuOG6Y
         aKQKlFPWTTcm6qmsFfBl9o0N0KK5lOI4S3H0V9hoYF2/CS5MD1GoyqTIAS++C2SFfyBT
         FWelGYdeNFm8vgQCPf/JCiJKi9Z/WEfF1aPm0nTi4igTxYOtHXDh2BxwCiQF94IBNvYA
         Hrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f2B4u15lC2Ii8tq/d8kCTsZtVNP3WmCeuq2bZvx3ex0=;
        b=ghBzkn6BIBEQtliH3i83Eow2owZ2IJWi4jiINzvOMerqoIcYoKxrEcDkhygO1x7i4o
         NHGVJeoejwNQ2BBzEUEuZaxzATAy8VVMACn45cAfzHVdG5m/Geg3jEVAJL/mn0L0Y2fH
         cb49fJ4V5po/fwcNuAgm/ww43C/TwKnRluTe+NaY4xysx3ZA/FcPekgTWYAutIVXGy7c
         VSdRh2P8jl4I81gkgKH79Are4tOlAbRtkmyRXK6e4pEhaShYUGG6cSvItZbML90ZLMuh
         OGlQoEeuXkd9uQb3PxwAHIsIcJMkw0mB+74QjWhbVoYeyZTcbdq4X/sU//8E52c/fHYq
         ppZQ==
X-Gm-Message-State: AOAM532yRqLvbfPbvkwnJ71YAKBPkhb+9/ARlabyKjnYDaf713fy3JHF
        lI9O68ZVbsuMj1AjFJafLY5c//aL66N9
X-Google-Smtp-Source: ABdhPJwr/2o3Byk4DBdlB7a1P7ZbpNs4X0OJ56qGKs0Oc39AI2TalVwlH8x9OdPAJvUSidUsrhb7pw==
X-Received: by 2002:a63:3041:: with SMTP id w62mr852183pgw.166.1604650818861;
        Fri, 06 Nov 2020 00:20:18 -0800 (PST)
Received: from he-cluster.localdomain (67.216.221.250.16clouds.com. [67.216.221.250])
        by smtp.gmail.com with ESMTPSA id d7sm896697pgh.17.2020.11.06.00.20.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Nov 2020 00:20:18 -0800 (PST)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] netfilter: Remove unnecessary conversion to bool
Date:   Fri,  6 Nov 2020 16:20:13 +0800
Message-Id: <1604650813-1132-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

Here we could use the '!=' expression to fix the following coccicheck
warning:

./net/netfilter/xt_nfacct.c:30:41-46: WARNING: conversion to bool not needed here

Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 net/netfilter/xt_nfacct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_nfacct.c b/net/netfilter/xt_nfacct.c
index a97c2259bbc8..7c6bf1c16813 100644
--- a/net/netfilter/xt_nfacct.c
+++ b/net/netfilter/xt_nfacct.c
@@ -27,7 +27,7 @@ static bool nfacct_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	overquota = nfnl_acct_overquota(xt_net(par), info->nfacct);
 
-	return overquota == NFACCT_UNDERQUOTA ? false : true;
+	return overquota != NFACCT_UNDERQUOTA;
 }
 
 static int
-- 
2.20.0

