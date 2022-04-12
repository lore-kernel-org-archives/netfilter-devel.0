Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98037C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiDLXY5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiDLXY3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 19:24:29 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EEB13D05
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 15:43:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nePEV-00032P-7w; Wed, 13 Apr 2022 00:43:36 +0200
Date:   Wed, 13 Apr 2022 00:43:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 0/9] nftables: add support for wildcard string
 as set keys
Message-ID: <20220412224335.GB10279@breakpoint.cc>
References: <20220409135832.17401-1-fw@strlen.de>
 <YlX6gfgq4SFPTU+B@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlX6gfgq4SFPTU+B@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sat, Apr 09, 2022 at 03:58:23PM +0200, Florian Westphal wrote:
> > Allow to match something like
> > 
> > meta iifname { eth0, ppp* }.
> 
> This series LGTM, thanks for working on this.
> 
> > Set ranges or concatenations are not yet supported.
> > Test passes on x86_64 and s390 (bigendian), however, the test fails dump
> > validation:
> > 
> > -  iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
> > +  iifname { "abcdef0", "eth0" } counter packets 0 bytes 0
> 
> Hm. Is it reordering the listing?

Yes, but its like this also before my patch, there are several
test failures on s390 with nft master.

I will have a look, so far I only checked that my patch
series does not cause any additional test failures, and the only
reason why the new test fails is the output reorder on s390.

> > I wil try to get string range support working and will
> > then ook into concat set support.
> 
> OK, so then this is a WIP?

If you want all at once then yes, but do you think thats needed?

I have not looked at EXPR_RANGE or concat-with-wildcard yet and
I don't know when I will be able to do so.
