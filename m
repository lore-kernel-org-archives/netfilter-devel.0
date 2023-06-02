Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3648AC77B7A
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jun 2023 23:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbjFBXOq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Jun 2023 19:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234452AbjFBXOp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2023 19:14:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78A7EE40
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Jun 2023 16:14:44 -0700 (PDT)
Date:   Sat, 3 Jun 2023 01:14:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft transaction semantics and flowtable hw offload
Message-ID: <ZHp34K4HsS/b/jOc@calendula>
References: <20230505123208.GB6126@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230505123208.GB6126@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Fri, May 05, 2023 at 02:32:08PM +0200, Florian Westphal wrote:
> Following dummy ruleset only works on first load:
> 
> $ cat bug
> flush ruleset
> table inet filter {
>   flowtable f1 {
>   hook ingress priority 10
>   flags offload
>   devices = { dummy0, dummy1 }
>  }
> }
> $ nft -f bug
> $ nft -f bug
> bug:3:13-14: Error: Could not process rule: Device or resource busy
> 
> This works when 'offload' flag is removed.
> 
> Transaction will *first* try to register the flowtable hook,
> then it unregisters the existing flowtable hook.
> 
> When 'offload' flag is enabled, hook registration fails because
> the device offload capability is already busy.
> 
> Any suggestions on how to fix this?
> Or would you say this is as expected/designed?
> 
> I don't see a way to resolve this.
>
> We could swap register/unregister, but this has two major issues:
> 
> 1. it gives a window where no hook is registered on hw side
> 2. after unreg, we cannot assume that (re)registering works, so
>    'nft -f' may cause loss of functionality.
> 
> Adding a 'refcount' scheme doesn't really work either, we'd need
> an extra data structure to record the known offload settings, so that
> on a 'hook flowtable f1 to dummy0' request we can figure out that this
> is expected to be busy and then we could skip the register request.
> 
> But that has to problem that the batch might not have an unregister
> request, i.e. we would accept a bogus ruleset that *should* have failed
> with -EBUSY.
> 
> Any ideas?

I think the hardware offload API needs to support transaction
semantics (generation mask), this requires a flag to enable such
behaviour, so 'tc' can toggle this off.
