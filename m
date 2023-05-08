Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2969C7EE2A
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 20:07:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbjEHUH4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 16:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbjEHUHq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 16:07:46 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 111C55597
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2023 13:07:45 -0700 (PDT)
Date:   Mon, 8 May 2023 22:07:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <ZFlWjETnQgotP6NO@calendula>
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
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 08, 2023 at 04:38:06PM +0300, Boris Sukholitko wrote:
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

I think Florian's concern is that there is better infrastructure to
handle for ruleset offloads, ie. ingress/egress ruleset hardware
offload infrastructure.

> Obviously the performance of the fast path is very important to our
> customers. Otherwise they would not be requiring dscp fast path
> modification. :)
> 
> One of the things we've thought about regarding the fast path
> performance is rewriting nf_flow_offload_ip_hook to work with
> nf_flowtable->flow_block instead of flow_offload_tuple.
> 
> We hope that iterating over flow_action_entry list similar to what the
> hardware acceleration does, will be more efficient also in software.
> 
> Nice side-effect of such optimization would be that the amount of
> feature bloat (such as dscp modification!) will not affect your typical
> connection unless the user actually uses them.
> 
> For example, for dscp payload modification we'll generate
> FLOW_ACTION_MANGLE entry. This entry will appear on flow_block's of
> the only connections which require it. Others will be uneffected.
>
> Would you be ok with such direction (with performance tests of
> course)?

I am still missing the reason why the ingress/egress ruleset hardware
offload infrastructure is not a good fit for your requirements.
