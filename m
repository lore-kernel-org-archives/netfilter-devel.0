From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] xtables: use guarded types
Date: Wed, 15 Dec 2010 23:47:24 +0100
Message-ID: <4D09457C.5050302@trash.net>
References: <alpine.LNX.2.01.1012032012320.26825@obet.zrqbmnf.qr> <4D00B2D7.4010401@netfilter.org> <alpine.LNX.2.01.1012092024000.30670@obet.zrqbmnf.qr> <4D01FFC5.90808@netfilter.org> <4D093A49.2060500@trash.net> <alpine.LNX.2.01.1012152319550.2669@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60640 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0LOWrZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:47:25 -0500
In-Reply-To: <alpine.LNX.2.01.1012152319550.2669@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.12.2010 23:20, schrieb Jan Engelhardt:
> 
> On Wednesday 2010-12-15 22:59, Patrick McHardy wrote:
>>
>> Well, we can resync userspace, but the __ types specifically exist
>> to avoid namespace polution.
>>
>> Applied, thanks.
>>
>> I'll also gladly apply a patch to get rid of the u_int_XX crap.
> 
> To be found where? (Choose: kernel/userspace/both)
> 

Both I guess, but I was previously referring to the kernel.
