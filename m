From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH -next] netfilter: nf_ct_sctp: validate vtag for new
 conntrack entries
Date: Thu, 26 Nov 2015 15:11:17 +0000
Message-ID: <20151126151117.GM16828@macbook.localdomain>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1448478477.git.marcelo.leitner@gmail.com>
 <20151125194234.GA12460@salvia>
 <5656181E.2010001@gmail.com>
 <20151125205830.GC1254@unicorn.suse.cz>
 <20151126095133.GA1612@salvia>
 <20151126141552.GH16828@macbook.localdomain>
 <20151126143328.GC32716@breakpoint.cc>
 <20151126144916.GJ16828@macbook.localdomain>
 <20151126150726.GD32716@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Michal Kubecek <mkubecek@suse.cz>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:36470 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751501AbbKZPLW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 10:11:22 -0500
Content-Disposition: inline
In-Reply-To: <20151126150726.GD32716@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > Yeah, my main concern is that this requires the user to know about protocol
> > modules, details about how the distribution build the kernel etc.
> 
> Yep, sucks.
> 
> > main reason for this problem to exists is exactly because users *don't* know
> > about this, so I'm questioning whether this really solves it.
> > 
> > The =y case is easy, it will work. The =m case should probably at least be
> > handled automatically. And then =n case is impossible to solve correctly
> > and therefore probably should not be possible.
> 
> With you so far.
> 
> > I think the question during configuration should be "SCTP support y/n/m".
> > We would then select the sctp match, build the SCTP conntrack into the
> > conntrack core the SCTP NAT into the NAT core and the problem can not
> > occur anymore. Same thing for other protocols. If the user selects n,
> > no SCTP conntrack, no SCTP match.
> 
> So you'd propose that one can have
> SCTP_MATCH=y
> CONNTRACK=n
> 
> but not:
> 
> SCTP_MATCH=y
> CONNTRACK=y
> SCTP_CONNTRACK=n
> 
> IOW, make SCTP_CONNTRACK a non-visible symbol that
> just glues sctp conntrack to the conntrack core when
> both conntrack and sctp match is selected.

Basically, although I wouldn't necessarily call it SCTP match but simply
SCTP support (for all of netfilter) and enable the individual parts depending
on their dependencies (CONNTRACK, X_TABLES, ...).

This leaves the question of nft since we don't have explicit options for
that and no protocol knowledge in the kernel. That might need a bit more
thought, but generally I think the before mentioned solution would be a
good idea.

> > Alternatively, as I believe Pablo suggested, we can simply put all conntrack
> > modules inside the core.
> 
> I would prefer to NOT force people to use extra connection tracking code
> for sctp if they don't need it.
> 
> Most distributions will ship with all of this as '=m', but IMHO its safe
> to assume that most users will in fact not use sctp (but conntrack for
> udp and tcp).

I agree, it would be better to not force this code upon users.
