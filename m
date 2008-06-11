From: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Wed, 11 Jun 2008 19:15:30 +0200
Message-ID: <200806111915.32313.sabelka@iue.tuwien.ac.at>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <200806111545.18856.sabelka@iue.tuwien.ac.at> <484FFCA2.1090500@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mr1-n.kom.tuwien.ac.at ([128.130.2.109]:11577 "EHLO
	mr.tuwien.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751186AbYFKRPu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 13:15:50 -0400
In-Reply-To: <484FFCA2.1090500@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 11 June 2008 18:26, Pablo Neira Ayuso wrote:
> Rainer Sabelka wrote:
> > On Wednesday 11 June 2008 15:25, Pablo Neira Ayuso wrote:
> >> Are your scripts committing the entries twice (ie. invoking conntrackd
> >> -c several times)?
> >
> > In my case - yes I did.
> >
> >> The only way to reproduce this that I have found is
> >> to double insert an existing conntrack with some NAT handling. In the
> >> upcoming 2.6.26 you'll get a EBUSY instead of EINVAL which sounds more
> >> reasonable.
> >>
> >> Anyhow, does the patch attached fix this behaviour? The idea behind it
> >> is to check if there is a conntrack present in kernel, if so, just
> >> update the attributes of the conntrack object that are changeable to
> >> avoid the error. Would you mind testing it?
> >
> > Thanks for the patch!
> > Now I see no more "commit: Invalid argument" in the logs. Instead I get
> > something like this, which looks much fiendlier:
> >
> > Jun 11 15:36:48 fw1b conntrack-tools[13273]: committing external cache
> > Jun 11 15:36:48 fw1b conntrack-tools[13273]: Committed 69 new entries
> > Jun 11 15:36:48 fw1b conntrack-tools[13273]: 53 entries ignored, already
> > exist
>                                                              ^^^
> I'll also fix the message (those entries are not ignored but updated).
> Then I'll commit the patch asap.
>
> > But in rare cases I can see "commit-create: Cannot allocate memory".
> > I also noticed this a few times before applying this patch. Is this
> > something I should worry about?
>
> Yes, very strange. ctnetlink is hitting ENOMEM, ie. it cannot create the
> conntrack because there's no memory available. As for now ctnetlink is
> allocating conntracks via nf_conntrack_alloc() which uses GFP_ATOMIC.
> I'll send you a patch to relax this to check if that is the problem,
> otherwise I think that the error is bogus.
>
> > Jun 11 15:40:07 fw1b conntrack-tools[13383]: committing external cache
> > Jun 11 15:40:07 fw1b conntrack-tools[13383]: commit-create: Cannot
> > allocate memory
> > Jun 11 15:40:07 fw1b conntrack-tools[13383]: Committed 33 new entries
> > Jun 11 15:40:07 fw1b conntrack-tools[13383]: 25 entries ignored, already
> > exist Jun 11 15:40:07 fw1b conntrack-tools[13383]: 1 entries can't be
> > committed
>
> What it is really annoying is the fact that you hit error with that less
> entries. I cannot reproduce that in my testbed with ~20000 entries. Are
> you using some kind of embedded device? Architecture?

This is a vitual machine (i686) which 128 MByte of memory running under VMware 
server 1.0.4.

-Rainer
