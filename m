Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F12E95A84
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Oct 2023 02:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjJHCln (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Oct 2023 22:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjJHClm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Oct 2023 22:41:42 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C81BA
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Oct 2023 19:41:39 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1c0fcbf7ae4so2562072fac.0
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Oct 2023 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696732895; x=1697337695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=i/L+UD75hsMd61ESdhzt5v7e6ZszIAOh0sq67RG0miw=;
        b=YNilfbro3ftIAGCIUZBC+w6v76j+G/fCwtgtQn6xHVU1Cs8tQ4GxCnHLTClHZ1iWLj
         oqZR3sbQcMEqLQmcF1SkYcPSsU149eN93za9sg1Z5cRupvuRk/HGFgSHd7WKKq3geSXp
         ziljX7oTsNWx3c3ubPtf7F4U2VRnHpEzede57p2f0dv0u0OsHx76Ues2vCGIMv85uled
         kllS97W6A5xD3FahjVdoUaYXaRiJNWbG+1Xt2xAS+I2GV+ymMyN4jy7PhswlBjXji0xK
         NPm7FSVSYSxpeqBc1FZN6MGUtp9pR9y9JrRqASERQK9RL7aLSXKB0+HOlNMs/9JRlyR2
         zr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696732895; x=1697337695;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/L+UD75hsMd61ESdhzt5v7e6ZszIAOh0sq67RG0miw=;
        b=voAqVzJJ+SqWxN/xuEAreTGygvrpZCBGv1Rkr8o1+K1Fam5yml7se6qloVbqNrMePb
         mX7Rv5RZYShf30nI87Jz5b++fDxL3fOuOWH9dk5o5s3EXD0vkvFehwXBWbGRuJxd3rPA
         bUN6AaJ5vJSBY1u+CVmZFm5hrrP44e6JJw09ZNzz4dW4nXItMMpoWuKVw0csbZB1ZDJg
         7IYAwCrBMczrvqCDp8K4jsqO9KITTPoDQ6ubDC+TJ+utlyr63g/3+vgaq0qbzZ+4V8Kb
         J7N/Ddw0qq4BeVOcNoDVyXD70kf3tk7KgDsSzdi0F5hHWoNKPtZSLZo/ZlfZkxZFc+z2
         Zf8A==
X-Gm-Message-State: AOJu0YyH2nirrqBar8ZCvbvGNQTNRsLk9uGrletDMOIPnD/o4TLNAvie
        YjRvzpcpJ3Lwq77KqWyYyETM/3lexOY=
X-Google-Smtp-Source: AGHT+IFxGZBETg7Z57VtaFVxjcFqxcWS4DHAzSx3Zkq8LaZcwn2sRoYd87KTgVCESxmBXQajS8O8RQ==
X-Received: by 2002:a05:6870:2383:b0:1bb:7d24:eabb with SMTP id e3-20020a056870238300b001bb7d24eabbmr14024382oap.0.1696732895608;
        Sat, 07 Oct 2023 19:41:35 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f54d00b001c61921d4d2sm6605987plf.302.2023.10.07.19.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Oct 2023 19:41:35 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] src: Fix IPv6 Fragment Header processing
Date:   Sun,  8 Oct 2023 13:41:31 +1100
Message-Id: <20231008024131.3654-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

2 items:
 1. frag_off (Fragment Offset pointer) overshot by 2 bytes because of adding
    offsetof() to it *after* it had been cast to uint16_t *.
 2. Need to mask off LS 3 bits of ip6f_offlg *after* call to htons.

Fixes: a0c885ae5a79 ("add pkt_buff and protocol helper functions")
Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/extra/ipv6.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/extra/ipv6.c b/src/extra/ipv6.c
index 69d86a8..fd8ebc4 100644
--- a/src/extra/ipv6.c
+++ b/src/extra/ipv6.c
@@ -113,11 +113,11 @@ int nfq_ip6_set_transport_header(struct pkt_buff *pktb, struct ip6_hdr *ip6h,
 				break;
 			}
 
-			frag_off = (uint16_t *)cur +
-					offsetof(struct ip6_frag, ip6f_offlg);
+			frag_off = (uint16_t *)(cur +
+					offsetof(struct ip6_frag, ip6f_offlg));
 
 			/* Fragment offset is only 13 bits long. */
-			if (htons(*frag_off & ~0x7)) {
+			if (htons(*frag_off) & ~0x7) {
 				/* Not the first fragment, it does not contain
 				 * any headers.
 				 */
-- 
2.35.8

