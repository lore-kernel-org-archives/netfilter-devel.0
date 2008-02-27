From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 16:34:38 +0100
Message-ID: <47C5830E.3070500@trash.net>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net> <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net> <47C5761E.5070606@netoyen.net> <47C578E8.8040800@trash.net> <20080227153124.GA20024@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mouss <mouss@netoyen.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?ISO-8859-15?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:14086 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752109AbYB0Pee (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:34:34 -0500
In-Reply-To: <20080227153124.GA20024@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Wed, Feb 27, 2008 at 03:51:20PM +0100, Patrick McHardy wrote:
>> Well, yes, the main question is whether this causes privacy issues.
>> "Security by obscurity" is a pretty poor argument, does anyone have
>> a well founded reason for not allowing users to see the rules and
>> counters?
> 
> I really don't think this is a good idea.  We allow non-root users
> on some of our firewalls, and I don't want them to see the ruleset.
> Also, it helps miscreants to better pick their targets, if they
> know in advance which ports are opened.


They could also find out about this simply by probing ports ...

> If making this change, *please* consider making it configurable,
> with the default being NO access.


No, in that case I prefer to keep it restricted to root
unconditionally. Using sudo to get the rules is no big
deal I guess.

