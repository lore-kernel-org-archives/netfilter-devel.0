Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7812C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5A660FA0
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhG0VXN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhG0VXL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 17:23:11 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37426C061369
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 14:22:27 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j1so1878719pjv.3
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 14:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MAf7u4TJvs5Sv03AGISvam/0mpJzusFYzH1iCFFxX7w=;
        b=RWnugz+5AV737Gf+cyi+F/L4qo6NnU2NBvtxokZOKlsDxwPxaSYUu2sab01LSQlkRj
         o09/ztAXNOM8eZFwswoUPLdBEhl+jR6bKniGOK/0nglciRzG82oGYrkwt9GcOB1LGpyX
         3EdZCWfOTTO0OIVdVGuGOZLa0VxcbYI9UHsPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MAf7u4TJvs5Sv03AGISvam/0mpJzusFYzH1iCFFxX7w=;
        b=THnscOFniOjW51L9znr3l1RKhXz6ICiyPP/J94Bo17lyfKjSRerFkCdGO7cK4T7gV6
         LPQaRPQs4aoD44kOl11hCkFaFXmZ5GGtrgtEMVdF6m6GFVOjtnnmrsPg+0/MMlfCDJc4
         udMgfXXwtVB4aSJUs9/2PlZrFuvnbLSUzajQJoRhzqqiYoUoSDJt41xU9/wiJ5LpPyXj
         OlgD1fEkeNJ6E3GjUfdMIB4mJNYfHfgz7iAHgLZPPhIQtOpN7hOz8VttghrqRdc3jfNX
         fv1Nr2VsL+BaPgOIBNHQNYDngeJGJEIQ0Wi0zobhwHzXXlEfvOSflRBnLh4CxTX2QJM3
         aYRQ==
X-Gm-Message-State: AOAM531+aP5TC7enyxAT2ewRDSZtTKhNf24N0Tj+nDAg4naEgbv0HbTq
        Vlf+YDqdBk6cIjlskwWocjLfAYZAJZOO194clZPZsQ==
X-Google-Smtp-Source: ABdhPJwQBliYlJnfdssUkXjs3c/B4SZJzNwIVCGrM5vFGuthQVt5Tb4mIQhB6JsP+G1okjrNzoFt7eOfVZ8zT/WNqWo=
X-Received: by 2002:a17:90b:1612:: with SMTP id la18mr15746789pjb.95.1627420946711;
 Tue, 27 Jul 2021 14:22:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com> <20210727211029.GA17432@salvia>
In-Reply-To: <20210727211029.GA17432@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 16:22:10 -0500
Message-ID: <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> It should be possible to update iptables-nft to use nft_log from
> userspace (instead of xt_LOG) which removes this limitation, there is
> no need for a kernel upgrade.

We have been able to migrate some parts of this workload to the
nftables subsystem by treating network namespaces sort of like VRFs.
Unfortunately, we have not been able to use nftables to handle all
traffic, since it does not have an equivalent for xt_bpf.

Alex Forster
