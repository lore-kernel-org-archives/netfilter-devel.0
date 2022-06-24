Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E1FCCA473
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Jun 2022 15:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiFXPBy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Jun 2022 11:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiFXPBm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Jun 2022 11:01:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130F1BC3A
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id o9so3828163edt.12
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jun 2022 08:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=357uLHlRUMlpr+NZRfDB3TvOJz2otjc8t3xHBbesPds=;
        b=M8EmoUWHNhUiwa4PCH553gdXsoq0rLkFnvozxckmVnNgAkCyw1voxMW0GEna2PZSsB
         NLzUtNypf8ae21jzIMmoHLLXSdN5/AgjnSlJT2NrM/xeBBULnLZ8Xrr4Bk8vucxLgiz5
         L5bsAu78uVuqKwKqNtfhSMyLBWxrrKO+oNoCfgQeTVaFAPO05+s51p9j/02R5l9tjBzF
         LWPBB723UmjwhKY9MQqy6ESh9tWpUfticJ/OL7xvlOZXLnmRDS1frFl5VRWcmQfaHM77
         H/wWLpITG+dSd18P8GWVr7GcubJ+ZZzA2yb4pqU7DcjvIbx5T4Hcipq5RHV2Ds7NVWT/
         ga9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=357uLHlRUMlpr+NZRfDB3TvOJz2otjc8t3xHBbesPds=;
        b=AwMd32H6lsfydcvKE7DkxqoDqwEvkR9yoKbFK0Cb6DxsbtynPTXicfdZJZO/1CCxQm
         6npWPfdMyEni9vc3d0tCyPiB1t86hO/Jd4nzpErnuRs/hqO8/tZTm5DngEUACpHCIdyh
         +kxq/ztLZ+NKedIG+kbJ1VYGfqGO4gWUJadn1uK/NmpwYSYcfOSgCn/+Ca1GzQcbHf2j
         Sw2tuUmgxd4SfKVyCWoVZQDz/NW7lnmAOn3zXMvTc/LptPYU+Lhqr3oSMYqJovPSFe7z
         D3BcnlEOLE+ylieWzpM+nrUdiGWoQTZ9BvRHUFm8ZFBkdlgmIuWJ8OyBuAmez13eBhAE
         9vUw==
X-Gm-Message-State: AJIora+984B8qypUXNy4at1BZFpuM3Ienqk2pXH/TSFst66JmEMKTUuY
        Orumwdv4KN/srwQxj1P62j3Woa1wUl7+TA==
X-Google-Smtp-Source: AGRyM1tOiSppzJ+unnw1Ii415d9rfZ910QpoFFopXgBM9LS4cBnTJ4AZ3ABu1MvYDvlGSB/LG+l8Ow==
X-Received: by 2002:aa7:d7c4:0:b0:435:6a5b:b02f with SMTP id e4-20020aa7d7c4000000b004356a5bb02fmr17934514eds.365.1656082900186;
        Fri, 24 Jun 2022 08:01:40 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf48a.dynamic.kabel-deutschland.de. [95.91.244.138])
        by smtp.gmail.com with ESMTPSA id r13-20020a170906a20d00b006fec9cf9237sm1246842ejy.130.2022.06.24.08.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 08:01:39 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 0/3] conntrack: fixes for handling unknown protocols
Date:   Fri, 24 Jun 2022 17:01:23 +0200
Message-Id: <20220624150126.24916-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

Thanks a lot for the fast feedback!
Here is the updated patch set addressing your comments.

Any further comments/suggestions are very welcome.

Regards,
Mikhail

Mikhail Sennikovsky (3):
  conntrack: set reply l4 proto for unknown protocol
  conntrack: fix protocol number parsing
  conntrack: fix -o save dump for unknown protocols

 extensions/libct_proto_unknown.c    | 11 +++++++++
 src/conntrack.c                     | 28 ++++++++++++++++++++--
 tests/conntrack/testsuite/00create  | 37 +++++++++++++++++++++++++++++
 tests/conntrack/testsuite/09dumpopt | 26 ++++++++++++++++++++
 4 files changed, 100 insertions(+), 2 deletions(-)

-- 
2.25.1

