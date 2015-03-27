From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: x_tables: fix cgroup's
 NF_INET_LOCAL_IN sk lookups
Date: Fri, 27 Mar 2015 11:47:11 +0100
Message-ID: <20150327104711.GA3313@salvia>
References: <cover.1427394874.git.daniel@iogearbox.net>
 <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net>
 <20150327001408.GD3545@salvia>
 <20150327021014.GA3142@salvia>
 <55152783.4000607@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54096 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbbC0KnN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 06:43:13 -0400
Content-Disposition: inline
In-Reply-To: <55152783.4000607@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 27, 2015 at 10:48:51AM +0100, Daniel Borkmann wrote:
> On 03/27/2015 03:10 AM, Pablo Neira Ayuso wrote:
> >
> > What started a simple cgroup match extension is turning into a more
> > complicated thing. And you want to do firewalling with this, which
> > doesn't work for other socket families than TCP and UDP.
> 
> Right, so for me it started out as a simple outgoing match extension
> for skb->sk and this should be protocol agnostic, for example, SCTP
> sets the skb owner in its output path, so the cgroup id would work
> there, too. (That should be the case for every protocol that's doing
> proper socket accounting.)
> 
> People have since then seen a use case for accounting, so support
> was added for local-in (which we try to fix), where it's being used
> in Tizen OS apparently, but the idea for realizing a per-application,
> per-container, ... firewall for both filtering and accounting sounds
> appealing to me.

Yes, but the more I look into this the more I'm convinced that the nf
socket infrastructure was not designed for generic socket-based
firewalling.

This is basically there for TPROXY and very simple socket filtering
scenarios. This really needs more thinking.

> So, I'd like to get this right for iptables and am also eager to help
> out fixing this in nft.

I'm just going to send two-liner patch for nft to get this working at
least in the limited supported scenarios that we already have.

> I was thinking that if we add --lookup-sock in a second revision,
> the man-page would _clearly_ need to describe that when being used
> w/o the lookup option, it only works for protocols making use of
> early demuxes on ingress, and when being being used with the lookup
> option, we would have TCP/UDP covered on ingress.

Not even that, it seems to me this will not work for UDP multicast
either.

> Would that be fine as a start to have this documented?

I think this is not going to work the way users expect, so I would
either schedule INPUT cgroup filtering for removal (to get this
aligned with the owner match) or document how limited this is.

> Or, would nft also require niche protocols like SCTP/DCCP to be
> supported for the lookup up-front?
>
> What I've seen so far is, that besides the basic xt_sctp matching,
> the perhaps biggest request SCTP users might have, is that association
> tracking currently is missing for the conntracker and ipvs to make
> their multi-homed use-cases work, but I guess I'm starting to get
> off-topic. :)

Yes, that's a different front ;-).
