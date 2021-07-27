Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8E1C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33E3E60F9B
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 20:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhG0UGZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhG0UGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 16:06:24 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D651C061760
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 13:06:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t21so17369044plr.13
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 13:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qD/PBt3CNf26h7b3FD4L2B5zkfWzkBxO/uqzlPboJk4=;
        b=RtKqi/DcgLMxnMaj3mmxGPKAlnxq8ASoHJIzENVvIf3qFiGfkOTG3XdpIhr6YpXXDj
         NIq54XP3HiGYLgLnhQCb5WsbrWd2m9bnyWVyvbsDVfIVyeGddeJXCgxZXd5HVQ/6cFFQ
         oLWOXdmGT91LEzQMFj1574ESYTGDz9iCP7LxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qD/PBt3CNf26h7b3FD4L2B5zkfWzkBxO/uqzlPboJk4=;
        b=OjxmER6wTUpAkFSf1sr3ndR7Cas+BigIYUM8Up7svZgYYgbtJiShRCaZZo4YTH8o6C
         8DrQPmywvPL5LZMDxFmyShYxwoYr3NZXMLNayrsHYlOBmmuhjcptJ5IkYohakgK3FtXM
         58Na449xigMfc/gpcILxE6bVL+kIme1TegRKlFYxUUKCh5rsplCVfylxi1MhX3+evjIF
         8bBFr1qKLu5oW5Hb/ivkpjyQmkaTD5cDh5on/3a1tFDo5IuIFzrgHBwXCV0pE7hh943U
         lA5GnIsTpku+U0lN8MrgYvkr+Av53Q/XvmJDHrpIn4oFItvuD2hWnmdJbgjqpzvsElOX
         rLww==
X-Gm-Message-State: AOAM5317RcYAjQOGnlnXOONcuRpgBgAerUSuHzMjytlGAkHRy7/plgWz
        0k9eYhzLyx3U2uqK0BoCjJlZ+cyLqJ6eexQ5QYrLTQ==
X-Google-Smtp-Source: ABdhPJwHwSVtXYZElTiWWA6Bv52JZubsCu2gGXGiKvvmMRBeVFTzoiIWcaSwvUKA3i3Aa/uGinn2/U6KKAmEYcASojQ=
X-Received: by 2002:a17:902:7885:b029:12c:437a:95eb with SMTP id
 q5-20020a1709027885b029012c437a95ebmr4647830pll.80.1627416381609; Tue, 27 Jul
 2021 13:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
In-Reply-To: <20210727195459.GA15181@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 15:06:05 -0500
Message-ID: <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
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

(And again, this time as plain-text...)

> Why do you need to make the two consistent? iptables NFLOG prefix
> length is a subset of nftables log action, this is sufficient for the
> iptables-nft layer. I might be missing the use-case on your side,
> could you please elaborate?

We use the nflog prefix space to attach various bits of metadata to
iptables and nftables rules that are dynamically generated and
installed on our edge. 63 printable chars is a bit too tight to fit
everything that we need, so we're running this patch internally and
are looking to upstream it.

Alex Forster
