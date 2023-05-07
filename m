Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09C97C77B7C
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 May 2023 17:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbjEGRiD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 May 2023 13:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEGRiD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 May 2023 13:38:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ADB811568
        for <netfilter-devel@vger.kernel.org>; Sun,  7 May 2023 10:38:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pviKc-00077E-DH; Sun, 07 May 2023 19:37:58 +0200
Date:   Sun, 7 May 2023 19:37:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <20230507173758.GA25617@breakpoint.cc>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> On Wed, May 3, 2023 at 9:46 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> [... snip to non working offload ...]
> 
> > > table inet filter {
> > >         flowtable f1 {
> > >                 hook ingress priority filter
> > >                 devices = { veth0, veth1 }
> > >         }
> > >
> > >         chain forward {
> > >                 type filter hook forward priority filter; policy accept;
> > >                 ip dscp set cs3 offload
> > >                 ip protocol { tcp, udp, gre } flow add @f1
> > >                 ct state established,related accept
> > >         }
> > > }
> 
> [...]
> 
> >
> > I wish you would have reported this before you started to work on
> > this, because this is not a bug, this is expected behaviour.
> >
> > Once you offload, the ruleset is bypassed, this is by design.
> 
> From the rules UI perspective it seems possible to accelerate
> forward chain handling with the statements such as dscp modification there.
> 
> Isn't it better to modify the packets according to the bypassed
> ruleset thus making the behaviour more consistent?

The behaviour is consistent.  Once flow is offloaded, ruleset is
bypassed.  Its easy to not offload those flows that need the ruleset.

> > Lets not make the software offload more complex as it already is.
> 
> Could you please tell which parts of software offload are too complex?
> It's not too bad from what I've seen :)
> 
> This patch series adds 56 lines of code in the new nf_conntrack.ext.c
> file. 20 of them (nf_flow_offload_apply_payload) are used in
> the software fast path. Is it too high of a price?

56 lines of code *now*.

Next someone wants to call into sets/maps for named counters that
they need.  Then someone wants limit or quota to work.  Then they want fib
for RPF.  Then xfrm policy matching to augment acccounting.
This will go on until we get to the point where removing "fast" path
turns into a performance optimization.

Existing rule hw offload via netdev:ingress makes it clear
what rules are offloaded and to which device and it augments
flowtable feature regardless if thats handled by software fastpath,
software fallback/slowpath or by hardware offload.

> > If you want to apply dscp payload modification, do not use flowtable
> > offload or hook those parts at netdev:ingress, it will be called before the
> > software offload pipeline.
> >
> 
> The problem is that our customers need to apply dscp modification in
> more complex scenarios, e.g. after NAT.
> Therefore I am not sure that ingress chain is enough for them.

I don't understand why this would have to occur after nat, but
netdev:egress exists as well.
