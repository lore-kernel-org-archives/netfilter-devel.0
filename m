Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BAC6C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Apr 2022 23:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiDLXTb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiDLXTT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Apr 2022 19:19:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6E26554B8
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2022 16:08:16 -0700 (PDT)
Date:   Wed, 13 Apr 2022 01:08:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 0/9] nftables: add support for wildcard string
 as set keys
Message-ID: <YlYGXSrxnspdBzr5@salvia>
References: <20220409135832.17401-1-fw@strlen.de>
 <YlX6gfgq4SFPTU+B@salvia>
 <20220412224335.GB10279@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220412224335.GB10279@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 13, 2022 at 12:43:35AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sat, Apr 09, 2022 at 03:58:23PM +0200, Florian Westphal wrote:
> > > Allow to match something like
> > > 
> > > meta iifname { eth0, ppp* }.
> > 
> > This series LGTM, thanks for working on this.
> > 
> > > Set ranges or concatenations are not yet supported.
> > > Test passes on x86_64 and s390 (bigendian), however, the test fails dump
> > > validation:
> > > 
> > > -  iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
> > > +  iifname { "abcdef0", "eth0" } counter packets 0 bytes 0
> > 
> > Hm. Is it reordering the listing?
> 
> Yes, but its like this also before my patch, there are several
> test failures on s390 with nft master.

Why is the listing being reordered?

> I will have a look, so far I only checked that my patch
> series does not cause any additional test failures, and the only
> reason why the new test fails is the output reorder on s390.

This is also related to the set description patchset that Phil posted,
correct?

> > > I wil try to get string range support working and will
> > > then ook into concat set support.
> >
> > OK, so then this is a WIP?
> 
> If you want all at once then yes, but do you think thats needed?

If you consider that adding remaining features is feasible,
incrementally should be fine.

> I have not looked at EXPR_RANGE or concat-with-wildcard yet and
> I don't know when I will be able to do so.
