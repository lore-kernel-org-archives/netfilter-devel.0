Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E921ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 20:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiHaUi2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 16:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiHaUi1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 16:38:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99B2AE3427;
        Wed, 31 Aug 2022 13:38:25 -0700 (PDT)
Date:   Wed, 31 Aug 2022 22:38:22 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <Yw/Gvhjy2h47RfU9@salvia>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
 <Yw95m0mcPeE68fRJ@salvia>
 <20220831153508.GB15107@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220831153508.GB15107@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 31, 2022 at 05:35:08PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > asking the kernel to store an additional label with the program rule?
> > 
> > @Florian, could you probably use the object infrastructure to refer to
> > the program?
> 
> Yes, I would like to extend objref infra later once this is accepted.
> 
> > This might also allow you to refer to this new object type from
> > nf_tables maps.
> 
> Yes, but first nft needs to be able to construct some meaningful output
> again.  If we don't attach a specific label (such as filename), we need
> to be able to reconstruct info based on what we can query via id/tag and
> bpf syscall.
> 
> objref infra doesn't help here unless we'll force something like
> 'nft-defined-objref-name-must-match-elf-binary-name', and I find that
> terrible.

OK, you don't have to select such an ugly long name ;)

But I get your point: users need to declare explicitly the object.

> > It would be good to avoid linear rule-based matching to select what
> > program to run.
> 
> Hmmm, I did not consider it a huge deal, its an ebpf program so
> users can dispatch to another program.
> 
> Objref is nice if the program to run should be selected from a criterion that isn't
> readily available to a sk_filter program though.

You can also perform updates on the object without the need for
reloading your ruleset. And the declared object also allows for more
attributes to be added on it moving forward.

I think this approach would also allow you to maintain symmetry
between what you add and what it is shown in the listing?
