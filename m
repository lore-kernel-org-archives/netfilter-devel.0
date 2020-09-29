Return-Path: <SRS0=rcIs=DG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C21C4727C
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46152076A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="IDj9CMRR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbgI2MhV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgI2LU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 07:20:58 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72450C061755
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2020 04:20:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i1so5931660edv.2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2020 04:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KVart9pzlsQjpoXCD62AYLiJx/+Zz9Grty5qEnJegUM=;
        b=IDj9CMRRlGAvgyx3TblEeDcvdTqJ8pZ3ObRjWi0O4uGb+slBN5prKIQNvNM18up4Mc
         E9Pn7D1GfZeXYFnrwUORnPgr5Ojw7ZH65NyhPb+Cc1CSbbpL/VJj5xDBuICQk5LE5jPc
         MZqwOnA27ZPqNIJ0744Iint561fLSeRNXyPqXZvBML2M1XNBD2WKfjToSC5JIqPrXEy8
         edHoYXtg0G8JqxJi6a4UAxoysxrTrbzA2kYhPrg6XlXQ7DKS8eGIceAx6+HWuduCoi16
         a3CYJ5YdrUG3dc1/k9KMmnGueMuj65AhymcOOw7/RTqb8R8VMfpLVoeAPBGN6R8DiyXG
         fwXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KVart9pzlsQjpoXCD62AYLiJx/+Zz9Grty5qEnJegUM=;
        b=bNE6J3HNMSuDNO0IdXIAWAkJfMWd8VI1G0vC//KdWRcDpDzOMjRwyfoyXXtwIhmO/o
         lMg1yVSnWGQDX7ccrjgi0PMhAWN/NDVidbhoTVHb0XMRJXdCpaWYS03tsmGF1C87XCy7
         R9M5RpbMUmElXw+ftGbs2Nmgqg0J82pSBRczsYIUN/jFALnLCNdaiSQsZtM5V4xwZ/9I
         D6xNofW/qor3hS8nQznRBRH56olvTXz6bFe1uFehsISa7X+vDqn6Q54MsHXpVHUGHuUR
         fENpkPXPX5qDtTZgu4YBE5ozCp1bcAWvZ3VvDLEvqwDs7/KnL4o2EbZoV74Mtt8dadQ7
         YfAA==
X-Gm-Message-State: AOAM532GAnSqgeDOCOCHdkuVRONbkAg7W7YVZUcT8wzUPUxrCGRZdKbF
        3fOptmheDMxvxe7vS2MkqkmWyNJ/lekL5Q==
X-Google-Smtp-Source: ABdhPJwJee9NbuuWeZe1p6t4U0mEiCHAak2Dy/WlsgkT8AV6I6mTTzXRnye7ZD0Fil18dxJsE4DGvg==
X-Received: by 2002:a05:6402:696:: with SMTP id f22mr2598659edy.290.1601378448894;
        Tue, 29 Sep 2020 04:20:48 -0700 (PDT)
Received: from localhost.localdomain (ip5f5af5ad.dynamic.kabel-deutschland.de. [95.90.245.173])
        by smtp.gmail.com with ESMTPSA id bn2sm1999761ejb.48.2020.09.29.04.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:20:48 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 0/2] conntrack: -L/-D both ipv4/6 if no family is given
Date:   Tue, 29 Sep 2020 13:20:15 +0200
Message-Id: <20200929112017.18582-1-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926181928.GA3598@salvia>
References: <20200926181928.GA3598@salvia>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

As we discussed in the "Fast bulk transfers of large sets of ct 
entries" mailing thread, conntrack -L (and presumably
conntracks -D as well) should dump/delete both IPv4 and IPv6
entries if no family is specified.

As a follow-up for that here is a patch which supposed to restore
this behavior and a patch with the test-cases covering both the
invocation with family is specified and not.

The patches are created on top of my previous set of patches,
mainly for the reason that the "opts" output format and stdio 
input introduced there among other thing allow testing the 
-L functionality easily.

I would really appreciate if someone could have a look into
those patches btw and give some feedback on whether they make
sense or not.

Thanks & Regards,
Mikhail

Mikhail Sennikovsky (2):
  conntrack: -L/-D both ipv4/6 if no family is given
  tests: conntrack -L/-D ip family filtering

 src/conntrack.c                     | 35 +++++++++++---
 tests/conntrack/testsuite/09dumpopt | 72 ++++++++++++++++++++++++++++-
 2 files changed, 99 insertions(+), 8 deletions(-)

-- 
2.25.1

