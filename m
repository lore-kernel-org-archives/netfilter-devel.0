Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A66C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 22:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 721C060F6D
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 22:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhG0Wp1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhG0Wp0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 18:45:26 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61396C061757
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 15:45:26 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ds11-20020a17090b08cbb0290172f971883bso7054743pjb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jul 2021 15:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c1rNywmSdGGjGqVOum2VanmkhITHWhYb0J24So7djoA=;
        b=TtkGy7LcJ0WaUCyu8a042D7dQ5rVq9C9zu07do3LnWSBuJ5oCbUqsDiU7RUSneJ/s6
         ZH5v/8j9GH6ylGb4tQt/VqKvcFv/GAAG8YDIJWQqTBskmZukEkA+CGu8EFtyHO6bZJrg
         EPlodJpw0j7mGTlbwWK0YXKvfQaTUJulof0zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c1rNywmSdGGjGqVOum2VanmkhITHWhYb0J24So7djoA=;
        b=I+icpjsBjfWvKNKq2xdvcS6fBwKLrKQe0IeE1nn7xhomXmLB8FceZLLYa5oMcuel9J
         LnCeV9qBVTNaZR8YTIl7YqEHxChSjq5IZFHSKf7i0zZjUWC6tVuahv4oiGdRzZSmnkB/
         fOLggF68MBoTx4x5BY4N7ujrC4WoD5cAfIRTV1RlLCvedrEmXeQkidKEj+e1AhIcV/4T
         Kf6ZtieclEuJ8CpiORxLatJSljQmyjY66REzZEUern+3ATuCru5L+mN9DWApSBdBBlMw
         mj5gbq3hcDownQ4Ag8vK2VhEfIWuee8hQ+ZaoDrqKg/o0kwLyRCwj8xQQZD5wYVl7lG7
         f49w==
X-Gm-Message-State: AOAM530/xwhe4O4+sKeNJ/lKvEEs2C/mtg02wyNlsylDBCysnGJJ1lN5
        xXfdZLK0be2H+wyz6Jj+Ty2GxfzMtSZdKOS01E9iJQ==
X-Google-Smtp-Source: ABdhPJwuBW1u+RvaSDnnOQwgWCiGU3dOFFm7AXmwt8lUWMZ3xtjeLMUpHyNxEFomuxPLlrfXGToVv2Xas45ir3vVhhw=
X-Received: by 2002:a17:902:e84d:b029:12b:b2aa:5266 with SMTP id
 t13-20020a170902e84db029012bb2aa5266mr20457222plg.65.1627425925801; Tue, 27
 Jul 2021 15:45:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210727190001.914-1-kbowman@cloudflare.com> <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia> <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia> <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
 <20210727215240.GA25043@salvia>
In-Reply-To: <20210727215240.GA25043@salvia>
From:   Alex Forster <aforster@cloudflare.com>
Date:   Tue, 27 Jul 2021 17:45:09 -0500
Message-ID: <CAKxSbF1cxKOLTFNZG40HLN-gAYnYM+8dXH_04vQ8+v3KXdAq8Q@mail.gmail.com>
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

> Yes, you can update iptables-nft to use nft_log instead of xt_LOG,
> that requires no kernel upgrades and it will work with older kernels.

I've always been under the impression that mixing xtables and nftables
was impossible. Forgive me, but I just want to clarify one more time:
you're saying we should be able to modify iptables-nft such that the
following rule will use xt_bpf to match a packet and then nft_log to
log it, rather than xt_log as it does today?

    iptables-nft -A test-chain -d 11.22.33.44/32 -m bpf --bytecode
"1,6 0 0 65536" -j NFLOG --nflog-prefix
"0123456789012345678901234567890123456789012345678901234567890123456789"

We had some unexplained performance loss when we were evaluating
switching to iptables-nft, but if this sort of mixing is possible then
it is certainly worth reevaluating.
