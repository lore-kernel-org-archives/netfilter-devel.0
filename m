Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522CCC282DE
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 09:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 074542075B
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 09:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nfware-com.20150623.gappssmtp.com header.i=@nfware-com.20150623.gappssmtp.com header.b="sx9J+qvB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfFEJcr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 05:32:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38443 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfFEJcr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 05:32:47 -0400
Received: by mail-lf1-f66.google.com with SMTP id b11so18571539lfa.5
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2019 02:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nfware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WOFpsitPD9CuJytHuND7By9/J+aiHSP2evoHUJKB6ek=;
        b=sx9J+qvBiCCVh47A9yPuWypE7U1Mup7IxCfVsX1cHCa0uI2qSKfvgvpnNghi6qs3oP
         1UuxO24L8mSASkyP3eD7+0ixMMpOzHh7NA69hy7y+JTv+9jFuIvAy5zwqYx5GtbgKNWj
         0j6NWG1VXm+HEQN+/RPj4Tg/px6AqlEEpT9jxelFyXjOTXsvVroVsQoZb7u0gEo2oyut
         vhEdfSFtSGQMMZhYmKIRplP1kMam4DGoRU/NIqlvJTvHvPeDl+njSMu4qTeKKiz2qBtq
         8RVeLiDX3xZMjJ30tyog9dxzCIPGnrcHuw81yGpVXivmLj+dc0f9m7eovPDCF3ZMKHim
         kqkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WOFpsitPD9CuJytHuND7By9/J+aiHSP2evoHUJKB6ek=;
        b=rT7Y7IlyB1d2C38eM7qDDabwlZ/troa8scYntsYzrp7PYiL24dY6oRTWLRqaN72yUv
         NY1TpErv4T9FXP4+fe6Yg65uQJ9CNEA6tquRu5UJMH0BVKzgLmfEgmlZiCkNJPZRvt9Y
         6HIdmfuXDhzLfTAOxNkLbZ1SyON/DKbjTaP5D4YRePLBCU8VMVSipYZQuIHoMFsO/Vgj
         cGMTQ2fInm5MkSobnAoq5BaV2TnwnN8GbTPmH3uohTvfc/xRi+XCbmbALNA9Afvr3iqn
         muEaAF6ykGS0ii6u6OMb2qG7DTXpr7ZQC73j/hQui+zJrUAsNnppSVJ+lyXxTBIR55P7
         4RCQ==
X-Gm-Message-State: APjAAAUf/yyexJ/YSVKhHStZGJmGheax7rwzEHBgS7GFJ+deEAImxb0b
        lMAVRydLXJ622+EOmqoG5Du5k65lj0o=
X-Google-Smtp-Source: APXvYqxAprGuPwbs/7StTZBXPYq/XrlaX8nvR7UsxEtOzLQRYglmOkDtWuGbsOTr2dAAXyagjzfuVw==
X-Received: by 2002:a19:4a49:: with SMTP id x70mr7038921lfa.151.1559727165590;
        Wed, 05 Jun 2019 02:32:45 -0700 (PDT)
Received: from localhost.localdomain ([212.48.63.198])
        by smtp.gmail.com with ESMTPSA id q13sm4089461lfk.65.2019.06.05.02.32.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 02:32:44 -0700 (PDT)
From:   Igor Ryzhov <iryzhov@nfware.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
Date:   Wed,  5 Jun 2019 12:32:40 +0300
Message-Id: <20190605093240.23212-1-iryzhov@nfware.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ct_sip_next_header and ct_sip_get_header return an absolute
value of matchoff, not a shift from current dataoff.
So dataoff should be assigned matchoff, not incremented by it.

Signed-off-by: Igor Ryzhov <iryzhov@nfware.com>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index c30c883c370b..966c5948f926 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -480,7 +480,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 				return ret;
 			if (ret == 0)
 				break;
-			dataoff += *matchoff;
+			dataoff = *matchoff;
 		}
 		*in_header = 0;
 	}
@@ -492,7 +492,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 			break;
 		if (ret == 0)
 			return ret;
-		dataoff += *matchoff;
+		dataoff = *matchoff;
 	}
 
 	if (in_header)
-- 
2.21.0

