Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8DAC77B7C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 May 2023 09:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjEIJsz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 May 2023 05:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234418AbjEIJsa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2023 05:48:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48471E60
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2023 02:48:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pwJxL-0004Ir-7t; Tue, 09 May 2023 11:48:27 +0200
Date:   Tue, 9 May 2023 11:48:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <20230509094827.GA14758@breakpoint.cc>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
 <20230507173758.GA25617@breakpoint.cc>
 <ZFj7PomKpCnLsDz2@noodle>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZFj7PomKpCnLsDz2@noodle>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> On Sun, May 07, 2023 at 07:37:58PM +0200, Florian Westphal wrote:
> > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > > On Wed, May 3, 2023 at 9:46 PM Florian Westphal <fw@strlen.de> wrote:
> > > >
> > > > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > > [... snip to non working offload ...]
> > > 
> > > > > table inet filter {
> > > > >         flowtable f1 {
> > > > >                 hook ingress priority filter
> > > > >                 devices = { veth0, veth1 }
> > > > >         }
> > > > >
> > > > >         chain forward {
> > > > >                 type filter hook forward priority filter; policy accept;
> > > > >                 ip dscp set cs3 offload
> > > > >                 ip protocol { tcp, udp, gre } flow add @f1
> > > > >                 ct state established,related accept
> > > > >         }
> > > > > }
> > > 
> > > [...]
> > > 
> > > >
> > > > I wish you would have reported this before you started to work on
> > > > this, because this is not a bug, this is expected behaviour.
> > > >
> > > > Once you offload, the ruleset is bypassed, this is by design.
> > > 
> > > From the rules UI perspective it seems possible to accelerate
> > > forward chain handling with the statements such as dscp modification there.
> > > 
> > > Isn't it better to modify the packets according to the bypassed
> > > ruleset thus making the behaviour more consistent?
> > 
> > The behaviour is consistent.  Once flow is offloaded, ruleset is
> > bypassed.  Its easy to not offload those flows that need the ruleset.
> > 
> > > > Lets not make the software offload more complex as it already is.
> > > 
> > > Could you please tell which parts of software offload are too complex?
> > > It's not too bad from what I've seen :)
> > > 
> > > This patch series adds 56 lines of code in the new nf_conntrack.ext.c
> > > file. 20 of them (nf_flow_offload_apply_payload) are used in
> > > the software fast path. Is it too high of a price?
> > 
> > 56 lines of code *now*.
> > 
> > Next someone wants to call into sets/maps for named counters that
> > they need.  Then someone wants limit or quota to work.  Then they want fib
> > for RPF.  Then xfrm policy matching to augment acccounting.
> > This will go on until we get to the point where removing "fast" path
> > turns into a performance optimization.
> 
> OK. May I assume that you are concerned with the eventual performance impact
> on the software fast path (i.e. nf_flow_offload_ip_hook)?

Yes, but I also dislike the concept, see below.

> Obviously the performance of the fast path is very important to our
> customers. Otherwise they would not be requiring dscp fast path
> modification. :)
> 
> One of the things we've thought about regarding the fast path
> performance is rewriting nf_flow_offload_ip_hook to work with
> nf_flowtable->flow_block instead of flow_offload_tuple.

Sorry, I should have expanded on my reservations towards this concept.

Let me explain.
Lets consider your original example first:

----------
table inet filter {
        flowtable f1 {
                hook ingress priority filter
                devices = { veth0, veth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                ip dscp set cs3
                ip protocol { tcp, udp, gre } flow add
                ct state established,related accept
        }
}
----------

This has a clearly defined meaning in all possible combinations.

Software:
1. It defines a bypass for veth0 <-> veth1
2. the way this specific ruleset is defined, all of tcp/udp/gre will
   attempt to offload
3. once offload has happened, entire inet:forward may be bypassed
4. User ruleset needs to cope with packets being moved back to
   software: fragmented packets, tcp fin/rst, hw timeouts and so on.
5. User can control via 'offload' keyword if HW offload should be
   attempted or not

Hardware:
even 'nf_flow_offload_ip_hook' may be bypassed.  But nothing changes
compared to 'no hw offload' case from a conceptual point of view.

Lets now consider existing netdev:ingress/egress in this same picture:
(Example from Pablo):
------
table inet filter {
        flowtable f1 {
                hook ingress priority filter
                devices = { veth0, veth1 }
        }

        chain ingress {
                type filter hook ingress device veth0 priority filter; policy accept; flags offload;
                ip dscp set cs3
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                meta l4proto { tcp, udp, gre } flow add @f1
                ct state established,related accept
        }
}

Again, this has defined meaning in all combinations:
With HW offload: veth0 will be told to mangle dscp.
This happens in all cases and for every matching packet,
regardless if a flowtable exists or not.

Same would happen for 'egress', just that it would happen at xmit time
rather at receive time.  Again, its not relevant if there is active
flowtable or not, or if data path is offloaded to hardware, to software,
handled by fallback or entirely without flowtables being present.

Its also clear that this is tied to 'veth0', other devices will
not be involved and not do such mangling.

Now lets look at your proposal:
----------------
table inet filter {
        flowtable f1 {
                hook ingress priority filter
                devices = { veth0, veth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                ip dscp set cs3 offload
                ip protocol { tcp, udp, gre } flow add
                ct state established,related accept
        }
}
----------------

This means that software flowtable offload
shall do a 'ip dscp set cs3'.

What if the flowtable is offloaded to hardware
entirely, without software fallback?

What if the devices listed in the flowtable definition can handle
flow offload, but no payload mangling?

Does the 'offload' mean that the rule is only active for
software path?  Only for hardware path? both?

How can I tell if its offloaded to hardware for one device
but not for the other?  Or will that be disallowed?

What if someone adds another rule after or before 'ip dscp',
but without the 'offload' keyword?  Now ordering becomes an
issue.

Users now need to consider different control flows:

  jump exceptions
  ip dscp set cs3 offload

  chain exceptions {
    ip daddr 1.2.3.4 accept
  }

This won't work as expected, because offloaded flows will not
pass through 'forward' chain but somehow a few selected rules
will be run anyway.

TL;DR: I think that for HW offload its paramount to make it crystal
clear as to which device is responsible to handle such rules.

The existing netdev:ingress/egress hooks provide the needed
chain/rules/expression:device mapping.  User can easily
tell if HW is responsible or SW by looking for 'offload' flag
presence.

I don't think mixing software and hardware offload contexts as proposed
is a good idea, both from user frontend syntax, clarity and error reporting
(e.g. if hw rejects offload request) point of view.

I also believe that allowing payload mangling from *software* offload
path sets a precedence for essentially allowing all other expressions
again which completely negates the flowtable concept.

I still think that dscp mangling should be done via netdev:ingress/egress
hooks, I don't see why this has to be bolted into flowtable sw offload.

