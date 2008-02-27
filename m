From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 08:34:36 -0800
Message-ID: <20080227083436.68fe60e3@extreme>
References: <20080225094951.5bd89c9c@extreme>
	<47C54F14.4010709@trash.net>
	<20080227123122.GA22353@rere.qmqm.pl>
	<47C55AFC.7090705@trash.net>
	<Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu>
	<47C55FC5.60607@trash.net>
	<47C5761E.5070606@netoyen.net>
	<47C578E8.8040800@trash.net>
	<20080227153124.GA20024@linuxace.com>
	<47C5830E.3070500@trash.net>
	<20080227154320.GB20024@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, mouss <mouss@netoyen.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?UTF-8?B?TWljaGHCsyBNaXJvc8KzYXc=?= <mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([216.93.170.194]:58887 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342AbYB0Qem (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:34:42 -0500
In-Reply-To: <20080227154320.GB20024@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 27 Feb 2008 07:43:20 -0800
Phil Oester <kernel@linuxace.com> wrote:

> On Wed, Feb 27, 2008 at 04:34:38PM +0100, Patrick McHardy wrote:
> > Phil Oester wrote:
> > >I really don't think this is a good idea.  We allow non-root users
> > >on some of our firewalls, and I don't want them to see the ruleset.
> > >Also, it helps miscreants to better pick their targets, if they
> > >know in advance which ports are opened.
> > 
> > 
> > They could also find out about this simply by probing ports ...
> 
> And assuming a /16 with 65K ports, that would take a bit longer than
> the few seconds it takes to dump the ruleset.  Why make it easier
> than it has to be?
> 
> > >If making this change, *please* consider making it configurable,
> > >with the default being NO access.
> > 
> > 
> > No, in that case I prefer to keep it restricted to root
> > unconditionally. Using sudo to get the rules is no big
> > deal I guess.
> 

Well in our case of router administration the risk of allowing an operator
sudo access to iptables is higher than the risk of exposing ports to wankers.
This is a special purpose distribution, so we will allow it, how about
a config option or sysctl?
