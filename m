From: mouss <mouss@netoyen.net>
Subject: Re: [RFC] Allowing non-root to get iptables info?
Date: Wed, 27 Feb 2008 18:48:18 +0100
Message-ID: <47C5A262.9000106@netoyen.net>
References: <20080225094951.5bd89c9c@extreme> <47C54F14.4010709@trash.net> <20080227123122.GA22353@rere.qmqm.pl> <47C55AFC.7090705@trash.net> <Pine.LNX.4.64.0802271351550.12047@blackhole.kfki.hu> <47C55FC5.60607@trash.net> <47C5761E.5070606@netoyen.net> <47C578E8.8040800@trash.net> <20080227153124.GA20024@linuxace.com> <47C5830E.3070500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	=?ISO-8859-15?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@vyatta.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balou.adapsec.com ([91.121.103.130]:50250 "EHLO
	balou.adapsec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbYB0RsU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 12:48:20 -0500
In-Reply-To: <47C5830E.3070500@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Phil Oester wrote:
>> On Wed, Feb 27, 2008 at 03:51:20PM +0100, Patrick McHardy wrote:
>>> Well, yes, the main question is whether this causes privacy issues.
>>> "Security by obscurity" is a pretty poor argument, does anyone have
>>> a well founded reason for not allowing users to see the rules and
>>> counters?
>>
>> I really don't think this is a good idea.  We allow non-root users
>> on some of our firewalls, and I don't want them to see the ruleset.
>> Also, it helps miscreants to better pick their targets, if they
>> know in advance which ports are opened.
>
>
> They could also find out about this simply by probing ports ...

they could, but their IP may get blocked before that. if they know the 
rules, they will avoid being trapped. of course, the attack requires 
user collaboration, but why make it easier?

many people use "reactive" rules that blacklist an IP after N bad 
requests. if an attacker knows how many requests during what period of 
time he can do without being blacklisted, his task is easier. sure, a 
botnet owner doesn't care as he can use a distributed attack, but that's 
no reason to help silly kids.

or consider a case when a set of ports is forwarded to a set of hosts. 
why would a user need to know? it's none of his business. 

I would understand giving users information they need to do their job so 
that they don't bother admins or spend too much time in useless 
debugging. but this is different than giving access to _all_ 
informations to _all_ users. I said "security by obscurity", but it may 
also be considered as "minimum privilege" (or one tool in a "defense in 
depth" strategy)

>
>> If making this change, *please* consider making it configurable,
>> with the default being NO access.
>
>
> No, in that case I prefer to keep it restricted to root
> unconditionally. Using sudo to get the rules is no big
> deal I guess.
>

I agree. if it can be implemented in "user space", there is no reason to 
"pollute" netfilter. one can even think of a program that gives specific 
infos based on user/group rules.


