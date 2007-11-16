From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 13:19:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711161316060.3340@fbirervta.pbzchgretzou.qr>
References: <473CDF12.9080206@trash.net> <Pine.LNX.4.64.0711160139480.3340@fbirervta.pbzchgretzou.qr>
 <473D6C99.1010306@trash.net> <20071116.021254.114985389.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39225 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbXKPMTp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:19:45 -0500
In-Reply-To: <20071116.021254.114985389.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 16 2007 02:12, David Miller wrote:
>> Jan Engelhardt wrote:
>> > Yeah, I'd agree that on CONFIG_NETFILTER_ADVANCED=no, all the fluffy
>> > modules should be selected. It is largely an allmodconfig inside
>> > the nf menuconfig tree.
>> 
>> Mhh I'm not sure if that should really select all modules, I was more
>> thinking of NETFILTER_ADVANCED=n should select the basic modules that
>> are needed to run let say a normal distribution firewall script, and
>> CONFIG_NETFILTER_ADVANCED=y would give you more choice over the modules.
>
>I think this is what Jan meant to say, he just forgot a "not"
>somewhere :-)
>
Actually I meant what I said. Providing a user with all the matches
and targets allows him to use tutorials like lartc.org without
having to think about whether a module is already in his kernel.

Well, anyway, what modules did you have in mind NETFILTER_ADVANCED=n would turn
on?
