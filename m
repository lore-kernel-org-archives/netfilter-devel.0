From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Thu, 25 Mar 2010 17:09:14 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251706470.6356@obet.zrqbmnf.qr>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de> <4BAA2969.8010106@trash.net> <alpine.LSU.2.01.1003241616120.20299@obet.zrqbmnf.qr> <4BAB359F.6030308@trash.net>
 <alpine.DEB.2.00.1003251109190.21938@blackhole.kfki.hu> <4BAB3A51.3060001@trash.net> <alpine.LSU.2.01.1003251335270.27347@obet.zrqbmnf.qr> <alpine.DEB.2.00.1003251339180.22672@blackhole.kfki.hu> <4BAB5BE3.3020703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36028 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab0CYQJP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:09:15 -0400
In-Reply-To: <4BAB5BE3.3020703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-25 13:49, Patrick McHardy wrote:
>> 
>>>>>> and it seems more intuitive to write "-m state"
>>>>>> than "-m conntrack --ctstate" to me.

But "-m state --ctorigsrc fe80::/64" does not seem as intuitive
as "-m conntrack --ctorigsrc fe80::/64".

>>>>> It's such a basic match that it's simply overkill to remove it.
>>>> Agreed.
>>> So what now? Should xt_conntrack be perhaps rebranded as a new
>>> xt_state rev and let's obsolete xt_conntrack.c instead?
>> 
>> That's much more acceptable, also because of the usage patterns. And the 
>> migration can be made easier with module aliasing.
>
>Yes, I prefer that way as well. Both state and conntrack should
>continue to work in userspace.

We should be settling for one name in the long run.
