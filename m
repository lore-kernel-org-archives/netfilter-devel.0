Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8ADC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 09:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbiCPJNc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 05:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiCPJNc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 05:13:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11B335BE51
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 02:12:18 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D3FC163014;
        Wed, 16 Mar 2022 10:09:54 +0100 (CET)
Date:   Wed, 16 Mar 2022 10:12:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [RFC] conntrack event framework speedup
Message-ID: <YjGp7pPqw8EzACDL@salvia>
References: <20220315120538.GB16569@breakpoint.cc>
 <YjEFXmDfNN6k63+H@salvia>
 <20220315214121.GA9936@breakpoint.cc>
 <YjEK9RsgJuONGyTI@salvia>
 <20220315220748.GC9936@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220315220748.GC9936@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 15, 2022 at 11:07:48PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Mar 15, 2022 at 10:41:21PM +0100, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > > add new net.netfilter.nf_conntrack_events default mode: 2, autodetect.
> > > > 
> > > > Probably the sysctl entry does not make any sense anymore if you can
> > > > autodetect when there is a listener?
> > > 
> > > Hmmm, did not consider that.  I *think* we still want to allow to
> > > disable the feature because of xt_CT/nft_ct.
> > > 
> > > Someone might have nf_conntrack_events=0 and tehy could be using
> > > explicit configuration via templates (and then expect that only
> > > those flows that matched a '-j CT' rule generate events.
> > 
> > Maybe could you bump the ctnetlink_listeners counter when -j CT is
> > used with event filtering?
> 
> Hmmm, I don't think that will work.  The -j CT thing can be used to
> enable event reporting (including the event type) for particular flows
> only.

IIRC, it allows to filter what events are of your interest in a global
fashion.

> E.g. users might do:
> 
> nf_conntrack_events=0
> and then only enable destroy events for tcp traffic on port 22, 80, 443
> (arbitrary example).
> 
> If I bump the listen-count, then they will see event reports for
> for udp timeouts and everything else.

Are you sure? -j CT sets on the event mask. The explicit -j CT rules
means userspace want to listen to events, but only those that you
specified. So it is the same as having a userspace process to listen,
but the global filtering applies.

My understanding is that the listen-count tells that packets should
follow ct netlink event path.

What am I missing?

> IDEALLY we could ditch the sysctl, the autotuning and tell users they
> now need to configure events with nft/iptables but given the 'ct
> helpers' thing I'm sure we'll get lots of complaits about broken event
> reporting ;-)

It won't be flexible enough for all usecases. The ct event filter from
rule is global.

> > > @@ -691,11 +691,47 @@ static int nfnetlink_bind(struct net *net, int group)
> > >         if (!ss)
> > >                 request_module_nowait("nfnetlink-subsys-%d", type);
> > > +
> > > +       if (type == NFNL_SUBSYS_CTNETLINK) {
> > > +               struct nfnl_net *nfnlnet = nfnl_pernet(net);
> > > +
> > > +               nfnl_lock(NFNL_SUBSYS_CTNETLINK);
> > > +               nfnlnet->ctnetlink_listeners++;
> > > +               if (nfnlnet->ctnetlink_listeners == 1)
> > > +                       net->ct.ctnetlink_has_listener = true;
> > > +               nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
> > > 
> > > and then check 'net->ct.ctnetlink_has_listener' when allocating
> > > a new conntrack.
> > 
> > LGTM.
> 
> Thanks.  I will work on a parototype along these lines and see where
> that leads.

Let me know,

Thanks
