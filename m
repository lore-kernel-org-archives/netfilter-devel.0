Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEE6C48BCF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 19:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EDB9613D4
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Jun 2021 19:08:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhFITKe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Jun 2021 15:10:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59988 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFITKd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Jun 2021 15:10:33 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9B08B6422C;
        Wed,  9 Jun 2021 21:07:24 +0200 (CEST)
Date:   Wed, 9 Jun 2021 21:08:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/2] netfilter: nft_fib: ignore icmpv6 packets from ::
Message-ID: <20210609190835.GA4231@salvia>
References: <20210608114818.23397-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210608114818.23397-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 08, 2021 at 01:48:16PM +0200, Florian Westphal wrote:
> Quoting nf bugzilla:
> --------
> Using the following for
> reverse path filtering breaks IPv6 duplicate address detection:
> 
> table inet ip46_firewall {
>     chain ip46_rpfilter {
>         type filter hook prerouting priority raw;
>         fib saddr . iif oif missing log prefix "RPFILTER: " drop
>     }
> }
> 
> This is because packets from :: to ff02::1:ff00/104 will be dropped and thus
> other hosts on the network cannot detect that this host already has the same
> address assigned. The problem can be worked around in nft rules by handling
> such packets specially but I guess it should work as is.
> 
> In the kernel in ip6t_rpfilter.c the function rpfilter_mt() checks for
> saddrtype == IPV6_ADDR_ANY. nft_fib_ipv6.c doesn't seem to have an equivalent
> check for this special case.
> --------
> 
> First patch adds a test case for this, second patch makes icmpv6 from
> any to link-local bypass the fib lookup, just like loopback packets.

Applied, thanks.
