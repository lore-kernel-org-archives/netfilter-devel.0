From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Thu, 11 May 2017 08:41:31 +0200
Message-ID: <20170511064131.GB1682@salvia>
References: <20170510105510.891-1-phil@nwl.cc>
 <20170510112724.GD16263@breakpoint.cc>
 <20170510113855.GD29824@salvia>
 <20170510115748.GE16263@breakpoint.cc>
 <20170510143946.GX20805@orbyte.nwl.cc>
 <20170510145437.GA17305@breakpoint.cc>
 <20170510151131.GY20805@orbyte.nwl.cc>
 <20170510175920.GG16263@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:44120 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754503AbdEKHEc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2017 03:04:32 -0400
Content-Disposition: inline
In-Reply-To: <20170510175920.GG16263@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 10, 2017 at 07:59:20PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > I don't find it ugly, but alternatively we could add a new type of info
> > > sent at the beginning of the commit phase (before all the table/rule etc
> > > updates) and include it there.
> > 
> > You mean as a separate netlink message? Then we would have to map that
> > message to the actual notification, no? Or do you think it's sufficient
> > to cache the last PID/name received and use it for the monitor messages
> > until an update to them comes in?
> 
> I didn't check yet but all the notifications should contain the current
> generation id and we also send a genid update after a transaction is
> done so I suspect its enough to emit the name once per transaction.

What is the usecase for this? Please don't tell me the obvious the
answer: I just want to know what process has modified what.

If the point is to know if someone else, not myself as a process, has
modified the ruleset, that is very easy to know with the netlink
infrastructure.
