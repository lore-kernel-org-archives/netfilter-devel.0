From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 17:28:15 +0200
Message-ID: <20120716152815.GA28284@1984>
References: <50002CEF.508@googlemail.com>
 <1342194935.11019.12.camel@tiger.regit.org>
 <50016D84.5080207@googlemail.com>
 <1342300959.6098.8.camel@tiger.regit.org>
 <5002B688.4070907@googlemail.com>
 <1342385528.8476.2.camel@tiger.regit.org>
 <500345F1.3050407@googlemail.com>
 <20120716080013.GA522@breakpoint.cc>
 <50040E96.5050005@googlemail.com>
 <20120716132759.GB522@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Eric Leblond <eric@regit.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42581 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab2GPP2V (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:28:21 -0400
Content-Disposition: inline
In-Reply-To: <20120716132759.GB522@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 16, 2012 at 03:27:59PM +0200, Florian Westphal wrote:
> Mr Dash Four <mr.dash.four@googlemail.com> wrote:
> > 
> > >>The specific reason I raised this issue is because on the main
> > >>firewall we have here, if I deploy ulogd2 and use NFCT at its
> > >>present form, I will get the logs from all 7 interfaces, and it
> > >>would make it an absolutely huge task to sift through all these logs
> > >>and "match" the various entries (OK, doing it through the database
> > >>will help up a bit, but not a lot).
> > >
> > >Try something like
> > >iptables -t raw -A PREROUTING (thingsyoudontwant) -j CT --ctevents related
> > What do you mean by "(thingsyoudontwant)"? How would that affect
> > tracking (sorry, I probably need to brush-up on the CT a bit)?
> 
> It specifies what events to generate; Events that aren't generated can't be
> seen by NFCT.  Tracking itself is not influenced.
> 
> As Pablo pointed out, you could also try disabling event reporting
> completely via sysctl and only enable events for those networks/services
> you're interested in.
> 
> So e.g. if you are only interested in logging the start and end
> of connections coming from 192.168.1/24 on eth0 and going out
> via eth7 you could try
> 
> echo 0 > /proc/sys/net/netfilter/nf_conntrack_events

oops, sorry, this is not what I meant to say. This line above
*completely* disables events. Thus, the line below does not have effect
anymore.

> iptables -t raw -A PREROUTING -i eth0 -o eth7 \
> 	 -s 192.168.1.0/24 -j CT --ctevents new,related,destroy

It should be hard to add some "none" for --ctevents so you can add to
the following rules below:

iptables -t raw -A PREROUTING -i eth0 -o eth7 \
	 -s 192.168.1.0/24 -j CT --ctevents new,related,destroy
iptables -t raw -A PREROUTING -i eth0 -o eth7 \
	 ! -s 192.168.1.0/24 -j CT --ctevents none

Not to report events for others. Note that the "none" is missing now
in iptables.

Thus, we will only get events coming from 192.168.1.0/24.

Still, for better per-process (not global) filtering some ulogd2
filter that uses the libnetfilter_conntrack filtering based on
Berkeley Socket Filters can help.

I remember that I posted some patches long time ago to add
unicast-based ctevent. These days that could be easier by reusing the
user-space cthelper infrastructure that went into the kernel for
3.7.
