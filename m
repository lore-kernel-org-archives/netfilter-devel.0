From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 2/3] Do error handling if __build_packet_message fails
Date: Tue, 4 Nov 2014 20:04:48 +0100
Message-ID: <20141104190448.GA27841@salvia>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
 <8dcee609af0015c15d2a99ab6d076a65d6ec01a8.1414586968.git.mleitner@redhat.com>
 <20141104164757.GA15508@salvia>
 <54591492.5090205@redhat.com>
 <20141104182609.GA26344@salvia>
 <5459206F.7080702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Marcelo Ricardo Leitner <mleitner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37782 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbaKDTDE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:03:04 -0500
Content-Disposition: inline
In-Reply-To: <5459206F.7080702@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 04, 2014 at 04:52:31PM -0200, Marcelo Ricardo Leitner wrote:
> >That will catch possible miscalculations too, I don't like we're
> >polluting this with many WARN_ONCE, but I don't see any better way to
> >catch this size miscalculation bugs, so ahead add it.
> >
> >BTW, we should also signal the userspace when we fail to build the
> >message via:
> >
> >nfnetlink_set_err(net, 0, group, -ENOBUFS);
> >
> >so it knows that we're losing log messages for whatever reason.
> >Basically, userspace hits -ENOBUFS when calling recv(), which means
> >netlink is losing messages. I don't think we really need the
> >statistics.
> 
> Cool. Then we probably don't need the WARN_ON unless we really want
> those numbers, or even so. As we will be calling nfnetlink_set_err,
> we have other ways of debugging. Wouldn't be as ready as a WARN_ONCE
> in there, yes.. but a systemtap script can easily get a hold in
> there.
> 
> So no WARN_ONCE, just the nfnetlink_set_err() call? Like this?

The ENOBUFS notice won't be enough. This can be triggered if the rate
of log message is too high, or the userspace process is too slow to
empty the socket queue.

I think we need both WARN_ONCE (tells us that miscalculation is
happening, ie. we have a bug) and the nfnetlink_set_err (tells
userspace it's losing log messages, so logging becomes
unreliable/approximative).
