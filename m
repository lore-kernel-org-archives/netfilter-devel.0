From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Mon, 6 Dec 2010 14:59:49 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012061457220.29349@obet.zrqbmnf.qr>
References: <87sjyercks.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr> <874oaroznk.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr> <87tyirnhs1.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37753 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab0LFN7u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:59:50 -0500
In-Reply-To: <87tyirnhs1.fsf@tac.ki.iif.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-12-06 14:38, Ferenc Wagner wrote:
>
>>> This is indeed true if you only use a local passwd and group database.
>>
>> (Is your LDAP _that_ slow?)
>
>It's dog slow until the network is brought up...  But maybe there's some
>misunderstanding here.  My problem isn't slowness, it's the fundamental
>impossibility of resolving the user names to numbers before the network
>is up.

If the network is not up, the potential connections to the database
immediately terminate with "No route to host".

>And that's the very time to install firewall rules, isn't it?

Yes indeed.

>> The change is now in git://dev.medozas.de/iptables .
>
>How cool!  So you decided to change the default behaviour after all!

I just like to light up more corners before making decisions.
