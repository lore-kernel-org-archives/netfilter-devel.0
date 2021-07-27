Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43138C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D2860F6E
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhG0Vws (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:52:48 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36800 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232460AbhG0Vws (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 17:52:48 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 213D4642B2;
        Tue, 27 Jul 2021 23:52:16 +0200 (CEST)
Date:   Tue, 27 Jul 2021 23:52:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Alex Forster <aforster@cloudflare.com>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
Message-ID: <20210727215240.GA25043@salvia>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
 <20210727211029.GA17432@salvia>
 <CAKxSbF1bMzTc8sTQLFZpeY5XsymL+njKaTJOCb93RT6aj2NPVw@mail.gmail.com>
 <20210727212730.GA20772@salvia>
 <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKxSbF3ZLjFo2TaWATCA8L-xQOEppUOhveybgtQrma=SjVoCeg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 27, 2021 at 04:44:42PM -0500, Alex Forster wrote:
> > I'm not refering to nftables, I'm refering to iptables-nft.
> 
> Possibly I'm misunderstanding. Here's a realistic-ish example of a
> rule we might install:
> 
>     iptables -A INPUT -d 11.22.33.44/32 -m bpf --bytecode "43,0 0 0
> 0,48 0 0 0,...sic..." -m statistic --mode random --probability 0.0001
> -j NFLOG --nflog-prefix "drop 10000 c37904a83b344404
> e4ec6050966d4d2f9952745de09d1308"
> 
> Is there a way to install such a rule with an nflog prefix that is >63 chars?

Yes, you can update iptables-nft to use nft_log instead of xt_LOG,
that requires no kernel upgrades and it will work with older kernels.
