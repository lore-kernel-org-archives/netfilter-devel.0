Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8EDC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Nov 2023 23:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbjKMXZO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Nov 2023 18:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjKMXZE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Nov 2023 18:25:04 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BB6C5
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 15:25:00 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-28014fed9efso4211288a91.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Nov 2023 15:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699917900; x=1700522700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=VOx6FzOtdVTHLntWWWv2avtAByxTUMuxATfrrUYng3E=;
        b=HkmT+x495jRmtzowE9UGJ2sXQ9cpS4JKZzIIMGw01nZ5Q8BO5h2Eve42/qv09nICcp
         mI0gQUFtdRf1iu5DSkxxGexWKyUn2TzHgpRFRjgE+37/AKtjCHOMiFZgOY5H7XtdfsVo
         SlO/srtiiF5tDs4t4ErousBBATEbLPfZa2TA5PdHOboiymLq24lhesh+HH0xxm6d9nW/
         OK9kE8Sd2gvsxFu6pLArm7j/w4fZBV65tG3I5mJpT1VR46Bi2CsCco+d+41vUsvv9sHO
         rUVBeumhUhEbDAcarlLSQx8UU6q9KBByJhaSzcWIdkuEAsp7SNKEyJ65+r4pZcxF+k/r
         08yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699917900; x=1700522700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VOx6FzOtdVTHLntWWWv2avtAByxTUMuxATfrrUYng3E=;
        b=KK3ifPXfpkrRXiHAIYKffFQ7OookIGH0MzVGAsrEZ5l5MMdYEIFRL4d4TdTg6NCf25
         JWPkIY5+savvi+UKMlE0eq+CqDK6+qMzQWXLSDkSUopbp7gQcBNAsZXjxknU6jhHRoM4
         gSrj53kP1371T8lcF+tYG7NSvDMrxF1F1eV7jDKGeJ8UfZp4ksRWa6MYOz1X76u/goZy
         Ez3ttFjjExSr5AtzyHRjHdN7fmTd88FFFcC2vjieBNQFVOMkuYAXnwQWtF2YmiAXJ2ia
         bhtdFrmXhk751vetL+INn4F2XcKaK7INH/ee1HRt+eaytBNBF30nfmvOK9eYuaipNJy6
         BMCg==
X-Gm-Message-State: AOJu0Yz6a4HaKf2Kiv3B16ZHdNy2h67kuUgNXfXZxqvLpz4Do2ZVt1vW
        V0eMxPfc6IlREhkVvlfR5yh7JozcrVY=
X-Google-Smtp-Source: AGHT+IFLmAYRJKjlVRLHvcwpx03XyEexC0T9UJIrJge3sYyxG2hdiygQLrUBQvE0XqnbiAJ92LDbug==
X-Received: by 2002:a17:90b:3012:b0:280:25b8:ae8f with SMTP id hg18-20020a17090b301200b0028025b8ae8fmr6046455pjb.37.1699917899836;
        Mon, 13 Nov 2023 15:24:59 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id ml10-20020a17090b360a00b002802a080d1dsm4212558pjb.16.2023.11.13.15.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 15:24:59 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] libnfnetlink dependency elimination
Date:   Tue, 14 Nov 2023 10:24:54 +1100
Message-Id: <20231113232455.5150-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This patch enables nfqnl_test to run up to the line
> printf("binding this socket to queue '%d'\n", queue);
nfnl_rcvbufsiz() also succeeds.
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231110041604.11564-1-duncan_roe@optusnet.com.au/
nfqnl_test will crash if allowed to run further.

In nfq_open(), I renamed qh to h: it was just too annoying having the
nfq_handle called qh while everywhere else qh is a nfq_q_handle. Sorry if
that makes review harder.

For now I just made the obsolete functions nfq_{,un}bind_pf return 0. Can
do them properly later if you would prefer.

The patch is obviously not ready to apply yet so just for your review ATM.
Please suggest changes as you see fit.

Cheers ... Duncan.

Duncan Roe (1):
  Convert nfq_open(), nfq_bind_pf() & nfq_unbind_pf() to use libmnl

 doxygen/doxygen.cfg.in   |  1 +
 src/libnetfilter_queue.c | 43 ++++++++++++++++++++++++++++++----------
 2 files changed, 33 insertions(+), 11 deletions(-)

-- 
2.35.8

