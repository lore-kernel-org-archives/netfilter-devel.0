From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 14:15:52 +0000
Message-ID: <20151126141552.GH16828@macbook.localdomain>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:36067 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751165AbbKZOP6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 09:15:58 -0500
Content-Disposition: inline
In-Reply-To: <20151126095133.GA1612@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> On Wed, Nov 25, 2015 at 09:58:30PM +0100, Michal Kubecek wrote:
> > On Wed, Nov 25, 2015 at 06:20:46PM -0200, Marcelo Ricardo Leitner wrote:
> > > Em 25-11-2015 17:42, Pablo Neira Ayuso escreveu:
> > > >
> > > >Any specific reason ...
> > > >
> > > >not to have this enable by default?
> > > >to have a sysctl switch to enable/disable this?
> > > >
> > > >Thanks.
> > > 
> > > Yes, because it can't be used in routers in the middle. That is,
> > > unless it's a common hop with the initial path..
> > > If it's enabled and this router doesn't see the initial handshake,
> > > it won't allow heartbeats to pass and will block all secondary
> > > paths.
> > > 
> > > So if one is already using commit d7ee35190427 and this went on by
> > > default, it would break his/her setup.
> > 
> > This essentially means anyone using SCTP multihoming and conntrack based
> > rules as commit db29a9508a92 ("netfilter: conntrack: disable generic
> > tracking for known protocols") enforces using the helper. This is where
> > the need for basic multihoming support came from: our customer was using
> > SCTP multihoming through a firewall with connection tracking but without
> > helper (so that only IP addresses were used to match the conntrack); the
> > security fix prevented them from doing that.
> 
> I would really like to see some scrutiny on the SCTP to get it
> embedded into nf_conntrack.
> 
> Similar things with other existing protocols that are supported, where
> you need to modprobe the protocol to get support for this.
> 
> I think this existing behaviour is an anachronism.

I agree.

I'm wondering about the mentioned security fix though. The exceptions from
generic processing are wrapped into #ifdefs for their respective modules.
But the same problem exists if they're disabled, and in fact you can make
the same case for *any* protocol, even those that don't have protocol helpers.
I'm pretty sure not every distribution enables those modules, but I don't
think it should be up to the user to really consider the exact way his
distribution built netfilter and what is included. If it seems to work, it
should work.

Also Consider:

ah spi 12345
esp spi 12345
ipcomp 12345

All of them are individual flows, but we will treat anything of these protocol
as ESTABLISHED. Basically whenever we support to match on the exact identity
of a flow/connection, the user can reasonably assume that the ct state also
applies to that specific flow.

The way I see it we basically have two options for fixing this:

* disable the generic protocol entirely

* add a helper for every protocol for which we support matching on the identity
  of a flow and load the helper automatically when conntrack is enabled and
  the match is used.


