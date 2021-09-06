Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461C3C43217
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 13:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3260960F92
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Sep 2021 13:00:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbhIFNBJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Sep 2021 09:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243596AbhIFNAD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Sep 2021 09:00:03 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D26C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Sep 2021 05:57:52 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e131so13439987ybb.7
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Sep 2021 05:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZQNCHEgUbJcmCrDf5vdXrIRNpsBtW4kXCqg5Vmp9JbE=;
        b=ja77ZYG/TQ2WvHGS4Qv1PccJMfTbbZsXfWrGr+pLLFHYWkU/FBqC9/QNrHxWUsq92O
         JNlRcUeF2DFbTfd/356NXeQ6h97dVKD72cQbz0WE5eg+heYVPyz+ZaERieT6HeMT2eHN
         D9TpDOBotoPDLLRnzLPxiFStYUJUZIRjgkSiH5ICpZL9sNHKI8JAVqpTxaIaRzW1gFWm
         bf+X7NhLFKFf+UWPUYOCMu+7Hkt/kkA5mLEr0K49Wt4x4OPc8mrZV5l1ZhGMqBDrNJjb
         RCFwQttH30CpxhJE8GmnRvxqPIwQYhCC6tGvwaBmHrB+AQJ1lVDqLBB99nUp1SySK3R2
         WkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZQNCHEgUbJcmCrDf5vdXrIRNpsBtW4kXCqg5Vmp9JbE=;
        b=ol2YY3FNr+p1iao7Zp718xdiHMT0DrmBKnjWkjFgtNPVOeRf+1v0YGyr8slIIyNMzR
         A8hpFFEX93AqHid0Ku5yU/ScvvUvGVcLGGtPWo9nGCngnrHODYUaBGGois1270NcxqZW
         Bn5eTEN+jY7+QQfQQKb+U26RF6I9U85bpJQZDYrECzeZIsSIgnPm7ldTXse/XvHK0jdS
         v5U+Dx8YY0EY21VhmGnVpfuAIe9KEHI86RVBoXPcs8p/x0TDW4DyZBOcRqswheOfYEVn
         /h5YIJGbfJOyRdb4PfPaByRLmasf0l1cIj8iXoI6PB/pKX6pGIK6l0BXYLiVr7Ayz5kw
         Y1qw==
X-Gm-Message-State: AOAM5333js1EiPVEaHP+Sjxi9+fJC4e1IdUEhMuR8lXAPMzHB9w25cI9
        jtJ0mGWCAh7Kk8fHHdLiQggk7tbi3CnuzOXa3USGmTWKQehXdg==
X-Google-Smtp-Source: ABdhPJyIXnJCtDdnL7TdWtDIwctDLbfQv97ZKxCW5VgyFtWnqowSS4XGUPLjyGZAg6k0YGkifGLBLlluUlQOEpCzuq4=
X-Received: by 2002:a25:388c:: with SMTP id f134mr16315314yba.209.1630933071667;
 Mon, 06 Sep 2021 05:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210906030641.10958-1-shaw.leon@gmail.com> <20210906091304.GA2114@salvia>
In-Reply-To: <20210906091304.GA2114@salvia>
From:   Xiao Liang <shaw.leon@gmail.com>
Date:   Mon, 6 Sep 2021 20:57:15 +0800
Message-ID: <CABAhCOSRfufkkDZd7GcLa2yjqhwew4roB+AnUsL8kuNeF0gJRQ@mail.gmail.com>
Subject: Re: [PATCH nft] src: Check range bounds before converting to prefix
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 6, 2021 at 5:13 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Mon, Sep 06, 2021 at 11:06:41AM +0800, Xiao Liang wrote:
> > The lower bound must be the first value of the prefix to be coverted.
> > For example, range "10.0.0.15-10.0.0.240" can not be converted to
> > "10.0.0.15/24". Validate it by checking if the lower bound value has
> > enough trailing zeros.
>
> # nft add rule x y ip saddr 10.0.0.15-10.0.0.240
> # nft list ruleset
> ...
>         ip saddr 10.0.0.15-10.0.0.240
>
> Is a different range that triggers the problem?

Hi,

Please try
# nft add rule x y snat to 10.0.0.15-10.0.0.240
