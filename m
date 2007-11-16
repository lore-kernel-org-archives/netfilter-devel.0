From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 01:41:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711160139480.3340@fbirervta.pbzchgretzou.qr>
References: <20071115.160110.12856737.davem@davemloft.net> <473CDF12.9080206@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58118 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbXKPAlM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:41:12 -0500
In-Reply-To: <473CDF12.9080206@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 16 2007 01:06, Patrick McHardy wrote:
> David Miller wrote:
>> Patrick I would like to propose that we do something similar to how we
>> handle all the non-trivial routing and TCP congestion control
>> settings.
>>
>> And that is to have an "ADVANCED" guard that simply doesn't present
>> the myriad of netfilter modules and options we have.
>>
>> Basically, if the user doesn't set CONFIG_NETFILTER_ADVANCED he gets
>> basic NAT and connection tracking support, that's it.
>>
>> Or at least something along those lines.

> That sounds good, I believe we already talked at the workshop about
> this. Additionally I'd like something that selects all modules at
> once if it doesn't get too ugly since its a PITA to go through all
> the options, and I usually do enable them :). I'll look into these
> two things tommorrow.

Yeah, I'd agree that on CONFIG_NETFILTER_ADVANCED=no, all the fluffy
modules should be selected. It is largely an allmodconfig inside
the nf menuconfig tree.
