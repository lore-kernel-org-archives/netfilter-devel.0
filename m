From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 16 Aug 2010 17:26:51 +0300
Message-ID: <1281968811.27200.41.camel@chilepepper>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
	 <1279285829.1603.77.camel@powerslave>
	 <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
	 <1279517423.7097.2.camel@powerslave>
	 <1281966043.27200.30.camel@chilepepper>
	 <AANLkTinrnA0H9RH533jQQman2NLFAywx8eA=80n1vv2e@mail.gmail.com>
	 <1281967287.27200.37.camel@chilepepper>
	 <AANLkTikd75p0UU-SVp2yXPHR4KJeZJxzbD4QYmNAUUMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: ext Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:22723 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab0HPO1B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:27:01 -0400
In-Reply-To: <AANLkTikd75p0UU-SVp2yXPHR4KJeZJxzbD4QYmNAUUMA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-16 at 16:13 +0200, ext Changli Gao wrote:
> On Mon, Aug 16, 2010 at 10:01 PM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> > On Mon, 2010-08-16 at 15:51 +0200, ext Changli Gao wrote:
> >>
> >> You can implement a daemon: which samples the statistics data of NIC
> >> periodically, calculates the average bandwidth in a period, and change
> >> the condition variables accordingly.
> >
> > We don't want to use polling from userspace.  That's the reason why we
> > decided to use iptables instead.  The idea is that we will only notify
> > the userspace when the throughput crosses the threshold line.  And the
> > rules I defined above are working rather well, except for this "detail"
> > that the BELOW signal is not sent when there's no data flowing.
> >
> 
> There is a daemon watching the ABOVE signal in any way. How about
> staring a timer, which is used to check if there is no packet
> transfered in a period, in this daemon when receiving the ABOVE
> signal, and stopping this timer when receiving the BELOW signal? It is
> like the implementation of IDLETIMER in user space.

Yeah, we do have a daemon listening to it.  This idea is actually good
and might work.  As you say, it's very similar to IDLETIMER, but in
userspace.  I'll ask our userspace guy which one he prefers to use (ie.
either making the timer himself, or listening to IDLETIMER's sysfs
indication).

Of course, it is also possible to implement a netfilter interface for
the idletimer target as well (as Samuel has already suggested), so that
dependencies in userspace would be simplified. ;)


-- 
Cheers,
Luca.

