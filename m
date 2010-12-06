From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Mon, 06 Dec 2010 14:38:06 +0100
Message-ID: <87tyirnhs1.fsf@tac.ki.iif.hu>
References: <87sjyercks.fsf@tac.ki.iif.hu>
	<alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr>
	<874oaroznk.fsf@tac.ki.iif.hu>
	<alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tac.ki.iif.hu ([193.6.222.43]:54362 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab0LFNiI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Dec 2010 08:38:08 -0500
In-Reply-To: <alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr> (Jan
	Engelhardt's message of "Mon, 6 Dec 2010 13:35:57 +0100 (CET)")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> writes:

> On Monday 2010-12-06 13:26, Ferenc Wagner wrote:
>
>>>> I opened http://bugzilla.netfilter.org/show_bug.cgi?id=683
>>>
>>> This was done on purpose by me, because username resolution usually does 
>>> not take ages like DNS, and user ids can actually change if you copy a 
>>> ruleset to another machine (this is much more unlikely to be the case 
>>> with DNS).
>>
>> This is indeed true if you only use a local passwd and group database.
>
> (Is your LDAP _that_ slow?)

It's dog slow until the network is brought up...  But maybe there's some
misunderstanding here.  My problem isn't slowness, it's the fundamental
impossibility of resolving the user names to numbers before the network
is up.  And that's the very time to install firewall rules, isn't it?

> The change is now in git://dev.medozas.de/iptables .

How cool!  So you decided to change the default behaviour after all!
-- 
Thanks a lot!
Feri.
