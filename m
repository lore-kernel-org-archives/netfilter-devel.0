Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C3CBCDB465
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 08:03:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjJPIDz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 04:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjJPIDy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 04:03:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C388A1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 01:03:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1bdf4752c3cso22962315ad.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 01:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697443431; x=1698048231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=y4DL6NQn5EoZgjlfSIsOMTk2Zgfdv/FURuCQewbfwlg=;
        b=YHv2YtUkj7egOHPHNQuK0VZBNCwhd1X3lBTvVfy2b/8KtqfPlE6WALri58j/HJ3atQ
         hj+tv7a0DzkxvQxHA7Fm0ckASsq2X8ikRqqgts5d+CSvAFMZzKhFsaM5Lu3qn0dTQyll
         LJPrd6QeFhn0iUMAS564wRIcC2hXmM6h484pEyRlayKsgZcF8x068nTZZftlD78eXLDF
         gGVBaMrDifF6cnxI1j2L2LFIUvpPMU/XaVYJD3K35JfbTeL3hyrqbabJtZB1Y2CGi+Ye
         9K5rKQZA9sosEZfqiyLXf+KQtVIFAklf+1G1y4K8BBwn4l3ZYq8HZ018Jt5dPUJPHxGg
         cV2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697443431; x=1698048231;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y4DL6NQn5EoZgjlfSIsOMTk2Zgfdv/FURuCQewbfwlg=;
        b=cVFoSnFUxw3aiIHSkwFfQ8hUg32B4ah71GWd60gbFhMGlbBhq/hcqz+BoT4WYp/dMh
         Tl0g9bsAi6NvY/Ut2JFhm2dSOk2nZL6fQt1k9zhBcE/gYAPZV/qasr2CURNKs6IUlc5s
         7T+OnecBeeiUsYnzQy+czf/+ldriHo5R6jNtnyHvxP3pXWJ8uylS/4mSFa/Q5MfvccUU
         HDNjw/vSqOwJj6iwEhVsWgkYMXfLKQsBmxLWWphh+HfNMMcENG0/+Ec+jXfCslqHI0D8
         o4yagizc6smm7zFBY7r1VXuoBtQAVVjXEixlqVRtoB27jgLgk9Pk4wVfUTCdUSSQqlrt
         BZ2A==
X-Gm-Message-State: AOJu0YwgqmeTqPSynBcmVznbrdfS4NOHTBW8VW7JPkofREVMz1lKeWuR
        v44e1gYjaZ79VwBkqzQIh61OzQLr1fs=
X-Google-Smtp-Source: AGHT+IELYbMwj8FL9BbuTL/l6DCczysr6+pEfJa6VnGWiNFtNUys35wi446Cf4vxVxv9vK1DTpsY1A==
X-Received: by 2002:a17:902:d50c:b0:1bb:94ed:20a with SMTP id b12-20020a170902d50c00b001bb94ed020amr34697685plg.24.1697443430654;
        Mon, 16 Oct 2023 01:03:50 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id jw14-20020a170903278e00b001adf6b21c77sm7897980plb.107.2023.10.16.01.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 01:03:50 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] New example program nfq6
Date:   Mon, 16 Oct 2023 19:03:44 +1100
Message-Id: <20231016080345.11965-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

I've been using nfq6 as a patch testbed for some time.

Now that nfq6 has matured to only use functions from the code base,
I offer it as a second example for libnetfilter_queue.

I did fix some errors from checkpatch.
I myself disagree with those that remain.
If you think some of them warrant fixing, I'll do it of course.

Cheers ... Duncan.

Duncan Roe (1):
  examples: add an example which uses more functions

 .gitignore           |   1 +
 examples/Makefile.am |   6 +-
 examples/nfq6.c      | 648 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 654 insertions(+), 1 deletion(-)
 create mode 100644 examples/nfq6.c

-- 
2.35.8

