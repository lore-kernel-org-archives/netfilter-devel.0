From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [RFC] setting up throughput threshold indications to userspace
Date: Fri, 16 Jul 2010 16:10:29 +0300
Message-ID: <1279285829.1603.77.camel@powerslave>
References: <1279268431.1603.44.camel@powerslave> <4C40583F.40200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Changli Gao <xiaosuo@gmail.com>
To: ext Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:55406 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965234Ab0GPNK5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:10:57 -0400
In-Reply-To: <4C40583F.40200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-07-16 at 15:01 +0200, ext Patrick McHardy wrote:
> Am 16.07.2010 10:20, schrieb Luciano Coelho:
> > I'm thinking about having this kind of ruleset:
> > 
> > -A INPUT -j throughput 
> > -A above -m connmark --mark 0x1 -j RETURN 
> > -A above -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-gt -j LOG --log-prefix "ABOVE" 
> > -A above -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-gt -j CONNMARK --set-xmark 0x1/0xffffffff 
> > -A below -m connmark --mark 0x2 -j RETURN 
> > -A below -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-lt -j LOG --log-prefix "BELOW" 
> > -A below -m rateest --rateest throughput --rateest-bps1 0bit --rateest-bps2 1000bit --rateest-lt -j CONNMARK --set-xmark 0x2/0xffffffff 
> > -A throughput -j RATEEST --rateest-name throughput --rateest-interval 250.0ms --rateest-ewmalog 500.0ms 
> > -A throughput -j above 
> > -A throughput -j below 
> > 
> > I'm using a normal LOG just for simplicity reasons, in real life I'd use
> > NFLOG instead.
> > 
> > The idea here is that all packets would be collected by RATEEST for rate
> > estimation and then I'd check whether the throughput is above the
> > threshold.  If it is, I mark it as such and print the log.  Same thing
> > for below the threshold.  The RETURN rules are there to prevent more LOG
> > messages from being printed (what I need is to know only when the
> > throughput "crosses" the threshold).
> > 
> > Do you think this works?
> 
> Looks reasonable, but you could probably simplify it a bit by adding
> RETURN rules to the above/below chains when the threshold is below/
> above the specified value. That way you only need a single rateest
> match.

Right, that would certainly make it simpler.


> > There is one problem with this solution, which is that it works in a
> > per-connection basis (due to CONNMARK).  This is not exactly what I
> > want.  I need to have this on a per-ruleset basis.  For that, I need to
> > have a MARK (variable?) which can be set independently of connections or
> > packets.  This is similar to the proposed condition match, but what is
> > missing there is a way to set the condition with iptables itself,
> > without requiring the userspace to change the procfs file.  This could
> > probably be achieved with a "CONDITION" target or something similar.
> > Any ideas?
> 
> Sounds useful.

Okay, this was the kind of confirmation I wanted before jumping into the
implementation. ;) I'll implement this target soon.

Thanks for your comments!

-- 
Cheers,
Luca.

