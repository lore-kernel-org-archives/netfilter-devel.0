From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Wed, 30 Dec 2015 09:49:18 -0200
Message-ID: <20151230114918.GA16270@localhost.localdomain>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
 <20151210140625.GC3886@mrl.redhat.com>
 <20151210170647.GA1547@salvia>
 <20151215190304.GA3724@mrl.redhat.com>
 <20151217110512.GA1863@salvia>
 <567BEA14.9030007@gmail.com>
 <20151230000317.GA1480@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754312AbbL3LtX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Dec 2015 06:49:23 -0500
Content-Disposition: inline
In-Reply-To: <20151230000317.GA1480@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

On Wed, Dec 30, 2015 at 01:03:17AM +0100, Pablo Neira Ayuso wrote:
> Hi Marcelo,
> 
> On Thu, Dec 24, 2015 at 10:50:28AM -0200, Marcelo Ricardo Leitner wrote:
> > I can see how it would work for the vtag-tracking scenario, I think. I'm
> > just not seeing the non-tracking one (routers in the middle) yet.
> > It doesn't seem it can fit the helper way because it can't prepare
> > expectations as it doesn't see the packets in the initial path,
> > meaning that we would have to have 2 ways of handling such new
> > entries.
> 
> We assume that conntrack sees all traffic in our existing helpers,
> think of tcp. Otherwise, we may classify packets as invalid if we
> don't all packets that belong to the flow.

Yes, okay.

> > It would work like: if the helper is not present, allow heartbeats with any
> > vtag like it currently is. Otherwise, for validating vtag too, only allow
> > them via expectations.
> 
> I'm starting to think the lazy multihoming support is problematic
> since you can actually allow pushing holes into the firewall, how easy
> would be to push holes with this mode?

Please don't. Currently there is no other way to do it. The check I want
to add only works on a corner case of what we already have, on which we
can do better. It's just that. The way Michal handled the state
transitions is very good and the fact that the conntrack entries are
created as NEW, makes them pass the same user validation rules as a real
new association would do. So there can't be any hitch-hicking...

And for vtag probing, that's not an issue either because SCTP just drops
such heartbeat requests with invalid vtags (at sctp_sf_beat_8_3).

The only vector of attack I can think of that the initial multi-homing
support would allow is a DoS, a flood of incoming heartbeat requests.
Such flood would _not_ end up on the association buffer because if the
transport tuple (src ip, dst ip, src port, dst port) doesn't match a
known association, it's discarded. It's just as any other DoS, but as
they pass the same user validation rules, there should be rules
restricting the rate or IP range or something like that if user is
worried with that. Nothing that could jeopardize the original
association.

Note that the transport validation is performed before the vtag one, and
the stack behavior is to also drop out of the blue packets silently.
Meaning that even if the attacker get a hit at the 32-bit vtag, it will
be discarded by the transport validation firstly.

So what my patch add to it, it pulls/adds this vtag check to an earlier
moment, from the stack itself to the firewall, so that the peer
firewall will be a bit more stateful.

> You can probably achieve the same effect by allowing heartbearts go
> through via NOTRACK and then have some connection pickup from the
> middle feature. That, however, would make the user fully aware of the
> limitations since it would require explicit configuration.

Interesting idea, thanks.

