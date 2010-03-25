From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Thu, 25 Mar 2010 13:49:39 +0100
Message-ID: <4BAB5BE3.3020703@trash.net>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de> <4BAA2969.8010106@trash.net> <alpine.LSU.2.01.1003241616120.20299@obet.zrqbmnf.qr> <4BAB359F.6030308@trash.net> <alpine.DEB.2.00.1003251109190.21938@blackhole.kfki.hu> <4BAB3A51.3060001@trash.net> <alpine.LSU.2.01.1003251335270.27347@obet.zrqbmnf.qr> <alpine.DEB.2.00.1003251339180.22672@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51172 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0CYMtj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:49:39 -0400
In-Reply-To: <alpine.DEB.2.00.1003251339180.22672@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> On Thu, 25 Mar 2010, Jan Engelhardt wrote:
> 
>>>>> and it seems more intuitive to write "-m state"
>>>>> than "-m conntrack --ctstate" to me.
>>>> I oppose the removal of xt_state, *unless* the userspace "-m state" is 
>>>> kept working and the conntrack module automatically supports it.
>>> Yes, that would be acceptable.
>>>
>>>> It's such a basic match that it's simply overkill to remove it.
>>> Agreed.
>> So what now? Should xt_conntrack be perhaps rebranded as a new
>> xt_state rev and let's obsolete xt_conntrack.c instead?
> 
> That's much more acceptable, also because of the usage patterns. And the 
> migration can be made easier with module aliasing.

Yes, I prefer that way as well. Both state and conntrack should
continue to work in userspace.
