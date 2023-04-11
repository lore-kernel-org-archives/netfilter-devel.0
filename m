Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C4EC76196
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 11:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjDKLpR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 07:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjDKLpL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 07:45:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9D2044491
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 04:44:48 -0700 (PDT)
Date:   Tue, 11 Apr 2023 13:43:54 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <ZDVH+puTElQrkblc@calendula>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZDUaIa0N2R1Ay7o/@calendula>
 <20230411102532.GC21051@breakpoint.cc>
 <ZDU8GcaowpCbIeDJ@calendula>
 <20230411112001.GD21051@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230411112001.GD21051@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 11, 2023 at 01:20:01PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Sorry, I don't see the usecase for different deltas.
> > 
> > Then, users will more than one single rule for different port-shift
> > mappings?
> 
> Hmm, why?  Can't the variable offset be stored in the map itself
> (instead of the new dport value)?
> 
> so assuming a map that has
> 
>   typeof ip saddr . ip daddr : ip daddr . tcp dport

I am not sure we can use . tcp dport here, we might need a specific
datatype for offset.

> ... but the map content stores the delta to use, e.g.
> 
>   { 192.168.7.1 . 10.2.2.2 : 10.2.2.1 . 10000 }
>
> ... where 10000 isn't the new dport but a delta that has to be added.
> 
>   [ payload load 4b @ network header + 12 => reg 1 ] # saddr
>   [ payload load 4b @ network header + 16 => reg 9 ] # daddr
>   [ lookup reg 1 set m dreg 1 0x0 ]	# now we have reg1: dnat addr, reg 9: delta to add
>   [ payload load 2b @ transport header + 2 => reg 10 ]
>   [ math add reg 9 + reg 10 => reg 9 ]		# real port value from packet added with delta
>   [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 9 proto_max reg 9 flags 0x3 ]

It is very similar to my proposal, but using an explicit: payload +
math.

How are you going to express this in syntax? Maybe this:

   { 192.168.7.1 . 10.2.2.2 : 10.2.2.1 . +10000 }

or

   { 192.168.7.1 . 10.2.2.2 : 10.2.2.1 . -10000 }

so + or - tells this is an offset. Parser will need this notation, so
the evaluation step infers the map datatype from the element.

For explicit maps, we need the datatype to interpret that this is an
offset accordingly.

> add operation should probably also take a modulus (fixed immediate value)
> so we can make a defined result for things like:
> 
>   65532 + 10000
> 
> ... without a need to wrap implicitly back to "0 + remainder".

not sure I follow this modulus idea.

> > In my proposal, kernel would take the delta from register, the flag
> > tells the nat core how to interpret this.
> 
> Yep, understood.  This is mapping the existing iptables approach,
> but using register instead of immediate to pass data.
> 
> > > So we need an 'add' operation in kernel to compute
> > 
> > This is an 'add' operation built-in into the NAT engine.
> > 
> > How would a generic 'add' operation in the kernel will work with
> > concatenations?
> 
> Its not needed for concatentation case, the port value (in packet)
> is always a fixed value, so it can be (re)loaded at runtime.
> 
> But maybe i'm missing something that the nat engone is already offering
> that this approach can't handle, or some other limitation.

Your proposal is not a deal breaker to me, I think it will be more
work to explore than my proposal, but this delta datatype might be
useful in the future for generic delta add/sub in other payload / meta
fields.
