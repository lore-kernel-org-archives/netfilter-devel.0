From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 16 Aug 2010 17:19:15 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008161714260.9026@obet.zrqbmnf.qr>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>  <1279285829.1603.77.camel@powerslave>  <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>  <1279517423.7097.2.camel@powerslave>  <1281966043.27200.30.camel@chilepepper>
 <AANLkTinrnA0H9RH533jQQman2NLFAywx8eA=80n1vv2e@mail.gmail.com> <1281967287.27200.37.camel@chilepepper>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ext Changli Gao <xiaosuo@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41542 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0HPPT0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:19:26 -0400
In-Reply-To: <1281967287.27200.37.camel@chilepepper>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-08-16 16:01, Luciano Coelho wrote:
>> You can implement a daemon: which samples the statistics data of NIC
>> periodically, calculates the average bandwidth in a period, and change
>> the condition variables accordingly.
>
>We don't want to use polling from userspace.  That's the reason why we
>decided to use iptables instead.  The idea is that we will only notify
>the userspace when the throughput crosses the threshold line.  And the
>rules I defined above are working rather well, except for this "detail"
>that the BELOW signal is not sent when there's no data flowing.

Without data, the turing machine won't finish, so you can't say for
sure that you reached below. That is sort of a halting problem, which
is known to be unsolvable.
