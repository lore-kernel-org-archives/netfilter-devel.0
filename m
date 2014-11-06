From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v4 2/3] Do error handling if __build_packet_message fails
Date: Thu, 6 Nov 2014 03:19:21 +0100
Message-ID: <20141106021921.GB23131@breakpoint.cc>
References: <7be00bf663b212d4984414346da216cf17d3443d.1414586968.git.mleitner@redhat.com>
 <8dcee609af0015c15d2a99ab6d076a65d6ec01a8.1414586968.git.mleitner@redhat.com>
 <20141104164757.GA15508@salvia>
 <54591492.5090205@redhat.com>
 <20141104182609.GA26344@salvia>
 <20141104191120.GC6874@breakpoint.cc>
 <20141106010717.GA5205@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Marcelo Ricardo Leitner <mleitner@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52231 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750970AbaKFCTY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Nov 2014 21:19:24 -0500
Content-Disposition: inline
In-Reply-To: <20141106010717.GA5205@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 04, 2014 at 08:11:20PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > BTW, we should also signal the userspace when we fail to build the
> > > message via:
> > > 
> > > nfnetlink_set_err(net, 0, group, -ENOBUFS);
> > > 
> > > so it knows that we're losing log messages for whatever reason.
> > > Basically, userspace hits -ENOBUFS when calling recv(), which means
> > > netlink is losing messages. I don't think we really need the
> > > statistics.
> > 
> > Not sure if this is a good idea.
> > 
> > a) __build_packet_message must never fail.
> > If it does, the kernel has a size accoutning bug somewhere.
> > b) I see no meaningful way for userspace to handle this error;
> > there is nothing it can do about it.
> > c) If it happens, it might be that some userspace logging daemon
> > suddently dies because it sees an unexpected 'fatal' error.
> 
> userspace should be handling -ENOBUFS already, netlink reports this if
> the buffer overruns.

You're right.

> I would remove those printk there to
> report OOM, there's nothing userspace can do with that.

Agreed.
