Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7F6C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Jun 2022 16:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbiFBQey (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Jun 2022 12:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236738AbiFBQex (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Jun 2022 12:34:53 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDBC13CA3E
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2022 09:34:51 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id s12so3793951ejx.3
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jun 2022 09:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0B1LK0KstwgUTnMOacN6khMuZlYalZmypJA8QSYOPVg=;
        b=iLDhRhrySWGqH61kfmIg6EWc+CiXT/RMr8hgAriE+g0x6GbqRedeoz8npdvkHzLPo0
         9oxiSUdNG5ZP8zakgFabi6+g1yhLImehZKnzIUHpXj+96NMamVb/u2SagJXpBG4Q9O0J
         XlvGQGpiepHT+MPxVJRtFrwWE2zxtydfmwvgv8Oz3Vu6e+G1RReospD5zldoE222I11N
         SWStc0IqEXRd7hcVMAnXyOeWrhuuP8ARobqP8dhbj+pFxthEzBnBIaiU0NyuryCEx+J2
         bKq7K2ll6AgcoPvfdbINDeOF//jm5AzpG7gRR6emlGsOlUTv2n2d0OxR16DOfNjoGII6
         VS4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0B1LK0KstwgUTnMOacN6khMuZlYalZmypJA8QSYOPVg=;
        b=5j7w+O7gTEIch5Xrks3JKvElagre0J0oFKZzszID37I+HA+08z2P6/qHAPg438NFyf
         H42XRmm5R2pHZ4sHK5PeSICeDND7vnVoob4+CqTSuGbj91aAJWkHA4kEtwOwbjPEkeRc
         uPsW1jpbbCkHqCdXNv36ADSsvjC0fqIHVqbj8PI4ItN4XiBx+ChjaGGhow9foZCEGLoJ
         O9WYcGlZWfJVpruWJ2HmpTC5A8Wxd/AO7NShXmiQuI1KXeeyx9vK/Sm8Jnv6p695DDih
         ennNur6GZlUIc+qbPrMPERKgTvdfNRHu+VMb4RYoSgDg6dsaMa766mNYwCHe52c1xkLF
         GGYw==
X-Gm-Message-State: AOAM530dq4cF8CVX0DkVGg4CFaj9AXCFyyRzIX5StlIbO+OlDC3ZErFS
        f0kCA+vWx2KMvO0+COgtzjdxESzMfm2qIg==
X-Google-Smtp-Source: ABdhPJxTFrsVP0f6frvA8kyby5qk/n3P4pR/9Tlor4z7JTNE82aeTLqoG191zi1NkO+hcZjN1UZQrw==
X-Received: by 2002:a17:907:7e84:b0:6fe:cded:7d1f with SMTP id qb4-20020a1709077e8400b006fecded7d1fmr5105447ejc.35.1654187689452;
        Thu, 02 Jun 2022 09:34:49 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a02:3032:d:38a1:cadc:e8b7:bdfd:d7d0])
        by smtp.gmail.com with ESMTPSA id i14-20020a17090685ce00b00706287ba061sm1881833ejy.180.2022.06.02.09.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:34:48 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 0/1] Reusing modifier socket for bulk ct loads
Date:   Thu,  2 Jun 2022 18:34:28 +0200
Message-Id: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

As discussed, here is the follow-up patch to use the same
mnl modifier socket for all operation in bulk ct loads
to increase performance of such loads.

Any feedback/suggestions are welcome.

Regards,
Mikhail

Mikhail Sennikovsky (1):
  conntrack: use same modifier socket for bulk ops

 src/conntrack.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
2.25.1

