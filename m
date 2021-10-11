Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B7CBC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E255A600EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhJKXpF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 19:45:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39398 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJKXpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 19:45:05 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id DB40663F09;
        Tue, 12 Oct 2021 01:41:27 +0200 (CEST)
Date:   Tue, 12 Oct 2021 01:42:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, eric@garver.life, phil@nwl.cc,
        kadlec@netfilter.org
Subject: Re: [PATCH nf 1/2] selftests: nft_nat: add udp hole punch test case
Message-ID: <YWTMA8I7XeiGhulm@salvia>
References: <20210923131243.24071-1-fw@strlen.de>
 <20210923131243.24071-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210923131243.24071-2-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 23, 2021 at 03:12:42PM +0200, Florian Westphal wrote:
> Add a test case that demonstrates port shadowing via UDP.
> 
> ns2 sends packet to ns1, from source port used by a udp service on the
> router, ns0.  Then, ns1 sends packet to ns0:service, but that ends up getting
> forwarded to ns2.
> 
> Also add three test cases that demonstrate mitigations:
> 1. disable use of $port as source from 'unstrusted' origin
> 2. make the service untracked.  This prevents masquerade entries
>    from having any effects.
> 3. add forced PAT via 'random' mode to translate the "wrong" sport
>    into an acceptable range.

Applied, thanks
