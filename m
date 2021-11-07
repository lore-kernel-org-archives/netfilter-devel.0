Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DD5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Nov 2021 01:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C027A6127B
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Nov 2021 01:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhKGBcm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 21:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhKGBcl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 21:32:41 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CF7C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 18:29:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y1so13398925plk.10
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Nov 2021 18:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qP/GfuHSqXgcyx8byXCmagMpPORaeKXqMr7funC3yDc=;
        b=FDqPKlm+ltE6Hf3dLwPNpmxZ99Y3HVAHfhTgbGKa1lylzStn13HiPCdWUvUlmUmRp/
         lWDVrIlkdf1HefmpT2dy6FMdOB4wnCacYiPYcjqSfFQiQa0ORLLzgSBSceCDlwAB4xEv
         Iifiux1qOUJBUoUYaA1w4YeKpQrWsrFbrBpfr90S/mrBWxVsHamjyNb1j99qgb1aj4Bt
         VL78cctKuFJE7JgXz0PTVqKgOi0bQ4IlbyymeVTj+bZuS0JcHaqvN1G8bo4ZRD8lLj3m
         iw/oEb3ptoZ0cjEAObSdJufMHiN6k6g7yJMC86IrJ48PTRNLiffWPGTe4FofmXLSXuY4
         uEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qP/GfuHSqXgcyx8byXCmagMpPORaeKXqMr7funC3yDc=;
        b=kCdw0mIQbg+sUKCx4lUmjF3SGWyusGDxhTyYG27dBJgeE1/fck1vMXrnT6OcUocW0t
         RUn3MuJeISQeHko0ceSJsvrj2YyIfe2FeCCpV5VX+g7dx21HeNh2/McJWKIDgzjzCzHM
         3lRNgBqTDRiubqxf+xGCO404qxd6JAnLVPnrt6H0824vC36vE0Q/teFe5bi7OwnyyYVU
         1VG4RNFL8sNYSc6+W71/6bBppw3EdfaV3xjfz5f2IR3oGX8WOLBHEtf8f5iOVlfyKS6s
         9rUTExcZBLzIaKZAle+m9XYb4TssguWSacIQwfClgkFedPOKAgK7wF+cBh0MfdT4FTvl
         CyPQ==
X-Gm-Message-State: AOAM530dTujNP7sFLJasQB4QO0fS3lHAPCqeKVruI6DjaB613ZsR1IBA
        fXzNU+GBIkpylGNfxUZYqUgkTOZO3Os=
X-Google-Smtp-Source: ABdhPJw3vh8Kra7T92tcoJs9wNsdacSE91e/fP565U7GC8iBnPjA6a07bLdqthpxqoGAc4hX0Fhxzg==
X-Received: by 2002:a17:902:b18b:b0:13a:354a:3e9d with SMTP id s11-20020a170902b18b00b0013a354a3e9dmr61345427plr.36.1636248598550;
        Sat, 06 Nov 2021 18:29:58 -0700 (PDT)
Received: from localhost.localdomain ([2604:4080:1178:803a:d4fe:9eea:bd14:ae7])
        by smtp.gmail.com with ESMTPSA id s69sm8910117pgc.43.2021.11.06.18.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 18:29:58 -0700 (PDT)
From:   Will Mortensen <willmo@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Will Mortensen <willmo@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        wenxu <wenxu@ucloud.cn>
Subject: [PATCH] netfilter: flowtable: fix IPv6 tunnel addr match
Date:   Sat,  6 Nov 2021 18:28:21 -0700
Message-Id: <20211107012821.629933-1-willmo@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously the IPv6 addresses in the key were clobbered and the mask was
left unset.

I haven't tested this; I noticed it while skimming the code to
understand an unrelated issue.

Fixes: cfab6dbd0ecf ("netfilter: flowtable: add tunnel match offload support")
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: wenxu <wenxu@ucloud.cn>
Signed-off-by: Will Mortensen <willmo@gmail.com>
---
 net/netfilter/nf_flow_table_offload.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index d6bf1b2cd541..b561e0a44a45 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -65,11 +65,11 @@ static void nf_flow_rule_lwt_match(struct nf_flow_match *match,
 		       sizeof(struct in6_addr));
 		if (memcmp(&key->enc_ipv6.src, &in6addr_any,
 			   sizeof(struct in6_addr)))
-			memset(&key->enc_ipv6.src, 0xff,
+			memset(&mask->enc_ipv6.src, 0xff,
 			       sizeof(struct in6_addr));
 		if (memcmp(&key->enc_ipv6.dst, &in6addr_any,
 			   sizeof(struct in6_addr)))
-			memset(&key->enc_ipv6.dst, 0xff,
+			memset(&mask->enc_ipv6.dst, 0xff,
 			       sizeof(struct in6_addr));
 		enc_keys |= BIT(FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS);
 		key->enc_control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
-- 
2.30.2

