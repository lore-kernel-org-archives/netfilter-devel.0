From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 17:51:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802271750140.5388@fbirervta.pbzchgretzou.qr>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net>
 <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net>
 <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net>
 <47C5761E.5070606@netoyen.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?ISO-8859-15?Q?Micha=B3?= =?ISO-8859-15?Q?_Miros=B3aw?=
	<mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: mouss <mouss@netoyen.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53574 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbYB0Qv5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:51:57 -0500
In-Reply-To: <47C5761E.5070606@netoyen.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 27 2008 15:39, mouss wrote:
> on a server where are allowed to run commands, but we don't want them to know
> more than they should, I am not sure one wants them to see the rules. call it
> security by obscurity if you like, but some people may want this. I guess this
> is what Jozef meant by compatibility (is it "least surprise"?).

=>
>> > I'd be more happy with a module parameter and/or proc switch by which this
>> > new feature could be enabled.

So just `modprobe ip_tables ipfreely=0` on your systems
once that option has been added.
