From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race
 condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 18:22:48 +0200
Message-ID: <20120830162248.GA3783@1984>
References: <7353554.n89QJXU3eh@gentoovm>
 <5239380.eElFyXbOPg@gentoovm>
 <20120830103437.GA13756@1984>
 <149613366.axl8ME3any@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48987 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab2H3QW5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:22:57 -0400
Content-Disposition: inline
In-Reply-To: <149613366.axl8ME3any@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Oliver,

On Thu, Aug 30, 2012 at 02:28:20PM +0200, Oliver wrote:
> On Thursday 30 August 2012 12:34:37 you wrote:
> > Yes, I prefer the second patch. There is still races in the first
> > patch I sent you, harder to trigger, but still there.
> > 
> > There are several cleanups I'd like to recover from the first patch
> > though. Would you help testing them?
> > 
> > Thanks a lot for testing.
> 
> HI Pablo,
> 
> Yep, I'd be happy to test. I've also uncovered a new issue: I have two Active-
> Active machines (conntrackd running NOTRACK mode with both External and 
> Internal cache disabled)

Thanks. I'll send you patches then.

> In kernel 3.2 this pair works asymmetric and issue-free. Upgrade it to 3.4 and 
> it immediately has around 50% failure of TCP connection attempts on systems 
> behind them - ICMP on the other hand is flawless, DNS lookups also are OK so I 
> *believe* that UDP may also be performing well - I've no idea where to even 
> look on this one so any insight would be most appreciated.

Unfortunately, asymmetric active-active is a crazy setup for conntrack
(documentation already discuss this). The state synchronization that
we are doing is asynchronous, so state-updates race with TCP packet.
We don't support this, sorry.

We can support active-active with hash-based load-sharing with the
cluster match / arptables, it seems more sane to me, theory is
described here:

http://1984.lsi.us.es/~pablo/docs/intcomp09.pdf

However, there is not documentation yet on how to make it. Last time I
looked at existing HA daemons, I didn't find that they support
active-active setup very well, so they require some changes / we need
some small new HA daemon for this.

I need to work on active/active load-sharing, to fully documented and
support it. That's not in top of my priority list at the moment
though.

Another (simpler) alternative is, in case your firewall have two IPs,
to statically distribute the load between your firewalls by assigning
different gateway IP to your client nodes. That should not be hard to
deploy.
