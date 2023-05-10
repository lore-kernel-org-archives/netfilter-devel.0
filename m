Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A779C7EE22
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 12:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236497AbjEJMzu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 08:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbjEJMzt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 08:55:49 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3637949E9
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 05:55:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pwjM8-0007AJ-Hv; Wed, 10 May 2023 14:55:44 +0200
Date:   Wed, 10 May 2023 14:55:44 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <20230510125544.GC21949@breakpoint.cc>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
 <20230507173758.GA25617@breakpoint.cc>
 <ZFj7PomKpCnLsDz2@noodle>
 <20230509094827.GA14758@breakpoint.cc>
 <ZFtMhcF4wvV3drx8@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFtMhcF4wvV3drx8@noodle>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > table inet filter {
> >         flowtable f1 {
> >                 hook ingress priority filter
> >                 devices = { veth0, veth1 }
> >         }
> > 
> >         chain forward {
> >                 type filter hook forward priority filter; policy accept;
> >                 ip dscp set cs3
> >                 ip protocol { tcp, udp, gre } flow add
> >                 ct state established,related accept
> >         }
> > }
> > ----------
> > 
> > This has a clearly defined meaning in all possible combinations.
> > 
> > Software:
> > 1. It defines a bypass for veth0 <-> veth1
> > 2. the way this specific ruleset is defined, all of tcp/udp/gre will
> >    attempt to offload
> 
> OK.
> 
> > 3. once offload has happened, entire inet:forward may be bypassed
> 
> By bypassed, do you mean that chain forward ruleset body becomes
> irrelevant?

Yes.  It becomes irrelevant because the entire ip forward stack
becomes irrelevant. Prerouting and postrouting hooks get skipped
too, would you restore those as well?

> If the unfortunate answer is yes, than as in the original
> report, once we are in the software fast path we do not do dscp
> modification, right?

Yes. Its expected.  Entire IP stack is bypassed, including MTU
checks, xfrm policy lookups and so on.

> Then once we hit the NF_FLOW_TIMEOUT, some of the packets will have dscp
> modified, because we've went out of software acceleration. I.e. some of
> the packets will arrive with and some without dscp. As you can imagine,
> this could be hard to debug. This is the scenario that the patch series
> tries to fix.
> 
> > 4. User ruleset needs to cope with packets being moved back to
> >    software: fragmented packets, tcp fin/rst, hw timeouts and so on.
> 
> Should we require our user to understand that some lines in their
> forward table configuration may or may not be executed sporadically?

Yes.  They have to understand the packet is handled in a *completely
different* way, the IP stack is bypassed, including ipsec/xfrm policies,
icmp checks, mtu checks, and so on.

This is also why the fastpath *must* push some packets back to
normal plane: so that packet passes through ip_forward() which does
all this extra work.

Some packets cannot be added to flowtable either even if user asks
for it, e.g. when ip options are enabled.

> Should we give the user at least some kind of warning regarding this
> during the ruleset load?

You could try to do this for the 'nft -f' case, but I doubt its worth
it, see below for an example.

> To be constructive, isn't it better to rephrase points 3 and 4 as:
> 
> 3. once offload has happened, entire inet:forward will be executed with
> the same semantics but with better performance. Any difference between
> fast and slow path is considered a bug.

Err. no.  Because its impossible to do unless you stick a
nf_hook_slow() call into the "fastpath", otherwise you will diverge
from what normal path is doing.  And its still not the same,
feature-wise, because we e.g. cache route info rather than per-packet
lookup.

Flowtable software path is the *fallback* for when we don't have offload
capable hardware, it bypasses entire ip forward plane and packets take
a different, shorter code path, iff possible.

> 4. If something in user ruleset (such as dscp rule now) precludes fast
> path optimization then either error will be given or slow path will be
> taken with a warning.

Yes, nftables userspace could be augmented so that 'nft -f' could
display a warning if there is a rule other than 'conntrack
established,related accept' or similar as first line.

But I don't think its worth doing, f.e. someone could be doing
selective offload based on src/dst networks or similar.

Updating/expanding flowtable documentation would be welcome of course.

> > Lets now consider existing netdev:ingress/egress in this same picture:
> > (Example from Pablo):
> > ------
> > table inet filter {
> >         flowtable f1 {
> >                 hook ingress priority filter
> >                 devices = { veth0, veth1 }
> >         }
> > 
> >         chain ingress {
> >                 type filter hook ingress device veth0 priority filter; policy accept; flags offload;
> >                 ip dscp set cs3
> >         }
> > 
> >         chain forward {
> >                 type filter hook forward priority filter; policy accept;
> >                 meta l4proto { tcp, udp, gre } flow add @f1
> >                 ct state established,related accept
> >         }
> > }
> > 
> > Again, this has defined meaning in all combinations:
> > With HW offload: veth0 will be told to mangle dscp.
> > This happens in all cases and for every matching packet,
> > regardless if a flowtable exists or not.
> > 
> > Same would happen for 'egress', just that it would happen at xmit time
> > rather at receive time.  Again, its not relevant if there is active
> > flowtable or not, or if data path is offloaded to hardware, to software,
> > handled by fallback or entirely without flowtables being present.
> > 
> > Its also clear that this is tied to 'veth0', other devices will
> > not be involved and not do such mangling.
> > 
> 
> As I've mentioned in my other reply to Pablo, our focus is exclusively
> on the *software* fast path of the forward chain. In this scenario
> getting into additional nftables VM path in the ingress or egress seems
> like pessimization which we'd like to avoid.

You will have to add a call to nf_hook_slow, or at very least to
nft_do_chain...

netdev:in/egress is the existing plumbing that we have that
allows for this, and I think that this is what should be used
here.

> > Now lets look at your proposal:
> > ----------------
> > table inet filter {
> >         flowtable f1 {
> >                 hook ingress priority filter
> >                 devices = { veth0, veth1 }
> >         }
> > 
> >         chain forward {
> >                 type filter hook forward priority filter; policy accept;
> >                 ip dscp set cs3 offload
> >                 ip protocol { tcp, udp, gre } flow add
> >                 ct state established,related accept
> >         }
> > }
> > ----------------
> > 
> > This means that software flowtable offload
> > shall do a 'ip dscp set cs3'.
> > 
> > What if the flowtable is offloaded to hardware
> > entirely, without software fallback?
> > 
> > What if the devices listed in the flowtable definition can handle
> > flow offload, but no payload mangling?
> > 
> > Does the 'offload' mean that the rule is only active for
> > software path?  Only for hardware path? both?
> > 
> > How can I tell if its offloaded to hardware for one device
> > but not for the other?  Or will that be disallowed?
> > 
> > What if someone adds another rule after or before 'ip dscp',
> > but without the 'offload' keyword?  Now ordering becomes an
> > issue.
> > 
> > Users now need to consider different control flows:
> > 
> >   jump exceptions
> >   ip dscp set cs3 offload
> > 
> >   chain exceptions {
> >     ip daddr 1.2.3.4 accept
> >   }
> > 
> > This won't work as expected, because offloaded flows will not
> > pass through 'forward' chain but somehow a few selected rules
> > will be run anyway.
> > 
> > TL;DR: I think that for HW offload its paramount to make it crystal
> > clear as to which device is responsible to handle such rules.
> 
> Your critique of my offload flag is well deserved and fully correct,
> thanks! The reason for the dscp statement offload flag was to try to be
> explicit about the need for payload modification capture.
> 
> What we've really wanted to do here is to make the payload capture
> dependent on the chain flowtable acceleration status. I.e. if the
> forward chain is supposed to be accelerated, than the payload
> modification capture should happen. Being lazy, I've went through that
> ugly keyword path. Apologies for that.

> Yes. But again hardware offload is irrelevant for the problem we have
> here.

Unfortunately its not, we cannot make waters murkier and just pretend
HW offloads don't exist.  Behavior for "flags offload;" presence or
absence should be identical (in absence of bugs of course).

> > I don't think mixing software and hardware offload contexts as proposed
> > is a good idea, both from user frontend syntax, clarity and error reporting
> > (e.g. if hw rejects offload request) point of view.
> > 
> 
> Frontend syntax and nft userspace should not be affected once we drop
> the unneeded offload flag on dscp statement.

So you propose to software-offload all mangle statements and
prune all other rules...?

How is that any better than what we do now?

> > I also believe that allowing payload mangling from *software* offload
> > path sets a precedence for essentially allowing all other expressions
> > again which completely negates the flowtable concept.
> 
> IMHO, the flowtable concept means transparent acceleration of packet
> processing between the specified interfaces. If something in the ruleset
> precludes such acceleration warnings/errors should be given.
> 
> Do you agree?

It would be nice to give a warning but I don't think its feasible.
Consider something like

 chain forward {
  ip dscp set cs3
  ct state established,related accept
  ip saddr @should_offload_nets flow add @ft
 }

Should this generate a warning?

Also, because of forward path bypass even if the ruleset is just doing:

ct state established,related
ip saddr @can_offload flow add @ft

Packet flow is not the same as without "flow add" for a large swath of
packets, as no prerouting or postrouting hooks are executed either.

> Once the goal of significant performance gains is preserved, the
> expansion of the universe of accelerated expressions is benign. And why
> not? We are still being fast.

I still think that my critique stands, pruning other rules and
magically considering some while completely disregarding their context
is not a good idea.

Now, theoretically, you could add this:

chain fast_fwd {
	hook flowtable @f1 prio 0
	ip dscp set cs3
}

Where this chain is hooked into the flowtable fastpath *ONLY*.

However, I don't like it either because its incompatible with
HW offloads and we can be sure that once we allow this people
will want things like sets and maps too 8-(

> > I still think that dscp mangling should be done via netdev:ingress/egress
> > hooks, I don't see why this has to be bolted into flowtable sw offload.
> > 
> Because it can be made faster :)

If you want to make software fastpath fast(er), explore a XDP program
that can handle the post-offload packet funneling via xdp_frames to get rid of
sk_buff allocation overhead.

Program should make upcalls to stack (costly) to get back to software
and otherwise appear like HW offload-capable device from flowtable point
of view.  Some parts of the flowtable infrastructure could probably be exposed
via kfuncs so that certain functionality such as NAT doesn't have to be
(re)implemented.

Requires lots of code churn in flowtable support code to get rid
of sk_buff * arguments whereever possible.

There is also pending xmit_more support (skb trains/aggregation),
perhaps it will land in 6.5 cycle.
