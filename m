From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: schedule xt_state for removal
Date: Thu, 25 Mar 2010 13:38:12 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251335270.27347@obet.zrqbmnf.qr>
References: <1269377101-13875-1-git-send-email-jengelh@medozas.de> <1269377101-13875-5-git-send-email-jengelh@medozas.de> <4BAA2969.8010106@trash.net> <alpine.LSU.2.01.1003241616120.20299@obet.zrqbmnf.qr> <4BAB359F.6030308@trash.net>
 <alpine.DEB.2.00.1003251109190.21938@blackhole.kfki.hu> <4BAB3A51.3060001@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45850 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017Ab0CYMiO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:38:14 -0400
In-Reply-To: <4BAB3A51.3060001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-25 11:26, Patrick McHardy wrote:

>>> Yes, a kernel message sounds fine and less annoying than an
>>> iptables message since we can limit it to print only once.
>>>
>>> I'm not really convinced of removing state though, I has never
>>> caused any maintenance overhead, it requires a lot less memory
>>> than xt_conntrack

And yet, you proposed removing xt_NOTRACK in favor of xt_CT where the
same argument about memory tradeoff would hold.

>>> and it seems more intuitive to write "-m state"
>>> than "-m conntrack --ctstate" to me.
>> 
>> I oppose the removal of xt_state, *unless* the userspace "-m state" is 
>> kept working and the conntrack module automatically supports it.
>
>Yes, that would be acceptable.
>
>> It's such a basic match that it's simply overkill to remove it.
>
>Agreed.

So what now? Should xt_conntrack be perhaps rebranded as a new
xt_state rev and let's obsolete xt_conntrack.c instead?
