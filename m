Return-Path: <SRS0=nQ4N=BG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2386C433E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 17:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9F8B20775
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 17:57:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VI+Js1Ll"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbgG0R5x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 13:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgG0R5w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 13:57:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825CFC061794
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 10:57:52 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a19so12049881pjq.9
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 10:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VDh5LTn5/ZVR5v2GMBstyU78YrxDP+L2saq8RGpE+c4=;
        b=VI+Js1LlOS4+vYfkrEcM9/2qZl7STFhKkIwyot5Fl2+47jj/NalIdRC+JtJJqDw45N
         Q1zG0PLqQG4F8fW4i/bgwc1Twxh3MM99Dp8QzJvOW5+RGNiTfUwK28RUqTYIz6Sc5dqd
         0He09JKyXRGOPXd2PxE8FuC603PdtQnRGwx+UISTJ3pjPEC/BVLf2CMiscpTOtgNSiCq
         ZR863Zu9mtuqw/X9+lggUygUea1BjFWxarPOueKvEOieKoPx12cCZzZHWUmU4ymU+uVH
         A8sY7hV1/1XV781MN7W2ZM+NMBgGH0wOHa0giTV+blIOOPgq4DhelbQuTZU1vtt4pDyc
         8GfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VDh5LTn5/ZVR5v2GMBstyU78YrxDP+L2saq8RGpE+c4=;
        b=fRtNN5j8RmsCwezEThEliR65c9DVdRBNsWJSKAs2w6kGgJ9rnxj2hmqnJTxFxvVjPw
         L/4jIuizL1/fu1Trou+5zpPszYk01OkLLbdIC9MhaUpvV8tpsWUqmWGfMxaZibDt6cun
         oeUAJNKttNe9PxoBu5ekKakw/Sec3NL28R3eitkMof9jXcjEZwk7jW4KuFub5xCdIbzm
         vYcCKH4SNOfr/vROvjDgHsQyyie5ZVkK2FC1qtAY6jHFDrZ28CdNwaySxv9ee5cB8nFp
         zn7mvxDizwOMZFywcjzfsbmwybhiX0uZDGmXvk4GUs/AoiQkigRL6NnED1BEiYPH1s2d
         Lrew==
X-Gm-Message-State: AOAM531Ab5Ym3kHUww/L8FGn0S+DiwEC+YC1Ygb8HyR9GE8TMLvc4Byo
        Bzdyp170SHn2VRzGdBxRgU/MBFtJTxg3gPBGnGE=
X-Google-Smtp-Source: ABdhPJzDrjFU1sQNyMhzJqK6w6XXIYi7TYcE8bhVTDa1mS9FhJ0DS/ExvwpMcLroP8Bwx6S7A7cLZp47VpxSp903/IY=
X-Received: by 2002:a63:1d4:: with SMTP id 203mr20365661pgb.356.1595872670647;
 Mon, 27 Jul 2020 10:57:50 -0700 (PDT)
Date:   Mon, 27 Jul 2020 17:57:19 +0000
Message-Id: <20200727175720.4022402-1-willmcvicker@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 0/1] Netfilter OOB memory access security patch
From:   Will McVicker <willmcvicker@google.com>
To:     security@kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Will McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
The attached patch fixes an OOB memory access security bug. The bug is
already fixed in the upstream kernel due to the vulnerable code being
refactored in commit fe2d0020994c ("netfilter: nat: remove
l4proto->in_range") and commit d6c4c8ffb5e5 ("netfilter: nat: remove
l3proto struct"), but the 4.19 and below LTS branches remain vulnerable.
I have verifed the OOB kernel panic is fixed with this patch on both the
4.19 and 4.14 kernels using the approariate hardware.

Please review the fix and apply to branches 4.19.y, 4.14.y, 4.9.y and
4.4.y.

Thanks,
Will

Will McVicker (1):
  netfilter: nat: add range checks for access to nf_nat_l[34]protos[]

 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  5 +++--
 net/netfilter/nf_nat_core.c              | 27 ++++++++++++++++++++++--
 net/netfilter/nf_nat_helper.c            |  4 ++++
 4 files changed, 36 insertions(+), 6 deletions(-)

-- 
2.28.0.rc0.142.g3c755180ce-goog

