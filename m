From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Tue, 17 Aug 2010 08:27:59 +0300
Message-ID: <1282022879.1773.7.camel@powerslave>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
	 <1279285829.1603.77.camel@powerslave>
	 <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
	 <1279517423.7097.2.camel@powerslave>
	 <1281966043.27200.30.camel@chilepepper>
	 <AANLkTinrnA0H9RH533jQQman2NLFAywx8eA=80n1vv2e@mail.gmail.com>
	 <1281967287.27200.37.camel@chilepepper>
	 <alpine.LSU.2.01.1008161714260.9026@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: ext Changli Gao <xiaosuo@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>
To: ext Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:59879 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab0HQFdk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:33:40 -0400
In-Reply-To: <alpine.LSU.2.01.1008161714260.9026@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-16 at 17:19 +0200, ext Jan Engelhardt wrote:
> On Monday 2010-08-16 16:01, Luciano Coelho wrote:
> >> You can implement a daemon: which samples the statistics data of NIC
> >> periodically, calculates the average bandwidth in a period, and change
> >> the condition variables accordingly.
> >
> >We don't want to use polling from userspace.  That's the reason why we
> >decided to use iptables instead.  The idea is that we will only notify
> >the userspace when the throughput crosses the threshold line.  And the
> >rules I defined above are working rather well, except for this "detail"
> >that the BELOW signal is not sent when there's no data flowing.
> 
> Without data, the turing machine won't finish, so you can't say for
> sure that you reached below. That is sort of a halting problem, which
> is known to be unsolvable.

Yes, that's the theoretical way to put it.  :) In practice I see that
without data the rules won't be traversed and therefore we can't make
any rate calculations.

But if I add an idletimer (which uses a timer to trigger execution,
regardless of the availability of packets to process) with a timeout
equal to the estimator's measurement averaging interval (ewmalog), I can
be sure that the rate went to 0 bps if the timer expires.  Ie. no
packets at all during the measurement interval means 0 bps, right?

-- 
Cheers,
Luca.

