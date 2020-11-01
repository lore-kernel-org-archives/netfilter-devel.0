Return-Path: <SRS0=/QgY=EH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9469AC2D0A3
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 21:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F25422275
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Nov 2020 21:49:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DAUZS5W0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgKAVts (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Nov 2020 16:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgKAVts (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Nov 2020 16:49:48 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2BDC0617A6
        for <netfilter-devel@vger.kernel.org>; Sun,  1 Nov 2020 13:49:48 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id z7so8215676ybg.10
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Nov 2020 13:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=jy5whpdkbJURNW0PeeiRBIKqG8eYfhi8IgQsqrYGi50=;
        b=DAUZS5W0q0MKiCopPQOOj+SDwYvSEf0GdaTyBwV+oRpNlAukn4Y6eEHM/tYU7ZCT/1
         tDmiPCXOTlzj8qB904NXAKnga7u0bUS3rKbX85gHlw1ob9OfewqB5JrPsL8pJ1aSavzq
         l351nDpEzsj8vQjAecFbFRxZ95VxfRnUQqfldG5ti0RRJmuJS3cZigVnewL3Df8FvwLY
         Ji47DEFJmhjipvkYnb4GoJJe/dnSXWj8xJtO5fpVbI2FjDrdP24DObHp2sVtJ8URHr4L
         4dA1vGmZO2stqVLXZ0Mut16mWp5JabPXSnrVhJ1qIw6Lc4+ikkjRC+sGHbdX0wKbemT4
         RJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jy5whpdkbJURNW0PeeiRBIKqG8eYfhi8IgQsqrYGi50=;
        b=sXsJFmuijuK6v3ZmLuzSF0mfIbJe3Eyg+dpbw0Gk1j0aja8GnbUqjYeN3HzboqLz1N
         oL9zHI9+6zqZaJI2qBOhJWQEqmKSno/V5kE7KNUKibHJA5WwkXtNyodwVs1sPSyqPS+1
         RoGo0HmjcxNAKc0Xf0FqauUnAN3EIPCl82Fig75QMNgZff9X8onDf23P9xSCD7JFpGzK
         MVTc2D/mpVPUo3/5YwIfzE4ZFdFc/8JCe99LogBCJax9W9KosIb3LYYiuQMrjoBV7Rkf
         T9h2Qy1JT97shBzES8kKIEGKZxspjYihHqTiOsgZb3cFT0BwBtpC1LoNkCzWFppX3bbd
         T76w==
X-Gm-Message-State: AOAM532vnf6TLq5EY6/JwMj3jZ9r7NSjPDIIoY1lfnWYcOULtugc29uK
        QsbuYWQUxwGftmgHFm7YqpLyrXsVsXkr2e1QCZupZICmh6mLSTpq
X-Google-Smtp-Source: ABdhPJyVz82pAeNQLilUE6GjPa8s66/AEwVSfZ/j3O0XZx8YuvMyEU9tSLM1WYX5y3xKCquOWuwaVMldJtF1vadajmM=
X-Received: by 2002:a25:d68a:: with SMTP id n132mr17215667ybg.325.1604267387543;
 Sun, 01 Nov 2020 13:49:47 -0800 (PST)
MIME-Version: 1.0
From:   Oskar Berggren <oskar.berggren@gmail.com>
Date:   Sun, 1 Nov 2020 22:49:36 +0100
Message-ID: <CAHOuc7N4gWZQmGaHdZ3oMt6S2PA-8JXTEabaybsH2bM9zHcBfA@mail.gmail.com>
Subject: ipset 7.7 modules fail to build on kernel 4.19.152
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I can build ipset 7.6 modules on 4.19.152 kernel (Debian buster
current stable), but 7.7 fails:

$ configure; make
$ make modules
jhash.h:90:32 `fallthrough` undeclared
jhash.h:136:21 `fallthrough` undeclared

ip_set_core.c:90:40 macro list_for_each_entry_rcu passed 4 arguments
but takes just 3
ip_set_core.c:89:2 list_for_each_entry_rcu undeclared

Plus a few more but I think they are just because the compiler is
confused after the above problems.

There are commits in 7.7 touching the above pieces of code.


Btw, and unrelated to above, recent kernels (4.19.134+) remove
tc_skb_protocol [0] but seems to provide vlan aware skb_protocol [1]
instead. Perhaps ipset should use that when available, instead of its
own tc_skb_protocol fallback?


[0] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.19.134&id=9fd235ff00008e093951b4801349436fa27c64e8
[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.19.134&id=d4d0e6c07bcd17d704afe64e10382ffc5d342765
