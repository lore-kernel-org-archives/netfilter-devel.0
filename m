From: Patrick McHardy <kaber@trash.net>
Subject: Re: CONFIG_NETFILTER_ADVANCED
Date: Fri, 16 Nov 2007 11:10:33 +0100
Message-ID: <473D6C99.1010306@trash.net>
References: <20071115.160110.12856737.davem@davemloft.net> <473CDF12.9080206@trash.net> <Pine.LNX.4.64.0711160139480.3340@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39062 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbXKPKKg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 05:10:36 -0500
In-Reply-To: <Pine.LNX.4.64.0711160139480.3340@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 16 2007 01:06, Patrick McHardy wrote:
>> David Miller wrote:
>>> Patrick I would like to propose that we do something similar to how we
>>> handle all the non-trivial routing and TCP congestion control
>>> settings.
>>>
>>> And that is to have an "ADVANCED" guard that simply doesn't present
>>> the myriad of netfilter modules and options we have.
>>>
>>> Basically, if the user doesn't set CONFIG_NETFILTER_ADVANCED he gets
>>> basic NAT and connection tracking support, that's it.
>>>
>>> Or at least something along those lines.
> 
>> That sounds good, I believe we already talked at the workshop about
>> this. Additionally I'd like something that selects all modules at
>> once if it doesn't get too ugly since its a PITA to go through all
>> the options, and I usually do enable them :). I'll look into these
>> two things tommorrow.
> 
> Yeah, I'd agree that on CONFIG_NETFILTER_ADVANCED=no, all the fluffy
> modules should be selected. It is largely an allmodconfig inside
> the nf menuconfig tree.


Mhh I'm not sure if that should really select all modules, I was more
thinking of NETFILTER_ADVANCED=n should select the basic modules that
are needed to run let say a normal distribution firewall script, and
CONFIG_NETFILTER_ADVANCED=y would give you more choice over the modules.
