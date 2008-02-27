From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 07:43:20 -0800
Message-ID: <20080227154320.GB20024@linuxace.com>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net> <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net> <47C5761E.5070606@netoyen.net> <47C578E8.8040800@trash.net> <20080227153124.GA20024@linuxace.com> <47C5830E.3070500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mouss <mouss@netoyen.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?iso-8859-1?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:36236
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751369AbYB0PnU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:43:20 -0500
Content-Disposition: inline
In-Reply-To: <47C5830E.3070500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 27, 2008 at 04:34:38PM +0100, Patrick McHardy wrote:
> Phil Oester wrote:
> >I really don't think this is a good idea.  We allow non-root users
> >on some of our firewalls, and I don't want them to see the ruleset.
> >Also, it helps miscreants to better pick their targets, if they
> >know in advance which ports are opened.
> 
> 
> They could also find out about this simply by probing ports ...

And assuming a /16 with 65K ports, that would take a bit longer than
the few seconds it takes to dump the ruleset.  Why make it easier
than it has to be?

> >If making this change, *please* consider making it configurable,
> >with the default being NO access.
> 
> 
> No, in that case I prefer to keep it restricted to root
> unconditionally. Using sudo to get the rules is no big
> deal I guess.

Seconded.

Phil
