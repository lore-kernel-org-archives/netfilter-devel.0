Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AEFC433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Feb 2021 16:49:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E40664E92
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Feb 2021 16:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhBHQtk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 11:49:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhBHQse (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 11:48:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDC7C061788;
        Mon,  8 Feb 2021 08:47:53 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l99hW-0008Js-Hm; Mon, 08 Feb 2021 17:47:50 +0100
Date:   Mon, 8 Feb 2021 17:47:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Unable to create a chain called "trace"
Message-ID: <20210208164750.GM3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Martin Gignac <martin.gignac@gmail.com>, netfilter@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <CANf9dFMJN5ZsihtygUnEWB_9T=WLbEHrZY1a5mTqLgN7J39D5w@mail.gmail.com>
 <20210208154915.GF16570@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208154915.GF16570@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Feb 08, 2021 at 04:49:15PM +0100, Florian Westphal wrote:
> Martin Gignac <martin.gignac@gmail.com> wrote:
> 
> [ cc devel ]
> 
> > Out of curiosity, is there a reason why calling a chain "trace"
> > results in an error?
> > 
> > This configuration:
> > 
> >   chain trace {
> >     type filter hook prerouting priority -301;
> >     ip daddr 24.153.88.9 ip protocol icmp meta nftrace set 1
> >   }
> > 
> > Results in the following error when I try loading the ruleset:
> > 
> >   /etc/firewall/rules.nft:40:9-13: Error: syntax error, unexpected
> > trace, expecting string
> >   chain trace {
> >         ^^^^^
> 
> grammar bug.
> 
> Pablo, Phil, others, can you remind me why we never did:

Because this would be followed up by:

| Subject: Unable to create a table called "trace"

Jokes aside:

I think Pablo didn't like the obvious consequence of having to quote
*all* string types which are user-defined in output. He played with
keeping the quotes as part of the name, so they are sent to kernel and
in listing they would automatically appear quoted. I don't quite
remember why this was problematic, though.

In general, shells eating the quotes is problematic and users may not be
aware of it. This includes scripts that mangle ruleset dumps by
accident, etc. (Not sure if it is really a problem as we quote some
strings already).

Using JSON, there are no such limits, BTW. I really wonder if there's
really no fix for bison parser to make it "context aware".

Cheers, Phil


