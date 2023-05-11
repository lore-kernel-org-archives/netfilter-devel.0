Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85062C77B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 16:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbjEKQg1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 12:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbjEKQg0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 12:36:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 695FAD9
        for <netfilter-devel@vger.kernel.org>; Thu, 11 May 2023 09:36:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1px9HD-0002JG-BU; Thu, 11 May 2023 18:36:23 +0200
Date:   Thu, 11 May 2023 18:36:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <20230511163623.GB11411@breakpoint.cc>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
 <20230507173758.GA25617@breakpoint.cc>
 <ZFj7PomKpCnLsDz2@noodle>
 <20230509094827.GA14758@breakpoint.cc>
 <ZFtMhcF4wvV3drx8@noodle>
 <20230510125544.GC21949@breakpoint.cc>
 <ZF0Q37gucB2EiCxQ@nixemu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF0Q37gucB2EiCxQ@nixemu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> On Wed, May 10, 2023 at 02:55:44PM +0200, Florian Westphal wrote:
> I think I finally understand your reasoning. May I summarise it as the
> following:
> 
> nftables chain forward having a flow add clause becomes a request from
> the user to skip parts of Linux network stack. The affected flows will
> become special and unaffected by most of the rules of the "slowpath"
> chain forward. This is a sharp tool and user gets to keep both pieces
> if something breaks :)

Yes.

> > Now, theoretically, you could add this:
> > 
> > chain fast_fwd {
> > 	hook flowtable @f1 prio 0
> > 	ip dscp set cs3
> > }
> > 
> 
> Yes, I really like that. Here is what such chain will do:

NOOOOOOOOOOOOOOOOOOOOO!

> 1. On the slow path it will behave identical to the forward chain.

So one extra interpreter trip?

> 2. The only processing done on fast_fwd fast path is interpretation
>    of struct flow_offload_entry list (.

list iteration? What?  But netdev:ingress can't be used because
its too slow?!

I'm going to stop responding, sorry.

Netfilter already has byzantine technical debt, I don't want
to maintain any more 8-(

> 3. Such fast path is done between devices defined in flowtable f1
> 4. Apart from the interpretation of flow offload entries no other
>    processing will be done.
> 5. (4) means that no Linux IP stack is involved in the forwarding.
> 6. However (4) allows concatenation of other flow_offload_entry
>    producers (e.g. TC, ingress, egress nft chains).

Ugh.  This is already problematic.  Pipeline/processing ordering matters.

> 7. flow_offload_entry lists may be connection dependent.

Thanks for reminding me.  This is also bad.
Flowtable offload is tied to conntrack, yes.

But rule offload SHOULD NOT be tied to connection tracking.
What you are proposing is the ability to attach rules to a conntrack
entry.

> 8. Similar to chain forward now, flow_offload_entry lists will be passed
>    to devices for hardware acceleration.

Wnich devices?  Error handling?

> 9. IOW, flow_offload_entry lists become connection specific programs.
>    Therefore such lists may be compiled to EBPF and accelerated on XDP.

By whom? How?

> 10. flow_action_entry interpreters should be prepared to deal with IP
>     fragments and other strangeness that ensues on our networks.
> 
> > Where this chain is hooked into the flowtable fastpath *ONLY*.
> 
> I don't fully understand the ONLY part, but do my points above address
> this?

Only == not called for slowpath.

I don't understand you, you reject netdev:ingress/egress
but want a new conntrack extension that iterates flow_offload entries in
software?

> > However, I don't like it either because its incompatible with
> > HW offloads and we can be sure that once we allow this people
> > will want things like sets and maps too 8-(
> 
> I think that due to point (8) above the potential for hardware
> acceleration is higher. The hardware (e.g. switch) is free to pass
> the packets between flowtable ports and not involve Linux stack at all.
> It may do such forwarding because of the promise (4) above.
>
> sets and maps are welcome in chain fast_fwd :) EBPF and XDP already have
> them. Once (9) becomes reality we'll be able to suport them, somehow :)

No, XDP *DOES NOT* have them.  nftables sets and ebpf sets are
completely different entities.  'nft add element inet filter bla { 1.2.3,4 }

will not magically alter some ebpf set.

They also have different scoping rules.

> What do you think? Is going chain fast_fwd direction is feasible and
> desirable?

I think you should use netdev:ingress/egress hook points.

Or use an xdp program and don't use netfilter at all.

If you want to use nftables sets with ebpf, then you might investigate
adding kfuncs for ebpf so nftables sets can be used from bpf programs,
that might actually be useful for some people, but I'm not sure how to
make this work at this time due to nature of set/map scoping in
nftables.  We have to be mindful to not crash kernel when table/set/map
is going away on netfilter side.
