Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3A2C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 21:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74EAB22CF7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 21:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbfHUVAc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 17:00:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43072 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728971AbfHUVAc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 17:00:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0XiY-000714-8g; Wed, 21 Aug 2019 23:00:30 +0200
Date:   Wed, 21 Aug 2019 23:00:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     michael-dev <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nftables matching gratuitous arp
Message-ID: <20190821210030.GC20113@breakpoint.cc>
References: <c81c933d181adbfdad94057569501d35@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c81c933d181adbfdad94057569501d35@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

michael-dev <michael-dev@fami-braun.de> wrote:
> I'm trying to match gratuitous arp with nftables. I've tried
> > nft add rule bridge filter somechain arp saddr ip == arp daddr ip
> 
> but nft (some commits before 0.9.2) says:
> > Error: syntax error, unexpected daddr, expecting end of file or newline
> > or semicolon
> > add rule bridge filter FORWARD arp saddr ip == arp daddr ip
>                                                    ^^^^^
> Looking at the description of the netlink protocol, it looks like two loads
> and a cmp of both registers would do it.

Yes, but cmp doesn't support this, see nft_cmp_eval() in
net/netfilter/nft_cmp.c .

The compare occurs between a register and a immediate value.

Having cmp (and also binops) involving a second sreg would be
good to have.
