From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 14:32:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010071430320.29910@obet.zrqbmnf.qr>
References: <201010061842.20142.sven-ola@gmx.de> <201010070940.08259.sven-ola@gmx.de> <alpine.LNX.2.01.1010070945540.29249@obet.zrqbmnf.qr> <201010071427.25625.sven-ola@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven-Ola Tuecke <sven-ola@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35635 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab0JGMcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 08:32:35 -0400
In-Reply-To: <201010071427.25625.sven-ola@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-10-07 14:27, Sven-Ola Tuecke wrote:
>
>> No oopses should happen. It's just that conntrack will record two
>> different connections for what is one, and the states thus don't work
>> reliably.
>
>Thanks for the estimation - but untested stuff tends to trigger mem leaks and 
>whatnot.

Well since it has to record twice the connections it will use twice as much
memory, yes. It is probably best to tag every packet that is going to be
MAP66'd with -j NOTRACK anyway (when you don't use raw/rawpost), to avoid
wasting conntrack resources on something it won't do.

>I leave the warning there. While I'm here: I wasn't aware that sme. 
>has written a complete book on writing NF modules as well as maintaining a 
>compat framework as well. Next time I'd try google first, then start hacking, 
>Promised ;-)

You should come to NFWS in Sevilla later this month. ;)
