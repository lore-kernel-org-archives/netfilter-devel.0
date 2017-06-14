From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 19:13:12 +0200
Message-ID: <20170614171312.GA7062@salvia>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
 <20170614104008.GA14452@salvia>
 <20170614111934.GA5591@breakpoint.cc>
 <20170614112934.GA21546@salvia>
 <20170614115338.GB5591@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752141AbdFNRNR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 13:13:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B77053066AF
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 19:13:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5E286DAC4
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 19:13:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2AF571E8
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 19:13:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170614115338.GB5591@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 14, 2017 at 01:53:38PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > The extra hook has a performance impact though, is it something that
> > would just go away one x_tables is gone? What is your plan on this?
> 
> Once we do it we can't remove it again, because you can have multiple
> nat base chains after this change, and removing hook and merging it back
> into the l3 nat code means first chain attaches a null binding again.

With multiple nat chains, in case of overlap, we would just take the
last coming in the pipeline. Just like several chains several times
the same packet from a filter chain, right?

> > On a different front (just an idea), I would really like to provide an
> > alternative to setting conntrack templates, so we can get rid of
> > having a chain (hence another hook) just to set the zone. It's just
> > more cycles on a hook to do something very simple.
> 
> I don't think it can be done, the zone id has to be set before conntrack
> lookup, I see no way to avoid this?
>
> So even if we find a way to transport zone id from one hook to the
> next (sans skb->nfct template) we still need one extra hook to
> configure/set the zone id to use.

Can we do this from rule? So we run sort of nf_conntrack_in() from a
expression that enables tracking? I remember you mentioned about ICMP
and related traffic, we just have to document how to configure this so
people don't shoot on the feet, ie. track both tcp and icmp if you
want to do this right with this selective tracking expressed in
positive logic (contrary to the notrack, negative, logic).

I guess you would need something like this for bridge conntrack
support, right?
