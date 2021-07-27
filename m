Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E614C4338F
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173DE60F90
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhG0VKn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:10:43 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36444 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbhG0VKh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 17:10:37 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 381C2605D7;
        Tue, 27 Jul 2021 23:10:05 +0200 (CEST)
Date:   Tue, 27 Jul 2021 23:10:29 +0200
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
Message-ID: <20210727211029.GA17432@salvia>
References: <20210727190001.914-1-kbowman@cloudflare.com>
 <20210727195459.GA15181@salvia>
 <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAKxSbF0tjY7EV=OOyfND8CxSmusfghvURQYnBxMz=DoNtGrfSg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 27, 2021 at 03:06:05PM -0500, Alex Forster wrote:
> (And again, this time as plain-text...)
> 
> > Why do you need to make the two consistent? iptables NFLOG prefix
> > length is a subset of nftables log action, this is sufficient for the
> > iptables-nft layer. I might be missing the use-case on your side,
> > could you please elaborate?
> 
> We use the nflog prefix space to attach various bits of metadata to
> iptables and nftables rules that are dynamically generated and
> installed on our edge. 63 printable chars is a bit too tight to fit
> everything that we need, so we're running this patch internally and
> are looking to upstream it.

It should be possible to update iptables-nft to use nft_log from
userspace (instead of xt_LOG) which removes this limitation, there is
no need for a kernel upgrade.
