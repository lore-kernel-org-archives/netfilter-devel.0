From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] iptables version defines
Date: Mon, 02 Jun 2008 15:50:40 +0200
Message-ID: <4843FAB0.9080608@trash.net>
References: <200805301016.03130.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0805301246450.11875@fbirervta.pbzchgretzou.qr> <48431116.8000607@trash.net> <200806021545.23690.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38563 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYFBNuq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:50:46 -0400
In-Reply-To: <200806021545.23690.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> Hi Patrick,
> 
>>>>>> #ifdef _XTABLES_H
>>>>>> init(struct xt_entry_target *t)
>>>>>> #else
>>>>>> init(struct ipt_entry_target *t, unsigned int *nfcache)
>>>>>> #endif
>>> Woah this is ridiculously ugly. (Remember, such constructs were
>>> just eliminated from the kernel in the past years.)
>> I don't care about uglyness as long as it stays in external
>> code. So if someone sends me a patch to add this version
>> define, I'll add it.
> 
> External code has to be "ugly" if you want to keep the user experience high.
> I don't feel like breaking ipt_ACCOUNT for older iptables versions without
> any real gain, it should work out of the box with iptables 1.4.0 and 1.4.1.
> 
> Attached is a patch to add the new defines. The macro XTABLES_VERSION is already in use, so I named it XTABLES_VERSION_CHECK. I've also tested
> that an empty XTABLES_VERSION_EXTRA in configure.ac works.
> 
> Now we can write code like this:
> 
> #if XTABLES_VERSION_CODE < XTABLES_VERSION_CHECK(1,5,0)
>     #warning You are obselete and will be assimilated.
> #endif


Looks good to me - I'll let it sit on netfilter-devel until tonight
though since my auto* knowlegde is close to zero :)
