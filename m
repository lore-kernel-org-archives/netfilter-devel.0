From: Florian Westphal <fw@strlen.de>
Subject: Re: pgsql-ulogd2
Date: Mon, 16 Jul 2012 15:27:59 +0200
Message-ID: <20120716132759.GB522@breakpoint.cc>
References: <50002CEF.508@googlemail.com>
 <1342194935.11019.12.camel@tiger.regit.org>
 <50016D84.5080207@googlemail.com>
 <1342300959.6098.8.camel@tiger.regit.org>
 <5002B688.4070907@googlemail.com>
 <1342385528.8476.2.camel@tiger.regit.org>
 <500345F1.3050407@googlemail.com>
 <20120716080013.GA522@breakpoint.cc>
 <50040E96.5050005@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Eric Leblond <eric@regit.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57065 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab2GPN2B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Jul 2012 09:28:01 -0400
Content-Disposition: inline
In-Reply-To: <50040E96.5050005@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mr Dash Four <mr.dash.four@googlemail.com> wrote:
> 
> >>The specific reason I raised this issue is because on the main
> >>firewall we have here, if I deploy ulogd2 and use NFCT at its
> >>present form, I will get the logs from all 7 interfaces, and it
> >>would make it an absolutely huge task to sift through all these logs
> >>and "match" the various entries (OK, doing it through the database
> >>will help up a bit, but not a lot).
> >
> >Try something like
> >iptables -t raw -A PREROUTING (thingsyoudontwant) -j CT --ctevents related
> What do you mean by "(thingsyoudontwant)"? How would that affect
> tracking (sorry, I probably need to brush-up on the CT a bit)?

It specifies what events to generate; Events that aren't generated can't be
seen by NFCT.  Tracking itself is not influenced.

As Pablo pointed out, you could also try disabling event reporting
completely via sysctl and only enable events for those networks/services
you're interested in.

So e.g. if you are only interested in logging the start and end
of connections coming from 192.168.1/24 on eth0 and going out
via eth7 you could try

echo 0 > /proc/sys/net/netfilter/nf_conntrack_events

iptables -t raw -A PREROUTING -i eth0 -o eth7 \
	 -s 192.168.1.0/24 -j CT --ctevents new,related,destroy
