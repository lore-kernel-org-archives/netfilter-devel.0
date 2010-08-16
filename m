From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Mon, 16 Aug 2010 17:01:27 +0300
Message-ID: <1281967287.27200.37.camel@chilepepper>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
	 <1279285829.1603.77.camel@powerslave>
	 <alpine.LSU.2.01.1007162127090.22666@obet.zrqbmnf.qr>
	 <1279517423.7097.2.camel@powerslave>
	 <1281966043.27200.30.camel@chilepepper>
	 <AANLkTinrnA0H9RH533jQQman2NLFAywx8eA=80n1vv2e@mail.gmail.com>
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
Received: from mgw-sa02.nokia.com ([147.243.1.48]:44176 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0HPOBj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:01:39 -0400
In-Reply-To: <AANLkTinrnA0H9RH533jQQman2NLFAywx8eA=80n1vv2e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-16 at 15:51 +0200, ext Changli Gao wrote:
> On Mon, Aug 16, 2010 at 9:40 PM, Luciano Coelho
> <luciano.coelho@nokia.com> wrote:
> > Hello,
> >
> > On Mon, 2010-07-19 at 07:30 +0200, Coelho Luciano (Nokia-MS/Helsinki)
> > wrote:
> >> On Fri, 2010-07-16 at 21:27 +0200, ext Jan Engelhardt wrote:
> >> > On Friday 2010-07-16 15:10, Luciano Coelho wrote:
> >> > >> > There is one problem with this solution, which is that it works in a
> >> > >> > per-connection basis (due to CONNMARK).  This is not exactly what I
> >> > >> > want.  I need to have this on a per-ruleset basis.  For that, I need to
> >> > >> > have a MARK (variable?) which can be set independently of connections or
> >> > >> > packets.  This is similar to the proposed condition match, but what is
> >> > >> > missing there is a way to set the condition with iptables itself,
> >> > >> > without requiring the userspace to change the procfs file.  This could
> >> > >> > probably be achieved with a "CONDITION" target or something similar.
> >> > >> > Any ideas?
> >> > >>
> >> > >> Sounds useful.
> >> > >
> >> > >Okay, this was the kind of confirmation I wanted before jumping into the
> >> > >implementation. ;) I'll implement this target soon.
> >> >
> >> > My suggestion to have it combined with xt_condition.
> >>
> >> Yes, I also think that is the best idea.  I'll implement a CONDITION
> >> target that will work together with the condition match.  For now I'll
> >> use the non-final version you submitted some time ago.
> >
> > Now that I have implemented the changes needed in the condition module
> > so that it has a target which can be used to set the condition, I came
> > up with the following rules to inform the userspace about the throughput
> > of a specific interface (in this case wlan0):
> >
> > iptables -N throughput
> > iptables -N test_above
> > iptables -N test_below
> > iptables -A INPUT -i wlan0 -j throughput
> > iptables -A OUTPUT -o wlan0 -j throughput
> > iptables -A throughput -j RATEEST --rateest-name throughput --rateest-interval 250.0ms --rateest-ewmalog 500.0ms
> > iptables -A throughput -m condition --name throughput ! --value 1 -j test_above
> > iptables -A throughput -m condition --name throughput ! --value 2 -j test_below
> > iptables -A test_above -m rateest --rateest1 throughput --rateest-bps1 0 --rateest-bps2 512bps --rateest-gt -j CONDITION --value 1 --name throughput
> > iptables -A test_above -m condition --name "throughput" --value 1 -j NFLOG --nflog-prefix "ABOVE "
> > iptables -A test_below -m rateest --rateest1 throughput --rateest-bps1 0 --rateest-bps2 512bps --rateest-lt -j CONDITION --value 2 --name throughput
> > iptables -A test_below -m condition --name "throughput" --value 2 -j NFLOG --nflog-prefix "BELOW "
> >
> > This is just a proof of concept and I'm sure it can be optimized (I'll
> > look into it once it works fully).
> >
> > Anyway, my problem now, is that the rate estimator targets are only
> > reached when there are packets coming through (for obvious reasons).
> > What is happening is that, if the last packet sent through this
> > interface is sent as part of a high throughput burst, the last signal
> > the userspace will get is "ABOVE".  After that, the interface becomes
> > idle and the "BELOW" signal is never sent, even though we will be
> > transmitting at 0 bps.
> >
> > Does anyone have an idea on how I could solve this problem?
> >
> > I have been considering using the IDLETIMER target and activate it when
> > the throughput goes to HIGH.  Then if this timer expires, it would
> > inform the userspace that now there's no data going through.  But this
> > sounds very artificial to me and will add one more dependency on the
> > userspace, since the IDLETIMER is using sysfs to inform userspace,
> > instead of netlink.
> >
> > Any other suggestions?
> >
> 
> You can implement a daemon: which samples the statistics data of NIC
> periodically, calculates the average bandwidth in a period, and change
> the condition variables accordingly.

We don't want to use polling from userspace.  That's the reason why we
decided to use iptables instead.  The idea is that we will only notify
the userspace when the throughput crosses the threshold line.  And the
rules I defined above are working rather well, except for this "detail"
that the BELOW signal is not sent when there's no data flowing.

Thanks for your suggestion anyway, we will reconsider the idea of
polling, but still I would prefer to fix the 0 bps problem (if
possible). ;)


-- 
Cheers,
Luca.

