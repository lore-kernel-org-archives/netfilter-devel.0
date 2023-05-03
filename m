Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46084C77B7F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 20:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjECUyR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 16:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjECUyQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 16:54:16 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C7BF83D7
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 13:54:15 -0700 (PDT)
Date:   Wed, 3 May 2023 22:54:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZFLJ886DVa1d53kc@calendula>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZCCtjm1rgpa5Z+Sr@salvia>
 <20230411122140.GA1279805@celephais.dreamlands>
 <ZDaQmlLBAnopcqdO@calendula>
 <20230425195143.GC5944@celephais.dreamlands>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230425195143.GC5944@celephais.dreamlands>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 25, 2023 at 08:51:43PM +0100, Jeremy Sowden wrote:
> On 2023-04-12, at 13:06:02 +0200, Pablo Neira Ayuso wrote:
> > On Tue, Apr 11, 2023 at 01:21:40PM +0100, Jeremy Sowden wrote:
> > > On 2023-03-26, at 22:39:42 +0200, Pablo Neira Ayuso wrote:
> > > > Jeremy, may I suggest you pick up on the bitwise _SREG2 support?
> > > > I will post a v4 with small updates for ("mark statement support
> > > > for non-constant expression") tomorrow. Probably you don't need
> > > > the new AND and OR operations for this? Only the a new _SREG2 to
> > > > specify that input comes from non-constant?
> > > 
> > > Just to clarify, do you want just the `_SREG2` infrastructure from
> > > the last patch series but without the new bitwise ops?  That is to
> > > say it would be possible to send two operands to the kernel in
> > > registers, but no use would be made of it (yet).  Or are you
> > > proposing to update the existing mask-and-xor ops to send right hand
> > > operands via registers?
> > 
> > I mean, would it be possible to add a NFT_BITWISE_BOOL variant that
> > takes _SREG2 via select_ops?
> 
> In an earlier version, instead of adding new boolean ops, I added
> support for passing the mask and xor arguments in registers:
> 
>   https://lore.kernel.org/netfilter-devel/20200224124931.512416-1-jeremy@azazel.net/
> 
> Doing the same thing with one extra register is straightforward for AND
> and XOR:
> 
>   AND(x, y) = (x & y) ^ 0
>   XOR(x, y) = (x & 1) ^ y
> 
> since we can pass y in _SREG2 and 0 in _XOR for AND, and 1 in _MASK and
> y in _SREG2 for XOR.  For OR:
> 
>   OR(x, y) = (x & ~y) ^ y
> 
> it's a bit more complicated.  Instead of getting both the mask and xor
> arguments from user space, we need to do something like passing y in
> _SREG2 alone, and then constructing the bitwise negation in the kernel.
>
> Obviously, this means that the kernel is no longer completely agnostic
> about the sorts of mask-and-xor expressions user space may send.
>
> Since that is the case, we could go further and just perform the
> original ope- rations.  Thus if we get an boolean op with an _SREG2
> argument:
> 
>   * if there is an _XOR of 0, compute:
> 
>     _SREG & _SREG2
> 
>   * if there is a _MASK of 1, compute:
> 
>     _SREG ^ _SREG2
> 
>   * if there are no _MASK or _XOR arguments, compute:
> 
>     _SREG | _SREG2

OK, if my understanding is correct, these are the two options:

1) Infer from arguments the type of operation.
2) Have explicit NFT_BITWISE_{AND,OR,XOR} operations.

If so, I think it is better to stick to your original patch, where
explicit bitwise operations NFT_BITWISE_{_AND,_OR,_XOR} are added
(which is what you proposed last time IIRC).

Thanks for explaining.
