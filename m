From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 07:31:24 -0800
Message-ID: <20080227153124.GA20024@linuxace.com>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net> <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net> <47C5761E.5070606@netoyen.net> <47C578E8.8040800@trash.net>
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
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:52306
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751077AbYB0PiG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:38:06 -0500
Content-Disposition: inline
In-Reply-To: <47C578E8.8040800@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 27, 2008 at 03:51:20PM +0100, Patrick McHardy wrote:
> Well, yes, the main question is whether this causes privacy issues.
> "Security by obscurity" is a pretty poor argument, does anyone have
> a well founded reason for not allowing users to see the rules and
> counters?

I really don't think this is a good idea.  We allow non-root users
on some of our firewalls, and I don't want them to see the ruleset.
Also, it helps miscreants to better pick their targets, if they
know in advance which ports are opened.

If making this change, *please* consider making it configurable,
with the default being NO access.

Phil
