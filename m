From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: using nft & iptables nat in parallel
Date: Wed, 14 Jun 2017 19:44:05 +0200
Message-ID: <20170614174405.GA7395@salvia>
References: <20170614092448.GB10130@breakpoint.cc>
 <CAOkSjBiSrj_V0nJoV8zXmfN-0mDcbfYEuf_knAnp+cHgOa=ePA@mail.gmail.com>
 <20170614095803.GC10130@breakpoint.cc>
 <20170614104008.GA14452@salvia>
 <20170614111934.GA5591@breakpoint.cc>
 <20170614112934.GA21546@salvia>
 <20170614115338.GB5591@breakpoint.cc>
 <20170614171312.GA7062@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo@debian.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752471AbdFNRoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Jun 2017 13:44:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44F883066AF
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 19:44:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36965D191C
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 19:44:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E9AFD191C
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Jun 2017 19:44:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170614171312.GA7062@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 14, 2017 at 07:13:12PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 14, 2017 at 01:53:38PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > > The extra hook has a performance impact though, is it something that
> > > would just go away one x_tables is gone? What is your plan on this?
> > 
> > Once we do it we can't remove it again, because you can have multiple
> > nat base chains after this change, and removing hook and merging it back
> > into the l3 nat code means first chain attaches a null binding again.
> 
> With multiple nat chains, in case of overlap, we would just take the
> last coming in the pipeline. Just like several chains several times
> the same packet from a filter chain, right?

I meant: just like marking the packet several times from different
chains.
