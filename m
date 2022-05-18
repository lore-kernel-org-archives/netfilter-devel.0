Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEBBC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 May 2022 12:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbiERMoU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 May 2022 08:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237295AbiERMoH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 May 2022 08:44:07 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B9C1AEC70
        for <netfilter-devel@vger.kernel.org>; Wed, 18 May 2022 05:38:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nrIwQ-0000lR-VI; Wed, 18 May 2022 14:38:15 +0200
Date:   Wed, 18 May 2022 14:38:14 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_tables: restrict expression reduction to
 first expression
Message-ID: <20220518123814.GF4316@breakpoint.cc>
References: <20220518100842.1950-1-pablo@netfilter.org>
 <YoTPlIBany/aRvtK@orbyte.nwl.cc>
 <YoTSHls/on1S+/4N@salvia>
 <YoTbJTDxuQ131EDG@orbyte.nwl.cc>
 <20220518114807.GE4316@breakpoint.cc>
 <YoTl2oM6xiRg2/N8@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoTl2oM6xiRg2/N8@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This all seems fragile to me, with huge potential to add subtle bugs
> > that will be hard to track down.
> 
> We can expose flags to indicate that an expression is reduced and
> expressions that are prefetched.
> 
> New test infrastructure will help to catch bugs, more selftests and
> userspace validation of bytecode through exposed flags.
> 
> It would be good not to re-fetch data into register that is already
> there.

I wonder if we should explore doing this from userspace only, i.e.
provide hints to kernel which expressions should be dropped in a given
chain.

Thats more transparent and would permit to reshuffle expressions,
e.g. first add all 'load instructions' and then do the comparisions
register opererations.

Kind of reverse approach to what you and Phil are doing, instead of
eliding expressions in the data path representation based on in-kernel
logic and a debug infra that annotates 'soft off' expressions, annotate
them in userspace and then tell kernel what it can discard.

Downside is that userspace would have to delete+re-add entire chain to
keep the 'elide' as-is.

With proposed scheme, we will have to patch kernel and then tell users
that they must upgrade kernel or risk that their ruelset is incorrect.

With userspace approach, we could slowly extend nft and add explicit
optimization flags to the commandline tool, with default of re-fetch.
