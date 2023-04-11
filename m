Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55A2C77B6F
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 12:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjDKM2G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 08:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjDKM2F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 08:28:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF0010DE
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 05:28:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pmD6P-0001aM-Qg; Tue, 11 Apr 2023 14:28:01 +0200
Date:   Tue, 11 Apr 2023 14:28:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Jeremy Sowden <jeremy@azazel.net>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230411122801.GE21051@breakpoint.cc>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZDUaIa0N2R1Ay7o/@calendula>
 <20230411102532.GC21051@breakpoint.cc>
 <ZDU8GcaowpCbIeDJ@calendula>
 <20230411112001.GD21051@breakpoint.cc>
 <ZDVH+puTElQrkblc@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVH+puTElQrkblc@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > so assuming a map that has
> > 
> >   typeof ip saddr . ip daddr : ip daddr . tcp dport
> 
> I am not sure we can use . tcp dport here, we might need a specific
> datatype for offset.

Right.  integer will work fine.  We will need a pseudotype
for 'typeof', tcp dport won't work as-is because nftables won't
know it needs to do the offset thing under the hood (math op or
flag or whatever).

> > ... but the map content stores the delta to use, e.g.
> > 
> >   { 192.168.7.1 . 10.2.2.2 : 10.2.2.1 . 10000 }
> >
> > ... where 10000 isn't the new dport but a delta that has to be added.
> > 
> >   [ payload load 4b @ network header + 12 => reg 1 ] # saddr
> >   [ payload load 4b @ network header + 16 => reg 9 ] # daddr
> >   [ lookup reg 1 set m dreg 1 0x0 ]	# now we have reg1: dnat addr, reg 9: delta to add
> >   [ payload load 2b @ transport header + 2 => reg 10 ]
> >   [ math add reg 9 + reg 10 => reg 9 ]		# real port value from packet added with delta
> >   [ nat dnat ip addr_min reg 1 addr_max reg 1 proto_min reg 9 proto_max reg 9 flags 0x3 ]
> 
> It is very similar to my proposal, but using an explicit: payload +
> math.

Yes.

> How are you going to express this in syntax? Maybe this:
> 
>    { 192.168.7.1 . 10.2.2.2 : 10.2.2.1 . +10000 }
> 
> or
> 
>    { 192.168.7.1 . 10.2.2.2 : 10.2.2.1 . -10000 }
> 
> so + or - tells this is an offset. Parser will need this notation, so
> the evaluation step infers the map datatype from the element.
> 
> For explicit maps, we need the datatype to interpret that this is an
> offset accordingly.

Yes.  This will also mean you can't mix real port value with offsets.
(which i don't think is a problem).

> > add operation should probably also take a modulus (fixed immediate value)
> > so we can make a defined result for things like:
> > 
> >   65532 + 10000
> > 
> > ... without a need to wrap implicitly back to "0 + remainder".
> 
> not sure I follow this modulus idea.

What should happen if you add, say, 20k, but the packet dport is larger
than (0xffff - 20k) ?

If I undertand correctly, with current iptables this will be placed
in the desired offset range, rather than wrap back to 0.

> > But maybe i'm missing something that the nat engone is already offering
> > that this approach can't handle, or some other limitation.
> 
> Your proposal is not a deal breaker to me, I think it will be more
> work to explore than my proposal, but this delta datatype might be
> useful in the future for generic delta add/sub in other payload / meta
> fields.

Ok, right, I don't think there is anything bad with your proposal
either.

Even Jeremys rebased kernel patchset looks fine to me, I just dislike
the proposed syntax (since it follows the iptables one which I don't
like either :-) )

