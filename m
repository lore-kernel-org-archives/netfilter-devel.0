Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F6AC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 02:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC7C1611CD
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 02:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhEDCfy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 22:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDCfx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 22:35:53 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA26C061574
        for <netfilter-devel@vger.kernel.org>; Mon,  3 May 2021 19:34:59 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y32so5365932pga.11
        for <netfilter-devel@vger.kernel.org>; Mon, 03 May 2021 19:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=liE+UEyRvWk2Bbgs/9RfIlm2wKLuyWNh+rsATZ8hPgo=;
        b=V9nWQdYzmFpfI4L9xfFFFFGQ+QOUpHm9eiXb/Udgyxa9ykOiFX7O5xasnXY0Gd4iQc
         ftksLNkUknkHDziYvAQhMQozdONPrFWZDt2emvYKni9Ox8aqFxx+fMJvJQTrjP59T5Fa
         H1byVl6iBWEumF6OgZR38TH8an1RVk7jCUZXGNPn5mKQ2cmA9+jA2dJ4ABpxvfZvIGXA
         NggnmGdWNbr8RrzgDMrddWppFZL7n92gNfUdcrraqBT1n48MCvTVmwLCJi+WiIvAF2H0
         0Ir5h5nuhk5NZnXh1yKvCNPPtbP/2wRNoScZOpK6w7y7qgn7z0XYsFakhWwo1rtKv1+0
         wqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=liE+UEyRvWk2Bbgs/9RfIlm2wKLuyWNh+rsATZ8hPgo=;
        b=JngvgKpC1yWmfGKVc/6EChThTHceRJispAzBvzR9G83DnM1+hEANiDsJ1TUCMcq72F
         qOtIct16f/sqT3EcXd4nvDXW6TyjEwePsQhtXff/oSo3tK1IBVFy9xfkk5kwCr/o72rW
         yzYdGl2RhsX++0AGd+OWhGvmUvpW+9hiTcrzfazDuuFLz2UwmVoQPW4UY5ZeZGzGgxdr
         XIaRl1p6kDtvXvPVCzWuvk3FUjfIVd3OLawRFR1vA6UIQqlY8mBJjvn1tjfbMuOebRF7
         l4ZRxeoTtpMBT8WIsCraoccuUfdGuQiyWwKAIW6rNFDwMsDn0c5pNDO+Ewl1q4eA5QpD
         T1GA==
X-Gm-Message-State: AOAM532srt2sgbALN3V6G5bqVF1O/akl7i+wSWhO841776AqpRYiSRwF
        1o5BR6JK4Ha7r+NlsvT7e0k=
X-Google-Smtp-Source: ABdhPJzRgVE9cfyTzawVkf7nHLxRiEXhQB2mtuAtaq65kRoGp5W0U0txKavPZuiyVKWyH2ZeGMuBxw==
X-Received: by 2002:a62:7c4d:0:b029:289:d38:d1be with SMTP id x74-20020a627c4d0000b02902890d38d1bemr20430695pfc.23.1620095699214;
        Mon, 03 May 2021 19:34:59 -0700 (PDT)
Received: from slk1.local.net (n49-192-228-163.sun4.vic.optusnet.com.au. [49.192.228.163])
        by smtp.gmail.com with ESMTPSA id 205sm10386366pfc.201.2021.05.03.19.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 19:34:58 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC libnetfilter_queue 0/1] Eliminate packet copy when constructing struct pkt_buff
Date:   Tue,  4 May 2021 12:34:30 +1000
Message-Id: <20210504023431.19358-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

This is item 2 of 4 after which I think we could do a new release.

Item 3 is to eliminate packet copy when returning a mangled packet in a verdict.
I have this working in inline code, not yet factored into function calls.

Item 4 is to document how to use the library (i.e. using non-deprecated calls).
I haven't started it yet.
Perhaps I can get rid of the implicit forced-load of libnfnetlink (only used by
deprecated functions).

Cheers ... Duncan.

Duncan Roe (1):
  Eliminate packet copy when constructing struct pkt_buff

 examples/nf-queue.c                    | 22 ++++++-
 include/libnetfilter_queue/Makefile.am |  1 +
 include/libnetfilter_queue/callback.h  | 11 ++++
 include/libnetfilter_queue/pktbuff.h   |  2 +
 src/Makefile.am                        |  1 +
 src/extra/callback.c                   | 52 +++++++++++++++++
 src/extra/pktbuff.c                    | 80 ++++++++++++++++++--------
 7 files changed, 141 insertions(+), 28 deletions(-)
 create mode 100644 include/libnetfilter_queue/callback.h
 create mode 100644 src/extra/callback.c

-- 
2.17.5

