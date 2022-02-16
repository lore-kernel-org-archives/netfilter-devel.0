Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5A0C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Feb 2022 18:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiBPS7c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 13:59:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiBPS7b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 13:59:31 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C1D2AD677
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w3so5549023edu.8
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Feb 2022 10:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pf5YDEqKBffQVGZ75UkRSm3birQjMuJ8Qskuwi/B35w=;
        b=d/Jzl6AoebFAJmKnQxQjfFZbded6d9xz3sHDdxuBQq8KbgavccOUJWXfsNUNP2YRlc
         armVDER9E3rT9hq44pYKS5OL4u7AZcEAXdWmbJOplhiuGyBv7NE0UDc/iixsSD/Wr29Q
         r+/5JljOJgHUqYsZ0Py6xLVQMOIEmcU+rGMS1lCGIiUy1OwdInQq3rpFtsw9GoXBJ2zS
         xEctHj0ehRgNThTa4MKfAPAdLJPMe71yHPmnftK/58V1qAlHiGi+1z+TT6BkzOPKSbND
         UKJ9Q2UVndN85Ud+58Y1HKbDKMz0uVTX7rBFD8tL29SulDFVAGJfDjebFebq2Jq8r2/6
         /Vtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pf5YDEqKBffQVGZ75UkRSm3birQjMuJ8Qskuwi/B35w=;
        b=Rs8+wNeRN77g+ZZQ0kVElehTmb2AsgCBhpg8v03g2GOTVyE5TWrO9T4ZlrHj97rq9y
         Z/bRDyhurJZyPGGQlEblY+Y8YnSYDpUlzasoqWz525qVOVcUuIyx708+QM9H09ODUSDj
         9nD3sEq40wrozqQuFxGlyLkNjeENlo/UTY5GPuBfNCmZlv2eWkPaa8/J0rmJyuB8bkLo
         8UdR7LfpdrKBpw5yUxF4ZVSOuihqL3yDwnpbKaKHuAJjdT9FdwBts7fyOpr902wIyLkU
         k6D2ARlbxKiyMWlZz+KLbevRzzu4GwGVSWi10cvFS0gGFNraJyfs4FmLW787PRuVryRu
         MsmQ==
X-Gm-Message-State: AOAM5311MEOA0rTwGrxYFEtXj0SrvI3MXsa8f6UY9kehPGGv6rsfND3l
        65YCM27du/VWlUENr9IsvBewpiTXLuefxg==
X-Google-Smtp-Source: ABdhPJzib/nk4TPEiezmTs/SvLCc2I1/ihWGVihBIjZCGmKuYo5cUjVX4s0ZwwS5pCWiWR6u/WQSZw==
X-Received: by 2002:a50:d0c2:0:b0:410:8268:92b1 with SMTP id g2-20020a50d0c2000000b00410826892b1mr4588646edf.122.1645037956954;
        Wed, 16 Feb 2022 10:59:16 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf784.dynamic.kabel-deutschland.de. [95.91.247.132])
        by smtp.gmail.com with ESMTPSA id dz8sm2156167edb.96.2022.02.16.10.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:59:16 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH v2 0/3] conntrack: use libmnl for various operations
Date:   Wed, 16 Feb 2022 19:58:23 +0100
Message-Id: <20220216185826.48218-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo and all,

Here is the second version of the patches to switch to libmnl
the remaining set of conntrack tool commands used in the load-file
operation, adjusted to the latest master.

Any feedback is very welcome.

Thanks & Regards,
Mikhail

Mikhail Sennikovsky (3):
  conntrack: use libmnl for updating conntrack table
  conntrack: use libmnl for ct entries deletion
  conntrack: use libmnl for flushing conntrack table

 src/conntrack.c | 405 +++++++++++++++++++++++++++++-------------------
 1 file changed, 246 insertions(+), 159 deletions(-)

-- 
2.25.1

